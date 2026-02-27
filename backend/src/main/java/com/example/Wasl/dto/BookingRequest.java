package com.example.Wasl.dto;

import java.util.UUID;

import jakarta.validation.constraints.NotNull;
import lombok.Data;

@Data
public class BookingRequest {
    @NotNull(message = "Provider ID is required")
    private UUID providerId;

    private UUID apartmentListingId;

    private UUID transportSubscriptionId;
}
