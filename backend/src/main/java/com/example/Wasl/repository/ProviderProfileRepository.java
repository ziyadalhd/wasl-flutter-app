package com.example.Wasl.repository;

import java.util.UUID;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.example.Wasl.entity.ProviderProfile;

@Repository
public interface ProviderProfileRepository extends JpaRepository<ProviderProfile, UUID> {

    boolean existsByUser_Id(UUID userId);
}
