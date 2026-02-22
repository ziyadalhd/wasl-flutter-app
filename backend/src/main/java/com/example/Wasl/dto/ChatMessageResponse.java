package com.example.Wasl.dto;

import java.time.LocalDateTime;
import java.util.UUID;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class ChatMessageResponse {
    private UUID id;
    private UUID sessionId;
    private UUID senderId;
    private String content;
    private boolean isRead;
    private LocalDateTime createdAt;
}
