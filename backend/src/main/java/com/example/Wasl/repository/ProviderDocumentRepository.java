package com.example.Wasl.repository;

import java.util.UUID;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.example.Wasl.entity.ProviderDocument;

@Repository
public interface ProviderDocumentRepository extends JpaRepository<ProviderDocument, UUID> {
}
