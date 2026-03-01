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
public class AttachmentDTO {
    private UUID id;
    private String fileUrl;
    private String fileName;
    private String fileType;
    private Long fileSize;
    private OffsetDateTime createdAt;
}
