package com.example.Wasl.repository;

import java.util.List;
import java.util.UUID;

import org.springframework.data.jpa.repository.JpaRepository;

import com.example.Wasl.entity.Booking;

public interface BookingRepository extends JpaRepository<Booking, UUID> {

    List<Booking> findByStudentIdOrderByCreatedAtDesc(UUID studentId);

    List<Booking> findByProviderIdOrderByCreatedAtDesc(UUID providerId);

    List<Booking> findByEntityIdAndEntityTypeOrderByCreatedAtDesc(UUID entityId, String entityType);
}
