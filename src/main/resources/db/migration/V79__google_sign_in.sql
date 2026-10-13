-- Sign in with Google: the Google account (its stable "sub" id) a user signed in with. A Google-only account
-- has no password (password_hash = '', so the password form can't sign in to it) until one is set via "forgot password".
ALTER TABLE users ADD COLUMN IF NOT EXISTS google_sub VARCHAR(64) NULL;
CREATE UNIQUE INDEX IF NOT EXISTS uq_users_google_sub ON users (google_sub);
