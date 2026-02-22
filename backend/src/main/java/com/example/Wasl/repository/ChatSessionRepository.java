package com.example.Wasl.repository;

import java.util.List;
import java.util.Optional;
import java.util.UUID;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import com.example.Wasl.entity.ChatSession;
import com.example.Wasl.entity.User;

public interface ChatSessionRepository extends JpaRepository<ChatSession, UUID> {

    @Query("SELECT cs FROM ChatSession cs WHERE (cs.user1 = :userA AND cs.user2 = :userB) OR (cs.user1 = :userB AND cs.user2 = :userA)")
    Optional<ChatSession> findChatSessionBetweenUsers(@Param("userA") User userA, @Param("userB") User userB);

    @Query("SELECT cs FROM ChatSession cs WHERE cs.user1.id = :userId OR cs.user2.id = :userId ORDER BY cs.updatedAt DESC")
    List<ChatSession> findChatSessionsByUserId(@Param("userId") UUID userId);
}
