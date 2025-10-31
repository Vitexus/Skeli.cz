START TRANSACTION;

-- Ensure songs exist (idempotent via unique (name, year))
INSERT INTO `songs` (`name`, `year`) VALUES
  ('Skeli - Chillujem', 2024)
ON DUPLICATE KEY UPDATE `name`=VALUES(`name`), `year`=VALUES(`year`);

INSERT INTO `songs` (`name`, `year`) VALUES
  ('Skeli - Tisíc kousků', 2025)
ON DUPLICATE KEY UPDATE `name`=VALUES(`name`), `year`=VALUES(`year`);

-- Map videos to songs by youtube_id
UPDATE `videos` v
JOIN `songs` s ON s.`name`='Skeli - Chillujem' AND s.`year`=2024
SET v.`song_id` = s.`id`
WHERE v.`youtube_id` = 'YQt6qBZ2f4g';

UPDATE `videos` v
JOIN `songs` s ON s.`name`='Skeli - Tisíc kousků' AND s.`year`=2025
SET v.`song_id` = s.`id`
WHERE v.`youtube_id` = 'pZx0xa6MpbE';

COMMIT;