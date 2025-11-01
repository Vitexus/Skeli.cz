-- V26__social_posts.sql
-- Social posts table for IG/FB aggregation
CREATE TABLE IF NOT EXISTS social_posts (
  id INT PRIMARY KEY AUTO_INCREMENT,
  source VARCHAR(16) NOT NULL,            -- 'instagram' | 'facebook'
  post_id VARCHAR(191) NOT NULL,          -- platform specific ID
  permalink VARCHAR(512) NOT NULL,
  image_url VARCHAR(512) NULL,
  caption TEXT NULL,
  created_at DATETIME NOT NULL,
  inserted_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  UNIQUE KEY uq_source_postid (source, post_id),
  KEY idx_created_at (created_at)
);
