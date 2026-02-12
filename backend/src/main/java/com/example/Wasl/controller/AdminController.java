package com.example.Wasl.controller;

import java.util.UUID;

import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.example.Wasl.service.ProfileService;

import lombok.RequiredArgsConstructor;

@RestController
@RequestMapping("/api/admin")
@PreAuthorize("hasRole('ADMIN')")
@RequiredArgsConstructor
public class AdminController {

    private final ProfileService profileService;

    @PostMapping("/providers/{id}/verify")
    public ResponseEntity<String> verifyProvider(@PathVariable UUID id) {
        profileService.verifyProvider(id);
        return ResponseEntity.ok("Provider verified successfully");
    }
}
