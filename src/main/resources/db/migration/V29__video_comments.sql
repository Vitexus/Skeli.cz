-- V29__video_comments.sql

CREATE TABLE IF NOT EXISTS video_comments (
  id INT PRIMARY KEY AUTO_INCREMENT,
  user_id INT NOT NULL,
  youtube_id VARCHAR(32) NOT NULL,
  content TEXT NOT NULL,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
  INDEX idx_video (youtube_id),
  INDEX idx_user (user_id)
);

CREATE TABLE IF NOT EXISTS video_comment_votes (
  comment_id INT NOT NULL,
  user_id INT NOT NULL,
  vote TINYINT NOT NULL CHECK (vote IN (-1,1)),
  PRIMARY KEY (comment_id, user_id)
);
