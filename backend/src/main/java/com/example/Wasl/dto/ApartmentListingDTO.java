package com.example.Wasl.dto;

import java.math.BigDecimal;
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
    private String city;
    private BigDecimal price;
    private OffsetDateTime createdAt;
}
