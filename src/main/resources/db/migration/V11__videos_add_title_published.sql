START TRANSACTION;

ALTER TABLE `videos`
  ADD COLUMN `title` varchar(255) DEFAULT NULL,
  ADD COLUMN `published_at` datetime DEFAULT NULL,
  ADD KEY `idx_videos_published_at` (`published_at`);

COMMIT;