package com.example.Wasl.repository;

import java.util.UUID;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.example.Wasl.entity.College;

@Repository
public interface CollegeRepository extends JpaRepository<College, UUID> {
}
