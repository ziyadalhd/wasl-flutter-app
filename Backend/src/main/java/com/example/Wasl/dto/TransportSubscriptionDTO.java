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
public class TransportSubscriptionDTO {
    private UUID id;
    private String name;
    private BigDecimal price;
    private OffsetDateTime createdAt;
}
