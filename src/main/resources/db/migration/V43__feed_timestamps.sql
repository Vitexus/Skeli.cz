-- Dates for RSS/Atom feeds (/{lang}/feed/*): when a song was released and
-- when each language variant of its lyric was added / last changed.
-- New songs get NOW() automatically, so the INSERTs in the sync/admin code stay as they are.

ALTER TABLE `songs`
  ADD COLUMN `published_at` DATETIME NULL DEFAULT CURRENT_TIMESTAMP AFTER `year`,
  ADD KEY `idx_songs_published_at` (`published_at`);

ALTER TABLE `lyrics`
  ADD COLUMN `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  ADD COLUMN `updated_at` DATETIME NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
  ADD KEY `idx_lyrics_lang_created` (`lang`, `created_at`);

-- Existing songs: the first video/short on YouTube, otherwise 1 January of the song's year,
-- otherwise unknown (NULL, listed last) rather than "released today"
UPDATE `songs` s
LEFT JOIN (
  SELECT song_id, MIN(published_at) AS first_at FROM (
    SELECT song_id, published_at FROM `videos` WHERE song_id IS NOT NULL AND published_at IS NOT NULL
    UNION ALL
    SELECT song_id, published_at FROM `shorts` WHERE song_id IS NOT NULL AND published_at IS NOT NULL
  ) m GROUP BY song_id
) yt ON yt.song_id = s.id
SET s.published_at = COALESCE(yt.first_at, IF(s.year IS NULL, NULL, MAKEDATE(s.year, 1)));

-- Existing lyrics would otherwise all carry the migration date
UPDATE `lyrics` l
JOIN `songs` s ON s.id = l.song_id
SET l.created_at = s.published_at,
    l.updated_at = NULL
WHERE s.published_at IS NOT NULL;
