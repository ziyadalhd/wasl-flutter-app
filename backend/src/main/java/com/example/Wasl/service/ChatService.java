package com.example.Wasl.service;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;
import java.util.UUID;
import java.util.stream.Collectors;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.example.Wasl.dto.ChatMessageResponse;
import com.example.Wasl.dto.ChatSessionResponse;
import com.example.Wasl.entity.ChatMessage;
import com.example.Wasl.entity.ChatSession;
import com.example.Wasl.entity.Role;
import com.example.Wasl.entity.User;
import com.example.Wasl.repository.ChatMessageRepository;
import com.example.Wasl.repository.ChatSessionRepository;
import com.example.Wasl.repository.UserRepository;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class ChatService {

    private final ChatSessionRepository chatSessionRepository;
    private final ChatMessageRepository chatMessageRepository;
    private final UserRepository userRepository;

    @Transactional
    public ChatSessionResponse createOrGetSession(UUID currentUserId, UUID targetUserId) {
        if (currentUserId.equals(targetUserId)) {
            throw new IllegalArgumentException("Cannot create a chat session with yourself");
        }

        User currentUser = userRepository.findById(currentUserId)
                .orElseThrow(() -> new IllegalArgumentException("Current user not found"));
        User targetUser = userRepository.findById(targetUserId)
                .orElseThrow(() -> new IllegalArgumentException("Target user not found"));

        Optional<ChatSession> existingSession = chatSessionRepository.findChatSessionBetweenUsers(currentUser,
                targetUser);

        ChatSession session = existingSession.orElseGet(() -> {
            ChatSession newSession = ChatSession.builder()
                    .user1(currentUser)
                    .user2(targetUser)
                    .build();
            return chatSessionRepository.save(newSession);
        });

        return mapToSessionResponse(session, currentUser);
    }

    @Transactional(readOnly = true)
    public List<ChatSessionResponse> getUserChatSessions(UUID currentUserId) {
        User currentUser = userRepository.findById(currentUserId)
                .orElseThrow(() -> new IllegalArgumentException("User not found"));

        List<ChatSession> sessions = chatSessionRepository.findChatSessionsByUserId(currentUserId);

        return sessions.stream()
                .map(session -> mapToSessionResponse(session, currentUser))
                .collect(Collectors.toList());
    }

    @Transactional(readOnly = true)
    public List<ChatMessageResponse> getSessionMessages(UUID currentUserId, UUID sessionId) {
        ChatSession session = chatSessionRepository.findById(sessionId)
                .orElseThrow(() -> new IllegalArgumentException("Chat session not found"));

        if (!isUserInSession(session, currentUserId)) {
            throw new IllegalArgumentException("User is not part of this chat session");
        }

        User currentUser = userRepository.findById(currentUserId)
                .orElseThrow(() -> new IllegalArgumentException("User not found"));

        List<ChatMessage> messages = chatMessageRepository.findBySessionOrderByCreatedAtAsc(session);

        // Mark messages as read
        boolean updated = false;
        for (ChatMessage message : messages) {
            if (!message.getSender().getId().equals(currentUserId) && !message.isRead()) {
                message.setRead(true);
                updated = true;
            }
        }

        if (updated) {
            chatMessageRepository.saveAll(messages);
        }

        return messages.stream()
                .map(this::mapToMessageResponse)
                .collect(Collectors.toList());
    }

    @Transactional
    public ChatMessageResponse sendMessage(UUID currentUserId, UUID sessionId, String content) {
        ChatSession session = chatSessionRepository.findById(sessionId)
                .orElseThrow(() -> new IllegalArgumentException("Chat session not found"));

        if (!isUserInSession(session, currentUserId)) {
            throw new IllegalArgumentException("User is not part of this chat session");
        }

        User sender = userRepository.findById(currentUserId)
                .orElseThrow(() -> new IllegalArgumentException("User not found"));

        ChatMessage message = ChatMessage.builder()
                .session(session)
                .sender(sender)
                .content(content)
                .isRead(false)
                .build();

        message = chatMessageRepository.save(message);

        // Update session's updatedAt timestamp
        session.setUpdatedAt(LocalDateTime.now());
        chatSessionRepository.save(session);

        return mapToMessageResponse(message);
    }

    private boolean isUserInSession(ChatSession session, UUID userId) {
        return session.getUser1().getId().equals(userId) || session.getUser2().getId().equals(userId);
    }

    private ChatSessionResponse mapToSessionResponse(ChatSession session, User currentUser) {
        User otherUser = session.getUser1().getId().equals(currentUser.getId()) ? session.getUser2()
                : session.getUser1();

        int unreadCount = chatMessageRepository.countBySessionAndSenderNotAndIsReadFalse(session, currentUser);

        String lastMessageText = null;
        LocalDateTime lastMessageTime = null;

        List<ChatMessage> messages = session.getMessages();
        if (messages != null && !messages.isEmpty()) {
            ChatMessage lastMessage = messages.get(messages.size() - 1);
            lastMessageText = lastMessage.getContent();
            lastMessageTime = lastMessage.getCreatedAt();
        }

        String primaryRole = otherUser.getRoles().stream()
                .map(Role::getName)
                .filter(name -> name.equals("STUDENT") || name.equals("PROVIDER"))
                .findFirst()
                .orElse("UNKNOWN");

        return ChatSessionResponse.builder()
                .id(session.getId())
                .otherUserId(otherUser.getId())
                .otherUserName(otherUser.getFullName())
                .otherUserRole(primaryRole)
                .lastMessage(lastMessageText)
                .lastMessageTime(lastMessageTime)
                .unreadCount(unreadCount)
                .createdAt(session.getCreatedAt())
                .updatedAt(session.getUpdatedAt())
                .build();
    }

    private ChatMessageResponse mapToMessageResponse(ChatMessage message) {
        return ChatMessageResponse.builder()
                .id(message.getId())
                .sessionId(message.getSession().getId())
                .senderId(message.getSender().getId())
                .content(message.getContent())
                .isRead(message.isRead())
                .createdAt(message.getCreatedAt())
                .build();
    }
}
