package com.example.Wasl.dto;

import java.time.OffsetDateTime;
import java.util.Map;

import com.fasterxml.jackson.annotation.JsonFormat;
import com.fasterxml.jackson.annotation.JsonInclude;

@JsonInclude(JsonInclude.Include.NON_NULL)
public record ApiErrorResponse(
        @JsonFormat(shape = JsonFormat.Shape.STRING, pattern = "yyyy-MM-dd'T'HH:mm:ss.SSSXXX") OffsetDateTime timestamp,
        int status,
        String error,
        String message,
        String path,
        Map<String, String> validationErrors) {
}
