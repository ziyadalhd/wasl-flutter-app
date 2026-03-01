-- =============================================
-- V8__service_listings_enrich.sql
-- Enriches apartment_listings and transport_subscriptions
-- with full form fields + admin approval workflow
-- =============================================

-- ─── 1. Enrich apartment_listings ─────────────────────────────────

ALTER TABLE apartment_listings
    ADD COLUMN accommodation_type   VARCHAR(50),
    ADD COLUMN description          TEXT,
    ADD COLUMN location             VARCHAR(500),
    ADD COLUMN rooms                INTEGER,
    ADD COLUMN bathrooms            INTEGER,
    ADD COLUMN facilities           INTEGER,
    ADD COLUMN capacity             INTEGER,
    ADD COLUMN subscription_duration VARCHAR(50),
    ADD COLUMN start_date           DATE,
    ADD COLUMN end_date             DATE,
    ADD COLUMN status               VARCHAR(50) NOT NULL DEFAULT 'ACTIVE';

-- Existing seed data gets ACTIVE status (already set by DEFAULT above)

-- Constraints
ALTER TABLE apartment_listings
    ADD CONSTRAINT chk_apartment_accommodation_type
    CHECK (accommodation_type IN ('APARTMENT', 'STUDIO', 'SHARED_ROOM'));

ALTER TABLE apartment_listings
    ADD CONSTRAINT chk_apartment_subscription_duration
    CHECK (subscription_duration IN ('MONTHLY', 'SEMESTER', 'YEARLY'));

ALTER TABLE apartment_listings
    ADD CONSTRAINT chk_apartment_status
    CHECK (status IN ('PENDING_REVIEW', 'ACTIVE', 'REJECTED', 'INACTIVE'));

-- Index on status for filtering
CREATE INDEX idx_apartment_listings_status ON apartment_listings(status);

-- ─── 2. Enrich transport_subscriptions ────────────────────────────

ALTER TABLE transport_subscriptions
    ADD COLUMN vehicle_type          VARCHAR(20),
    ADD COLUMN vehicle_model         VARCHAR(255),
    ADD COLUMN vehicle_year          INTEGER,
    ADD COLUMN plate_number          VARCHAR(50),
    ADD COLUMN seats                 INTEGER,
    ADD COLUMN city                  VARCHAR(255),
    ADD COLUMN departure_location    VARCHAR(500),
    ADD COLUMN university_location   VARCHAR(500),
    ADD COLUMN subscription_duration VARCHAR(50),
    ADD COLUMN start_date            DATE,
    ADD COLUMN end_date              DATE,
    ADD COLUMN status                VARCHAR(50) NOT NULL DEFAULT 'ACTIVE';

-- Constraints
ALTER TABLE transport_subscriptions
    ADD CONSTRAINT chk_transport_vehicle_type
    CHECK (vehicle_type IN ('BUS', 'CAR'));

ALTER TABLE transport_subscriptions
    ADD CONSTRAINT chk_transport_subscription_duration
    CHECK (subscription_duration IN ('MONTHLY', 'SEMESTER', 'YEARLY'));

ALTER TABLE transport_subscriptions
    ADD CONSTRAINT chk_transport_status
    CHECK (status IN ('PENDING_REVIEW', 'ACTIVE', 'REJECTED', 'INACTIVE'));

-- Index on status for filtering
CREATE INDEX idx_transport_subscriptions_status ON transport_subscriptions(status);
