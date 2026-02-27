package com.example.Wasl.service;

import java.util.List;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.example.Wasl.dto.CollegeDTO;
import com.example.Wasl.repository.CollegeRepository;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class CollegeService {

    private final CollegeRepository collegeRepository;

    @Transactional(readOnly = true)
    public List<CollegeDTO> getAllColleges() {
        return collegeRepository.findAll().stream()
                .map(c -> new CollegeDTO(c.getId(), c.getName()))
                .toList();
    }
}
