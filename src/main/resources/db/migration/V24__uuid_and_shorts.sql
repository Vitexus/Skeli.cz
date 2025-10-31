START TRANSACTION;

-- Add UUID column to songs table
ALTER TABLE `songs` ADD COLUMN `uuid` varchar(36) NULL AFTER `id`;
ALTER TABLE `songs` ADD UNIQUE KEY `uq_songs_uuid` (`uuid`);

-- Create shorts table for YouTube Shorts videos
CREATE TABLE `shorts` (
  `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `youtube_id` varchar(20) NOT NULL,
  `song_id` int(10) UNSIGNED NULL,
  `title` varchar(255) DEFAULT NULL,
  `published_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_shorts_youtube_id` (`youtube_id`),
  KEY `idx_shorts_song_id` (`song_id`),
  CONSTRAINT `fk_shorts_song_id` FOREIGN KEY (`song_id`) REFERENCES `songs`(`id`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Add title and published_at columns to videos table if not exists
ALTER TABLE `videos` ADD COLUMN `title` varchar(255) DEFAULT NULL AFTER `song_id`;
ALTER TABLE `videos` ADD COLUMN `published_at` timestamp NULL DEFAULT NULL AFTER `title`;

COMMIT;
