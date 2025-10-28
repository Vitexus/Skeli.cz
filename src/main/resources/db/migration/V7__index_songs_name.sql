START TRANSACTION;

CREATE INDEX `idx_songs_name` ON `songs` (`name`);

COMMIT;