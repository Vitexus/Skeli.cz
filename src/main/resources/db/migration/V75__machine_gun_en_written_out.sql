-- Machine gun Skeli RMX (en): V73 missed the "(x3)" after this line (it ends in "…", not "..."), so the
-- English text had two lines fewer than the Czech one and the karaoke times did not fit it.
UPDATE `lyrics` l JOIN `songs` s ON s.`id` = l.`song_id`
SET l.`words` = REPLACE(l.`words`,
      'Throw wood onto the heat, ignore the idiots, ahhh… (x3)',
      CONCAT('Throw wood onto the heat, ignore the idiots, ahhh…', CHAR(10),
             'Throw wood onto the heat, ignore the idiots, ahhh…', CHAR(10),
             'Throw wood onto the heat, ignore the idiots, ahhh…'))
WHERE s.`name` LIKE 'Machine gun%' AND l.`lang` = 'en';
