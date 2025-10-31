-- Translated lyrics storage
CREATE TABLE IF NOT EXISTS lyrics_translations (
  lyric_id INT NOT NULL,
  lang VARCHAR(8) NOT NULL,
  words MEDIUMTEXT,
  PRIMARY KEY (lyric_id, lang)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
