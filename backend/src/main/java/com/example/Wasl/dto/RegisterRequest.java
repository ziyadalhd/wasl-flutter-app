package com.example.Wasl.dto;

import com.example.Wasl.entity.enums.UserMode;

import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Pattern;
import jakarta.validation.constraints.Size;
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
public class RegisterRequest {
    @NotBlank
    @Email
    private String email;

    @NotBlank
    @Pattern(regexp = "^(05\\d{8}|\\+9665\\d{8}|9665\\d{8})$", message = "Phone must be 05XXXXXXXX, +9665XXXXXXXX, or 9665XXXXXXXX")
    private String phone;

    @NotBlank
    @Size(min = 6)
    private String password;

    @NotBlank
    private String fullName;

    @NotNull
    private UserMode mode;
}
