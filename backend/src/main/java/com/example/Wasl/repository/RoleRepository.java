package com.example.Wasl.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.example.Wasl.entity.Role;

@Repository
public interface RoleRepository extends JpaRepository<Role, String> {
}
