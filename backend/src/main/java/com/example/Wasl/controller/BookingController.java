package com.example.Wasl.controller;

import java.util.List;
import java.util.UUID;

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

import com.example.Wasl.dto.BookingRequest;
import com.example.Wasl.dto.BookingResponse;
import com.example.Wasl.dto.UpdateBookingStatusRequest;
import com.example.Wasl.entity.User;
import com.example.Wasl.repository.UserRepository;
import com.example.Wasl.service.BookingService;

import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;

@RestController
@RequestMapping("/api/bookings")
@RequiredArgsConstructor
public class BookingController {

    private final BookingService bookingService;
    private final UserRepository userRepository;

    @PostMapping
    public ResponseEntity<BookingResponse> createBooking(
            @AuthenticationPrincipal UserDetails userDetails,
            @Valid @RequestBody BookingRequest request) {

        UUID studentId = UUID.fromString(userDetails.getUsername());
        BookingResponse response = bookingService.createBooking(studentId, request);
        return ResponseEntity.ok(response);
    }

    @GetMapping("/my-bookings")
    public ResponseEntity<List<BookingResponse>> getMyBookings(
            @AuthenticationPrincipal UserDetails userDetails) {

        UUID userId = UUID.fromString(userDetails.getUsername());

        // Find the user to know their active mode (STUDENT or PROVIDER)
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new IllegalArgumentException("User not found"));

        List<BookingResponse> responses = bookingService.getMyBookings(userId, user.getSelectedMode().name());
        return ResponseEntity.ok(responses);
    }

    @PutMapping("/{id}/status")
    public ResponseEntity<BookingResponse> updateBookingStatus(
            @AuthenticationPrincipal UserDetails userDetails,
            @PathVariable UUID id,
            @Valid @RequestBody UpdateBookingStatusRequest request) {

        UUID providerId = UUID.fromString(userDetails.getUsername());
        BookingResponse response = bookingService.updateBookingStatus(providerId, id, request);
        return ResponseEntity.ok(response);
    }
}
