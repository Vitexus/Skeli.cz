-- Clips kept off the site (an unfinished song on the YouTube channel): the YouTube sync never adds them again;
-- adding the clip by hand in the admin (Add track, the manual form) takes it off the list.
CREATE TABLE IF NOT EXISTS `video_blocklist` (
  `youtube_id` VARCHAR(32) NOT NULL,
  `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`youtube_id`)
) ENGINE=InnoDB DEFAULT CHARSET=ascii;

-- "Miluju každý další ráno (ft. Vitex)" is not a finished song yet (the user, 2026-10-16)
INSERT IGNORE INTO `video_blocklist` (`youtube_id`) VALUES ('l8kjNDs-T10');
DELETE FROM `video_comments` WHERE `youtube_id` = 'l8kjNDs-T10';
DELETE FROM `videos` WHERE `youtube_id` = 'l8kjNDs-T10' AND `song_id` IS NULL;
