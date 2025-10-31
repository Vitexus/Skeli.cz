START TRANSACTION;

-- Ensure songs exist
INSERT INTO songs(name, year)
SELECT 'Musíš odejít', NULL WHERE NOT EXISTS(SELECT 1 FROM songs WHERE name='Musíš odejít' AND year IS NULL);
INSERT INTO songs(name, year)
SELECT 'Fajn', NULL WHERE NOT EXISTS(SELECT 1 FROM songs WHERE name='Fajn' AND year IS NULL);
INSERT INTO songs(name, year)
SELECT 'Machine gun Skeli RMX', NULL WHERE NOT EXISTS(SELECT 1 FROM songs WHERE name='Machine gun Skeli RMX' AND year IS NULL);

-- Insert lyrics if missing
INSERT INTO lyrics(words, score, song_id)
SELECT 'Cejtíš ten chlad, když klečíš na kolenách,
kolom jen plyne čas, oporu v něm už nemáš.
Cítíš se sama, jak v nitru pustiny,
vnímáš ty vzpomínky, které máš chuť zapálit.

Chceš zapomenout na vše, co tě sune dolů,
flašky od alkoholu už padají ze stolu.
Chceš zapomenout na všechny ty dny,
kdy ti říkal, že ti splní všechny tvý sny.

Cítila ses v bezpečí v každým jeho objetí,
teď máš srdce zjizvený, pořezaný samou lží.
Jediný, pro co chceš žít, je to dítě, co máš s ním,
ona je jediný, na čem ti teďka záleží.

Už tě dávno přešel smích, zažila jsi to po stý,
no tak nebuď naivní — tyrana jen tak nezměníš.
Díváš se jí do očí, přitom tečou slzy z tvých,
není žádná jiná možnost, víš, že musíš odejít.

Už víš.

Jak je to složitý,
na všechno tu sama být.
Zatni zuby, postav se a neboj se zase dál jít.
Musíš zase začít snít o těch dnech,
když jsi byla plná sil.
Zapomenout na to, kolikrát tě zbil,
když se tak hrozně opil.
Zbal si věci a zmiz pryč,
však si beze něj poradíš.
Ona je teď tvoje zbroj,
tvoje vůle pokračovat.
Vytrpěla sis svoje,
spolu zapálíte most.

Zůstaň — bež — zůstaň — zůstaň —
nemáš kam jít — ty si najdeš cestu —
on se změní — už tomu nevěříš —
bez něj to nezvládneš — kvůli ní musíš!!!

Teď si píšeš scénář sama,
on už nemusí tě trápit,
holt malá vyroste bez vožralýho táty.
Ona pochopí, že nemohla jsi se nechat mlátit,
i to, že se k němu nemůžete nikdy vrátit.

Teď jsi silnější než jsi byla kdykoli dřív,
chtělo to odvahu se mu vzepřít, nalezla jsi ji až s ní.
Teď už se to všechno zlepší, urvala jsi svoji šanci,
další ráno tě neděsí, už vedle tebe nespí.
Bylo to za čárou, přelezla jsi přes ni,
tolerovala jsi mu to fest dní,
nespočítala bys, kolikrát uhodil tě pěstí.

Už víš.

Kolikrát uhodil tě pěstí,
no tak, kolikrát uhodil tě pěstí,
uhodil tě pěstí.', 0, s.id
FROM songs s WHERE s.name='Musíš odejít' AND s.year IS NULL AND NOT EXISTS(SELECT 1 FROM lyrics l WHERE l.song_id=s.id);

INSERT INTO lyrics(words, score, song_id)
SELECT 'A ty karty máme dávno rozdaný
natahujme ruce pro ty věci co nás postaví
i když nevědomky něco jako poddaný
podáváme výkony co oni za nás prodají

s myšlenkou na každý další lepší den
vstávat brzo ráno no tak honem ovce jdeme
prokousat se každodenní procesem
pro almužny kůži ze sebe sedřeme
ať se mají fajn, ať se mají fajn, ať se mají fajn

z vrcholu pyramidy musí svět vypadat fajn
ale co ten zbytek co musí v jejím stínu stát
zeptal ses jich, jestli mají se fajn,
jestli mají se fajn, jestli mají se fajn

včera přijel bavorákem zítra pořídí o třídu víš
mě před barákem stojí fábka co začíná už hnít
složenky se hromadí zatočili s výplatní páskou
něco málo do ledničky šrajtofli mám prázdnou

A ty karty máme dávno rozdaný
natahujeme ruce pro ty věci co nás postaví
i když nevědomky něco jako poddaný
podáváme výkony co oni za nás prodají

říkám dost !!!

beru to do vlastních rukou a půjdu cestou svou
už mě nebaví vydělávat na cizí sny
na tvou zkurvenou dovolenou

takže se měj fajn já chytám vibe a tak dám strike
padawan touží slyšet ten hajp
padawan chce dostat další like
padawan se stane mistrem a ta bída na vždy zmizne
ruce už jen čisté s instalatérem táhněte někam do piče
já chci dostat víc než jen cpát špinaví trubky do těch zdi
já chci dostat víc než jen cpát špinaví trubky do těch zdi', 0, s.id
FROM songs s WHERE s.name='Fajn' AND s.year IS NULL AND NOT EXISTS(SELECT 1 FROM lyrics l WHERE l.song_id=s.id);

INSERT INTO lyrics(words, score, song_id)
SELECT 'Ještě jsem na scénu nevlítnul, už si přejou, abych chcípnul,
abych to típnul, abych klopýtnul, že jsem prej píčus, co umí píču,
ani píču, konec kýčů, do těch beatu opřu se jak vítr,
nečekej psí trus, přináším hit plus, hledej novou pipku,
po tomhle shitu chce být na mým dicku.

Tak si zvykej, rozjíždím byznys, mám tu páku, svůj život změnit,
poslat to dál, dostat se výš, poctivej dříč,
zarobit míč a mít se líp, sít top seed, pálit top weed,
začít život žít, přestat živořit, pod kotel přiložit,
neřešit kokoty, ááá...

Pod kotel přiložit, neřešit kokoty, ááá...
Pod kotel přiložit, neřešit kokoty, ááá...
Pod kotel přiložit, neřešit kokoty, ááá...

Kolik heatu, tolik heaterů!
Tolik heaterů!', 0, s.id
FROM songs s WHERE s.name='Machine gun Skeli RMX' AND s.year IS NULL AND NOT EXISTS(SELECT 1 FROM lyrics l WHERE l.song_id=s.id);

-- Pair existing YouTube videos to songs by exact title match (case-insensitive)
UPDATE videos v JOIN songs s ON LOWER(IFNULL(v.title,'')) = LOWER(s.name)
SET v.song_id = s.id
WHERE v.song_id IS NULL;

COMMIT;
