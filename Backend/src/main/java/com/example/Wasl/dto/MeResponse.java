package com.example.Wasl.dto;

import io.swagger.v3.oas.annotations.media.DiscriminatorMapping;
import io.swagger.v3.oas.annotations.media.Schema;
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
public class MeResponse {
    private UserDTO user;

    @Schema(description = "Current active mode", example = "STUDENT")
    private String mode;

    @Schema(oneOf = { StudentProfileDTO.class,
            ProviderProfileDTO.class }, discriminatorProperty = "mode", discriminatorMapping = {
                    @DiscriminatorMapping(value = "STUDENT", schema = StudentProfileDTO.class),
                    @DiscriminatorMapping(value = "PROVIDER", schema = ProviderProfileDTO.class)
            })
    private ProfileDTO profile;
}
