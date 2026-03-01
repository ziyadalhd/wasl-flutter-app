package com.example.Wasl.repository;

import java.util.List;
import java.util.UUID;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.example.Wasl.entity.ListingAttachment;

@Repository
public interface ListingAttachmentRepository extends JpaRepository<ListingAttachment, UUID> {

    List<ListingAttachment> findByApartmentListing_Id(UUID apartmentListingId);

    List<ListingAttachment> findByTransportSubscription_Id(UUID transportSubscriptionId);
}
