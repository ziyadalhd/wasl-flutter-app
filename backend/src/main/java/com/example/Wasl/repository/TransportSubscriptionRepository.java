package com.example.Wasl.repository;

import java.util.UUID;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.example.Wasl.entity.TransportSubscription;
import com.example.Wasl.entity.enums.ListingStatus;

@Repository
public interface TransportSubscriptionRepository extends JpaRepository<TransportSubscription, UUID> {

    Page<TransportSubscription> findAllByOrderByCreatedAtDesc(Pageable pageable);

    Page<TransportSubscription> findByProviderProfile_IdOrderByCreatedAtDesc(UUID providerId, Pageable pageable);

    Page<TransportSubscription> findByStatusOrderByCreatedAtDesc(ListingStatus status, Pageable pageable);
}
