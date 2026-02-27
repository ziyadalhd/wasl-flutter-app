package com.example.Wasl.controller;

import java.util.List;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.example.Wasl.dto.CollegeDTO;
import com.example.Wasl.service.CollegeService;

import lombok.RequiredArgsConstructor;

@RestController
@RequestMapping("/api/colleges")
@RequiredArgsConstructor
public class CollegeController {

    private final CollegeService collegeService;

    @GetMapping
    public ResponseEntity<List<CollegeDTO>> getAllColleges() {
        return ResponseEntity.ok(collegeService.getAllColleges());
    }
}
