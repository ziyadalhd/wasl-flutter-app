package com.example.Wasl.dto;

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
public class TicketResponse {

    private UUID id;
    private String subject;
    private String status;
    private OffsetDateTime createdAt;
    private OffsetDateTime updatedAt;
    private String lastMessage;
    private int messageCount;
}
