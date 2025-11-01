-- V27__profile_extras.sql
-- Additional profile features: favorites, playlists, linked accounts, notifications

CREATE TABLE IF NOT EXISTS favorites (
  user_id INT NOT NULL,
  video_id VARCHAR(32) NOT NULL,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (user_id, video_id)
);

CREATE TABLE IF NOT EXISTS playlists (
  id INT PRIMARY KEY AUTO_INCREMENT,
  user_id INT NOT NULL,
  name VARCHAR(120) NOT NULL,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  INDEX idx_user (user_id)
);

CREATE TABLE IF NOT EXISTS playlist_items (
  playlist_id INT NOT NULL,
  position INT NOT NULL,
  video_id VARCHAR(32) NOT NULL,
  PRIMARY KEY (playlist_id, position),
  INDEX idx_pl_vid (playlist_id, video_id)
);

CREATE TABLE IF NOT EXISTS linked_accounts (
  user_id INT NOT NULL,
  provider VARCHAR(24) NOT NULL,
  external_id VARCHAR(191) NOT NULL,
  linked_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (user_id, provider)
);

CREATE TABLE IF NOT EXISTS notifications (
  id INT PRIMARY KEY AUTO_INCREMENT,
  user_id INT NOT NULL,
  type VARCHAR(40) NOT NULL,
  payload TEXT NULL,
  read_at TIMESTAMP NULL,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  INDEX idx_user_created (user_id, created_at)
);
