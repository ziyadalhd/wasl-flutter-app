package com.example.Wasl.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;
import java.util.stream.Collectors;

import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PatchMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.example.Wasl.entity.Role;
import com.example.Wasl.entity.User;
import com.example.Wasl.entity.enums.UserStatus;
import com.example.Wasl.repository.UserRepository;
import com.example.Wasl.service.ProfileService;

import lombok.RequiredArgsConstructor;

@RestController
@RequestMapping("/api/admin")
@PreAuthorize("hasRole('ADMIN')")
@RequiredArgsConstructor
public class AdminController {

    private final ProfileService profileService;
    private final UserRepository userRepository;

    @PostMapping("/providers/{id}/verify")
    public ResponseEntity<String> verifyProvider(@PathVariable UUID id) {
        profileService.verifyProvider(id);
        return ResponseEntity.ok("Provider verified successfully");
    }

    /**
     * GET /api/admin/users → returns all non-admin users.
     * Each user: {id, name, email, phone, role, status}
     */
    @GetMapping("/users")
    public ResponseEntity<List<Map<String, Object>>> listUsers() {
        List<User> users = userRepository.findAll();

        List<Map<String, Object>> result = users.stream()
                .filter(u -> u.getRoles().stream().noneMatch(r -> "ADMIN".equals(r.getName())))
                .map(u -> {
                    Map<String, Object> map = new HashMap<>();
                    map.put("id", u.getId().toString());
                    map.put("name", u.getFullName() != null ? u.getFullName() : "");
                    map.put("email", u.getEmail());
                    map.put("phone", u.getPhone() != null ? u.getPhone() : "");
                    // Determine primary role
                    boolean isProvider = u.getRoles().stream()
                            .anyMatch(r -> "PROVIDER".equals(r.getName()));
                    map.put("role", isProvider ? "مقدم خدمة" : "طالب");
                    map.put("status", u.getStatus() == UserStatus.ACTIVE ? "نشط" : "موقوف");
                    return map;
                })
                .collect(Collectors.toList());

        return ResponseEntity.ok(result);
    }

    /**
     * PATCH /api/admin/users/{id}/suspend → sets user status to SUSPENDED.
     */
    @PatchMapping("/users/{id}/suspend")
    public ResponseEntity<String> suspendUser(@PathVariable UUID id) {
        User user = userRepository.findById(id)
                .orElseThrow(() -> new UsernameNotFoundException("User not found"));
        user.setStatus(UserStatus.SUSPENDED);
        userRepository.save(user);
        return ResponseEntity.ok("User suspended successfully");
    }

    /**
     * PATCH /api/admin/users/{id}/activate → sets user status to ACTIVE.
     */
    @PatchMapping("/users/{id}/activate")
    public ResponseEntity<String> activateUser(@PathVariable UUID id) {
        User user = userRepository.findById(id)
                .orElseThrow(() -> new UsernameNotFoundException("User not found"));
        user.setStatus(UserStatus.ACTIVE);
        userRepository.save(user);
        return ResponseEntity.ok("User activated successfully");
    }
}
