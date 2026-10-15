-- What is played most (admin charts, VisitStats.countPlay): lyrics read, karaoke cinema entered, clips started.
-- item = the song's uuid (lyric, karaoke) or the clip's YouTube id (clip). No personal data: a visitor is the
-- same anonymous hash of the day as in visit_days, kept only to count each one once a day.

-- plays per day and item
CREATE TABLE IF NOT EXISTS `play_daily` (
  `day` DATE NOT NULL,
  `kind` ENUM('lyric', 'karaoke', 'clip') NOT NULL,
  `item` VARCHAR(40) NOT NULL,
  `plays` INT UNSIGNED NOT NULL DEFAULT 0,
  PRIMARY KEY (`day`, `kind`, `item`),
  KEY `play_daily_kind` (`kind`, `day`)
) ENGINE=InnoDB DEFAULT CHARSET=ascii;

-- who already counted today (rows older than yesterday are removed)
CREATE TABLE IF NOT EXISTS `play_seen` (
  `day` DATE NOT NULL,
  `kind` ENUM('lyric', 'karaoke', 'clip') NOT NULL,
  `item` VARCHAR(40) NOT NULL,
  `visitor` CHAR(32) NOT NULL,
  PRIMARY KEY (`day`, `kind`, `item`, `visitor`)
) ENGINE=InnoDB DEFAULT CHARSET=ascii;
