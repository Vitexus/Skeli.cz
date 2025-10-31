START TRANSACTION;

CREATE TABLE `videos` (
  `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `youtube_id` varchar(20) NOT NULL,
  `song_id` int(10) UNSIGNED NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_videos_youtube_id` (`youtube_id`),
  KEY `idx_videos_song_id` (`song_id`),
  CONSTRAINT `fk_videos_song_id` FOREIGN KEY (`song_id`) REFERENCES `songs`(`id`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Seed from previous hardcoded list in music.jsp
INSERT INTO `videos` (`youtube_id`) VALUES
 ('YQt6qBZ2f4g'),
 ('pZx0xa6MpbE'),
 ('DUyWTpG57NY'),
 ('euIYhNMeq8A'),
 ('8y60i79nVJc'),
 ('2vWZfiMnQ3Y'),
 ('sVOz2GRE3Cg'),
 ('AMEQfe9hWlg'),
 ('S3BFk-qmXAY'),
 ('8jcSUU-Xgvs');

COMMIT;