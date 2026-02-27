-- =============================================
-- V6__schema_hardening.sql
-- Timestamp standardization, admin password fix,
-- phone normalization, booking schema redesign
-- =============================================

-- ─── 1. TIMESTAMP → TIMESTAMPTZ ──────────────────────────────────

ALTER TABLE bookings
    ALTER COLUMN created_at TYPE TIMESTAMPTZ USING created_at AT TIME ZONE 'UTC',
    ALTER COLUMN updated_at TYPE TIMESTAMPTZ USING updated_at AT TIME ZONE 'UTC';

ALTER TABLE chat_sessions
    ALTER COLUMN created_at TYPE TIMESTAMPTZ USING created_at AT TIME ZONE 'UTC',
    ALTER COLUMN updated_at TYPE TIMESTAMPTZ USING updated_at AT TIME ZONE 'UTC';

ALTER TABLE chat_messages
    ALTER COLUMN created_at TYPE TIMESTAMPTZ USING created_at AT TIME ZONE 'UTC';

-- ─── 2. Admin seed password fix (BCrypt of "admin") ──────────────

UPDATE users
   SET password_hash = '$2a$10$GIeh7Es3q8/e96NuQkALYuzl02laoe68TFlWj1mtPF7vk/ye6bT3i'
 WHERE email = 'admin@wasl.com';

-- ─── 3. Phone normalization ─────────────────────────────────────

-- Strip whitespace first, then normalize known formats
UPDATE users
   SET phone = REGEXP_REPLACE(phone, '\s', '', 'g')
 WHERE phone IS NOT NULL;

-- +9665XXXXXXXX → 05XXXXXXXX
UPDATE users
   SET phone = '0' || SUBSTRING(phone FROM 5)
 WHERE phone ~ '^\+9665[0-9]{8}$';

-- 9665XXXXXXXX → 05XXXXXXXX
UPDATE users
   SET phone = '0' || SUBSTRING(phone FROM 4)
 WHERE phone ~ '^9665[0-9]{8}$';

-- Guard: reject non-standard phone formats after normalization
DO $$
BEGIN
    IF EXISTS (SELECT 1 FROM users WHERE phone IS NOT NULL AND phone !~ '^05[0-9]{8}$') THEN
        RAISE EXCEPTION 'MISSING: phone normalization rule for non-standard stored formats';
    END IF;
END $$;

-- ─── 4. Phone NOT NULL guard + constraint ────────────────────────

DO $$
BEGIN
    IF EXISTS (SELECT 1 FROM users WHERE phone IS NULL) THEN
        RAISE EXCEPTION 'MISSING: decision for NULL phone values before NOT NULL constraint';
    END IF;
END $$;

ALTER TABLE users ALTER COLUMN phone SET NOT NULL;

-- ─── 5. Booking schema redesign (Option A) ──────────────────────

-- Guard: ensure referenced tables exist (no guessing)
DO $$
BEGIN
  IF to_regclass('public.apartment_listings') IS NULL THEN
    RAISE EXCEPTION 'MISSING: apartment_listings';
  END IF;
  IF to_regclass('public.transport_subscriptions') IS NULL THEN
    RAISE EXCEPTION 'MISSING: transport_subscriptions';
  END IF;
END $$;

-- Add new FK columns (nullable initially to allow migration)
ALTER TABLE bookings ADD COLUMN apartment_listing_id UUID;
ALTER TABLE bookings ADD COLUMN transport_subscription_id UUID;

-- Migrate existing data
UPDATE bookings
   SET apartment_listing_id = entity_id
 WHERE entity_type = 'APARTMENT';

UPDATE bookings
   SET transport_subscription_id = entity_id
 WHERE entity_type = 'TRANSPORT';

-- Guard: reject orphaned apartment_listing_id references
DO $$
BEGIN
    IF EXISTS (
        SELECT 1 FROM bookings b
         WHERE b.apartment_listing_id IS NOT NULL
           AND NOT EXISTS (SELECT 1 FROM apartment_listings a WHERE a.id = b.apartment_listing_id)
    ) THEN
        RAISE EXCEPTION 'MISSING: booking apartment_listing_id orphaned references';
    END IF;
END $$;

-- Guard: reject orphaned transport_subscription_id references
DO $$
BEGIN
    IF EXISTS (
        SELECT 1 FROM bookings b
         WHERE b.transport_subscription_id IS NOT NULL
           AND NOT EXISTS (SELECT 1 FROM transport_subscriptions t WHERE t.id = b.transport_subscription_id)
    ) THEN
        RAISE EXCEPTION 'MISSING: booking transport_subscription_id orphaned references';
    END IF;
END $$;

-- Guard: ensure Option A state is valid after migration (no new CHECK constraints)
DO $$
BEGIN
    IF EXISTS (
        SELECT 1 FROM bookings
        WHERE (apartment_listing_id IS NULL AND transport_subscription_id IS NULL)
           OR (apartment_listing_id IS NOT NULL AND transport_subscription_id IS NOT NULL)
    ) THEN
        RAISE EXCEPTION 'MISSING: booking option A migration produced invalid FK state';
    END IF;
END $$;

-- Add foreign key constraints
ALTER TABLE bookings
    ADD CONSTRAINT fk_bookings_apartment_listing
    FOREIGN KEY (apartment_listing_id) REFERENCES apartment_listings(id);

ALTER TABLE bookings
    ADD CONSTRAINT fk_bookings_transport_subscription
    FOREIGN KEY (transport_subscription_id) REFERENCES transport_subscriptions(id);

-- Drop old columns and constraint
ALTER TABLE bookings DROP CONSTRAINT IF EXISTS chk_bookings_entity_type;
ALTER TABLE bookings DROP COLUMN entity_id;
ALTER TABLE bookings DROP COLUMN entity_type;

-- Indexes on new FK columns
CREATE INDEX idx_bookings_apartment_listing_id ON bookings(apartment_listing_id);
CREATE INDEX idx_bookings_transport_subscription_id ON bookings(transport_subscription_id);