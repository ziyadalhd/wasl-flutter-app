package com.example.Wasl.dto;

import java.util.List;

import com.example.Wasl.entity.enums.UserMode;

import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotEmpty;
import jakarta.validation.constraints.NotNull;
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
    private String phone;
    @NotBlank
    @Size(min = 6)
    private String password;
    @NotBlank
    private String fullName;
    @NotNull
    private UserMode mode;
    @NotEmpty
    private List<String> rolesWanted;
}
