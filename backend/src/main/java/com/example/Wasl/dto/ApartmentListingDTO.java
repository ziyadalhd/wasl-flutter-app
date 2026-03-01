package com.example.Wasl.dto;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.OffsetDateTime;
import java.util.UUID;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class ApartmentListingDTO {
    private UUID id;
    private String title;
    private String accommodationType;
    private String city;
    private String location;
    private String description;
    private Integer rooms;
    private Integer bathrooms;
    private Integer facilities;
    private Integer capacity;
    private String subscriptionDuration;
    private BigDecimal price;
    private LocalDate startDate;
    private LocalDate endDate;
    private String status;
    private String providerName;
    private UUID providerId;
    private OffsetDateTime createdAt;
}
