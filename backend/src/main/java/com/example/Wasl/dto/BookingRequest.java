package com.example.Wasl.dto;

import java.util.UUID;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import lombok.Data;

@Data
public class BookingRequest {
    @NotNull(message = "Provider ID is required")
    private UUID providerId;

    @NotNull(message = "Entity ID is required")
    private UUID entityId;

    @NotBlank(message = "Entity Type is required")
    private String entityType;
}
