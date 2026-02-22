package com.example.Wasl.dto;

import jakarta.validation.constraints.NotBlank;
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
public class UpdateProfileRequest {

    @NotBlank(message = "Full name is required")
    private String fullName;

    private String phone;

    private String city;

    // Student-only fields
    private String universityId;
    private String universityName;
    private String collegeName;

    // Provider-only fields
    private String bio;
}
