package com.example.Wasl.repository;

import java.util.List;
import java.util.UUID;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.example.Wasl.entity.SupportMessage;

@Repository
public interface SupportMessageRepository extends JpaRepository<SupportMessage, UUID> {

    List<SupportMessage> findByTicketIdOrderByCreatedAtAsc(UUID ticketId);
}
