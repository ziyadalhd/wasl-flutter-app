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
public class ChatSessionResponse {
    private UUID id;
    private UUID otherUserId;
    private String otherUserName;
    private String otherUserRole; // STUDENT, PROVIDER
    private String lastMessage;
    private OffsetDateTime lastMessageTime;
    private int unreadCount;
    private OffsetDateTime createdAt;
    private OffsetDateTime updatedAt;
}
