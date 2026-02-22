package com.example.Wasl.controller;

import java.util.List;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.example.Wasl.entity.College;
import com.example.Wasl.repository.CollegeRepository;

import lombok.RequiredArgsConstructor;

@RestController
@RequestMapping("/api/colleges")
@RequiredArgsConstructor
public class CollegeController {

    private final CollegeRepository collegeRepository;

    @GetMapping
    public ResponseEntity<List<College>> getAllColleges() {
        return ResponseEntity.ok(collegeRepository.findAll());
    }
}
