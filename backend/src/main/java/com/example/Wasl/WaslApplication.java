package com.example.Wasl;

import com.fasterxml.jackson.databind.ObjectMapper; 
import com.fasterxml.jackson.databind.SerializationFeature; 
import com.fasterxml.jackson.datatype.jsr310.JavaTimeModule; 
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.context.annotation.Bean; 
@SpringBootApplication
public class WaslApplication {

	public static void main(String[] args) {
		SpringApplication.run(WaslApplication.class, args);
	}

	@Bean
    public ObjectMapper objectMapper() {
        ObjectMapper mapper = new ObjectMapper();
        // Register JavaTimeModule to handle OffsetDateTime/LocalDateTime correctly
        mapper.registerModule(new JavaTimeModule());
        // Configure it to print dates as ISO-8601 strings (e.g., "2023-01-01T12:00:00Z") instead of arrays
        mapper.disable(SerializationFeature.WRITE_DATES_AS_TIMESTAMPS);
        return mapper;
    }

}
