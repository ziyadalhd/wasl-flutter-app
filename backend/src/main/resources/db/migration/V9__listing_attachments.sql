-- =============================================
-- V9__listing_attachments.sql
-- Attachments table for apartment and transport listings
-- =============================================

CREATE TABLE listing_attachments (
    id                        UUID          PRIMARY KEY DEFAULT gen_random_uuid(),
    apartment_listing_id      UUID,
    transport_subscription_id UUID,
    file_url                  VARCHAR(1024) NOT NULL,
    file_name                 VARCHAR(255)  NOT NULL,
    file_type                 VARCHAR(50)   NOT NULL,
    file_size                 BIGINT,
    created_at                TIMESTAMPTZ   NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_attachment_apartment
        FOREIGN KEY (apartment_listing_id) REFERENCES apartment_listings(id) ON DELETE CASCADE,
    CONSTRAINT fk_attachment_transport
        FOREIGN KEY (transport_subscription_id) REFERENCES transport_subscriptions(id) ON DELETE CASCADE,

    -- Each attachment must belong to exactly one listing type
    CONSTRAINT chk_attachment_one_parent
        CHECK (
            (apartment_listing_id IS NOT NULL AND transport_subscription_id IS NULL) OR
            (apartment_listing_id IS NULL AND transport_subscription_id IS NOT NULL)
        ),

    -- file_type must be one of the allowed types
    CONSTRAINT chk_attachment_file_type
        CHECK (file_type IN ('REGISTRATION', 'INSURANCE', 'VEHICLE_IMAGE', 'LISTING_IMAGE'))
);

-- Indexes
CREATE INDEX idx_attachments_apartment ON listing_attachments(apartment_listing_id);
CREATE INDEX idx_attachments_transport ON listing_attachments(transport_subscription_id);
