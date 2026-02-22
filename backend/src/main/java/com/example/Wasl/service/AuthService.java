package com.example.Wasl.service;

import java.util.HashMap;
import java.util.List;
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

import com.example.Wasl.entity.ProviderProfile;
import com.example.Wasl.entity.Role;
import com.example.Wasl.entity.StudentProfile;
import com.example.Wasl.entity.User;
import com.example.Wasl.entity.enums.UserMode;
import com.example.Wasl.entity.enums.UserStatus;
import com.example.Wasl.entity.enums.VerificationStatus;
import com.example.Wasl.exception.BusinessRuleException;
import com.example.Wasl.repository.RoleRepository;
import com.example.Wasl.repository.StudentProfileRepository;
import com.example.Wasl.repository.ProviderProfileRepository;
import com.example.Wasl.repository.UserRepository;
import com.example.Wasl.security.JwtUtil;

@Service
public class AuthService implements UserDetailsService {

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

        List<SimpleGrantedAuthority> authorities = user.getRoles().stream()
                .map(role -> new SimpleGrantedAuthority("ROLE_" + role.getName()))
                .toList();

        return new org.springframework.security.core.userdetails.User(
                user.getId().toString(),
                user.getPasswordHash(),
                authorities);
    }

    @Transactional
    public String register(String email, String phone, String password, String fullName, UserMode mode,
            List<String> rolesWanted) {
        email = email.toLowerCase().trim();
        if (userRepository.findByEmail(email).isPresent()) {
            throw new BusinessRuleException("Email already registered");
        }

        if (userRepository.findByPhone(phone).isPresent()) {
            throw new BusinessRuleException("Phone number already registered");
        }

        User user = User.builder()
                .email(email)
                .phone(phone)
                .passwordHash(passwordEncoder.encode(password))
                .fullName(fullName)
                .selectedMode(mode)
                .status(UserStatus.ACTIVE)
                .build();

        for (String roleName : rolesWanted) {
            Role role = roleRepository.findById(roleName)
                    .orElseThrow(() -> new BusinessRuleException("Role not found: " + roleName));
            user.getRoles().add(role);
        }

        user = userRepository.save(user);

        if (mode == UserMode.STUDENT) {
            StudentProfile profile = StudentProfile.builder().user(user).build();
            studentProfileRepository.save(profile);
        } else {
            ProviderProfile profile = ProviderProfile.builder()
                    .user(user)
                    .verificationStatus(VerificationStatus.PENDING)
                    .build();
            providerProfileRepository.save(profile);
        }

        return generateJwt(user);
    }

    public String login(String email, String password) {
        email = email.toLowerCase().trim();
        User user = userRepository.findByEmail(email)
                .orElseThrow(() -> new BadCredentialsException("Invalid email or password"));

        if (!passwordEncoder.matches(password, user.getPasswordHash())) {
            throw new BadCredentialsException("Invalid email or password");
        }

        return generateJwt(user);
    }

    private String generateJwt(User user) {
        Map<String, Object> claims = new HashMap<>();
        claims.put("mode", user.getSelectedMode().name());
        claims.put("roles", user.getRoles().stream()
                .map(Role::getName)
                .toList());

        return jwtUtil.generateToken(user.getId().toString(), claims);
    }
}
