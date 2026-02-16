package com.example.Wasl.service;

import java.time.OffsetDateTime;
import java.util.List;
import java.util.UUID;
import java.util.stream.Collectors;

import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.example.Wasl.dto.MessageResponse;
import com.example.Wasl.dto.TicketResponse;
import com.example.Wasl.entity.SupportMessage;
import com.example.Wasl.entity.SupportTicket;
import com.example.Wasl.entity.User;
import com.example.Wasl.entity.enums.TicketStatus;
import com.example.Wasl.exception.BusinessRuleException;
import com.example.Wasl.repository.SupportMessageRepository;
import com.example.Wasl.repository.SupportTicketRepository;
import com.example.Wasl.repository.UserRepository;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class SupportService {

    private static final String WELCOME_MESSAGE = "اهلا بك في الدعم الفني لتطبيق وصل، كيف نقدر نساعدك؟";

    private final SupportTicketRepository ticketRepository;
    private final SupportMessageRepository messageRepository;
    private final UserRepository userRepository;

    // ────────────────────────────────────────────────
    // Create ticket + user's first message + welcome
    // ────────────────────────────────────────────────
    @Transactional
    public TicketResponse createTicket(UUID userId, String subject, String firstMessage) {
        User user = findUserOrThrow(userId);

        SupportTicket ticket = SupportTicket.builder()
                .user(user)
                .subject(subject)
                .build();
        ticket = ticketRepository.save(ticket);

        // 1) Auto-welcome from support
        SupportMessage welcome = SupportMessage.builder()
                .ticket(ticket)
                .sender(null) // system message — no human sender
                .content(WELCOME_MESSAGE)
                .fromSupport(true)
                .build();
        messageRepository.save(welcome);

        // 2) User's first message
        SupportMessage userMsg = SupportMessage.builder()
                .ticket(ticket)
                .sender(user)
                .content(firstMessage)
                .fromSupport(false)
                .build();
        messageRepository.save(userMsg);

        return toTicketResponse(ticket, firstMessage, 2);
    }

    // ────────────────────────────────────────────────
    // List user's tickets
    // ────────────────────────────────────────────────
    public List<TicketResponse> getUserTickets(UUID userId) {
        List<SupportTicket> tickets = ticketRepository.findByUserIdOrderByUpdatedAtDesc(userId);

        return tickets.stream().map(ticket -> {
            List<SupportMessage> messages = messageRepository.findByTicketIdOrderByCreatedAtAsc(ticket.getId());
            String lastMsg = messages.isEmpty() ? "" : messages.get(messages.size() - 1).getContent();
            return toTicketResponse(ticket, lastMsg, messages.size());
        }).collect(Collectors.toList());
    }

    // ────────────────────────────────────────────────
    // Get messages for a specific ticket
    // ────────────────────────────────────────────────
    public List<MessageResponse> getTicketMessages(UUID userId, UUID ticketId) {
        SupportTicket ticket = findTicketOrThrow(ticketId, userId);

        List<SupportMessage> messages = messageRepository.findByTicketIdOrderByCreatedAtAsc(ticket.getId());

        return messages.stream()
                .map(this::toMessageResponse)
                .collect(Collectors.toList());
    }

    // ────────────────────────────────────────────────
    // Send a message inside a ticket
    // ────────────────────────────────────────────────
    @Transactional
    public MessageResponse sendMessage(UUID userId, UUID ticketId, String content) {
        SupportTicket ticket = findTicketOrThrow(ticketId, userId);

        if (ticket.getStatus() == TicketStatus.CLOSED) {
            throw new BusinessRuleException("Cannot send messages to a closed ticket");
        }

        User sender = findUserOrThrow(userId);

        SupportMessage message = SupportMessage.builder()
                .ticket(ticket)
                .sender(sender)
                .content(content)
                .fromSupport(false)
                .build();
        message = messageRepository.save(message);

        // Touch the ticket so it bubbles up in the list
        ticket.setUpdatedAt(OffsetDateTime.now());
        ticketRepository.save(ticket);

        return toMessageResponse(message);
    }

    // ────────────────────────────────────────────────
    // Close a ticket
    // ────────────────────────────────────────────────
    @Transactional
    public TicketResponse closeTicket(UUID userId, UUID ticketId) {
        SupportTicket ticket = findTicketOrThrow(ticketId, userId);

        if (ticket.getStatus() == TicketStatus.CLOSED) {
            throw new BusinessRuleException("Ticket is already closed");
        }

        ticket.setStatus(TicketStatus.CLOSED);
        ticket.setUpdatedAt(OffsetDateTime.now());
        ticketRepository.save(ticket);

        List<SupportMessage> messages = messageRepository.findByTicketIdOrderByCreatedAtAsc(ticket.getId());
        String lastMsg = messages.isEmpty() ? "" : messages.get(messages.size() - 1).getContent();

        return toTicketResponse(ticket, lastMsg, messages.size());
    }

    // ═══════════════════════════════════════════════
    // Private helpers
    // ═══════════════════════════════════════════════

    private User findUserOrThrow(UUID userId) {
        return userRepository.findById(userId)
                .orElseThrow(() -> new UsernameNotFoundException("User not found"));
    }

    private SupportTicket findTicketOrThrow(UUID ticketId, UUID userId) {
        return ticketRepository.findByIdAndUserId(ticketId, userId)
                .orElseThrow(() -> new BusinessRuleException("Ticket not found"));
    }

    private TicketResponse toTicketResponse(SupportTicket ticket, String lastMessage, int messageCount) {
        return TicketResponse.builder()
                .id(ticket.getId())
                .subject(ticket.getSubject())
                .status(ticket.getStatus().name())
                .createdAt(ticket.getCreatedAt())
                .updatedAt(ticket.getUpdatedAt())
                .lastMessage(lastMessage)
                .messageCount(messageCount)
                .build();
    }

    private MessageResponse toMessageResponse(SupportMessage message) {
        String senderName = message.isFromSupport()
                ? "الدعم الفني"
                : (message.getSender() != null ? message.getSender().getFullName() : "مستخدم");

        return MessageResponse.builder()
                .id(message.getId())
                .content(message.getContent())
                .fromSupport(message.isFromSupport())
                .senderName(senderName)
                .createdAt(message.getCreatedAt())
                .build();
    }
}
