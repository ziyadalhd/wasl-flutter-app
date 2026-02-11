package com.example.Wasl.service;

import java.util.HashMap;
import java.util.Map;
import java.util.UUID;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.example.Wasl.dto.ProfileCompletionDTO;
import com.example.Wasl.entity.ApartmentListing;
import com.example.Wasl.entity.TransportSubscription;
import com.example.Wasl.entity.User;
import com.example.Wasl.entity.enums.UserMode;
import com.example.Wasl.repository.ApartmentListingRepository;
import com.example.Wasl.repository.TransportSubscriptionRepository;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class HomeService {

    private final ApartmentListingRepository listingRepository;
    private final TransportSubscriptionRepository subscriptionRepository;
    private final ProfileService profileService;

    @Transactional(readOnly = true)
    public Map<String, Object> getHomeFeed(UUID userId, UserMode mode) {
        Page<ApartmentListing> listings = listingRepository
                .findAllByOrderByCreatedAtDesc(PageRequest.of(0, 4));

        Page<TransportSubscription> subscriptions = subscriptionRepository
                .findAllByOrderByCreatedAtDesc(PageRequest.of(0, 3));

        User user = profileService.getProfile(userId, mode);
        ProfileCompletionDTO completion = profileService.calculateCompletion(user, mode);

        Map<String, Object> feed = new HashMap<>();
        feed.put("listings", listings.getContent());
        feed.put("subscriptions", subscriptions.getContent());
        feed.put("profileCompletion", completion);

        return feed;
    }
}
