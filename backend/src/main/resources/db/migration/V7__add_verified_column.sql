-- Add verified column to users table (default: false/unverified)
ALTER TABLE users ADD COLUMN verified BOOLEAN NOT NULL DEFAULT false;
