package com.example.Wasl.service;

import java.util.List;
import java.util.UUID;
import java.util.stream.Collectors;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.example.Wasl.dto.BookingRequest;
import com.example.Wasl.dto.BookingResponse;
import com.example.Wasl.dto.UpdateBookingStatusRequest;
import com.example.Wasl.entity.Booking;
import com.example.Wasl.entity.User;
import com.example.Wasl.repository.BookingRepository;
import com.example.Wasl.repository.UserRepository;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class BookingService {

    private final BookingRepository bookingRepository;
    private final UserRepository userRepository;

    @Transactional
    public BookingResponse createBooking(UUID studentId, BookingRequest request) {
        User student = userRepository.findById(studentId)
                .orElseThrow(() -> new IllegalArgumentException("Student not found"));

        if (!"STUDENT".equals(student.getSelectedMode().name())) {
            throw new IllegalArgumentException("User is not in STUDENT mode");
        }

        User provider = userRepository.findById(request.getProviderId())
                .orElseThrow(() -> new IllegalArgumentException("Provider not found"));

        // Normally we'd also verify the entityId exists in ApartmentListing or
        // TransportSubscription
        // based on entityType, but for simplicity we'll just link it.

        Booking newBooking = Booking.builder()
                .student(student)
                .provider(provider)
                .entityId(request.getEntityId())
                .entityType(request.getEntityType())
                .status("PENDING")
                .build();

        newBooking = bookingRepository.save(newBooking);

        return mapToResponse(newBooking);
    }

    @Transactional(readOnly = true)
    public List<BookingResponse> getMyBookings(UUID userId, String roleMode) {
        List<Booking> bookings;
        if ("STUDENT".equals(roleMode)) {
            bookings = bookingRepository.findByStudentIdOrderByCreatedAtDesc(userId);
        } else if ("PROVIDER".equals(roleMode)) {
            bookings = bookingRepository.findByProviderIdOrderByCreatedAtDesc(userId);
        } else {
            throw new IllegalArgumentException("Invalid role mode for fetching bookings");
        }

        return bookings.stream().map(this::mapToResponse).collect(Collectors.toList());
    }

    @Transactional
    public BookingResponse updateBookingStatus(UUID providerId, UUID bookingId, UpdateBookingStatusRequest request) {
        Booking booking = bookingRepository.findById(bookingId)
                .orElseThrow(() -> new IllegalArgumentException("Booking not found"));

        if (!booking.getProvider().getId().equals(providerId)) {
            throw new IllegalArgumentException("Only the provider owning this booking can update its status");
        }

        booking.setStatus(request.getStatus());
        booking = bookingRepository.save(booking);

        return mapToResponse(booking);
    }

    private BookingResponse mapToResponse(Booking booking) {
        return BookingResponse.builder()
                .id(booking.getId())
                .studentId(booking.getStudent().getId())
                .studentName(booking.getStudent().getFullName())
                .providerId(booking.getProvider().getId())
                .providerName(booking.getProvider().getFullName())
                .entityId(booking.getEntityId())
                .entityType(booking.getEntityType())
                .status(booking.getStatus())
                .createdAt(booking.getCreatedAt())
                .updatedAt(booking.getUpdatedAt())
                .build();
    }
}
