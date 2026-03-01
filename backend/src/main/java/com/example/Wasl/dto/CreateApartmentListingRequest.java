package com.example.Wasl.dto;

import java.math.BigDecimal;
import java.time.LocalDate;

import jakarta.validation.constraints.Min;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class CreateApartmentListingRequest {

    @NotBlank(message = "اسم السكن مطلوب")
    private String title;

    @NotBlank(message = "نوع السكن مطلوب")
    private String accommodationType; // APARTMENT, STUDIO, SHARED_ROOM

    @NotBlank(message = "المدينة مطلوبة")
    private String city;

    private String location;

    private String description;

    @Min(value = 1, message = "عدد الغرف يجب أن يكون 1 على الأقل")
    private Integer rooms;

    @Min(value = 1, message = "عدد دورات المياه يجب أن يكون 1 على الأقل")
    private Integer bathrooms;

    @Min(value = 0)
    private Integer facilities;

    @Min(value = 1, message = "السعة يجب أن تكون 1 على الأقل")
    private Integer capacity;

    @NotBlank(message = "مدة الاشتراك مطلوبة")
    private String subscriptionDuration; // MONTHLY, SEMESTER, YEARLY

    @NotNull(message = "السعر مطلوب")
    @Min(value = 0, message = "السعر يجب أن يكون 0 أو أكثر")
    private BigDecimal price;

    @NotNull(message = "تاريخ البداية مطلوب")
    private LocalDate startDate;

    @NotNull(message = "تاريخ النهاية مطلوب")
    private LocalDate endDate;
}
