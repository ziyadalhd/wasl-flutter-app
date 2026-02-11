package com.example.Wasl.service;

import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.example.Wasl.dto.ProfileCompletionDTO;
import com.example.Wasl.entity.ProviderProfile;
import com.example.Wasl.entity.StudentProfile;
import com.example.Wasl.entity.User;
import com.example.Wasl.entity.enums.UserMode;
import com.example.Wasl.entity.enums.VerificationStatus;
import com.example.Wasl.repository.ProviderProfileRepository;
import com.example.Wasl.repository.UserRepository;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class ProfileService {

    private final UserRepository userRepository;
    private final ProviderProfileRepository providerProfileRepository;

    @Transactional(readOnly = true)
    public User getProfile(UUID userId, UserMode mode) {
        if (mode == UserMode.STUDENT) {
            return userRepository.findByIdWithStudentProfile(userId)
                    .orElseThrow(() -> new UsernameNotFoundException("User not found"));
        }
        return userRepository.findByIdWithProviderProfileAndDocuments(userId)
                .orElseThrow(() -> new UsernameNotFoundException("User not found"));
    }

    public ProfileCompletionDTO calculateCompletion(User user, UserMode mode) {
        if (mode == UserMode.STUDENT) {
            return calculateStudentCompletion(user.getStudentProfile());
        }
        return calculateProviderCompletion(user.getProviderProfile());
    }

    private ProfileCompletionDTO calculateStudentCompletion(StudentProfile profile) {
        int total = 2;
        int completed = 0;
        List<String> missing = new ArrayList<>();

        if (profile != null) {
            if (profile.getUniversityId() != null && !profile.getUniversityId().isBlank()) {
                completed++;
            } else {
                missing.add("universityId");
            }
            if (profile.getCollege() != null) {
                completed++;
            } else {
                missing.add("college");
            }
        } else {
            missing.add("universityId");
            missing.add("college");
        }

        int percentage = (int) ((completed / (double) total) * 100);
        return ProfileCompletionDTO.builder()
                .percentage(percentage)
                .missingFields(missing)
                .build();
    }

    private ProfileCompletionDTO calculateProviderCompletion(ProviderProfile profile) {
        int total = 3;
        int completed = 0;
        List<String> missing = new ArrayList<>();

        if (profile != null) {
            if (profile.getBio() != null && !profile.getBio().isBlank()) {
                completed++;
            } else {
                missing.add("bio");
            }
            if (profile.getProviderType() != null) {
                completed++;
            } else {
                missing.add("providerType");
            }
            if (profile.getDocuments() != null && !profile.getDocuments().isEmpty()) {
                completed++;
            } else {
                missing.add("documents");
            }
        } else {
            missing.add("bio");
            missing.add("providerType");
            missing.add("documents");
        }

        int percentage = (int) ((completed / (double) total) * 100);
        return ProfileCompletionDTO.builder()
                .percentage(percentage)
                .missingFields(missing)
                .build();
    }

    @Transactional
    public void verifyProvider(UUID providerId) {
        ProviderProfile profile = providerProfileRepository.findById(providerId)
                .orElseThrow(() -> new UsernameNotFoundException("Provider not found"));
        profile.setVerificationStatus(VerificationStatus.APPROVED);
        providerProfileRepository.save(profile);
    }
}
