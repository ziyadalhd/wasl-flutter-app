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
public class CreateTransportSubscriptionRequest {

    @NotBlank(message = "اسم الخدمة مطلوب")
    private String name;

    @NotBlank(message = "نوع المركبة مطلوب")
    private String vehicleType; // BUS, CAR

    private String vehicleModel;

    private Integer vehicleYear;

    private String plateNumber;

    @Min(value = 1, message = "عدد المقاعد يجب أن يكون 1 على الأقل")
    private Integer seats;

    @NotBlank(message = "المدينة مطلوبة")
    private String city;

    private String departureLocation;

    private String universityLocation;

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
