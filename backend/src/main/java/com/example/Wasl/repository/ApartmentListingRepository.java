package com.example.Wasl.repository;

import java.util.UUID;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.example.Wasl.entity.ApartmentListing;
import com.example.Wasl.entity.enums.ListingStatus;

@Repository
public interface ApartmentListingRepository extends JpaRepository<ApartmentListing, UUID> {

    Page<ApartmentListing> findAllByOrderByCreatedAtDesc(Pageable pageable);

    Page<ApartmentListing> findByProviderProfile_IdOrderByCreatedAtDesc(UUID providerId, Pageable pageable);

    Page<ApartmentListing> findByStatusOrderByCreatedAtDesc(ListingStatus status, Pageable pageable);
}
