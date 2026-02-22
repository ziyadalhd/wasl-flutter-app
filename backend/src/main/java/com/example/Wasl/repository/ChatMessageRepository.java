package com.example.Wasl.repository;

import java.util.List;
import java.util.UUID;

import org.springframework.data.jpa.repository.JpaRepository;

import com.example.Wasl.entity.ChatMessage;
import com.example.Wasl.entity.ChatSession;
import com.example.Wasl.entity.User;

public interface ChatMessageRepository extends JpaRepository<ChatMessage, UUID> {

    List<ChatMessage> findBySessionOrderByCreatedAtAsc(ChatSession session);

    int countBySessionAndSenderNotAndIsReadFalse(ChatSession session, User currentUser);
}
