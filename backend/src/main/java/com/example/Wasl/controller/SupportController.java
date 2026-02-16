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
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.example.Wasl.dto.CreateTicketRequest;
import com.example.Wasl.dto.MessageResponse;
import com.example.Wasl.dto.SendMessageRequest;
import com.example.Wasl.dto.TicketResponse;
import com.example.Wasl.service.SupportService;

import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;

@RestController
@RequestMapping("/api/support")
@RequiredArgsConstructor
public class SupportController {

    private final SupportService supportService;

    /**
     * POST /api/support/tickets — Create a new support ticket
     */
    @PostMapping("/tickets")
    public ResponseEntity<TicketResponse> createTicket(
            @AuthenticationPrincipal UserDetails userDetails,
            @Valid @RequestBody CreateTicketRequest request) {

        UUID userId = UUID.fromString(userDetails.getUsername());
        TicketResponse response = supportService.createTicket(
                userId, request.getSubject(), request.getMessage());

        return ResponseEntity.status(HttpStatus.CREATED).body(response);
    }

    /**
     * GET /api/support/tickets — List current user's tickets
     */
    @GetMapping("/tickets")
    public ResponseEntity<List<TicketResponse>> getMyTickets(
            @AuthenticationPrincipal UserDetails userDetails) {

        UUID userId = UUID.fromString(userDetails.getUsername());
        return ResponseEntity.ok(supportService.getUserTickets(userId));
    }

    /**
     * GET /api/support/tickets/{id}/messages — Get messages for a ticket
     */
    @GetMapping("/tickets/{id}/messages")
    public ResponseEntity<List<MessageResponse>> getTicketMessages(
            @AuthenticationPrincipal UserDetails userDetails,
            @PathVariable UUID id) {

        UUID userId = UUID.fromString(userDetails.getUsername());
        return ResponseEntity.ok(supportService.getTicketMessages(userId, id));
    }

    /**
     * POST /api/support/tickets/{id}/messages — Send a message in a ticket
     */
    @PostMapping("/tickets/{id}/messages")
    public ResponseEntity<MessageResponse> sendMessage(
            @AuthenticationPrincipal UserDetails userDetails,
            @PathVariable UUID id,
            @Valid @RequestBody SendMessageRequest request) {

        UUID userId = UUID.fromString(userDetails.getUsername());
        MessageResponse response = supportService.sendMessage(userId, id, request.getContent());

        return ResponseEntity.status(HttpStatus.CREATED).body(response);
    }

    /**
     * PUT /api/support/tickets/{id}/close — Close a ticket
     */
    @PutMapping("/tickets/{id}/close")
    public ResponseEntity<TicketResponse> closeTicket(
            @AuthenticationPrincipal UserDetails userDetails,
            @PathVariable UUID id) {

        UUID userId = UUID.fromString(userDetails.getUsername());
        return ResponseEntity.ok(supportService.closeTicket(userId, id));
    }
}
