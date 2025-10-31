START TRANSACTION;

-- Update known song years (update jen „první“ výskyt názvu, aby nevznikly duplicitní (name,year))
UPDATE songs s JOIN (SELECT MIN(id) id FROM songs WHERE LOWER(name) LIKE 'fajn%') pick ON s.id=pick.id SET s.year=2019;
UPDATE songs s JOIN (SELECT MIN(id) id FROM songs WHERE LOWER(name) LIKE 'chillujem%') pick ON s.id=pick.id SET s.year=2024;
UPDATE songs s JOIN (SELECT MIN(id) id FROM songs WHERE LOWER(name) LIKE 'machine gun skeli%') pick ON s.id=pick.id SET s.year=2019;
-- „Musíš odejít" může být bez diakritiky i s diakritikou; vezmi min(id) z obou
UPDATE songs s JOIN (
  SELECT MIN(id) id FROM songs WHERE LOWER(name) LIKE 'musis odejit%'
  UNION ALL
  SELECT MIN(id) id FROM songs WHERE LOWER(name) LIKE 'musíš odejít%'
) pick ON s.id=pick.id SET s.year=2025;

-- Insert new song Nechápu (2017) if not exists
INSERT INTO songs(name, year)
SELECT 'Nechápu', 2017
WHERE NOT EXISTS (SELECT 1 FROM songs WHERE name = 'Nechápu');

-- Insert lyrics for Nechápu if not exists
INSERT INTO lyrics(song_id, words)
SELECT s.id, 'Nechápu, kde se to zlo v nás bere\r\nNechápu, proč se to furt v nás pere\r\nNechápu, kde se to zlo v nás bere\r\nKde se to zlo v nás bere\r\nProč se to furt v nás pere\r\n\r\nMilujeme sebe, oba nás žere sedět vedle sebe\r\nKrmíme se medem a v něm ten jed\r\nA těch x let s otázkou jestli je to naposled\r\nCo se loučíme, furt jsme zkoušení\r\nFurt se snažíme, být si souzení\r\nVyjít si vstříc a neříct si víc\r\nNež to co je nezbytně nutný\r\nAle tak to nejde, ale tak to nejde\r\nAle tak to nejde, být spolu ze zvyku\r\nOpravdu nejde, sahám na kliku\r\nChci zmizet pryč, volám mayday kolem nás síť\r\nUšitá ze vzpomínek a těch míst\r\nUž víme, že to není jako dřív\r\nUž to jenom skřípe, ale v jiných postelích\r\n\r\nA ráno jakože nic, ráno jakože nic\r\nA ráno jakože nic, ráno jakože nic\r\n\r\nFalešný iluze, pravdivý lži\r\nPři snídaní řešíme ty dny kdy, byli jsme tým\r\nŽili jsme s tým, že jsem César ona můj Řím\r\nFalešný iluze, pravdivý lži\r\nPři snídaní řešíme ty dny kdy, byli jsme tým\r\nŽili jsme s tím, že jsem César ona můj Řím\r\n\r\nA proto nechápu, kde se to zlo v nás bere\r\nNechápu, proč se to furt v nás pere\r\nNechápu, kde se to zlo v nás bere\r\nKde se to zlo v nás bere\r\nProč se to furt v nás pere\r\n\r\nAle bylo nám to málo\r\nA dávno nedáme dohromady důvod, proč to dál táhnout\r\nStále máme vzpomínky dávné\r\nTo pouto pár let je to co nás teď k sobě váže\r\nMáme další zářez, hledáš nový tváře\r\nZačínáš zas zářit, poprvý co nezačínám žárlit\r\nTak si táhni, sbal si všechny krámy\r\nDávno jsem to strávil, že jsem sám na dráze\r\nSama dala si mi námět, lháře k sobě máme\r\nzáměr dobře známe zájem neni žádnej zachranit ten dávnej vztah\r\nCo byl tak krásnej, kdy zůstal tak prázdnej\r\nTy dny co se nevrátěj, ty jsi pro mě zátěž\r\nTak už neotálej a už můžeš jít..\r\n\r\nObou nám už bude líp\r\n a už můžeš jít..\r\nObou nám už bude líp\r\n a už můžeš jít..\r\nObou nám už bude líp'
FROM songs s
WHERE s.name = 'Nechápu'
  AND NOT EXISTS (SELECT 1 FROM lyrics l WHERE l.song_id = s.id);

-- Associate existing videos to songs by title match (only when not already linked)
UPDATE videos v
JOIN songs s ON LOWER(COALESCE(v.title,'')) LIKE CONCAT('%', LOWER(s.name), '%')
SET v.song_id = s.id
WHERE v.song_id IS NULL;

COMMIT;
