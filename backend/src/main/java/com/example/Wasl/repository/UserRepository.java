package com.example.Wasl.repository;

import java.util.Optional;
import java.util.UUID;

import org.springframework.data.jpa.repository.EntityGraph;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import com.example.Wasl.entity.User;

@Repository
public interface UserRepository extends JpaRepository<User, UUID> {

    Optional<User> findByEmail(String email);

    Optional<User> findByPhone(String phone);

    @EntityGraph(attributePaths = { "studentProfile" })
    @Query("SELECT u FROM User u WHERE u.id = :id")
    Optional<User> findByIdWithStudentProfile(@Param("id") UUID id);

    @EntityGraph(attributePaths = { "providerProfile", "providerProfile.documents" })
    @Query("SELECT u FROM User u WHERE u.id = :id")
    Optional<User> findByIdWithProviderProfileAndDocuments(@Param("id") UUID id);

    boolean existsByEmail(String email);

    boolean existsByPhone(String phone);
}
