package com.example.Wasl.service;

import java.util.UUID;

import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.example.Wasl.dto.AuthResponse;
import com.example.Wasl.entity.ProviderProfile;
import com.example.Wasl.entity.Role;
import com.example.Wasl.entity.User;
import com.example.Wasl.entity.enums.UserMode;
import com.example.Wasl.entity.enums.VerificationStatus;
import com.example.Wasl.repository.ProviderProfileRepository;
import com.example.Wasl.repository.RoleRepository;
import com.example.Wasl.repository.UserRepository;
import com.example.Wasl.security.JwtUtil;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class UserModeService {

        private final UserRepository userRepository;
        private final RoleRepository roleRepository;
        private final ProviderProfileRepository providerProfileRepository;
        private final JwtUtil jwtUtil;

        /**
         * Toggle selected_mode STUDENT <-> PROVIDER.
         * If switching to PROVIDER:
         * - Add ROLE_PROVIDER if missing
         * - Create ProviderProfile if missing (verificationStatus = PENDING)
         * NEVER remove ROLE_STUDENT. NEVER assign ADMIN.
         *
         * @return AuthResponse with new JWT + selectedMode
         */
        @Transactional
        public AuthResponse switchMode(UUID userId) {
                User user = userRepository.findById(userId)
                                .orElseThrow(() -> new UsernameNotFoundException("User not found"));

                // Toggle
                UserMode newMode = (user.getSelectedMode() == UserMode.STUDENT)
                                ? UserMode.PROVIDER
                                : UserMode.STUDENT;

                if (newMode == UserMode.PROVIDER) {
                        // Add ROLE_PROVIDER if missing
                        boolean hasProviderRole = user.getRoles().stream()
                                        .anyMatch(r -> "PROVIDER".equals(r.getName()));
                        if (!hasProviderRole) {
                                Role providerRole = roleRepository.findById("PROVIDER")
                                                .orElseThrow(() -> new IllegalStateException(
                                                                "Role PROVIDER not found"));
                                user.getRoles().add(providerRole);
                        }

                        // Create ProviderProfile if missing (prevent duplicates via existsByUser_Id)
                        if (!providerProfileRepository.existsByUser_Id(userId)) {
                                ProviderProfile profile = ProviderProfile.builder()
                                                .user(user)
                                                .verificationStatus(VerificationStatus.PENDING)
                                                .build();
                                providerProfileRepository.save(profile);
                        }
                }

                user.setSelectedMode(newMode);
                userRepository.save(user);

                // Build new JWT with updated mode & roles
                java.util.Map<String, Object> claims = new java.util.HashMap<>();
                claims.put("mode", newMode.name());
                claims.put("roles", user.getRoles().stream()
                                .map(Role::getName)
                                .toList());

                String token = jwtUtil.generateToken(user.getId().toString(), claims);

                return AuthResponse.builder()
                                .token(token)
                                .selectedMode(newMode.name())
                                .build();
        }
}
