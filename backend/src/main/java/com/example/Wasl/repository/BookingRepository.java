package com.example.Wasl.repository;

import java.util.List;
import java.util.UUID;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.EntityGraph;
import org.springframework.data.jpa.repository.JpaRepository;

import com.example.Wasl.entity.Booking;

public interface BookingRepository extends JpaRepository<Booking, UUID> {

    @EntityGraph(attributePaths = { "student", "provider", "apartmentListing", "transportSubscription" })
    Page<Booking> findByStudentIdOrderByCreatedAtDesc(UUID studentId, Pageable pageable);

    @EntityGraph(attributePaths = { "student", "provider", "apartmentListing", "transportSubscription" })
    Page<Booking> findByProviderIdOrderByCreatedAtDesc(UUID providerId, Pageable pageable);

    long countByStudentIdAndStatusIn(UUID studentId, List<String> statuses);

    long countByProviderIdAndStatusIn(UUID providerId, List<String> statuses);
}
