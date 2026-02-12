package com.example.Wasl.service;

import java.util.UUID;

import org.springframework.security.access.AccessDeniedException;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.example.Wasl.entity.User;
import com.example.Wasl.entity.enums.UserMode;
import com.example.Wasl.exception.BusinessRuleException;
import com.example.Wasl.repository.ProviderProfileRepository;
import com.example.Wasl.repository.StudentProfileRepository;
import com.example.Wasl.repository.UserRepository;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class UserModeService {

    private final UserRepository userRepository;
    private final StudentProfileRepository studentProfileRepository;
    private final ProviderProfileRepository providerProfileRepository;

    @Transactional
    public void switchMode(UUID userId, UserMode newMode) {
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new UsernameNotFoundException("User not found"));

        boolean hasRole = user.getRoles().stream()
                .anyMatch(r -> r.getName().equals(newMode.name()));

        if (!hasRole) {
            throw new AccessDeniedException(
                    "User does not have the " + newMode.name() + " role");
        }

        if (newMode == UserMode.STUDENT && !studentProfileRepository.existsById(userId)) {
            throw new BusinessRuleException(
                    "Student profile does not exist — data inconsistency");
        }
        if (newMode == UserMode.PROVIDER && !providerProfileRepository.existsById(userId)) {
            throw new BusinessRuleException(
                    "Provider profile does not exist — data inconsistency");
        }

        user.setSelectedMode(newMode);
        userRepository.save(user);
    }
}
