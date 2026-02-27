package com.example.Wasl.service;

import java.util.HashMap;
import java.util.Map;
import java.util.UUID;

import org.springframework.context.annotation.Lazy;
import org.springframework.security.authentication.BadCredentialsException;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.example.Wasl.dto.AuthResponse;
import com.example.Wasl.entity.ProviderProfile;
import com.example.Wasl.entity.Role;
import com.example.Wasl.entity.StudentProfile;
import com.example.Wasl.entity.User;
import com.example.Wasl.entity.enums.UserMode;
import com.example.Wasl.entity.enums.UserStatus;
import com.example.Wasl.entity.enums.VerificationStatus;
import com.example.Wasl.exception.BusinessRuleException;
import com.example.Wasl.repository.ProviderProfileRepository;
import com.example.Wasl.repository.RoleRepository;
import com.example.Wasl.repository.StudentProfileRepository;
import com.example.Wasl.repository.UserRepository;
import com.example.Wasl.security.JwtUtil;

@Service
public class AuthService implements UserDetailsService {

    private static final String NORMALIZED_PHONE_REGEX = "^05\\d{8}$";

    private final UserRepository userRepository;
    private final RoleRepository roleRepository;
    private final StudentProfileRepository studentProfileRepository;
    private final ProviderProfileRepository providerProfileRepository;
    private final PasswordEncoder passwordEncoder;
    private final JwtUtil jwtUtil;

    public AuthService(
            UserRepository userRepository,
            RoleRepository roleRepository,
            StudentProfileRepository studentProfileRepository,
            ProviderProfileRepository providerProfileRepository,
            @Lazy PasswordEncoder passwordEncoder,
            JwtUtil jwtUtil) {
        this.userRepository = userRepository;
        this.roleRepository = roleRepository;
        this.studentProfileRepository = studentProfileRepository;
        this.providerProfileRepository = providerProfileRepository;
        this.passwordEncoder = passwordEncoder;
        this.jwtUtil = jwtUtil;
    }

    @Override
    public UserDetails loadUserByUsername(String identifier) throws UsernameNotFoundException {
        User user;
        try {
            UUID id = UUID.fromString(identifier);
            user = userRepository.findById(id)
                    .orElseThrow(() -> new UsernameNotFoundException("User not found: " + identifier));
        } catch (IllegalArgumentException e) {
            user = userRepository.findByEmail(identifier)
                    .orElseThrow(() -> new UsernameNotFoundException("User not found: " + identifier));
        }

        var authorities = user.getRoles().stream()
                .map(role -> new SimpleGrantedAuthority("ROLE_" + role.getName()))
                .toList();

        return new org.springframework.security.core.userdetails.User(
                user.getId().toString(),
                user.getPasswordHash(),
                authorities);
    }

    @Transactional
    public AuthResponse register(String email, String phone, String password, String fullName, UserMode mode) {
        // Normalize email
        email = email.toLowerCase().trim();

        // Normalize phone: strip whitespace, convert known formats to 05XXXXXXXX
        phone = normalizePhone(phone);

        // Duplicate pre-checks (using normalized values)
        if (userRepository.existsByEmail(email)) {
            throw new BusinessRuleException("Email already registered");
        }
        if (userRepository.existsByPhone(phone)) {
            throw new BusinessRuleException("Phone number already registered");
        }

        // Build user
        User user = User.builder()
                .email(email)
                .phone(phone)
                .passwordHash(passwordEncoder.encode(password))
                .fullName(fullName)
                .selectedMode(mode)
                .status(UserStatus.ACTIVE)
                .build();

        // Assign roles: always STUDENT, plus PROVIDER if mode is PROVIDER
        Role studentRole = roleRepository.findById("STUDENT")
                .orElseThrow(() -> new BusinessRuleException("Role STUDENT not found"));
        user.getRoles().add(studentRole);

        if (mode == UserMode.PROVIDER) {
            Role providerRole = roleRepository.findById("PROVIDER")
                    .orElseThrow(() -> new BusinessRuleException("Role PROVIDER not found"));
            user.getRoles().add(providerRole);
        }

        user = userRepository.save(user);

        // Create profile based on mode
        StudentProfile studentProfile = StudentProfile.builder().user(user).build();
        studentProfileRepository.save(studentProfile);

        if (mode == UserMode.PROVIDER) {
            ProviderProfile providerProfile = ProviderProfile.builder()
                    .user(user)
                    .verificationStatus(VerificationStatus.PENDING)
                    .build();
            providerProfileRepository.save(providerProfile);
        }

        return buildAuthResponse(user);
    }

    public AuthResponse login(String email, String password) {
        email = email.toLowerCase().trim();
        User user = userRepository.findByEmail(email)
                .orElseThrow(() -> new BadCredentialsException("Invalid email or password"));

        if (!passwordEncoder.matches(password, user.getPasswordHash())) {
            throw new BadCredentialsException("Invalid email or password");
        }

        return buildAuthResponse(user);
    }

    private AuthResponse buildAuthResponse(User user) {
        return AuthResponse.builder()
                .token(generateJwt(user))
                .selectedMode(user.getSelectedMode().name())
                .build();
    }

    private String generateJwt(User user) {
        Map<String, Object> claims = new HashMap<>();
        claims.put("mode", user.getSelectedMode().name());
        claims.put("roles", user.getRoles().stream()
                .map(Role::getName)
                .toList());

        return jwtUtil.generateToken(user.getId().toString(), claims);
    }

    /**
     * Normalize phone to 05XXXXXXXX format:
     * - Remove all whitespace
     * - +9665XXXXXXXX -> 05XXXXXXXX
     * - 9665XXXXXXXX -> 05XXXXXXXX
     * - 05XXXXXXXX -> as-is
     * After normalization, enforce ^05\d{8}$ or reject.
     */
    static String normalizePhone(String phone) {
        if (phone == null) {
            throw new IllegalArgumentException("Phone number is required");
        }
        // Strip all whitespace
        phone = phone.replaceAll("\\s", "");

        // +9665XXXXXXXX -> 05XXXXXXXX
        if (phone.matches("^\\+9665\\d{8}$")) {
            phone = "0" + phone.substring(4);
        }
        // 9665XXXXXXXX -> 05XXXXXXXX
        else if (phone.matches("^9665\\d{8}$")) {
            phone = "0" + phone.substring(3);
        }

        // Final validation
        if (!phone.matches(NORMALIZED_PHONE_REGEX)) {
            throw new IllegalArgumentException("Phone number must be in format 05XXXXXXXX after normalization");
        }

        return phone;
    }
}
