package com.example.Wasl.controller;

import java.util.List;
import java.util.Map;
import java.util.UUID;

import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.example.Wasl.dto.ApartmentListingDTO;
import com.example.Wasl.dto.StudentHomeResponseDTO;
import com.example.Wasl.dto.TransportSubscriptionDTO;
import com.example.Wasl.entity.ApartmentListing;
import com.example.Wasl.entity.TransportSubscription;
import com.example.Wasl.entity.enums.UserMode;
import com.example.Wasl.service.HomeService;

import lombok.RequiredArgsConstructor;

@RestController
@RequestMapping("/api/home")
@RequiredArgsConstructor
public class HomeController {

    private final HomeService homeService;

    @GetMapping("/student")
    @PreAuthorize("hasRole('STUDENT')")
    public ResponseEntity<StudentHomeResponseDTO> getStudentHome(
            @AuthenticationPrincipal UserDetails principal) {
        UUID userId = UUID.fromString(principal.getUsername());
        Map<String, Object> feed = homeService.getHomeFeed(userId, UserMode.STUDENT);

        @SuppressWarnings("unchecked")
        List<ApartmentListing> listings = (List<ApartmentListing>) feed.get("listings");
        @SuppressWarnings("unchecked")
        List<TransportSubscription> subs = (List<TransportSubscription>) feed.get("subscriptions");

        StudentHomeResponseDTO response = StudentHomeResponseDTO.builder()
                .listings(listings.stream()
                        .map(l -> ApartmentListingDTO.builder()
                                .id(l.getId()).title(l.getTitle())
                                .city(l.getCity()).price(l.getPrice())
                                .createdAt(l.getCreatedAt()).build())
                        .toList())
                .subscriptions(subs.stream()
                        .map(s -> TransportSubscriptionDTO.builder()
                                .id(s.getId()).name(s.getName())
                                .price(s.getPrice()).createdAt(s.getCreatedAt()).build())
                        .toList())
                .profileCompletion((com.example.Wasl.dto.ProfileCompletionDTO) feed.get("profileCompletion"))
                .build();

        return ResponseEntity.ok(response);
    }
}
