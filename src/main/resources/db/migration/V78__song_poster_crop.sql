-- Where the picture sits in the song's poster on the Karaoke page (/karaoke-kino), set by hand in admin
-- (/admin/song): poster_x / poster_y = the point of the clip's thumbnail (% of its width / height, 0–100)
-- that is in the middle of the poster, poster_zoom = how much larger than "the clip's height fills the
-- poster" (1–3). NULL = automatic (the middle).
ALTER TABLE `songs`
  ADD COLUMN IF NOT EXISTS `poster_x` DECIMAL(5,2) NULL,
  ADD COLUMN IF NOT EXISTS `poster_y` DECIMAL(5,2) NULL,
  ADD COLUMN IF NOT EXISTS `poster_zoom` DECIMAL(4,2) NULL;
