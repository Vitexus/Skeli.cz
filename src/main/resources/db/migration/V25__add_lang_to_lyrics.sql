START TRANSACTION;

-- Add lang column to lyrics (default 'cs' for existing Czech lyrics)
ALTER TABLE `lyrics` ADD COLUMN `lang` varchar(5) DEFAULT 'cs' AFTER `song_id`;
ALTER TABLE `lyrics` ADD INDEX `idx_lyrics_lang` (`lang`);

-- If lyrics_translations exists, migrate data
-- Check if table exists first
SET @table_exists = (SELECT COUNT(*) FROM information_schema.tables 
    WHERE table_schema = DATABASE() AND table_name = 'lyrics_translations');

-- Copy translations from lyrics_translations to lyrics as separate rows
INSERT INTO `lyrics` (song_id, lang, words, score)
SELECT 
    l.song_id,
    lt.lang,
    lt.words,
    0 as score
FROM lyrics_translations lt
JOIN lyrics l ON l.id = lt.lyric_id
WHERE @table_exists > 0
ON DUPLICATE KEY UPDATE words = VALUES(words);

-- Drop lyrics_translations table if exists
DROP TABLE IF EXISTS `lyrics_translations`;

COMMIT;
