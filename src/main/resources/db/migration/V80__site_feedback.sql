-- "Co říkáš na web?": one rating of the whole site per signed-in user (thumbs up or down) and an optional short
-- message. Messages appear on the home page only after the artist gives them a heart (hearted_at).
CREATE TABLE IF NOT EXISTS site_feedback (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
  user_id INT UNSIGNED NOT NULL,
  vote TINYINT NOT NULL,
  message VARCHAR(500) NULL,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP NULL DEFAULT NULL,
  hearted_at TIMESTAMP NULL DEFAULT NULL,
  UNIQUE KEY uq_site_feedback_user (user_id),
  KEY idx_site_feedback_hearted (hearted_at),
  CONSTRAINT fk_site_feedback_user FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
