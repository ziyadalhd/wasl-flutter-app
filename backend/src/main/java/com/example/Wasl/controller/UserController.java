package com.example.Wasl.controller;

import java.util.UUID;

import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.web.bind.annotation.PatchMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.example.Wasl.dto.AuthResponse;
import com.example.Wasl.service.UserModeService;

import lombok.RequiredArgsConstructor;

@RestController
@RequestMapping("/api/users")
@RequiredArgsConstructor
public class UserController {

    private final UserModeService userModeService;

    @PatchMapping("/switch-mode")
    public ResponseEntity<AuthResponse> switchMode(@AuthenticationPrincipal UserDetails userDetails) {
        UUID userId = UUID.fromString(userDetails.getUsername());
        AuthResponse response = userModeService.switchMode(userId);
        return ResponseEntity.ok(response);
    }
}
