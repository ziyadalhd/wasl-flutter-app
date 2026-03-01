package com.example.Wasl.controller;

import java.util.UUID;
import java.util.stream.Collectors;

import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PatchMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.example.Wasl.dto.MeResponse;
import com.example.Wasl.dto.ProfileDTO;
import com.example.Wasl.dto.ProviderDocumentDTO;
import com.example.Wasl.dto.ProviderProfileDTO;
import com.example.Wasl.dto.StudentProfileDTO;
import com.example.Wasl.dto.UpdateProfileRequest;
import com.example.Wasl.dto.UserDTO;
import com.example.Wasl.entity.Role;
import com.example.Wasl.entity.User;
import com.example.Wasl.entity.enums.UserMode;
import com.example.Wasl.service.ProfileService;

import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;

@RestController
@RequestMapping("/api/me")
@RequiredArgsConstructor
public class MeController {

        private final ProfileService profileService;

        @GetMapping
        public ResponseEntity<MeResponse> getMe(@AuthenticationPrincipal UserDetails principal) {
                UUID userId = UUID.fromString(principal.getUsername());
                User user = profileService.getProfile(userId, null);
                UserMode mode = user.getSelectedMode();
                user = profileService.getProfile(userId, mode);

                return ResponseEntity.ok(buildMeResponse(user, mode));
        }

        @PutMapping("/profile")
        public ResponseEntity<MeResponse> updateProfile(
                        @AuthenticationPrincipal UserDetails principal,
                        @Valid @RequestBody UpdateProfileRequest request) {
                UUID userId = UUID.fromString(principal.getUsername());
                User updatedUser = profileService.updateProfile(userId, request);
                UserMode mode = updatedUser.getSelectedMode();

                // Re-fetch with profile loaded for response
                updatedUser = profileService.getProfile(userId, mode);

                return ResponseEntity.ok(buildMeResponse(updatedUser, mode));
        }

        @DeleteMapping
        public ResponseEntity<String> deleteAccount(@AuthenticationPrincipal UserDetails principal) {
                UUID userId = UUID.fromString(principal.getUsername());
                profileService.deleteAccount(userId);
                return ResponseEntity.ok("Account deleted successfully");
        }

        @PatchMapping("/verify")
        public ResponseEntity<MeResponse> verifyStudent(@AuthenticationPrincipal UserDetails principal) {
                UUID userId = UUID.fromString(principal.getUsername());
                User user = profileService.getProfile(userId, null);
                user.setVerified(true);
                profileService.saveUser(user);

                UserMode mode = user.getSelectedMode();
                user = profileService.getProfile(userId, mode);
                return ResponseEntity.ok(buildMeResponse(user, mode));
        }

        // ── Helper ──────────────────────────────────────────────────────
        private MeResponse buildMeResponse(User user, UserMode mode) {
                UserDTO userDTO = UserDTO.builder()
                                .id(user.getId())
                                .email(user.getEmail())
                                .phone(user.getPhone())
                                .fullName(user.getFullName())
                                .city(user.getCity())
                                .selectedMode(user.getSelectedMode().name())
                                .status(user.getStatus().name())
                                .verified(user.isVerified())
                                .roles(user.getRoles().stream().map(Role::getName).toList())
                                .build();

                ProfileDTO profileDTO;
                if (mode == UserMode.STUDENT) {
                        var sp = user.getStudentProfile();
                        profileDTO = StudentProfileDTO.builder()
                                        .universityId(sp != null ? sp.getUniversityId() : null)
                                        .universityName(sp != null ? sp.getUniversityName() : null)
                                        .collegeName(sp != null && sp.getCollege() != null ? sp.getCollege().getName()
                                                        : null)
                                        .build();
                } else {
                        var pp = user.getProviderProfile();
                        profileDTO = ProviderProfileDTO.builder()
                                        .bio(pp != null ? pp.getBio() : null)
                                        .verificationStatus(pp != null ? pp.getVerificationStatus().name() : null)
                                        .providerType(pp != null && pp.getProviderType() != null
                                                        ? pp.getProviderType().name()
                                                        : null)
                                        .documents(pp != null ? pp.getDocuments().stream()
                                                        .map(d -> ProviderDocumentDTO.builder().id(d.getId())
                                                                        .url(d.getUrl()).build())
                                                        .collect(Collectors.toList()) : null)
                                        .build();
                }

                return MeResponse.builder()
                                .user(userDTO)
                                .mode(mode.name())
                                .profile(profileDTO)
                                .build();
        }
}
