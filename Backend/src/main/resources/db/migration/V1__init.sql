-- =============================================
-- V1__init.sql  —  Wasl University Service Platform
-- =============================================

-- =============================================
-- 1. Extensions
-- =============================================
CREATE EXTENSION IF NOT EXISTS "pgcrypto";

-- =============================================
-- 2. Tables
-- =============================================

CREATE TABLE users (
    id              UUID         PRIMARY KEY DEFAULT gen_random_uuid(),
    email           VARCHAR(255) NOT NULL UNIQUE,
    phone           VARCHAR(50)  UNIQUE,
    password_hash   VARCHAR(255) NOT NULL,
    full_name       VARCHAR(255),
    selected_mode   VARCHAR(50)  NOT NULL DEFAULT 'STUDENT',
    status          VARCHAR(50)  NOT NULL DEFAULT 'ACTIVE',
    CONSTRAINT chk_users_selected_mode CHECK (selected_mode IN ('STUDENT', 'PROVIDER')),
    CONSTRAINT chk_users_status        CHECK (status IN ('ACTIVE', 'SUSPENDED', 'DELETED'))
);

CREATE TABLE roles (
    name VARCHAR(50) PRIMARY KEY
);

CREATE TABLE user_roles (
    user_id   UUID        NOT NULL,
    role_name VARCHAR(50) NOT NULL,
    PRIMARY KEY (user_id, role_name),
    CONSTRAINT fk_user_roles_user FOREIGN KEY (user_id)   REFERENCES users(id)  ON DELETE CASCADE,
    CONSTRAINT fk_user_roles_role FOREIGN KEY (role_name)  REFERENCES roles(name)
);

CREATE TABLE colleges (
    id   UUID         PRIMARY KEY DEFAULT gen_random_uuid(),
    name VARCHAR(255) NOT NULL
);

CREATE TABLE student_profiles (
    user_id       UUID PRIMARY KEY,
    university_id VARCHAR(255),
    college_id    UUID,
    CONSTRAINT fk_student_profiles_user    FOREIGN KEY (user_id)    REFERENCES users(id)    ON DELETE CASCADE,
    CONSTRAINT fk_student_profiles_college FOREIGN KEY (college_id) REFERENCES colleges(id)
);

