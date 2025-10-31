START TRANSACTION;

-- Normalize song names (remove leading "Skeli - ")
UPDATE songs SET name = TRIM(SUBSTRING(name, LOCATE('-', name)+1))
WHERE LOWER(name) LIKE 'skeli - %';

-- Pair videos to songs by normalized title
UPDATE videos v
JOIN songs s
  ON LOWER(TRIM(REPLACE(v.title,'Skeli - ',''))) = LOWER(s.name)
SET v.song_id = s.id
WHERE v.song_id IS NULL;

COMMIT;
