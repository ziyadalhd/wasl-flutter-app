package com.example.Wasl.dto;

import java.util.UUID;

import jakarta.validation.constraints.NotNull;
import lombok.Data;

@Data
public class CreateChatRequest {
    @NotNull(message = "Target user ID is required")
    private UUID targetUserId;
}
