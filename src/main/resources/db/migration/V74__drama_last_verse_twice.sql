-- Zoom – Drama: the last verse as Zoom sent it ("démoni a stíny", not "a stíny"), and it is sung twice
-- (3:11 and 3:27 in the clip) – the karaoke burns in every sung line, so both times are written out.
-- Only this block changes, in every language. CHAR(10) instead of line breaks inside the strings, so
-- the match does not depend on how Git wrote the line endings of this file.

UPDATE `lyrics` l JOIN `songs` s ON s.`id` = l.`song_id`
SET l.`words` = REPLACE(l.`words`,
      CONCAT('Je to debilní kráva a ráda dělá drama,', CHAR(10),
             'a stíny jí furt na vlně dělaj záda,', CHAR(10),
             'na chlastu se láme, každýho si dá,', CHAR(10),
             'sebeúcta zmizela, už není tak hodná.'),
      CONCAT('Je to debilní kráva a ráda dělá drama,', CHAR(10),
             'démoni a stíny jí furt na vlně dělaj záda,', CHAR(10),
             'na chlastu se láme, každýho si dá,', CHAR(10),
             'a sebeúcta zmizela, už není tak hodná.', CHAR(10), CHAR(10),
             'Je to debilní kráva a ráda dělá drama,', CHAR(10),
             'démoni a stíny jí furt na vlně dělaj záda,', CHAR(10),
             'na chlastu se láme, každýho si dá,', CHAR(10),
             'a sebeúcta zmizela, už není tak hodná.'))
WHERE s.`name` LIKE 'Zoom - Drama%' AND l.`lang` = 'cs';

UPDATE `lyrics` l JOIN `songs` s ON s.`id` = l.`song_id`
SET l.`words` = REPLACE(l.`words`,
      CONCAT('She''s a stupid cow and she loves making drama,', CHAR(10),
             'and the shadows still have her back on the wave,', CHAR(10),
             'she breaks down on booze, she''ll do anyone,', CHAR(10),
             'her self-respect is gone, she isn''t that sweet anymore.'),
      CONCAT('She''s a stupid cow and she loves making drama,', CHAR(10),
             'demons and shadows still have her back on the wave,', CHAR(10),
             'she breaks down on booze, she''ll do anyone,', CHAR(10),
             'and her self-respect is gone, she isn''t that sweet anymore.', CHAR(10), CHAR(10),
             'She''s a stupid cow and she loves making drama,', CHAR(10),
             'demons and shadows still have her back on the wave,', CHAR(10),
             'she breaks down on booze, she''ll do anyone,', CHAR(10),
             'and her self-respect is gone, she isn''t that sweet anymore.'))
WHERE s.`name` LIKE 'Zoom - Drama%' AND l.`lang` = 'en';

UPDATE `lyrics` l JOIN `songs` s ON s.`id` = l.`song_id`
SET l.`words` = REPLACE(l.`words`,
      CONCAT('Sie ist eine blöde Kuh und macht gern Drama,', CHAR(10),
             'und die Schatten halten ihr auf der Welle immer noch den Rücken frei,', CHAR(10),
             'am Alkohol zerbricht sie, sie nimmt sich jeden,', CHAR(10),
             'die Selbstachtung ist weg, sie ist nicht mehr so lieb.'),
      CONCAT('Sie ist eine blöde Kuh und macht gern Drama,', CHAR(10),
             'Dämonen und Schatten halten ihr auf der Welle immer noch den Rücken frei,', CHAR(10),
             'am Alkohol zerbricht sie, sie nimmt sich jeden,', CHAR(10),
             'und die Selbstachtung ist weg, sie ist nicht mehr so lieb.', CHAR(10), CHAR(10),
             'Sie ist eine blöde Kuh und macht gern Drama,', CHAR(10),
             'Dämonen und Schatten halten ihr auf der Welle immer noch den Rücken frei,', CHAR(10),
             'am Alkohol zerbricht sie, sie nimmt sich jeden,', CHAR(10),
             'und die Selbstachtung ist weg, sie ist nicht mehr so lieb.'))
WHERE s.`name` LIKE 'Zoom - Drama%' AND l.`lang` = 'de';

UPDATE `lyrics` l JOIN `songs` s ON s.`id` = l.`song_id`
SET l.`words` = REPLACE(l.`words`,
      CONCAT('Вона дурна корова і любить влаштовувати драму,', CHAR(10),
             'і тіні досі прикривають їй спину на хвилі,', CHAR(10),
             'на випивці ламається, дасть кожному,', CHAR(10),
             'самоповага зникла, вона вже не така мила.'),
      CONCAT('Вона дурна корова і любить влаштовувати драму,', CHAR(10),
             'демони й тіні досі прикривають їй спину на хвилі,', CHAR(10),
             'на випивці ламається, дасть кожному,', CHAR(10),
             'і самоповага зникла, вона вже не така мила.', CHAR(10), CHAR(10),
             'Вона дурна корова і любить влаштовувати драму,', CHAR(10),
             'демони й тіні досі прикривають їй спину на хвилі,', CHAR(10),
             'на випивці ламається, дасть кожному,', CHAR(10),
             'і самоповага зникла, вона вже не така мила.'))
WHERE s.`name` LIKE 'Zoom - Drama%' AND l.`lang` = 'uk';

UPDATE `lyrics` l JOIN `songs` s ON s.`id` = l.`song_id`
SET l.`words` = REPLACE(l.`words`,
      CONCAT('Nó là một con bò ngu và thích gây drama,', CHAR(10),
             'và những cái bóng vẫn luôn chống lưng cho nó trên con sóng,', CHAR(10),
             'nó gục ngã vì rượu, ai nó cũng chơi,', CHAR(10),
             'lòng tự trọng đã biến mất, nó chẳng còn ngoan như trước.'),
      CONCAT('Nó là một con bò ngu và thích gây drama,', CHAR(10),
             'quỷ dữ và những cái bóng vẫn luôn chống lưng cho nó trên con sóng,', CHAR(10),
             'nó gục ngã vì rượu, ai nó cũng chơi,', CHAR(10),
             'và lòng tự trọng đã biến mất, nó chẳng còn ngoan như trước.', CHAR(10), CHAR(10),
             'Nó là một con bò ngu và thích gây drama,', CHAR(10),
             'quỷ dữ và những cái bóng vẫn luôn chống lưng cho nó trên con sóng,', CHAR(10),
             'nó gục ngã vì rượu, ai nó cũng chơi,', CHAR(10),
             'và lòng tự trọng đã biến mất, nó chẳng còn ngoan như trước.'))
WHERE s.`name` LIKE 'Zoom - Drama%' AND l.`lang` = 'vi';
