-- Add avatar_url column to users for profile pictures
ALTER TABLE users ADD COLUMN avatar_url VARCHAR(255) NULL AFTER email;