START TRANSACTION;

CREATE TABLE `songs` (
  `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `year` year(4) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_songs_name_year` (`name`, `year`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Naplnění tabulky songs unikátními kombinacemi name + relase_year ze stávající tabulky lyrics
INSERT INTO `songs` (`name`, `year`)
SELECT DISTINCT l.`name`, l.`relase_year`
FROM `lyrics` l
WHERE l.`name` IS NOT NULL;

-- Přidání reference na songs do tabulky lyrics
ALTER TABLE `lyrics` ADD COLUMN `song_id` int(10) UNSIGNED NULL;

-- Backfill song_id přes join na (name, relase_year)
UPDATE `lyrics` l
JOIN `songs` s
  ON s.`name` = l.`name`
 AND (s.`year` <=> l.`relase_year`)
SET l.`song_id` = s.`id`;

-- Index a cizí klíč
ALTER TABLE `lyrics` ADD INDEX `idx_lyrics_song_id` (`song_id`);

ALTER TABLE `lyrics`
  ADD CONSTRAINT `fk_lyrics_song_id`
  FOREIGN KEY (`song_id`) REFERENCES `songs` (`id`)
  ON DELETE SET NULL
  ON UPDATE CASCADE;

-- Volitelné: Po úpravě aplikace na LEFT JOIN můžete odstranit původní sloupce
-- ALTER TABLE `lyrics` DROP COLUMN `name`, DROP COLUMN `relase_year`;

COMMIT;