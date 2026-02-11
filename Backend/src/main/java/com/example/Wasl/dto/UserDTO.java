package com.example.Wasl.dto;

import java.util.List;
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
public class UserDTO {
    private UUID id;
    private String email;
    private String phone;
    private String fullName;
    private String selectedMode;
    private String status;
    private List<String> roles;
}
