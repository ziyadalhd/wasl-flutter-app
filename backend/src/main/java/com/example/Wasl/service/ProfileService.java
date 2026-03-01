package com.example.Wasl.service;

import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.example.Wasl.dto.ProfileCompletionDTO;
import com.example.Wasl.dto.UpdateProfileRequest;
import com.example.Wasl.entity.College;
import com.example.Wasl.entity.ProviderProfile;
import com.example.Wasl.entity.StudentProfile;
import com.example.Wasl.entity.User;
import com.example.Wasl.entity.enums.UserMode;
import com.example.Wasl.entity.enums.VerificationStatus;
import com.example.Wasl.exception.BusinessRuleException;
import com.example.Wasl.repository.CollegeRepository;
import com.example.Wasl.repository.ProviderProfileRepository;
import com.example.Wasl.repository.UserRepository;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class ProfileService {

    private final UserRepository userRepository;
    private final ProviderProfileRepository providerProfileRepository;
    private final CollegeRepository collegeRepository;
    private final BookingService bookingService;

    @Transactional(readOnly = true)
    public User getProfile(UUID userId, UserMode mode) {
        if (mode == UserMode.STUDENT) {
            return userRepository.findByIdWithStudentProfile(userId)
                    .orElseThrow(() -> new UsernameNotFoundException("User not found"));
        }
        return userRepository.findByIdWithProviderProfileAndDocuments(userId)
                .orElseThrow(() -> new UsernameNotFoundException("User not found"));
    }

    @Transactional
    public User updateProfile(UUID userId, UpdateProfileRequest request) {
        // First get the user to determine mode
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new UsernameNotFoundException("User not found"));

        UserMode mode = user.getSelectedMode();

        // Re-fetch with the appropriate profile loaded
        user = getProfile(userId, mode);

        // Update shared fields
        user.setFullName(request.getFullName());
        if (request.getPhone() != null) {
            user.setPhone(request.getPhone());
        }
        if (request.getCity() != null) {
            user.setCity(request.getCity());
        }

        // Update mode-specific fields
        if (mode == UserMode.STUDENT) {
            StudentProfile profile = user.getStudentProfile();
            if (profile != null) {
                if (request.getUniversityId() != null) {
                    profile.setUniversityId(request.getUniversityId());
                }
                if (request.getUniversityName() != null) {
                    profile.setUniversityName(request.getUniversityName());
                }
                if (request.getCollegeName() != null) {
                    College college = collegeRepository.findByName(request.getCollegeName())
                            .orElse(null);
                    profile.setCollege(college);
                }
            }
        } else if (mode == UserMode.PROVIDER) {
            ProviderProfile profile = user.getProviderProfile();
            if (profile != null && request.getBio() != null) {
                profile.setBio(request.getBio());
            }
        }

        return userRepository.save(user);
    }

    @Transactional
    public void deleteAccount(UUID userId) {
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new UsernameNotFoundException("User not found"));

        if (bookingService.hasActiveBookingsAsStudent(userId)) {
            throw new BusinessRuleException(
                    "Cannot delete account: you have active bookings as a student (PENDING or ACCEPTED).");
        }

        if (bookingService.hasActiveBookingsAsProvider(userId)) {
            throw new BusinessRuleException(
                    "Cannot delete account: you have active bookings as a provider (PENDING or ACCEPTED).");
        }

        // Hard delete — all dependents cascade via ON DELETE CASCADE in schema
        userRepository.delete(user);
    }

    public ProfileCompletionDTO calculateCompletion(User user, UserMode mode) {
        if (mode == UserMode.STUDENT) {
            return calculateStudentCompletion(user.getStudentProfile());
        }
        return calculateProviderCompletion(user.getProviderProfile());
    }

    @Transactional
    public void saveUser(User user) {
        userRepository.save(user);
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
