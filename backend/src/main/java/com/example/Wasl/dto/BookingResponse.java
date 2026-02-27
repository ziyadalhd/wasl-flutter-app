package com.example.Wasl.dto;

import java.time.OffsetDateTime;
import java.util.UUID;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class BookingResponse {
    private UUID id;
    private UUID studentId;
    private String studentName;
    private UUID providerId;
    private String providerName;
    private UUID apartmentListingId;
    private UUID transportSubscriptionId;
    private String status;
    private OffsetDateTime createdAt;
    private OffsetDateTime updatedAt;
}