CREATE TABLE provider_profiles (
    user_id             UUID PRIMARY KEY,
    bio                 TEXT,
    verification_status VARCHAR(50) NOT NULL DEFAULT 'PENDING',
    provider_type       VARCHAR(50),
    CONSTRAINT chk_provider_verification_status CHECK (verification_status IN ('PENDING', 'APPROVED', 'REJECTED')),
    CONSTRAINT chk_provider_type                CHECK (provider_type IN ('ACCOMMODATION', 'TRANSPORTATION', 'BOTH')),
    CONSTRAINT fk_provider_profiles_user        FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

CREATE TABLE provider_documents (
    id               UUID          PRIMARY KEY DEFAULT gen_random_uuid(),
    provider_user_id UUID          NOT NULL,
    url              VARCHAR(1024) NOT NULL,
    CONSTRAINT fk_provider_documents_provider FOREIGN KEY (provider_user_id) REFERENCES provider_profiles(user_id) ON DELETE CASCADE
);

CREATE TABLE apartment_listings (
    id               UUID           PRIMARY KEY DEFAULT gen_random_uuid(),
    provider_user_id UUID           NOT NULL,
    title            VARCHAR(255),
    city             VARCHAR(255),
    price            NUMERIC(10,2),
    created_at       TIMESTAMPTZ    NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_apartment_listings_provider FOREIGN KEY (provider_user_id) REFERENCES provider_profiles(user_id) ON DELETE RESTRICT
);

CREATE TABLE transport_subscriptions (
    id               UUID           PRIMARY KEY DEFAULT gen_random_uuid(),
    provider_user_id UUID           NOT NULL,
    name             VARCHAR(255),
    price            NUMERIC(10,2),
    created_at       TIMESTAMPTZ    NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_transport_subscriptions_provider FOREIGN KEY (provider_user_id) REFERENCES provider_profiles(user_id) ON DELETE RESTRICT
);

-- =============================================
-- 3. Indexes
-- =============================================

-- Foreign-key column indexes
CREATE INDEX idx_user_roles_user_id                      ON user_roles(user_id);
CREATE INDEX idx_user_roles_role_name                    ON user_roles(role_name);
CREATE INDEX idx_student_profiles_college_id             ON student_profiles(college_id);
CREATE INDEX idx_provider_documents_provider_user_id     ON provider_documents(provider_user_id);
CREATE INDEX idx_apartment_listings_provider_user_id     ON apartment_listings(provider_user_id);
CREATE INDEX idx_transport_subscriptions_provider_user_id ON transport_subscriptions(provider_user_id);

-- Timestamp indexes (descending for recent-first queries)
CREATE INDEX idx_apartment_listings_created_at           ON apartment_listings(created_at DESC);
CREATE INDEX idx_transport_subscriptions_created_at      ON transport_subscriptions(created_at DESC);

-- =============================================
-- 4. Seed Data
-- =============================================

-- 4a. Roles
INSERT INTO roles (name) VALUES
    ('STUDENT'),
    ('PROVIDER'),
    ('ADMIN');

-- 4b. Colleges (5)
INSERT INTO colleges (id, name) VALUES
    ('00000000-0000-0000-0000-000000000101', 'College of Engineering'),
    ('00000000-0000-0000-0000-000000000102', 'College of Science'),
    ('00000000-0000-0000-0000-000000000103', 'College of Business Administration'),
    ('00000000-0000-0000-0000-000000000104', 'College of Medicine'),
    ('00000000-0000-0000-0000-000000000105', 'College of Arts');

-- 4c. Users (hardcoded UUIDs, exact BCrypt hash)
INSERT INTO users (id, email, phone, password_hash, full_name, selected_mode, status) VALUES
    ('00000000-0000-0000-0000-000000000001', 'admin@wasl.com',    '+966500000001', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOcd7qa8qkrF6', 'Admin User',    'STUDENT',  'ACTIVE'),
    ('00000000-0000-0000-0000-000000000002', 'student@wasl.com',  '+966500000002', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOcd7qa8qkrF6', 'Student User',  'STUDENT',  'ACTIVE'),
    ('00000000-0000-0000-0000-000000000003', 'provider@wasl.com', '+966500000003', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOcd7qa8qkrF6', 'Provider User', 'PROVIDER', 'ACTIVE');

-- 4d. User-Role assignments
INSERT INTO user_roles (user_id, role_name) VALUES
    ('00000000-0000-0000-0000-000000000001', 'ADMIN'),
    ('00000000-0000-0000-0000-000000000002', 'STUDENT'),
    ('00000000-0000-0000-0000-000000000003', 'PROVIDER');

-- 4e. Student profile
INSERT INTO student_profiles (user_id, university_id, college_id) VALUES
    ('00000000-0000-0000-0000-000000000002', 'UNI-001', '00000000-0000-0000-0000-000000000101');

-- Admin profile (empty to match selected_mode)
INSERT INTO student_profiles (user_id, university_id, college_id)
VALUES ('00000000-0000-0000-0000-000000000001', NULL, NULL);


-- 4f. Provider profile
INSERT INTO provider_profiles (user_id, bio, verification_status, provider_type) VALUES
    ('00000000-0000-0000-0000-000000000003', 'Verified accommodation and transport provider', 'APPROVED', 'BOTH');

-- 4g. Apartment Listings (20) — linked to Provider ...003
INSERT INTO apartment_listings (id, provider_user_id, title, city, price) VALUES
    (gen_random_uuid(), '00000000-0000-0000-0000-000000000003', 'Modern Studio near KSU',             'Riyadh',  1500.00),
    (gen_random_uuid(), '00000000-0000-0000-0000-000000000003', 'Spacious 2BR Apartment',             'Jeddah',  2500.00),
    (gen_random_uuid(), '00000000-0000-0000-0000-000000000003', 'Furnished Room for Students',        'Riyadh',   800.00),
    (gen_random_uuid(), '00000000-0000-0000-0000-000000000003', 'Luxury Apartment with Pool',         'Dammam',  3000.00),
    (gen_random_uuid(), '00000000-0000-0000-0000-000000000003', 'Cozy Studio Downtown',               'Riyadh',  1200.00),
    (gen_random_uuid(), '00000000-0000-0000-0000-000000000003', 'Shared Student Housing',             'Jeddah',   600.00),
    (gen_random_uuid(), '00000000-0000-0000-0000-000000000003', '1BR Near University Gate',           'Riyadh',  1800.00),
    (gen_random_uuid(), '00000000-0000-0000-0000-000000000003', 'Premium Penthouse Suite',            'Riyadh',  5000.00),
    (gen_random_uuid(), '00000000-0000-0000-0000-000000000003', 'Budget-Friendly Room',               'Dammam',   500.00),
    (gen_random_uuid(), '00000000-0000-0000-0000-000000000003', '3BR Family Apartment',               'Jeddah',  3500.00),
    (gen_random_uuid(), '00000000-0000-0000-0000-000000000003', 'Student Dormitory Single',           'Riyadh',   700.00),
    (gen_random_uuid(), '00000000-0000-0000-0000-000000000003', 'Furnished Flat with Balcony',        'Makkah',  2000.00),
    (gen_random_uuid(), '00000000-0000-0000-0000-000000000003', 'Modern Loft Apartment',              'Riyadh',  2200.00),
    (gen_random_uuid(), '00000000-0000-0000-0000-000000000003', 'Studio with Kitchenette',            'Madinah', 900.00),
    (gen_random_uuid(), '00000000-0000-0000-0000-000000000003', '2BR Near Shopping Mall',             'Dammam',  2800.00),
    (gen_random_uuid(), '00000000-0000-0000-0000-000000000003', 'Compact Studio for One',             'Riyadh',  1000.00),
    (gen_random_uuid(), '00000000-0000-0000-0000-000000000003', 'Newly Renovated 1BR',               'Jeddah',  1600.00),
    (gen_random_uuid(), '00000000-0000-0000-0000-000000000003', 'Quiet Neighborhood 2BR',            'Riyadh',  2400.00),
    (gen_random_uuid(), '00000000-0000-0000-0000-000000000003', 'Furnished Single Room',             'Dammam',   750.00),
    (gen_random_uuid(), '00000000-0000-0000-0000-000000000003', 'Deluxe 3BR with Parking',           'Jeddah',  4000.00);

-- 4h. Transport Subscriptions (10) — linked to Provider ...003
INSERT INTO transport_subscriptions (id, provider_user_id, name, price) VALUES
    (gen_random_uuid(), '00000000-0000-0000-0000-000000000003', 'Daily Campus Shuttle',       200.00),
    (gen_random_uuid(), '00000000-0000-0000-0000-000000000003', 'Weekly City-Campus Route',   150.00),
    (gen_random_uuid(), '00000000-0000-0000-0000-000000000003', 'Monthly All-Access Pass',    500.00),
    (gen_random_uuid(), '00000000-0000-0000-0000-000000000003', 'Weekend Special Route',      100.00),
    (gen_random_uuid(), '00000000-0000-0000-0000-000000000003', 'Express Morning Shuttle',    250.00),
    (gen_random_uuid(), '00000000-0000-0000-0000-000000000003', 'Evening Return Service',     180.00),
    (gen_random_uuid(), '00000000-0000-0000-0000-000000000003', 'Inter-Campus Connector',     300.00),
    (gen_random_uuid(), '00000000-0000-0000-0000-000000000003', 'Airport Transfer Package',   400.00),
    (gen_random_uuid(), '00000000-0000-0000-0000-000000000003', 'Premium Door-to-Door',       600.00),
    (gen_random_uuid(), '00000000-0000-0000-0000-000000000003', 'Semester Unlimited Pass',   1800.00);
