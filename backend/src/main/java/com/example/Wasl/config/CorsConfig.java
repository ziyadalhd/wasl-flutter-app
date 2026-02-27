package com.example.Wasl.config;

import java.util.Collections;
import java.util.List;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.cors.CorsConfiguration;
import org.springframework.web.cors.CorsConfigurationSource;
import org.springframework.web.cors.UrlBasedCorsConfigurationSource;

@Configuration
public class CorsConfig {

    @Value("${cors.allowed-origins}")
    private List<String> allowedOrigins;

    @Bean
    public CorsConfigurationSource corsConfigurationSource() {
        CorsConfiguration configuration = new CorsConfiguration();

        List<String> sanitized = allowedOrigins == null
                ? Collections.emptyList()
                : allowedOrigins.stream()
                        .filter(o -> o != null && !o.isBlank())
                        .toList();

        if (!sanitized.isEmpty()) {
            configuration.setAllowedOriginPatterns(sanitized);
        }

        // ✅ تم إضافة PATCH هنا للسماح لزر التبديل بالعمل
        configuration.setAllowedMethods(List.of("GET", "POST", "PUT", "PATCH", "DELETE", "OPTIONS"));
        
        // ✅ تم إضافة Accept هنا لأن تطبيق Flutter الخاص بك يرسله في الـ Headers
        configuration.setAllowedHeaders(List.of("Authorization", "Content-Type", "Accept"));

        UrlBasedCorsConfigurationSource source = new UrlBasedCorsConfigurationSource();
        source.registerCorsConfiguration("/**", configuration);
        return source;
    }
}