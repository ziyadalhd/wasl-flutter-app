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
public class TransportSubscriptionDTO {
    private UUID id;
    private String name;
    private String vehicleType;
    private String vehicleModel;
    private Integer vehicleYear;
    private String plateNumber;
    private Integer seats;
    private String city;
    private String departureLocation;
    private String universityLocation;
    private String subscriptionDuration;
    private BigDecimal price;
    private LocalDate startDate;
    private LocalDate endDate;
    private String status;
    private String providerName;
    private UUID providerId;
    private OffsetDateTime createdAt;
}
