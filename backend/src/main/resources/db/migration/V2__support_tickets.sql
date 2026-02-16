-- =============================================
-- V2__support_tickets.sql  —  Support & Chat System
-- =============================================

CREATE TABLE support_tickets (
    id          UUID         PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id     UUID         NOT NULL,
    subject     VARCHAR(255) NOT NULL,
    status      VARCHAR(20)  NOT NULL DEFAULT 'OPEN',
    created_at  TIMESTAMPTZ  NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at  TIMESTAMPTZ  NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT chk_ticket_status CHECK (status IN ('OPEN', 'CLOSED')),
    CONSTRAINT fk_support_tickets_user FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

CREATE TABLE support_messages (
    id               UUID    PRIMARY KEY DEFAULT gen_random_uuid(),
    ticket_id        UUID    NOT NULL,
    sender_id        UUID,
    content          TEXT    NOT NULL,
    is_from_support  BOOLEAN NOT NULL DEFAULT FALSE,
    created_at       TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_support_messages_ticket FOREIGN KEY (ticket_id) REFERENCES support_tickets(id) ON DELETE CASCADE,
    CONSTRAINT fk_support_messages_sender FOREIGN KEY (sender_id) REFERENCES users(id) ON DELETE SET NULL
);

-- Indexes
CREATE INDEX idx_support_tickets_user_id    ON support_tickets(user_id);
CREATE INDEX idx_support_tickets_status     ON support_tickets(status);
CREATE INDEX idx_support_tickets_updated_at ON support_tickets(updated_at DESC);
CREATE INDEX idx_support_messages_ticket_id ON support_messages(ticket_id);
CREATE INDEX idx_support_messages_created_at ON support_messages(created_at ASC);
