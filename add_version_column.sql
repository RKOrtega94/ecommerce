-- Add version column to all tables that extend BaseEntity
-- Run this migration script to add optimistic locking support

-- Core service tables
ALTER TABLE services ADD COLUMN version BIGINT DEFAULT 0;

ALTER TABLE service_resources ADD COLUMN version BIGINT DEFAULT 0;

ALTER TABLE applications ADD COLUMN version BIGINT DEFAULT 0;

-- Security service tables
ALTER TABLE users ADD COLUMN version BIGINT DEFAULT 0;

ALTER TABLE roles ADD COLUMN version BIGINT DEFAULT 0;

ALTER TABLE permissions ADD COLUMN version BIGINT DEFAULT 0;

ALTER TABLE sessions ADD COLUMN version BIGINT DEFAULT 0;

-- Update existing records to have version = 0
UPDATE services SET version = 0 WHERE version IS NULL;

UPDATE service_resources SET version = 0 WHERE version IS NULL;

UPDATE applications SET version = 0 WHERE version IS NULL;

UPDATE users SET version = 0 WHERE version IS NULL;

UPDATE roles SET version = 0 WHERE version IS NULL;

UPDATE permissions SET version = 0 WHERE version IS NULL;

UPDATE sessions SET version = 0 WHERE version IS NULL;

-- Make version columns NOT NULL after setting default values
ALTER TABLE services ALTER COLUMN version SET NOT NULL;

ALTER TABLE service_resources ALTER COLUMN version SET NOT NULL;

ALTER TABLE applications ALTER COLUMN version SET NOT NULL;

ALTER TABLE users ALTER COLUMN version SET NOT NULL;

ALTER TABLE roles ALTER COLUMN version SET NOT NULL;

ALTER TABLE permissions ALTER COLUMN version SET NOT NULL;

ALTER TABLE sessions ALTER COLUMN version SET NOT NULL;