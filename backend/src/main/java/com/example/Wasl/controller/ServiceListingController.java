package com.example.Wasl.controller;

import java.util.UUID;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.example.Wasl.dto.ApartmentListingDTO;
import com.example.Wasl.dto.CreateApartmentListingRequest;
import com.example.Wasl.dto.CreateTransportSubscriptionRequest;
import com.example.Wasl.dto.TransportSubscriptionDTO;
import com.example.Wasl.service.ServiceListingService;

import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;

@RestController
@RequestMapping("/api/services")
@RequiredArgsConstructor
public class ServiceListingController {

    private final ServiceListingService serviceListingService;

    // ── Apartment Listings ──────────────────────────────────────────

    @PostMapping("/apartments")
    public ResponseEntity<ApartmentListingDTO> createApartmentListing(
            @AuthenticationPrincipal UserDetails userDetails,
            @Valid @RequestBody CreateApartmentListingRequest request) {

        UUID providerId = UUID.fromString(userDetails.getUsername());
        ApartmentListingDTO response = serviceListingService.createApartmentListing(providerId, request);
        return ResponseEntity.status(HttpStatus.CREATED).body(response);
    }

    @PutMapping("/apartments/{id}")
    public ResponseEntity<ApartmentListingDTO> updateApartmentListing(
            @AuthenticationPrincipal UserDetails userDetails,
            @PathVariable UUID id,
            @Valid @RequestBody CreateApartmentListingRequest request) {

        UUID providerId = UUID.fromString(userDetails.getUsername());
        ApartmentListingDTO response = serviceListingService.updateApartmentListing(providerId, id, request);
        return ResponseEntity.ok(response);
    }

    @GetMapping("/apartments/mine")
    public ResponseEntity<Page<ApartmentListingDTO>> getMyApartmentListings(
            @AuthenticationPrincipal UserDetails userDetails,
            Pageable pageable) {

        UUID providerId = UUID.fromString(userDetails.getUsername());
        return ResponseEntity.ok(serviceListingService.getMyApartmentListings(providerId, pageable));
    }

    @GetMapping("/apartments")
    public ResponseEntity<Page<ApartmentListingDTO>> getActiveApartmentListings(Pageable pageable) {
        return ResponseEntity.ok(serviceListingService.getActiveApartmentListings(pageable));
    }

    @DeleteMapping("/apartments/{id}")
    public ResponseEntity<Void> deleteApartmentListing(
            @AuthenticationPrincipal UserDetails userDetails,
            @PathVariable UUID id) {

        UUID providerId = UUID.fromString(userDetails.getUsername());
        serviceListingService.deleteApartmentListing(providerId, id);
        return ResponseEntity.noContent().build();
    }

    // ── Transport Subscriptions ─────────────────────────────────────

    @PostMapping("/transport")
    public ResponseEntity<TransportSubscriptionDTO> createTransportSubscription(
            @AuthenticationPrincipal UserDetails userDetails,
            @Valid @RequestBody CreateTransportSubscriptionRequest request) {

        UUID providerId = UUID.fromString(userDetails.getUsername());
        TransportSubscriptionDTO response = serviceListingService.createTransportSubscription(providerId, request);
        return ResponseEntity.status(HttpStatus.CREATED).body(response);
    }

    @PutMapping("/transport/{id}")
    public ResponseEntity<TransportSubscriptionDTO> updateTransportSubscription(
            @AuthenticationPrincipal UserDetails userDetails,
            @PathVariable UUID id,
            @Valid @RequestBody CreateTransportSubscriptionRequest request) {

        UUID providerId = UUID.fromString(userDetails.getUsername());
        TransportSubscriptionDTO response = serviceListingService.updateTransportSubscription(providerId, id, request);
        return ResponseEntity.ok(response);
    }

    @GetMapping("/transport/mine")
    public ResponseEntity<Page<TransportSubscriptionDTO>> getMyTransportSubscriptions(
            @AuthenticationPrincipal UserDetails userDetails,
            Pageable pageable) {

        UUID providerId = UUID.fromString(userDetails.getUsername());
        return ResponseEntity.ok(serviceListingService.getMyTransportSubscriptions(providerId, pageable));
    }

    @GetMapping("/transport")
    public ResponseEntity<Page<TransportSubscriptionDTO>> getActiveTransportSubscriptions(Pageable pageable) {
        return ResponseEntity.ok(serviceListingService.getActiveTransportSubscriptions(pageable));
    }

    @DeleteMapping("/transport/{id}")
    public ResponseEntity<Void> deleteTransportSubscription(
            @AuthenticationPrincipal UserDetails userDetails,
            @PathVariable UUID id) {

        UUID providerId = UUID.fromString(userDetails.getUsername());
        serviceListingService.deleteTransportSubscription(providerId, id);
        return ResponseEntity.noContent().build();
    }
}
