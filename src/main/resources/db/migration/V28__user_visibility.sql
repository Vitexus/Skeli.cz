-- V28__user_visibility.sql
ALTER TABLE user_profiles ADD COLUMN IF NOT EXISTS visible TINYINT(1) NOT NULL DEFAULT 1;