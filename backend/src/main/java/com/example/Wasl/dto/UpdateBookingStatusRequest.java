package com.example.Wasl.dto;

import jakarta.validation.constraints.NotBlank;
import lombok.Data;

@Data
public class UpdateBookingStatusRequest {
    @NotBlank(message = "Status is required")
    private String status; // ACCEPTED, REJECTED, CANCELLED, COMPLETED
}
