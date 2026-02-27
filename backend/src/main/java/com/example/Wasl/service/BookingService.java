package com.example.Wasl.service;

import java.util.List;
import java.util.Set;
import java.util.UUID;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.example.Wasl.dto.BookingRequest;
import com.example.Wasl.dto.BookingResponse;
import com.example.Wasl.dto.UpdateBookingStatusRequest;
import com.example.Wasl.entity.ApartmentListing;
import com.example.Wasl.entity.Booking;
import com.example.Wasl.entity.TransportSubscription;
import com.example.Wasl.entity.User;
import com.example.Wasl.exception.BusinessRuleException;
import com.example.Wasl.repository.ApartmentListingRepository;
import com.example.Wasl.repository.BookingRepository;
import com.example.Wasl.repository.TransportSubscriptionRepository;
import com.example.Wasl.repository.UserRepository;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class BookingService {

    private static final List<String> ACTIVE_STATUSES = List.of("PENDING", "ACCEPTED");

    /**
     * Allowed transitions from a given status.
     * PENDING -> ACCEPTED, REJECTED, CANCELLED
     * ACCEPTED -> CANCELLED
     * All other transitions are disallowed.
     */
    private static final java.util.Map<String, Set<String>> ALLOWED_TRANSITIONS = java.util.Map.of(
            "PENDING", Set.of("ACCEPTED", "REJECTED", "CANCELLED"),
            "ACCEPTED", Set.of("CANCELLED"));

    private final BookingRepository bookingRepository;
    private final UserRepository userRepository;
    private final ApartmentListingRepository apartmentListingRepository;
    private final TransportSubscriptionRepository transportSubscriptionRepository;

    @Transactional
    public BookingResponse createBooking(UUID studentId, BookingRequest request) {
        User student = userRepository.findById(studentId)
                .orElseThrow(() -> new IllegalArgumentException("Student not found"));

        if (!"STUDENT".equals(student.getSelectedMode().name())) {
            throw new IllegalArgumentException("User is not in STUDENT mode");
        }

        User provider = userRepository.findById(request.getProviderId())
                .orElseThrow(() -> new IllegalArgumentException("Provider not found"));

        // Validate exactly one FK is provided
        ApartmentListing apartmentListing = null;
        TransportSubscription transportSubscription = null;

        if (request.getApartmentListingId() != null && request.getTransportSubscriptionId() != null) {
            throw new IllegalArgumentException(
                    "Cannot book both an apartment and a transport subscription at the same time");
        }

        if (request.getApartmentListingId() != null) {
            apartmentListing = apartmentListingRepository.findById(request.getApartmentListingId())
                    .orElseThrow(() -> new IllegalArgumentException("Apartment listing not found"));
            // Ownership: listing must belong to the requested provider
            if (!apartmentListing.getProviderProfile().getUser().getId().equals(provider.getId())) {
                throw new IllegalArgumentException("Apartment listing does not belong to the specified provider");
            }
        } else if (request.getTransportSubscriptionId() != null) {
            transportSubscription = transportSubscriptionRepository.findById(request.getTransportSubscriptionId())
                    .orElseThrow(() -> new IllegalArgumentException("Transport subscription not found"));
            // Ownership: subscription must belong to the requested provider
            if (!transportSubscription.getProviderProfile().getUser().getId().equals(provider.getId())) {
                throw new IllegalArgumentException("Transport subscription does not belong to the specified provider");
            }
        } else {
            throw new IllegalArgumentException("Either apartmentListingId or transportSubscriptionId must be provided");
        }

        Booking newBooking = Booking.builder()
                .student(student)
                .provider(provider)
                .apartmentListing(apartmentListing)
                .transportSubscription(transportSubscription)
                .status("PENDING")
                .build();

        newBooking = bookingRepository.save(newBooking);

        return mapToResponse(newBooking);
    }

    @Transactional(readOnly = true)
    public Page<BookingResponse> getMyBookings(UUID userId, Pageable pageable) {
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new IllegalArgumentException("User not found"));

        String roleMode = user.getSelectedMode().name();
        Page<Booking> bookings;

        if ("STUDENT".equals(roleMode)) {
            bookings = bookingRepository.findByStudentIdOrderByCreatedAtDesc(userId, pageable);
        } else if ("PROVIDER".equals(roleMode)) {
            bookings = bookingRepository.findByProviderIdOrderByCreatedAtDesc(userId, pageable);
        } else {
            throw new IllegalArgumentException("Invalid role mode for fetching bookings");
        }

        return bookings.map(this::mapToResponse);
    }

    @Transactional
    public BookingResponse updateBookingStatus(UUID userId, UUID bookingId, UpdateBookingStatusRequest request) {
        Booking booking = bookingRepository.findById(bookingId)
                .orElseThrow(() -> new IllegalArgumentException("Booking not found"));

        // IDOR check: user must be student or provider on this booking
        boolean isStudent = booking.getStudent().getId().equals(userId);
        boolean isProvider = booking.getProvider().getId().equals(userId);
        if (!isStudent && !isProvider) {
            throw new IllegalArgumentException("You do not have access to this booking");
        }

        String currentStatus = booking.getStatus();
        String newStatus = request.getStatus();

        // Cancellation idempotency
        if ("CANCELLED".equals(currentStatus) && "CANCELLED".equals(newStatus)) {
            return mapToResponse(booking);
        }

        // Action-level authorization
        if (("ACCEPTED".equals(newStatus) || "REJECTED".equals(newStatus)) && !isProvider) {
            throw new BusinessRuleException("Only the provider can accept or reject a booking");
        }
        if ("CANCELLED".equals(newStatus) && !isStudent) {
            throw new BusinessRuleException("Only the student can cancel a booking");
        }

        // Validate status transition
        Set<String> allowed = ALLOWED_TRANSITIONS.getOrDefault(currentStatus, Set.of());
        if (!allowed.contains(newStatus)) {
            throw new BusinessRuleException(
                    "Cannot transition from " + currentStatus + " to " + newStatus);
        }

        booking.setStatus(newStatus);
        booking = bookingRepository.save(booking);

        return mapToResponse(booking);
    }

    /**
     * Check if user has active bookings (PENDING or ACCEPTED) as student.
     */
    public boolean hasActiveBookingsAsStudent(UUID userId) {
        return bookingRepository.countByStudentIdAndStatusIn(userId, ACTIVE_STATUSES) > 0;
    }

    /**
     * Check if user has active bookings (PENDING or ACCEPTED) as provider.
     */
    public boolean hasActiveBookingsAsProvider(UUID userId) {
        return bookingRepository.countByProviderIdAndStatusIn(userId, ACTIVE_STATUSES) > 0;
    }

    private BookingResponse mapToResponse(Booking booking) {
        return BookingResponse.builder()
                .id(booking.getId())
                .studentId(booking.getStudent().getId())
                .studentName(booking.getStudent().getFullName())
                .providerId(booking.getProvider().getId())
                .providerName(booking.getProvider().getFullName())
                .apartmentListingId(
                        booking.getApartmentListing() != null ? booking.getApartmentListing().getId() : null)
                .transportSubscriptionId(
                        booking.getTransportSubscription() != null ? booking.getTransportSubscription().getId() : null)
                .status(booking.getStatus())
                .createdAt(booking.getCreatedAt())
                .updatedAt(booking.getUpdatedAt())
                .build();
    }
}
