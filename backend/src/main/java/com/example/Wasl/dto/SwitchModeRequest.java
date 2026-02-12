package com.example.Wasl.dto;

import com.example.Wasl.entity.enums.UserMode;

import jakarta.validation.constraints.NotNull;
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
public class SwitchModeRequest {
    @NotNull
    private UserMode mode;
}
