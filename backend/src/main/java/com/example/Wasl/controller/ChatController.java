package com.example.Wasl.controller;

import java.util.List;
import java.util.UUID;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.example.Wasl.dto.ChatMessageResponse;
import com.example.Wasl.dto.ChatSessionResponse;
import com.example.Wasl.dto.CreateChatRequest;
import com.example.Wasl.dto.SendMessageRequest;
import com.example.Wasl.service.ChatService;

import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;

@RestController
@RequestMapping("/api/chats")
@RequiredArgsConstructor
public class ChatController {

    private final ChatService chatService;

    @PostMapping
    public ResponseEntity<ChatSessionResponse> createOrGetSession(
            @AuthenticationPrincipal UserDetails userDetails,
            @Valid @RequestBody CreateChatRequest request) {

        UUID currentUserId = UUID.fromString(userDetails.getUsername());
        ChatSessionResponse response = chatService.createOrGetSession(currentUserId, request.getTargetUserId());
        return ResponseEntity.ok(response);
    }

    @GetMapping
    public ResponseEntity<List<ChatSessionResponse>> getMySessions(
            @AuthenticationPrincipal UserDetails userDetails) {

        UUID currentUserId = UUID.fromString(userDetails.getUsername());
        return ResponseEntity.ok(chatService.getUserChatSessions(currentUserId));
    }

    @GetMapping("/{sessionId}/messages")
    public ResponseEntity<List<ChatMessageResponse>> getSessionMessages(
            @AuthenticationPrincipal UserDetails userDetails,
            @PathVariable UUID sessionId) {

        UUID currentUserId = UUID.fromString(userDetails.getUsername());
        return ResponseEntity.ok(chatService.getSessionMessages(currentUserId, sessionId));
    }

    @PostMapping("/{sessionId}/messages")
    public ResponseEntity<ChatMessageResponse> sendMessage(
            @AuthenticationPrincipal UserDetails userDetails,
            @PathVariable UUID sessionId,
            @Valid @RequestBody SendMessageRequest request) {

        UUID currentUserId = UUID.fromString(userDetails.getUsername());
        ChatMessageResponse response = chatService.sendMessage(currentUserId, sessionId, request.getContent());
        return ResponseEntity.status(HttpStatus.CREATED).body(response);
    }
}
