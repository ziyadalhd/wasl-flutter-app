package com.example.Wasl.controller;

import java.util.UUID;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
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

import com.example.Wasl.dto.BookingRequest;
import com.example.Wasl.dto.BookingResponse;
import com.example.Wasl.dto.UpdateBookingStatusRequest;
import com.example.Wasl.service.BookingService;

import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;

@RestController
@RequestMapping("/api/bookings")
@RequiredArgsConstructor
public class BookingController {

    private final BookingService bookingService;

    @PostMapping
    public ResponseEntity<BookingResponse> createBooking(
            @AuthenticationPrincipal UserDetails userDetails,
            @Valid @RequestBody BookingRequest request) {

        UUID studentId = UUID.fromString(userDetails.getUsername());
        BookingResponse response = bookingService.createBooking(studentId, request);
        return ResponseEntity.status(HttpStatus.CREATED).body(response);
    }

    @GetMapping("/my-bookings")
    public ResponseEntity<Page<BookingResponse>> getMyBookings(
            @AuthenticationPrincipal UserDetails userDetails,
            Pageable pageable) {

        UUID userId = UUID.fromString(userDetails.getUsername());
        Page<BookingResponse> responses = bookingService.getMyBookings(userId, pageable);
        return ResponseEntity.ok(responses);
    }

    @PutMapping("/{id}/status")
    public ResponseEntity<BookingResponse> updateBookingStatus(
            @AuthenticationPrincipal UserDetails userDetails,
            @PathVariable UUID id,
            @Valid @RequestBody UpdateBookingStatusRequest request) {

        UUID userId = UUID.fromString(userDetails.getUsername());
        BookingResponse response = bookingService.updateBookingStatus(userId, id, request);
        return ResponseEntity.ok(response);
    }
}
