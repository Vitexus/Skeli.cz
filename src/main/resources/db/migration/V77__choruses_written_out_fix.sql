-- V73 missed six songs: the old text it looked for ended in an invisible Windows line end (CR) that the
-- stored text does not have, so their choruses stayed as "(2×)", "(3×)", "(4×)" and the karaoke was one line off
-- from there on. The same new texts as in V73, matched without that character.

-- Babaraptor - Obyčejnej člověk ft. Skeli (cs)
UPDATE `lyrics` l JOIN `songs` s ON s.`id` = l.`song_id`
SET l.`words` = 'Prej se mám usmívat, se stádem ubírat,
lidem lízt do zadku, nejspíš ho i utírat,
měl bych se prej krotit a přestat to tak hrotit,
a smířit se s tím, jak to je, nohama šoupat, hlavu sklopit.
Tohle neřeš, s tímhle nehneš, nemůžeš nic dělat,
nepřemýšlej, vypni mozek, makej do roztrhání těla,
svůj názor si nech nejlíp na druhej břeh,
nejsi tu proto, abys změnil nepříznivých věcí běh.

Jsi obyčejnej člověk, úděl srát se v hovnech,
účet splácet celej život, nechat sebou vláčet,
ujel ti vláček už ten moment, kdy jsi spatřil svět,
tak zavři hubu, srovnej krok a zapůj zpět.
Jsi obyčejnej člověk, úděl srát se v hovnech,
účet splácet celej život, nechat sebou vláčet,
ujel ti vláček už ten moment, kdy jsi spatřil svět,
tak zavři hubu, srovnej krok a zapůj zpět.

Jsem malej zmrd, mám skoro metr a půl,
vystrkuju z davu hlavu, chtěj mě napíchnout na kůl,
utržil jsem tvrdý rány, do nich mi sypou sůl,
nespočet ran ještě schytám,
letí ze všech stran, a nedělám věci jenom proto, že by byly cool,
nemám stejný záliby jako každej druhej vůl,
za povahu neustále po zásluze pykám,
je to průser, že průměru se úspěšně vymykám,
pod průměrem, nad průměrem nikdo nesmí stát,
nech si svý sny pro sebe, koukej si je kurva vzát,
musíš jenom makat, spát, makat, spát, makat, spát,
vydělávat hovno, hovno rovnou do hajzlu srát, dík, nemám zájem
kráčet se stádem, fakt nejsem blázen, řídím se svým plánem,
svůj názor si nech nejlépe na druhej břeh,
pojedu podle sebe, dokud mi vystačí dech.

Jsi obyčejnej člověk, úděl srát se v hovnech,
účet splácet celej život, nechat sebou vláčet,
ujel ti vláček už ten moment, kdy jsi spatřil svět,
tak zavři hubu, srovnej krok a zapůj zpět.
Jsi obyčejnej člověk, úděl srát se v hovnech,
účet splácet celej život, nechat sebou vláčet,
ujel ti vláček už ten moment, kdy jsi spatřil svět,
tak zavři hubu, srovnej krok a zapůj zpět.'
WHERE s.`name` = 'Babaraptor - Obyčejnej člověk ft. Skeli' AND l.`lang` = 'cs' AND l.`words` = 'Prej se mám usmívat, se stádem ubírat,
lidem lízt do zadku, nejspíš ho i utírat,
měl bych se prej krotit a přestat to tak hrotit,
a smířit se s tím, jak to je, nohama šoupat, hlavu sklopit.
Tohle neřeš, s tímhle nehneš, nemůžeš nic dělat,
nepřemýšlej, vypni mozek, makej do roztrhání těla,
svůj názor si nech nejlíp na druhej břeh,
nejsi tu proto, abys změnil nepříznivých věcí běh.

Jsi obyčejnej člověk, úděl srát se v hovnech,
účet splácet celej život, nechat sebou vláčet,
ujel ti vláček už ten moment, kdy jsi spatřil svět,
tak zavři hubu, srovnej krok a zapůj zpět.
(2×)

Jsem malej zmrd, mám skoro metr a půl,
vystrkuju z davu hlavu, chtěj mě napíchnout na kůl,
utržil jsem tvrdý rány, do nich mi sypou sůl,
nespočet ran ještě schytám,
letí ze všech stran, a nedělám věci jenom proto, že by byly cool,
nemám stejný záliby jako každej druhej vůl,
za povahu neustále po zásluze pykám,
je to průser, že průměru se úspěšně vymykám,
pod průměrem, nad průměrem nikdo nesmí stát,
nech si svý sny pro sebe, koukej si je kurva vzát,
musíš jenom makat, spát, makat, spát, makat, spát,
vydělávat hovno, hovno rovnou do hajzlu srát, dík, nemám zájem
kráčet se stádem, fakt nejsem blázen, řídím se svým plánem,
svůj názor si nech nejlépe na druhej břeh,
pojedu podle sebe, dokud mi vystačí dech.

Jsi obyčejnej člověk, úděl srát se v hovnech,
účet splácet celej život, nechat sebou vláčet,
ujel ti vláček už ten moment, kdy jsi spatřil svět,
tak zavři hubu, srovnej krok a zapůj zpět.
(2×)';

-- Babaraptor - Obyčejnej člověk ft. Skeli (de)
UPDATE `lyrics` l JOIN `songs` s ON s.`id` = l.`song_id`
SET l.`words` = 'Angeblich soll ich lächeln, mit der Herde ziehen,
den Leuten in den Arsch kriechen, ihn wahrscheinlich sogar abwischen,
ich sollte mich angeblich zügeln und aufhören, es so auf die Spitze zu treiben,
und mich damit abfinden, wie es ist, mit den Füßen schlurfen, den Kopf senken.
Kümmer dich nicht darum, daran änderst du nichts, du kannst nichts tun,
denk nicht nach, schalt das Hirn ab, schufte, bis der Körper reißt,
deine Meinung behältst du am besten für dich,
du bist nicht hier, um den Lauf der schlechten Dinge zu ändern.

Du bist ein gewöhnlicher Mensch, dein Los ist es, in der Scheiße zu wühlen,
das ganze Leben die Rechnung abzahlen, dich mitschleifen lassen,
dein Zug ist schon in dem Moment abgefahren, als du die Welt erblickt hast,
also halt die Klappe, geh im Gleichschritt und reih dich wieder ein.
Du bist ein gewöhnlicher Mensch, dein Los ist es, in der Scheiße zu wühlen,
das ganze Leben die Rechnung abzahlen, dich mitschleifen lassen,
dein Zug ist schon in dem Moment abgefahren, als du die Welt erblickt hast,
also halt die Klappe, geh im Gleichschritt und reih dich wieder ein.

Ich bin ein kleiner Wichser, fast anderthalb Meter groß,
ich strecke den Kopf aus der Menge, sie wollen mich auf einen Pfahl spießen,
ich hab harte Schläge eingesteckt, sie streuen mir Salz hinein,
unzählige Schläge werde ich noch einstecken,
sie fliegen von allen Seiten, und ich mache Dinge nicht nur, weil sie cool wären,
ich habe nicht dieselben Hobbys wie jeder zweite Ochse,
für meinen Charakter büße ich ständig, wie ich es verdiene,
es ist Mist, dass ich erfolgreich aus dem Durchschnitt herausfalle,
niemand darf unter dem Durchschnitt oder über dem Durchschnitt stehen,
behalte deine Träume für dich, schau, dass du sie dir verdammt nochmal nimmst,
du musst nur schuften, schlafen, schuften, schlafen, schuften, schlafen,
Scheiße verdienen, Scheiße direkt ins Klo scheißen, danke, kein Interesse,
mit der Herde zu gehen, ich bin echt nicht verrückt, ich folge meinem eigenen Plan,
deine Meinung behältst du am besten für dich,
ich gehe meinen eigenen Weg, solange mir der Atem reicht.

Du bist ein gewöhnlicher Mensch, dein Los ist es, in der Scheiße zu wühlen,
das ganze Leben die Rechnung abzahlen, dich mitschleifen lassen,
dein Zug ist schon in dem Moment abgefahren, als du die Welt erblickt hast,
also halt die Klappe, geh im Gleichschritt und reih dich wieder ein.
Du bist ein gewöhnlicher Mensch, dein Los ist es, in der Scheiße zu wühlen,
das ganze Leben die Rechnung abzahlen, dich mitschleifen lassen,
dein Zug ist schon in dem Moment abgefahren, als du die Welt erblickt hast,
also halt die Klappe, geh im Gleichschritt und reih dich wieder ein.'
WHERE s.`name` = 'Babaraptor - Obyčejnej člověk ft. Skeli' AND l.`lang` = 'de' AND l.`words` = 'Angeblich soll ich lächeln, mit der Herde ziehen,
den Leuten in den Arsch kriechen, ihn wahrscheinlich sogar abwischen,
ich sollte mich angeblich zügeln und aufhören, es so auf die Spitze zu treiben,
und mich damit abfinden, wie es ist, mit den Füßen schlurfen, den Kopf senken.
Kümmer dich nicht darum, daran änderst du nichts, du kannst nichts tun,
denk nicht nach, schalt das Hirn ab, schufte, bis der Körper reißt,
deine Meinung behältst du am besten für dich,
du bist nicht hier, um den Lauf der schlechten Dinge zu ändern.

Du bist ein gewöhnlicher Mensch, dein Los ist es, in der Scheiße zu wühlen,
das ganze Leben die Rechnung abzahlen, dich mitschleifen lassen,
dein Zug ist schon in dem Moment abgefahren, als du die Welt erblickt hast,
also halt die Klappe, geh im Gleichschritt und reih dich wieder ein.
(2×)

Ich bin ein kleiner Wichser, fast anderthalb Meter groß,
ich strecke den Kopf aus der Menge, sie wollen mich auf einen Pfahl spießen,
ich hab harte Schläge eingesteckt, sie streuen mir Salz hinein,
unzählige Schläge werde ich noch einstecken,
sie fliegen von allen Seiten, und ich mache Dinge nicht nur, weil sie cool wären,
ich habe nicht dieselben Hobbys wie jeder zweite Ochse,
für meinen Charakter büße ich ständig, wie ich es verdiene,
es ist Mist, dass ich erfolgreich aus dem Durchschnitt herausfalle,
niemand darf unter dem Durchschnitt oder über dem Durchschnitt stehen,
behalte deine Träume für dich, schau, dass du sie dir verdammt nochmal nimmst,
du musst nur schuften, schlafen, schuften, schlafen, schuften, schlafen,
Scheiße verdienen, Scheiße direkt ins Klo scheißen, danke, kein Interesse,
mit der Herde zu gehen, ich bin echt nicht verrückt, ich folge meinem eigenen Plan,
deine Meinung behältst du am besten für dich,
ich gehe meinen eigenen Weg, solange mir der Atem reicht.

Du bist ein gewöhnlicher Mensch, dein Los ist es, in der Scheiße zu wühlen,
das ganze Leben die Rechnung abzahlen, dich mitschleifen lassen,
dein Zug ist schon in dem Moment abgefahren, als du die Welt erblickt hast,
also halt die Klappe, geh im Gleichschritt und reih dich wieder ein.
(2×)';

-- Babaraptor - Obyčejnej člověk ft. Skeli (en)
UPDATE `lyrics` l JOIN `songs` s ON s.`id` = l.`song_id`
SET l.`words` = 'They say I should smile, follow the herd,
crawl up people''s asses, probably even wipe them,
they say I should tone it down and stop pushing it so hard,
and come to terms with how things are, shuffle my feet, keep my head down.
Don''t deal with this, you won''t change that, there''s nothing you can do,
don''t think, switch off your brain, work till your body tears apart,
better keep your opinion to yourself,
you''re not here to change the course of bad things.

You''re an ordinary man, your lot is to wallow in shit,
paying off the bill all your life, letting yourself be dragged along,
your train left the moment you first saw the world,
so shut your mouth, fall in step and get back in line.
You''re an ordinary man, your lot is to wallow in shit,
paying off the bill all your life, letting yourself be dragged along,
your train left the moment you first saw the world,
so shut your mouth, fall in step and get back in line.

I''m a little bastard, almost five feet tall,
I stick my head out of the crowd, they want to impale me on a stake,
I took hard blows, they pour salt into them,
I''ll take countless more blows,
they fly from all sides, and I don''t do things just because they''d be cool,
I don''t have the same hobbies as every other fool,
I keep paying for my nature, as I deserve,
it''s a bummer that I successfully stand out from the average,
nobody can be below average or above average,
keep your dreams to yourself, you''d better fucking take them,
you just have to work, sleep, work, sleep, work, sleep,
earn shit, shit straight down the toilet, thanks, I''m not interested
in walking with the herd, I''m really not crazy, I follow my own plan,
better keep your opinion to yourself,
I''ll go my own way as long as I have breath.

You''re an ordinary man, your lot is to wallow in shit,
paying off the bill all your life, letting yourself be dragged along,
your train left the moment you first saw the world,
so shut your mouth, fall in step and get back in line.
You''re an ordinary man, your lot is to wallow in shit,
paying off the bill all your life, letting yourself be dragged along,
your train left the moment you first saw the world,
so shut your mouth, fall in step and get back in line.'
WHERE s.`name` = 'Babaraptor - Obyčejnej člověk ft. Skeli' AND l.`lang` = 'en' AND l.`words` = 'They say I should smile, follow the herd,
crawl up people''s asses, probably even wipe them,
they say I should tone it down and stop pushing it so hard,
and come to terms with how things are, shuffle my feet, keep my head down.
Don''t deal with this, you won''t change that, there''s nothing you can do,
don''t think, switch off your brain, work till your body tears apart,
better keep your opinion to yourself,
you''re not here to change the course of bad things.

You''re an ordinary man, your lot is to wallow in shit,
paying off the bill all your life, letting yourself be dragged along,
your train left the moment you first saw the world,
so shut your mouth, fall in step and get back in line.
(2×)

I''m a little bastard, almost five feet tall,
I stick my head out of the crowd, they want to impale me on a stake,
I took hard blows, they pour salt into them,
I''ll take countless more blows,
they fly from all sides, and I don''t do things just because they''d be cool,
I don''t have the same hobbies as every other fool,
I keep paying for my nature, as I deserve,
it''s a bummer that I successfully stand out from the average,
nobody can be below average or above average,
keep your dreams to yourself, you''d better fucking take them,
you just have to work, sleep, work, sleep, work, sleep,
earn shit, shit straight down the toilet, thanks, I''m not interested
in walking with the herd, I''m really not crazy, I follow my own plan,
better keep your opinion to yourself,
I''ll go my own way as long as I have breath.

You''re an ordinary man, your lot is to wallow in shit,
paying off the bill all your life, letting yourself be dragged along,
your train left the moment you first saw the world,
so shut your mouth, fall in step and get back in line.
(2×)';

-- Babaraptor - Obyčejnej člověk ft. Skeli (uk)
UPDATE `lyrics` l JOIN `songs` s ON s.`id` = l.`song_id`
SET l.`words` = 'Кажуть, я маю усміхатися, йти разом зі стадом,
лізти людям у дупу, мабуть, навіть її витирати,
кажуть, я мав би вгамуватися й перестати так загострювати,
і змиритися з тим, як воно є, човгати ногами, похилити голову.
Цим не переймайся, цього не зрушиш, нічого не можеш зробити,
не думай, вимкни мозок, пахай, аж поки не розірветься тіло,
свою думку краще тримай при собі,
ти тут не для того, щоб змінити хід несприятливих речей.

Ти звичайна людина, твоя доля — колупатися в лайні,
усе життя сплачувати рахунок, дозволяти себе тягати,
твій потяг пішов уже в ту мить, коли ти побачив світ,
тож стули пельку, тримай крок і стань назад у стрій.
Ти звичайна людина, твоя доля — колупатися в лайні,
усе життя сплачувати рахунок, дозволяти себе тягати,
твій потяг пішов уже в ту мить, коли ти побачив світ,
тож стули пельку, тримай крок і стань назад у стрій.

Я малий покидьок, у мене майже півтора метра,
висовую голову з натовпу, мене хочуть посадити на палю,
я отримав тяжкі удари, в них мені сиплють сіль,
безліч ударів я ще отримаю,
вони летять з усіх боків, і я не роблю речі лише тому, що це було б cool,
у мене не ті самі захоплення, що в кожного другого бовдура,
за свою вдачу я постійно розплачуюсь по заслугах,
це халепа, що я успішно вибиваюсь із середнього,
ніхто не сміє бути нижче середнього чи вище середнього,
тримай свої мрії при собі, дивись, бляха, бери їх,
ти мусиш лише пахати, спати, пахати, спати, пахати, спати,
заробляти лайно, лайно одразу срати в унітаз, дякую, мені не цікаво
крокувати зі стадом, я справді не божевільний, я дотримуюсь свого плану,
свою думку краще тримай при собі,
я йтиму своїм шляхом, доки мені вистачить дихання.

Ти звичайна людина, твоя доля — колупатися в лайні,
усе життя сплачувати рахунок, дозволяти себе тягати,
твій потяг пішов уже в ту мить, коли ти побачив світ,
тож стули пельку, тримай крок і стань назад у стрій.
Ти звичайна людина, твоя доля — колупатися в лайні,
усе життя сплачувати рахунок, дозволяти себе тягати,
твій потяг пішов уже в ту мить, коли ти побачив світ,
тож стули пельку, тримай крок і стань назад у стрій.'
WHERE s.`name` = 'Babaraptor - Obyčejnej člověk ft. Skeli' AND l.`lang` = 'uk' AND l.`words` = 'Кажуть, я маю усміхатися, йти разом зі стадом,
лізти людям у дупу, мабуть, навіть її витирати,
кажуть, я мав би вгамуватися й перестати так загострювати,
і змиритися з тим, як воно є, човгати ногами, похилити голову.
Цим не переймайся, цього не зрушиш, нічого не можеш зробити,
не думай, вимкни мозок, пахай, аж поки не розірветься тіло,
свою думку краще тримай при собі,
ти тут не для того, щоб змінити хід несприятливих речей.

Ти звичайна людина, твоя доля — колупатися в лайні,
усе життя сплачувати рахунок, дозволяти себе тягати,
твій потяг пішов уже в ту мить, коли ти побачив світ,
тож стули пельку, тримай крок і стань назад у стрій.
(2×)

Я малий покидьок, у мене майже півтора метра,
висовую голову з натовпу, мене хочуть посадити на палю,
я отримав тяжкі удари, в них мені сиплють сіль,
безліч ударів я ще отримаю,
вони летять з усіх боків, і я не роблю речі лише тому, що це було б cool,
у мене не ті самі захоплення, що в кожного другого бовдура,
за свою вдачу я постійно розплачуюсь по заслугах,
це халепа, що я успішно вибиваюсь із середнього,
ніхто не сміє бути нижче середнього чи вище середнього,
тримай свої мрії при собі, дивись, бляха, бери їх,
ти мусиш лише пахати, спати, пахати, спати, пахати, спати,
заробляти лайно, лайно одразу срати в унітаз, дякую, мені не цікаво
крокувати зі стадом, я справді не божевільний, я дотримуюсь свого плану,
свою думку краще тримай при собі,
я йтиму своїм шляхом, доки мені вистачить дихання.

Ти звичайна людина, твоя доля — колупатися в лайні,
усе життя сплачувати рахунок, дозволяти себе тягати,
твій потяг пішов уже в ту мить, коли ти побачив світ,
тож стули пельку, тримай крок і стань назад у стрій.
(2×)';

-- Babaraptor - Obyčejnej člověk ft. Skeli (vi)
UPDATE `lyrics` l JOIN `songs` s ON s.`id` = l.`song_id`
SET l.`words` = 'Người ta bảo tôi phải mỉm cười, đi theo bầy đàn,
luồn cúi bợ đỡ người khác, có khi còn phải lau đít cho họ,
người ta bảo tôi nên biết kiềm chế và đừng làm quá lên như thế,
và chấp nhận mọi thứ như nó vốn là, lê chân, cúi đầu.
Đừng bận tâm chuyện này, chuyện đó mày chẳng thay đổi được, mày chẳng làm gì được,
đừng suy nghĩ, tắt não đi, cày đến khi rã rời thân xác,
ý kiến của mày tốt nhất cứ giữ cho riêng mình,
mày không ở đây để thay đổi dòng chảy của những điều tồi tệ.

Mày là một người bình thường, số phận mày là bới móc trong đống phân,
cả đời trả nợ hóa đơn, để mặc người ta lôi đi,
chuyến tàu của mày đã chạy mất ngay khoảnh khắc mày chào đời,
vậy nên im mồm đi, bước cho đều và quay lại hàng ngũ.
Mày là một người bình thường, số phận mày là bới móc trong đống phân,
cả đời trả nợ hóa đơn, để mặc người ta lôi đi,
chuyến tàu của mày đã chạy mất ngay khoảnh khắc mày chào đời,
vậy nên im mồm đi, bước cho đều và quay lại hàng ngũ.

Tôi là thằng khốn nhỏ con, cao gần một mét rưỡi,
tôi ló đầu ra khỏi đám đông, họ muốn xiên tôi lên cọc,
tôi đã lãnh những đòn đau, họ còn rắc muối vào đó,
vô số đòn nữa tôi vẫn sẽ còn lãnh,
chúng bay tới từ mọi phía, và tôi không làm gì chỉ vì nó trông cool,
tôi chẳng có cùng sở thích với mọi thằng ngốc khác,
vì tính cách mà tôi luôn phải trả giá xứng đáng,
thật tệ khi tôi thành công nổi bật khỏi mức trung bình,
không ai được phép đứng dưới mức trung bình hay trên mức trung bình,
giữ những giấc mơ cho riêng mày, liệu mà chộp lấy chúng, mẹ kiếp,
mày chỉ phải cày, ngủ, cày, ngủ, cày, ngủ,
kiếm toàn thứ vớ vẩn, thứ vớ vẩn đổ thẳng vào bồn cầu, cảm ơn, tôi không hứng thú
đi theo bầy đàn, tôi thật sự không điên, tôi theo kế hoạch của riêng mình,
ý kiến của mày tốt nhất cứ giữ cho riêng mình,
tôi sẽ đi theo cách của tôi, chừng nào tôi còn hơi thở.

Mày là một người bình thường, số phận mày là bới móc trong đống phân,
cả đời trả nợ hóa đơn, để mặc người ta lôi đi,
chuyến tàu của mày đã chạy mất ngay khoảnh khắc mày chào đời,
vậy nên im mồm đi, bước cho đều và quay lại hàng ngũ.
Mày là một người bình thường, số phận mày là bới móc trong đống phân,
cả đời trả nợ hóa đơn, để mặc người ta lôi đi,
chuyến tàu của mày đã chạy mất ngay khoảnh khắc mày chào đời,
vậy nên im mồm đi, bước cho đều và quay lại hàng ngũ.'
WHERE s.`name` = 'Babaraptor - Obyčejnej člověk ft. Skeli' AND l.`lang` = 'vi' AND l.`words` = 'Người ta bảo tôi phải mỉm cười, đi theo bầy đàn,
luồn cúi bợ đỡ người khác, có khi còn phải lau đít cho họ,
người ta bảo tôi nên biết kiềm chế và đừng làm quá lên như thế,
và chấp nhận mọi thứ như nó vốn là, lê chân, cúi đầu.
Đừng bận tâm chuyện này, chuyện đó mày chẳng thay đổi được, mày chẳng làm gì được,
đừng suy nghĩ, tắt não đi, cày đến khi rã rời thân xác,
ý kiến của mày tốt nhất cứ giữ cho riêng mình,
mày không ở đây để thay đổi dòng chảy của những điều tồi tệ.

Mày là một người bình thường, số phận mày là bới móc trong đống phân,
cả đời trả nợ hóa đơn, để mặc người ta lôi đi,
chuyến tàu của mày đã chạy mất ngay khoảnh khắc mày chào đời,
vậy nên im mồm đi, bước cho đều và quay lại hàng ngũ.
(2×)

Tôi là thằng khốn nhỏ con, cao gần một mét rưỡi,
tôi ló đầu ra khỏi đám đông, họ muốn xiên tôi lên cọc,
tôi đã lãnh những đòn đau, họ còn rắc muối vào đó,
vô số đòn nữa tôi vẫn sẽ còn lãnh,
chúng bay tới từ mọi phía, và tôi không làm gì chỉ vì nó trông cool,
tôi chẳng có cùng sở thích với mọi thằng ngốc khác,
vì tính cách mà tôi luôn phải trả giá xứng đáng,
thật tệ khi tôi thành công nổi bật khỏi mức trung bình,
không ai được phép đứng dưới mức trung bình hay trên mức trung bình,
giữ những giấc mơ cho riêng mày, liệu mà chộp lấy chúng, mẹ kiếp,
mày chỉ phải cày, ngủ, cày, ngủ, cày, ngủ,
kiếm toàn thứ vớ vẩn, thứ vớ vẩn đổ thẳng vào bồn cầu, cảm ơn, tôi không hứng thú
đi theo bầy đàn, tôi thật sự không điên, tôi theo kế hoạch của riêng mình,
ý kiến của mày tốt nhất cứ giữ cho riêng mình,
tôi sẽ đi theo cách của tôi, chừng nào tôi còn hơi thở.

Mày là một người bình thường, số phận mày là bới móc trong đống phân,
cả đời trả nợ hóa đơn, để mặc người ta lôi đi,
chuyến tàu của mày đã chạy mất ngay khoảnh khắc mày chào đời,
vậy nên im mồm đi, bước cho đều và quay lại hàng ngũ.
(2×)';

-- Ganja (cs)
UPDATE `lyrics` l JOIN `songs` s ON s.`id` = l.`song_id`
SET l.`words` = 'Začalo to nevinně, takhle jednou po víně,
sedíme, zevlíme, o světě vůbec nevíme,
sotva patnáct let, holt kluci neznalí,
svou první zelenou cigaretu zamotají,
stav houpavý se dostaví, když to brčko odpálíš,
s chutí do života vrhám se do víru poznání,
v puse nemám ani slinu, v tomhle dýmu se rozplynu,
inu, tuhle rostlinu od tý doby každou hodinu.
Jídlo, pití chutná líp, v práci se dá líp přežít,
celý den je veselej, tak nedělej, že seš nesmělej,
do kroužku sedej, nebuď jelen, život máš jenom jeden, tak si ho pořádně užívej.

Je to ganja, mocný čaroděj jménem ganja,
spasitel a lék na smutek a vztek,
málokdo to pochopí, lidi nejsou ochotní žít životy svobodný.
Je to ganja, mocný čaroděj jménem ganja,
spasitel a lék na smutek a vztek,
málokdo to pochopí, lidi nejsou ochotní žít životy svobodný.

Hnedka ráno, co vstanu, zamotám si půl gramu,
další půl gramu nechám na dýl na programu,
všude zákazy, rostliny ilegální, mi nezabrání
ve vyhledávání ideálních míst, kam si zalízt a nechat se svíst grandiózních palic,
už stačí jen zabalit, na záda se svalit,
užívat si dokonalý stavy bez práce, bez námahy.
Jo, to mám rád, tak mě to baví, zdravím všechny přátele, který dělají to samý,
jsme očarovaný mocným kouzlem mírumilovným,
nedá se to srovnat s chlastem.

Je to ganja, mocný čaroděj jménem ganja,
spasitel a lék na smutek a vztek,
málokdo to pochopí, lidi nejsou ochotní žít životy svobodný.
Je to ganja, mocný čaroděj jménem ganja,
spasitel a lék na smutek a vztek,
málokdo to pochopí, lidi nejsou ochotní žít životy svobodný.
Je to ganja, mocný čaroděj jménem ganja,
spasitel a lék na smutek a vztek,
málokdo to pochopí, lidi nejsou ochotní žít životy svobodný.'
WHERE s.`name` = 'Ganja' AND l.`lang` = 'cs' AND l.`words` = 'Začalo to nevinně, takhle jednou po víně,
sedíme, zevlíme, o světě vůbec nevíme,
sotva patnáct let, holt kluci neznalí,
svou první zelenou cigaretu zamotají,
stav houpavý se dostaví, když to brčko odpálíš,
s chutí do života vrhám se do víru poznání,
v puse nemám ani slinu, v tomhle dýmu se rozplynu,
inu, tuhle rostlinu od tý doby každou hodinu.
Jídlo, pití chutná líp, v práci se dá líp přežít,
celý den je veselej, tak nedělej, že seš nesmělej,
do kroužku sedej, nebuď jelen, život máš jenom jeden, tak si ho pořádně užívej.

Je to ganja, mocný čaroděj jménem ganja,
spasitel a lék na smutek a vztek,
málokdo to pochopí, lidi nejsou ochotní žít životy svobodný.
(2×)

Hnedka ráno, co vstanu, zamotám si půl gramu,
další půl gramu nechám na dýl na programu,
všude zákazy, rostliny ilegální, mi nezabrání
ve vyhledávání ideálních míst, kam si zalízt a nechat se svíst grandiózních palic,
už stačí jen zabalit, na záda se svalit,
užívat si dokonalý stavy bez práce, bez námahy.
Jo, to mám rád, tak mě to baví, zdravím všechny přátele, který dělají to samý,
jsme očarovaný mocným kouzlem mírumilovným,
nedá se to srovnat s chlastem.

Je to ganja, mocný čaroděj jménem ganja,
spasitel a lék na smutek a vztek,
málokdo to pochopí, lidi nejsou ochotní žít životy svobodný.
(3×)';

-- Ganja (de)
UPDATE `lyrics` l JOIN `songs` s ON s.`id` = l.`song_id`
SET l.`words` = 'Es fing harmlos an, so einmal nach dem Wein,
wir sitzen, wir hängen ab, wir wissen gar nichts von der Welt,
kaum fünfzehn Jahre alt, tja, ahnungslose Jungs,
sie drehen ihre erste grüne Zigarette,
ein schaukelnder Zustand stellt sich ein, wenn du die Tüte anzündest,
mit Lust aufs Leben stürze ich mich in den Strudel der Erkenntnis,
ich hab nicht mal Spucke im Mund, in diesem Rauch löse ich mich auf,
nun ja, diese Pflanze, seit damals jede Stunde.
Essen und Trinken schmecken besser, die Arbeit lässt sich besser überstehen,
der ganze Tag ist fröhlich, also tu nicht so schüchtern,
setz dich in den Kreis, sei kein Trottel, du hast nur ein Leben, also genieß es richtig.

Es ist Ganja, ein mächtiger Zauberer namens Ganja,
ein Retter und ein Heilmittel gegen Traurigkeit und Wut,
kaum einer versteht es, die Leute sind nicht bereit, ein freies Leben zu leben.
Es ist Ganja, ein mächtiger Zauberer namens Ganja,
ein Retter und ein Heilmittel gegen Traurigkeit und Wut,
kaum einer versteht es, die Leute sind nicht bereit, ein freies Leben zu leben.

Gleich am Morgen, sobald ich aufstehe, dreh ich mir ein halbes Gramm,
das andere halbe Gramm lasse ich für später auf dem Programm,
überall Verbote, Pflanzen illegal, das hält mich nicht ab
von der Suche nach idealen Plätzen, wo ich mich hinverziehen und mich von grandiosen Buds verführen lassen kann,
jetzt nur noch drehen, auf den Rücken fallen lassen,
perfekte Zustände genießen, ohne Arbeit, ohne Mühe.
Ja, das mag ich, das macht mir Spaß, Grüße an alle Freunde, die dasselbe tun,
wir sind verzaubert von einem mächtigen, friedlichen Zauber,
mit Alkohol lässt sich das nicht vergleichen.

Es ist Ganja, ein mächtiger Zauberer namens Ganja,
ein Retter und ein Heilmittel gegen Traurigkeit und Wut,
kaum einer versteht es, die Leute sind nicht bereit, ein freies Leben zu leben.
Es ist Ganja, ein mächtiger Zauberer namens Ganja,
ein Retter und ein Heilmittel gegen Traurigkeit und Wut,
kaum einer versteht es, die Leute sind nicht bereit, ein freies Leben zu leben.
Es ist Ganja, ein mächtiger Zauberer namens Ganja,
ein Retter und ein Heilmittel gegen Traurigkeit und Wut,
kaum einer versteht es, die Leute sind nicht bereit, ein freies Leben zu leben.'
WHERE s.`name` = 'Ganja' AND l.`lang` = 'de' AND l.`words` = 'Es fing harmlos an, so einmal nach dem Wein,
wir sitzen, wir hängen ab, wir wissen gar nichts von der Welt,
kaum fünfzehn Jahre alt, tja, ahnungslose Jungs,
sie drehen ihre erste grüne Zigarette,
ein schaukelnder Zustand stellt sich ein, wenn du die Tüte anzündest,
mit Lust aufs Leben stürze ich mich in den Strudel der Erkenntnis,
ich hab nicht mal Spucke im Mund, in diesem Rauch löse ich mich auf,
nun ja, diese Pflanze, seit damals jede Stunde.
Essen und Trinken schmecken besser, die Arbeit lässt sich besser überstehen,
der ganze Tag ist fröhlich, also tu nicht so schüchtern,
setz dich in den Kreis, sei kein Trottel, du hast nur ein Leben, also genieß es richtig.

Es ist Ganja, ein mächtiger Zauberer namens Ganja,
ein Retter und ein Heilmittel gegen Traurigkeit und Wut,
kaum einer versteht es, die Leute sind nicht bereit, ein freies Leben zu leben.
(2×)

Gleich am Morgen, sobald ich aufstehe, dreh ich mir ein halbes Gramm,
das andere halbe Gramm lasse ich für später auf dem Programm,
überall Verbote, Pflanzen illegal, das hält mich nicht ab
von der Suche nach idealen Plätzen, wo ich mich hinverziehen und mich von grandiosen Buds verführen lassen kann,
jetzt nur noch drehen, auf den Rücken fallen lassen,
perfekte Zustände genießen, ohne Arbeit, ohne Mühe.
Ja, das mag ich, das macht mir Spaß, Grüße an alle Freunde, die dasselbe tun,
wir sind verzaubert von einem mächtigen, friedlichen Zauber,
mit Alkohol lässt sich das nicht vergleichen.

Es ist Ganja, ein mächtiger Zauberer namens Ganja,
ein Retter und ein Heilmittel gegen Traurigkeit und Wut,
kaum einer versteht es, die Leute sind nicht bereit, ein freies Leben zu leben.
(3×)';

-- Ganja (en)
UPDATE `lyrics` l JOIN `songs` s ON s.`id` = l.`song_id`
SET l.`words` = 'It started innocently, one time like this after some wine,
we sit, we hang around, we know nothing about the world,
barely fifteen years old, well, clueless boys,
they roll their first green cigarette,
a swaying feeling kicks in when you light up that blunt,
with an appetite for life I throw myself into the whirl of discovery,
I don''t even have spit in my mouth, I dissolve in this smoke,
well, this plant, every hour since then.
Food and drink taste better, work is easier to survive,
the whole day is cheerful, so don''t act shy,
sit down in the circle, don''t be a fool, you only have one life, so enjoy it properly.

It''s ganja, a mighty wizard called ganja,
a saviour and a cure for sadness and anger,
few people understand it, people aren''t willing to live free lives.
It''s ganja, a mighty wizard called ganja,
a saviour and a cure for sadness and anger,
few people understand it, people aren''t willing to live free lives.

Right in the morning, as soon as I get up, I roll half a gram,
I leave the other half gram on the schedule for later,
bans everywhere, plants are illegal, but that won''t stop me
from searching for the ideal spots to crawl into and let myself be seduced by grandiose buds,
now all that''s left is to roll up, flop down on my back,
enjoy perfect highs without work, without effort.
Yeah, that''s what I like, that''s what I enjoy, shout-out to all my friends who do the same,
we''re enchanted by a mighty, peaceful spell,
there''s no comparing it to booze.

It''s ganja, a mighty wizard called ganja,
a saviour and a cure for sadness and anger,
few people understand it, people aren''t willing to live free lives.
It''s ganja, a mighty wizard called ganja,
a saviour and a cure for sadness and anger,
few people understand it, people aren''t willing to live free lives.
It''s ganja, a mighty wizard called ganja,
a saviour and a cure for sadness and anger,
few people understand it, people aren''t willing to live free lives.'
WHERE s.`name` = 'Ganja' AND l.`lang` = 'en' AND l.`words` = 'It started innocently, one time like this after some wine,
we sit, we hang around, we know nothing about the world,
barely fifteen years old, well, clueless boys,
they roll their first green cigarette,
a swaying feeling kicks in when you light up that blunt,
with an appetite for life I throw myself into the whirl of discovery,
I don''t even have spit in my mouth, I dissolve in this smoke,
well, this plant, every hour since then.
Food and drink taste better, work is easier to survive,
the whole day is cheerful, so don''t act shy,
sit down in the circle, don''t be a fool, you only have one life, so enjoy it properly.

It''s ganja, a mighty wizard called ganja,
a saviour and a cure for sadness and anger,
few people understand it, people aren''t willing to live free lives.
(2×)

Right in the morning, as soon as I get up, I roll half a gram,
I leave the other half gram on the schedule for later,
bans everywhere, plants are illegal, but that won''t stop me
from searching for the ideal spots to crawl into and let myself be seduced by grandiose buds,
now all that''s left is to roll up, flop down on my back,
enjoy perfect highs without work, without effort.
Yeah, that''s what I like, that''s what I enjoy, shout-out to all my friends who do the same,
we''re enchanted by a mighty, peaceful spell,
there''s no comparing it to booze.

It''s ganja, a mighty wizard called ganja,
a saviour and a cure for sadness and anger,
few people understand it, people aren''t willing to live free lives.
(3×)';

-- Ganja (uk)
UPDATE `lyrics` l JOIN `songs` s ON s.`id` = l.`song_id`
SET l.`words` = 'Почалося все невинно, якось так після вина,
ми сидимо, байдикуємо, про світ зовсім нічого не знаємо,
ледве п''ятнадцять років, ну що ж, необізнані хлопці,
вони скручують свою першу зелену цигарку,
приходить хиткий стан, коли ти підпалюєш той косяк,
зі смаком до життя я кидаюся у вир пізнання,
у роті навіть слини немає, у цьому диму я розчиняюсь,
що ж, цю рослину відтоді щогодини.
Їжа й питво смакують краще, на роботі легше вижити,
увесь день веселий, тож не вдавай, що ти сором''язливий,
сідай у коло, не будь бовдуром, життя в тебе лише одне, тож насолоджуйся ним як слід.

Це ганджа, могутній чарівник на ім''я ганджа,
рятівник і ліки від смутку й гніву,
мало хто це зрозуміє, люди не готові жити вільним життям.
Це ганджа, могутній чарівник на ім''я ганджа,
рятівник і ліки від смутку й гніву,
мало хто це зрозуміє, люди не готові жити вільним життям.

Одразу вранці, щойно встану, скручую собі пів грама,
ще пів грама лишаю на потім у програмі,
всюди заборони, рослини нелегальні, але мені це не завадить
шукати ідеальні місця, куди можна залізти й дати себе спокусити грандіозним шишкам,
тепер лишилося тільки скрутити, впасти на спину,
насолоджуватися ідеальними станами без роботи, без зусиль.
Так, оце я люблю, оце мені подобається, вітаю всіх друзів, які роблять те саме,
ми зачаровані могутнім миролюбним закляттям,
це не можна порівняти з випивкою.

Це ганджа, могутній чарівник на ім''я ганджа,
рятівник і ліки від смутку й гніву,
мало хто це зрозуміє, люди не готові жити вільним життям.
Це ганджа, могутній чарівник на ім''я ганджа,
рятівник і ліки від смутку й гніву,
мало хто це зрозуміє, люди не готові жити вільним життям.
Це ганджа, могутній чарівник на ім''я ганджа,
рятівник і ліки від смутку й гніву,
мало хто це зрозуміє, люди не готові жити вільним життям.'
WHERE s.`name` = 'Ganja' AND l.`lang` = 'uk' AND l.`words` = 'Почалося все невинно, якось так після вина,
ми сидимо, байдикуємо, про світ зовсім нічого не знаємо,
ледве п''ятнадцять років, ну що ж, необізнані хлопці,
вони скручують свою першу зелену цигарку,
приходить хиткий стан, коли ти підпалюєш той косяк,
зі смаком до життя я кидаюся у вир пізнання,
у роті навіть слини немає, у цьому диму я розчиняюсь,
що ж, цю рослину відтоді щогодини.
Їжа й питво смакують краще, на роботі легше вижити,
увесь день веселий, тож не вдавай, що ти сором''язливий,
сідай у коло, не будь бовдуром, життя в тебе лише одне, тож насолоджуйся ним як слід.

Це ганджа, могутній чарівник на ім''я ганджа,
рятівник і ліки від смутку й гніву,
мало хто це зрозуміє, люди не готові жити вільним життям.
(2×)

Одразу вранці, щойно встану, скручую собі пів грама,
ще пів грама лишаю на потім у програмі,
всюди заборони, рослини нелегальні, але мені це не завадить
шукати ідеальні місця, куди можна залізти й дати себе спокусити грандіозним шишкам,
тепер лишилося тільки скрутити, впасти на спину,
насолоджуватися ідеальними станами без роботи, без зусиль.
Так, оце я люблю, оце мені подобається, вітаю всіх друзів, які роблять те саме,
ми зачаровані могутнім миролюбним закляттям,
це не можна порівняти з випивкою.

Це ганджа, могутній чарівник на ім''я ганджа,
рятівник і ліки від смутку й гніву,
мало хто це зрозуміє, люди не готові жити вільним життям.
(3×)';

-- Ganja (vi)
UPDATE `lyrics` l JOIN `songs` s ON s.`id` = l.`song_id`
SET l.`words` = 'Mọi chuyện bắt đầu thật ngây thơ, một lần như thế sau chút rượu vang,
bọn mình ngồi, bọn mình la cà, chẳng biết gì về thế giới,
mới mười lăm tuổi, thôi thì, những cậu nhóc ngây ngô,
chúng cuốn điếu thuốc xanh đầu tiên của mình,
cảm giác chao đảo kéo đến khi bạn châm điếu ấy,
với niềm thèm khát cuộc sống tôi lao vào vòng xoáy khám phá,
trong miệng tôi đến nước bọt cũng chẳng còn, tôi tan biến trong làn khói này,
thôi thì, cái cây này, từ đó đến giờ cứ mỗi tiếng.
Đồ ăn thức uống ngon hơn, công việc cũng dễ sống sót hơn,
cả ngày đều vui vẻ, vậy nên đừng làm như mình nhút nhát,
ngồi vào vòng tròn đi, đừng ngốc nghếch, đời chỉ có một, nên hãy tận hưởng nó cho ra trò.

Đó là ganja, một phù thủy quyền năng tên là ganja,
vị cứu tinh và liều thuốc cho nỗi buồn và cơn giận,
hiếm ai hiểu được, con người không sẵn lòng sống một cuộc đời tự do.
Đó là ganja, một phù thủy quyền năng tên là ganja,
vị cứu tinh và liều thuốc cho nỗi buồn và cơn giận,
hiếm ai hiểu được, con người không sẵn lòng sống một cuộc đời tự do.

Sáng ra, vừa ngủ dậy, tôi cuốn ngay nửa gram,
nửa gram kia tôi để dành cho chương trình lát nữa,
khắp nơi là lệnh cấm, cây cỏ bất hợp pháp, nhưng chẳng ngăn được tôi
đi tìm những chỗ lý tưởng để chui vào và để những nụ hoa tuyệt vời quyến rũ mình,
giờ chỉ còn việc cuốn, nằm ngả lưng ra,
tận hưởng những trạng thái hoàn hảo, không làm lụng, không cực nhọc.
Yeah, đó là điều tôi thích, thế mới vui, gửi lời chào đến mọi người bạn cũng làm như vậy,
bọn mình bị mê hoặc bởi một bùa chú hòa bình đầy quyền năng,
chẳng thể so sánh nó với rượu được.

Đó là ganja, một phù thủy quyền năng tên là ganja,
vị cứu tinh và liều thuốc cho nỗi buồn và cơn giận,
hiếm ai hiểu được, con người không sẵn lòng sống một cuộc đời tự do.
Đó là ganja, một phù thủy quyền năng tên là ganja,
vị cứu tinh và liều thuốc cho nỗi buồn và cơn giận,
hiếm ai hiểu được, con người không sẵn lòng sống một cuộc đời tự do.
Đó là ganja, một phù thủy quyền năng tên là ganja,
vị cứu tinh và liều thuốc cho nỗi buồn và cơn giận,
hiếm ai hiểu được, con người không sẵn lòng sống một cuộc đời tự do.'
WHERE s.`name` = 'Ganja' AND l.`lang` = 'vi' AND l.`words` = 'Mọi chuyện bắt đầu thật ngây thơ, một lần như thế sau chút rượu vang,
bọn mình ngồi, bọn mình la cà, chẳng biết gì về thế giới,
mới mười lăm tuổi, thôi thì, những cậu nhóc ngây ngô,
chúng cuốn điếu thuốc xanh đầu tiên của mình,
cảm giác chao đảo kéo đến khi bạn châm điếu ấy,
với niềm thèm khát cuộc sống tôi lao vào vòng xoáy khám phá,
trong miệng tôi đến nước bọt cũng chẳng còn, tôi tan biến trong làn khói này,
thôi thì, cái cây này, từ đó đến giờ cứ mỗi tiếng.
Đồ ăn thức uống ngon hơn, công việc cũng dễ sống sót hơn,
cả ngày đều vui vẻ, vậy nên đừng làm như mình nhút nhát,
ngồi vào vòng tròn đi, đừng ngốc nghếch, đời chỉ có một, nên hãy tận hưởng nó cho ra trò.

Đó là ganja, một phù thủy quyền năng tên là ganja,
vị cứu tinh và liều thuốc cho nỗi buồn và cơn giận,
hiếm ai hiểu được, con người không sẵn lòng sống một cuộc đời tự do.
(2×)

Sáng ra, vừa ngủ dậy, tôi cuốn ngay nửa gram,
nửa gram kia tôi để dành cho chương trình lát nữa,
khắp nơi là lệnh cấm, cây cỏ bất hợp pháp, nhưng chẳng ngăn được tôi
đi tìm những chỗ lý tưởng để chui vào và để những nụ hoa tuyệt vời quyến rũ mình,
giờ chỉ còn việc cuốn, nằm ngả lưng ra,
tận hưởng những trạng thái hoàn hảo, không làm lụng, không cực nhọc.
Yeah, đó là điều tôi thích, thế mới vui, gửi lời chào đến mọi người bạn cũng làm như vậy,
bọn mình bị mê hoặc bởi một bùa chú hòa bình đầy quyền năng,
chẳng thể so sánh nó với rượu được.

Đó là ganja, một phù thủy quyền năng tên là ganja,
vị cứu tinh và liều thuốc cho nỗi buồn và cơn giận,
hiếm ai hiểu được, con người không sẵn lòng sống một cuộc đời tự do.
(3×)';

-- JML - No ty vole ft. Farri, Skeli, Babaraptor (cs)
UPDATE `lyrics` l JOIN `songs` s ON s.`id` = l.`song_id`
SET l.`words` = 'No ty vole, no ty vole,
takže chápej, jedu na sto procent,
rok po roce mrdám všechno, mrdám tebe, mrdám všechno v dnešní době,
promiňte, že jsem takový, arogantní, makový,
nedokážou pochopit, že mrdám český zákony.
Česká politika a. k. a. tlustá fanatika,
vyjebaná pointa tady toho světa,
nechci se už toho týkat, vidím semafory blikat,
proto pokračujem dál, není, more, na co čekat.
Jedu v formaci jak kryptonit, vybouchnu jak dynamit,
cítíš se jak superhero, chceš nás, more, zastavit,
jsi zdrojem naší potravy, podělanej wannabe,
hejter stále netuší, že končí stupeň kariéry,
vaší sféry, vaší rozehraný strany, o čistotě rasy,
vaší trasy, náboženský spásy,
pro mě vyjebaný kecy, jedu na sto procent k věci.

Nemůžeš jít, homie, dál, bez toho fakt nejsi high,
nevíš sám kudy kam, taktika, vlastní plán.
Nemůžeš jít, homie, dál, bez toho fakt nejsi high,
nevíš sám kudy kam, taktika, vlastní plán.

Česká republika vhodná tak pro notorika,
že tu žijeme, tak to zrovna není velká klika,
tunely, úplatky, to je naše vládní hra,
rychle všechno zdražit, kde na to kurva máme brát.
První v chlastu, první v drogách, každej balí jointa,
je to tady prohnilý, v tom je celá pointa,
už jsem na to zvyklej, a už se o to nestarám,
buď si, kámo, jistej, že o kvalitní rap se postarám,
rap je pro mě život a ten je zase krátkej,
jednou hore, jednou dole, no, je tak trochu vrtkej,
tohle je můj styl, tak tím si buď jistý,
a fakt je mi jedno, kámo, co si o mně myslíš,
mám prostě svou cestu, cestu vyvolenou,
i když je mi jasný, že to mnozí nepoberou,
dávám tak, jak dávám, žiju tam, kde žiju,
nic s tím nenadělám, jo, už to takhle beru.

Nemůžeš jít, homie, dál, bez toho fakt nejsi high,
nevíš sám kudy kam, taktika, vlastní plán.
Nemůžeš jít, homie, dál, bez toho fakt nejsi high,
nevíš sám kudy kam, taktika, vlastní plán.

No ty vole, koukni, jak se žije dole,
alespoň na chvíli se vžít do mojí role,
potí se mi koule z toho, jak musím dřít,
a je mi špatně z toho, že vím, jak málo za to budu mít.
Sedíte si na uších v kravatách, nafintěný, navoněný, peněženky přeplněný,
tlačí vás do prdelí a furt vám to nestačí,
nejsem slepej, blbej a ani nejmladší,
ale mám svůj plán, kterej mě zachrání,
naše CD bude všude dobře k sehnání.
Ukážem ti věci, co ti byly dodnes neznámý,
neřeším, že dělám věci, co nejsou legální,
zakázaný ovoce je tu všude k sehnání,
a proto se skrz mou ves chlupatý rádi prohání,
asi jim to nepřijde úplně normální,
že za to, co dělám, daně neodvádím.

Plány a taktika mi prej nic neříká,
divím se, když zaslechnu, že mi to lidi vytýkaj,
včera dělal jsem to, co dělám dneska,
od rána do večera visel jsem u Tesca,
musím furt chlastat, beztak nechci přestat,
žiju a profituju pouze z darů města,
mockrát jsem musel na chodníku přespat,
jsem socka, čpí ze mě rozklad,
já a můj gang zaujmeme pozice,
den co den prachy po všech kolem chcem,
posadím se na zem s hladovým čoklem,
vidíš pracku s kloboukem, obcházíš mě obloukem,
koleduju si, mám monokl pod vokem,
nepohnu se z místa, jsem tam, kde jsem byl před rokem,
jsem línej šmejd, ta nálepka nejde smejt,
mým plánem je celý život beton hubou rejt.

Nemůžeš jít, homie, dál, bez toho fakt nejsi high,
nevíš sám kudy kam, taktika, vlastní plán.'
WHERE s.`name` = 'JML - No ty vole ft. Farri, Skeli, Babaraptor' AND l.`lang` = 'cs' AND l.`words` = 'No ty vole, no ty vole,
takže chápej, jedu na sto procent,
rok po roce mrdám všechno, mrdám tebe, mrdám všechno v dnešní době,
promiňte, že jsem takový, arogantní, makový,
nedokážou pochopit, že mrdám český zákony.
Česká politika a. k. a. tlustá fanatika,
vyjebaná pointa tady toho světa,
nechci se už toho týkat, vidím semafory blikat,
proto pokračujem dál, není, more, na co čekat.
Jedu v formaci jak kryptonit, vybouchnu jak dynamit,
cítíš se jak superhero, chceš nás, more, zastavit,
jsi zdrojem naší potravy, podělanej wannabe,
hejter stále netuší, že končí stupeň kariéry,
vaší sféry, vaší rozehraný strany, o čistotě rasy,
vaší trasy, náboženský spásy,
pro mě vyjebaný kecy, jedu na sto procent k věci.

Nemůžeš jít, homie, dál, bez toho fakt nejsi high,
nevíš sám kudy kam, taktika, vlastní plán.
(2×)

Česká republika vhodná tak pro notorika,
že tu žijeme, tak to zrovna není velká klika,
tunely, úplatky, to je naše vládní hra,
rychle všechno zdražit, kde na to kurva máme brát.
První v chlastu, první v drogách, každej balí jointa,
je to tady prohnilý, v tom je celá pointa,
už jsem na to zvyklej, a už se o to nestarám,
buď si, kámo, jistej, že o kvalitní rap se postarám,
rap je pro mě život a ten je zase krátkej,
jednou hore, jednou dole, no, je tak trochu vrtkej,
tohle je můj styl, tak tím si buď jistý,
a fakt je mi jedno, kámo, co si o mně myslíš,
mám prostě svou cestu, cestu vyvolenou,
i když je mi jasný, že to mnozí nepoberou,
dávám tak, jak dávám, žiju tam, kde žiju,
nic s tím nenadělám, jo, už to takhle beru.

Nemůžeš jít, homie, dál, bez toho fakt nejsi high,
nevíš sám kudy kam, taktika, vlastní plán.
(2×)

No ty vole, koukni, jak se žije dole,
alespoň na chvíli se vžít do mojí role,
potí se mi koule z toho, jak musím dřít,
a je mi špatně z toho, že vím, jak málo za to budu mít.
Sedíte si na uších v kravatách, nafintěný, navoněný, peněženky přeplněný,
tlačí vás do prdelí a furt vám to nestačí,
nejsem slepej, blbej a ani nejmladší,
ale mám svůj plán, kterej mě zachrání,
naše CD bude všude dobře k sehnání.
Ukážem ti věci, co ti byly dodnes neznámý,
neřeším, že dělám věci, co nejsou legální,
zakázaný ovoce je tu všude k sehnání,
a proto se skrz mou ves chlupatý rádi prohání,
asi jim to nepřijde úplně normální,
že za to, co dělám, daně neodvádím.

Plány a taktika mi prej nic neříká,
divím se, když zaslechnu, že mi to lidi vytýkaj,
včera dělal jsem to, co dělám dneska,
od rána do večera visel jsem u Tesca,
musím furt chlastat, beztak nechci přestat,
žiju a profituju pouze z darů města,
mockrát jsem musel na chodníku přespat,
jsem socka, čpí ze mě rozklad,
já a můj gang zaujmeme pozice,
den co den prachy po všech kolem chcem,
posadím se na zem s hladovým čoklem,
vidíš pracku s kloboukem, obcházíš mě obloukem,
koleduju si, mám monokl pod vokem,
nepohnu se z místa, jsem tam, kde jsem byl před rokem,
jsem línej šmejd, ta nálepka nejde smejt,
mým plánem je celý život beton hubou rejt.

Nemůžeš jít, homie, dál, bez toho fakt nejsi high,
nevíš sám kudy kam, taktika, vlastní plán.';

-- JML - No ty vole ft. Farri, Skeli, Babaraptor (de)
UPDATE `lyrics` l JOIN `songs` s ON s.`id` = l.`song_id`
SET l.`words` = 'Alter, ey, Alter, ey,
also kapier''s, ich gebe hundert Prozent,
Jahr für Jahr fick ich alles, fick ich dich, fick ich alles in der heutigen Zeit,
entschuldigt, dass ich so bin, arrogant, auf Mohn,
sie können nicht begreifen, dass ich auf die tschechischen Gesetze scheiße.
Tschechische Politik a. k. a. fette Fanatiker,
die verfickte Pointe dieser ganzen Welt,
ich will damit nichts mehr zu tun haben, ich sehe die Ampeln blinken,
deshalb machen wir weiter, es gibt nichts zu warten, Bruder.
Ich fahre in Formation wie Kryptonit, ich explodiere wie Dynamit,
du fühlst dich wie ein Superheld, du willst uns aufhalten, Bruder,
du bist unsere Nahrungsquelle, ein beschissener Wannabe,
der Hater ahnt immer noch nicht, dass seine Karrierestufe endet,
eure Sphären, eure angespielten Seiten, über die Reinheit der Rasse,
eure Routen, religiöse Erlösung,
für mich verfickte Sprüche, ich gehe hundert Prozent zur Sache.

Du kannst nicht weiter, Homie, ohne das bist du echt nicht high,
du weißt selbst nicht, wohin, Taktik, eigener Plan.
Du kannst nicht weiter, Homie, ohne das bist du echt nicht high,
du weißt selbst nicht, wohin, Taktik, eigener Plan.

Die Tschechische Republik, genau richtig für einen Säufer,
dass wir hier leben, ist nicht gerade großes Glück,
Betrug, Bestechung, das ist das Spiel unserer Regierung,
schnell alles teurer machen, wo zum Teufel sollen wir das Geld hernehmen.
Erster im Saufen, Erster bei Drogen, jeder dreht einen Joint,
es ist hier verfault, das ist die ganze Pointe,
ich bin daran gewöhnt, und es kümmert mich nicht mehr,
sei dir sicher, Kumpel, dass ich mich um Qualitäts-Rap kümmere,
Rap ist mein Leben, und das ist kurz,
mal oben, mal unten, na ja, es ist ein bisschen wankelmütig,
das ist mein Style, da kannst du dir sicher sein,
und es ist mir echt egal, Kumpel, was du von mir denkst,
ich habe einfach meinen Weg, einen auserwählten Weg,
auch wenn mir klar ist, dass viele es nicht kapieren,
ich gebe es so, wie ich es gebe, ich lebe, wo ich lebe,
ich kann nichts dagegen tun, ja, ich nehme es so, wie es ist.

Du kannst nicht weiter, Homie, ohne das bist du echt nicht high,
du weißt selbst nicht, wohin, Taktik, eigener Plan.
Du kannst nicht weiter, Homie, ohne das bist du echt nicht high,
du weißt selbst nicht, wohin, Taktik, eigener Plan.

Alter, ey, schau, wie man da unten lebt,
versetz dich wenigstens für eine Weile in meine Rolle,
mir schwitzen die Eier davon, wie ich schuften muss,
und mir ist schlecht, weil ich weiß, wie wenig ich dafür kriege.
Ihr sitzt auf euren Ohren in Krawatten, rausgeputzt, parfümiert, die Brieftaschen übervoll,
es drückt euch in den Arsch und es reicht euch immer noch nicht,
ich bin nicht blind, nicht blöd und auch nicht der Jüngste,
aber ich habe meinen Plan, der mich retten wird,
unsere CD wird überall gut zu kriegen sein.
Wir zeigen dir Dinge, die du bis heute nicht kanntest,
es ist mir egal, dass ich Dinge tue, die nicht legal sind,
die verbotene Frucht gibt es hier überall,
und deshalb rasen die Bullen gern durch mein Dorf,
sie finden es wohl nicht ganz normal,
dass ich für das, was ich mache, keine Steuern zahle.

Pläne und Taktik sagen mir angeblich nichts,
ich wundere mich, wenn ich höre, dass die Leute mir das vorwerfen,
gestern hab ich gemacht, was ich heute mache,
von morgens bis abends hing ich beim Tesco rum,
ich muss ständig saufen, ich will sowieso nicht aufhören,
ich lebe und profitiere nur von den Gaben der Stadt,
oft musste ich auf dem Gehweg übernachten,
ich bin ein Sozialschmarotzer, aus mir stinkt der Verfall,
ich und meine Gang beziehen Position,
Tag für Tag wollen wir Geld von allen um uns herum,
ich setze mich mit einem hungrigen Köter auf den Boden,
du siehst eine Pfote mit einem Hut, du machst einen Bogen um mich,
ich lege es drauf an, ich hab ein blaues Auge,
ich rühre mich nicht vom Fleck, ich bin da, wo ich vor einem Jahr war,
ich bin ein fauler Mistkerl, das Etikett lässt sich nicht abwaschen,
mein Plan ist es, mein ganzes Leben lang mit der Fresse Beton zu pflügen.

Du kannst nicht weiter, Homie, ohne das bist du echt nicht high,
du weißt selbst nicht, wohin, Taktik, eigener Plan.'
WHERE s.`name` = 'JML - No ty vole ft. Farri, Skeli, Babaraptor' AND l.`lang` = 'de' AND l.`words` = 'Alter, ey, Alter, ey,
also kapier''s, ich gebe hundert Prozent,
Jahr für Jahr fick ich alles, fick ich dich, fick ich alles in der heutigen Zeit,
entschuldigt, dass ich so bin, arrogant, auf Mohn,
sie können nicht begreifen, dass ich auf die tschechischen Gesetze scheiße.
Tschechische Politik a. k. a. fette Fanatiker,
die verfickte Pointe dieser ganzen Welt,
ich will damit nichts mehr zu tun haben, ich sehe die Ampeln blinken,
deshalb machen wir weiter, es gibt nichts zu warten, Bruder.
Ich fahre in Formation wie Kryptonit, ich explodiere wie Dynamit,
du fühlst dich wie ein Superheld, du willst uns aufhalten, Bruder,
du bist unsere Nahrungsquelle, ein beschissener Wannabe,
der Hater ahnt immer noch nicht, dass seine Karrierestufe endet,
eure Sphären, eure angespielten Seiten, über die Reinheit der Rasse,
eure Routen, religiöse Erlösung,
für mich verfickte Sprüche, ich gehe hundert Prozent zur Sache.

Du kannst nicht weiter, Homie, ohne das bist du echt nicht high,
du weißt selbst nicht, wohin, Taktik, eigener Plan.
(2×)

Die Tschechische Republik, genau richtig für einen Säufer,
dass wir hier leben, ist nicht gerade großes Glück,
Betrug, Bestechung, das ist das Spiel unserer Regierung,
schnell alles teurer machen, wo zum Teufel sollen wir das Geld hernehmen.
Erster im Saufen, Erster bei Drogen, jeder dreht einen Joint,
es ist hier verfault, das ist die ganze Pointe,
ich bin daran gewöhnt, und es kümmert mich nicht mehr,
sei dir sicher, Kumpel, dass ich mich um Qualitäts-Rap kümmere,
Rap ist mein Leben, und das ist kurz,
mal oben, mal unten, na ja, es ist ein bisschen wankelmütig,
das ist mein Style, da kannst du dir sicher sein,
und es ist mir echt egal, Kumpel, was du von mir denkst,
ich habe einfach meinen Weg, einen auserwählten Weg,
auch wenn mir klar ist, dass viele es nicht kapieren,
ich gebe es so, wie ich es gebe, ich lebe, wo ich lebe,
ich kann nichts dagegen tun, ja, ich nehme es so, wie es ist.

Du kannst nicht weiter, Homie, ohne das bist du echt nicht high,
du weißt selbst nicht, wohin, Taktik, eigener Plan.
(2×)

Alter, ey, schau, wie man da unten lebt,
versetz dich wenigstens für eine Weile in meine Rolle,
mir schwitzen die Eier davon, wie ich schuften muss,
und mir ist schlecht, weil ich weiß, wie wenig ich dafür kriege.
Ihr sitzt auf euren Ohren in Krawatten, rausgeputzt, parfümiert, die Brieftaschen übervoll,
es drückt euch in den Arsch und es reicht euch immer noch nicht,
ich bin nicht blind, nicht blöd und auch nicht der Jüngste,
aber ich habe meinen Plan, der mich retten wird,
unsere CD wird überall gut zu kriegen sein.
Wir zeigen dir Dinge, die du bis heute nicht kanntest,
es ist mir egal, dass ich Dinge tue, die nicht legal sind,
die verbotene Frucht gibt es hier überall,
und deshalb rasen die Bullen gern durch mein Dorf,
sie finden es wohl nicht ganz normal,
dass ich für das, was ich mache, keine Steuern zahle.

Pläne und Taktik sagen mir angeblich nichts,
ich wundere mich, wenn ich höre, dass die Leute mir das vorwerfen,
gestern hab ich gemacht, was ich heute mache,
von morgens bis abends hing ich beim Tesco rum,
ich muss ständig saufen, ich will sowieso nicht aufhören,
ich lebe und profitiere nur von den Gaben der Stadt,
oft musste ich auf dem Gehweg übernachten,
ich bin ein Sozialschmarotzer, aus mir stinkt der Verfall,
ich und meine Gang beziehen Position,
Tag für Tag wollen wir Geld von allen um uns herum,
ich setze mich mit einem hungrigen Köter auf den Boden,
du siehst eine Pfote mit einem Hut, du machst einen Bogen um mich,
ich lege es drauf an, ich hab ein blaues Auge,
ich rühre mich nicht vom Fleck, ich bin da, wo ich vor einem Jahr war,
ich bin ein fauler Mistkerl, das Etikett lässt sich nicht abwaschen,
mein Plan ist es, mein ganzes Leben lang mit der Fresse Beton zu pflügen.

Du kannst nicht weiter, Homie, ohne das bist du echt nicht high,
du weißt selbst nicht, wohin, Taktik, eigener Plan.';

-- JML - No ty vole ft. Farri, Skeli, Babaraptor (en)
UPDATE `lyrics` l JOIN `songs` s ON s.`id` = l.`song_id`
SET l.`words` = 'Damn, dude, damn, dude,
so get it, I''m going a hundred percent,
year after year I fuck everything, I fuck you, I fuck everything these days,
sorry that I''m like this, arrogant, high on poppy,
they can''t understand that I fuck Czech laws.
Czech politics a.k.a. fat fanatics,
the fucked-up point of this whole world,
I don''t want to have anything to do with it anymore, I see the traffic lights blinking,
so we keep going, there''s nothing to wait for, bro.
I ride in formation like kryptonite, I explode like dynamite,
you feel like a superhero, you want to stop us, bro,
you''re our source of food, a shitty wannabe,
the hater still has no idea his career level is ending,
your spheres, your half-played sides, about the purity of race,
your routes, religious salvation,
fucked-up talk to me, I go a hundred percent to the point.

You can''t go on, homie, without it you''re really not high,
you don''t know which way to go yourself, tactics, your own plan.
You can''t go on, homie, without it you''re really not high,
you don''t know which way to go yourself, tactics, your own plan.

The Czech Republic, just right for an alcoholic,
the fact that we live here isn''t exactly great luck,
scams, bribes, that''s our government''s game,
raise all the prices fast, where the fuck are we supposed to get the money.
First in booze, first in drugs, everybody''s rolling a joint,
it''s rotten here, that''s the whole point,
I''m used to it, and I don''t care about it anymore,
be sure, man, that I''ll take care of quality rap,
rap is my life and life is short,
sometimes up, sometimes down, well, it''s a bit fickle,
this is my style, so you can be sure of that,
and I really don''t care, man, what you think of me,
I simply have my path, a chosen path,
even though it''s clear to me that many won''t get it,
I give it the way I give it, I live where I live,
I can''t do anything about it, yeah, I take it as it is.

You can''t go on, homie, without it you''re really not high,
you don''t know which way to go yourself, tactics, your own plan.
You can''t go on, homie, without it you''re really not high,
you don''t know which way to go yourself, tactics, your own plan.

Damn, dude, look how life is down below,
at least for a while put yourself in my shoes,
my balls are sweating from how hard I have to grind,
and it makes me sick to know how little I''ll get for it.
You sit on your ears in your ties, dressed up, perfumed, wallets overflowing,
it''s pushing you up the ass and it''s still not enough for you,
I''m not blind, stupid, or the youngest either,
but I have my plan that''ll save me,
our CD will be easy to get everywhere.
We''ll show you things you''ve never known till today,
I don''t care that I do things that aren''t legal,
the forbidden fruit is easy to get everywhere here,
and that''s why the cops love to race through my village,
they probably don''t find it completely normal
that I don''t pay taxes on what I do.

Plans and tactics supposedly mean nothing to me,
I''m surprised when I hear people blaming me for it,
yesterday I was doing what I''m doing today,
from morning till evening I hung around at Tesco,
I always have to booze, I don''t want to stop anyway,
I live and profit only from the city''s handouts,
many times I had to sleep on the pavement,
I''m a welfare bum, I reek of decay,
me and my gang take up our positions,
day after day we want money from everybody around,
I sit down on the ground with a hungry mutt,
you see a paw with a hat, you walk around me in a wide arc,
I''m asking for it, I''ve got a black eye,
I don''t move from the spot, I''m where I was a year ago,
I''m a lazy scumbag, that label won''t wash off,
my plan is to dig concrete with my face all my life.

You can''t go on, homie, without it you''re really not high,
you don''t know which way to go yourself, tactics, your own plan.'
WHERE s.`name` = 'JML - No ty vole ft. Farri, Skeli, Babaraptor' AND l.`lang` = 'en' AND l.`words` = 'Damn, dude, damn, dude,
so get it, I''m going a hundred percent,
year after year I fuck everything, I fuck you, I fuck everything these days,
sorry that I''m like this, arrogant, high on poppy,
they can''t understand that I fuck Czech laws.
Czech politics a.k.a. fat fanatics,
the fucked-up point of this whole world,
I don''t want to have anything to do with it anymore, I see the traffic lights blinking,
so we keep going, there''s nothing to wait for, bro.
I ride in formation like kryptonite, I explode like dynamite,
you feel like a superhero, you want to stop us, bro,
you''re our source of food, a shitty wannabe,
the hater still has no idea his career level is ending,
your spheres, your half-played sides, about the purity of race,
your routes, religious salvation,
fucked-up talk to me, I go a hundred percent to the point.

You can''t go on, homie, without it you''re really not high,
you don''t know which way to go yourself, tactics, your own plan.
(2×)

The Czech Republic, just right for an alcoholic,
the fact that we live here isn''t exactly great luck,
scams, bribes, that''s our government''s game,
raise all the prices fast, where the fuck are we supposed to get the money.
First in booze, first in drugs, everybody''s rolling a joint,
it''s rotten here, that''s the whole point,
I''m used to it, and I don''t care about it anymore,
be sure, man, that I''ll take care of quality rap,
rap is my life and life is short,
sometimes up, sometimes down, well, it''s a bit fickle,
this is my style, so you can be sure of that,
and I really don''t care, man, what you think of me,
I simply have my path, a chosen path,
even though it''s clear to me that many won''t get it,
I give it the way I give it, I live where I live,
I can''t do anything about it, yeah, I take it as it is.

You can''t go on, homie, without it you''re really not high,
you don''t know which way to go yourself, tactics, your own plan.
(2×)

Damn, dude, look how life is down below,
at least for a while put yourself in my shoes,
my balls are sweating from how hard I have to grind,
and it makes me sick to know how little I''ll get for it.
You sit on your ears in your ties, dressed up, perfumed, wallets overflowing,
it''s pushing you up the ass and it''s still not enough for you,
I''m not blind, stupid, or the youngest either,
but I have my plan that''ll save me,
our CD will be easy to get everywhere.
We''ll show you things you''ve never known till today,
I don''t care that I do things that aren''t legal,
the forbidden fruit is easy to get everywhere here,
and that''s why the cops love to race through my village,
they probably don''t find it completely normal
that I don''t pay taxes on what I do.

Plans and tactics supposedly mean nothing to me,
I''m surprised when I hear people blaming me for it,
yesterday I was doing what I''m doing today,
from morning till evening I hung around at Tesco,
I always have to booze, I don''t want to stop anyway,
I live and profit only from the city''s handouts,
many times I had to sleep on the pavement,
I''m a welfare bum, I reek of decay,
me and my gang take up our positions,
day after day we want money from everybody around,
I sit down on the ground with a hungry mutt,
you see a paw with a hat, you walk around me in a wide arc,
I''m asking for it, I''ve got a black eye,
I don''t move from the spot, I''m where I was a year ago,
I''m a lazy scumbag, that label won''t wash off,
my plan is to dig concrete with my face all my life.

You can''t go on, homie, without it you''re really not high,
you don''t know which way to go yourself, tactics, your own plan.';

-- JML - No ty vole ft. Farri, Skeli, Babaraptor (uk)
UPDATE `lyrics` l JOIN `songs` s ON s.`id` = l.`song_id`
SET l.`words` = 'Оце так, чувак, оце так, чувак,
тож зрозумій, я йду на сто відсотків,
рік за роком я їбу все, їбу тебе, їбу все в сьогоднішні часи,
вибачте, що я такий, зарозумілий, під маком,
вони не можуть зрозуміти, що я їбав чеські закони.
Чеська політика a. k. a. товсті фанатики,
заїбана суть усього цього світу,
я більше не хочу мати з цим нічого спільного, бачу, як блимають світлофори,
тому ми йдемо далі, нема чого чекати, бро.
Я їду у формації, як криптоніт, вибухаю, як динаміт,
ти почуваєшся супергероєм, хочеш нас, бро, зупинити,
ти джерело нашої їжі, засраний wannabe,
хейтер досі не підозрює, що його кар''єрний щабель закінчується,
ваші сфери, ваші розіграні сторони, про чистоту раси,
ваші маршрути, релігійне спасіння,
для мене заїбані балачки, я йду на сто відсотків до справи.

Ти не можеш іти, homie, далі, без цього ти справді не high,
ти й сам не знаєш, куди йти, тактика, власний план.
Ти не можеш іти, homie, далі, без цього ти справді не high,
ти й сам не знаєш, куди йти, тактика, власний план.

Чеська республіка якраз для алкаша,
те, що ми тут живемо, — не надто велике везіння,
махінації, хабарі, оце гра нашого уряду,
швидко все подорожчати, де, бляха, нам на це брати.
Перші в бухлі, перші в наркоті, кожен крутить джоінт,
тут усе прогнило, в цьому вся суть,
я до цього вже звик, і мені вже на це байдуже,
будь певен, друже, що про якісний реп я подбаю,
реп — це моє життя, а воно ж коротке,
то вгорі, то внизу, ну, воно трохи мінливе,
це мій стиль, тож у цьому будь певен,
і мені справді байдуже, друже, що ти про мене думаєш,
у мене просто свій шлях, шлях обраний,
хоч мені й ясно, що багато хто цього не второпає,
я даю так, як даю, живу там, де живу,
нічого з цим не вдію, так, я вже сприймаю це так.

Ти не можеш іти, homie, далі, без цього ти справді не high,
ти й сам не знаєш, куди йти, тактика, власний план.
Ти не можеш іти, homie, далі, без цього ти справді не high,
ти й сам не знаєш, куди йти, тактика, власний план.

Оце так, чувак, глянь, як живеться внизу,
хоч ненадовго увійди в мою роль,
у мене пітніють яйця від того, як мушу гарувати,
і мені погано від того, що я знаю, як мало за це отримаю.
Ви сидите на вухах у краватках, причепурені, напахчені, гаманці переповнені,
тисне вам у дупу, і вам усе мало,
я не сліпий, не дурний і не наймолодший,
але в мене є свій план, який мене врятує,
наш CD буде всюди легко дістати.
Ми покажемо тобі речі, яких ти досі не знав,
мені байдуже, що я роблю речі, які нелегальні,
заборонений плід тут усюди легко дістати,
і тому копи люблять ганяти через моє село,
мабуть, їм здається не зовсім нормальним,
що за те, що я роблю, я не плачу податків.

Плани й тактика мені нібито нічого не кажуть,
я дивуюсь, коли чую, що люди мені це закидають,
учора я робив те, що роблю сьогодні,
з ранку до вечора я тинявся біля «Теско»,
я мушу постійно бухати, все одно не хочу кидати,
живу й наживаюсь лише з подачок міста,
багато разів я мусив ночувати на тротуарі,
я соціальний злидар, від мене тхне розкладом,
я і моя банда займаємо позиції,
день у день ми хочемо грошей від усіх довкола,
я сідаю на землю з голодним псом,
ти бачиш лапу з капелюхом, обходиш мене десятою дорогою,
я сам напрошуюсь, у мене синець під оком,
я не зрушую з місця, я там, де був рік тому,
я лінивий покидьок, той ярлик не відмити,
мій план — усе життя орати бетон мордою.

Ти не можеш іти, homie, далі, без цього ти справді не high,
ти й сам не знаєш, куди йти, тактика, власний план.'
WHERE s.`name` = 'JML - No ty vole ft. Farri, Skeli, Babaraptor' AND l.`lang` = 'uk' AND l.`words` = 'Оце так, чувак, оце так, чувак,
тож зрозумій, я йду на сто відсотків,
рік за роком я їбу все, їбу тебе, їбу все в сьогоднішні часи,
вибачте, що я такий, зарозумілий, під маком,
вони не можуть зрозуміти, що я їбав чеські закони.
Чеська політика a. k. a. товсті фанатики,
заїбана суть усього цього світу,
я більше не хочу мати з цим нічого спільного, бачу, як блимають світлофори,
тому ми йдемо далі, нема чого чекати, бро.
Я їду у формації, як криптоніт, вибухаю, як динаміт,
ти почуваєшся супергероєм, хочеш нас, бро, зупинити,
ти джерело нашої їжі, засраний wannabe,
хейтер досі не підозрює, що його кар''єрний щабель закінчується,
ваші сфери, ваші розіграні сторони, про чистоту раси,
ваші маршрути, релігійне спасіння,
для мене заїбані балачки, я йду на сто відсотків до справи.

Ти не можеш іти, homie, далі, без цього ти справді не high,
ти й сам не знаєш, куди йти, тактика, власний план.
(2×)

Чеська республіка якраз для алкаша,
те, що ми тут живемо, — не надто велике везіння,
махінації, хабарі, оце гра нашого уряду,
швидко все подорожчати, де, бляха, нам на це брати.
Перші в бухлі, перші в наркоті, кожен крутить джоінт,
тут усе прогнило, в цьому вся суть,
я до цього вже звик, і мені вже на це байдуже,
будь певен, друже, що про якісний реп я подбаю,
реп — це моє життя, а воно ж коротке,
то вгорі, то внизу, ну, воно трохи мінливе,
це мій стиль, тож у цьому будь певен,
і мені справді байдуже, друже, що ти про мене думаєш,
у мене просто свій шлях, шлях обраний,
хоч мені й ясно, що багато хто цього не второпає,
я даю так, як даю, живу там, де живу,
нічого з цим не вдію, так, я вже сприймаю це так.

Ти не можеш іти, homie, далі, без цього ти справді не high,
ти й сам не знаєш, куди йти, тактика, власний план.
(2×)

Оце так, чувак, глянь, як живеться внизу,
хоч ненадовго увійди в мою роль,
у мене пітніють яйця від того, як мушу гарувати,
і мені погано від того, що я знаю, як мало за це отримаю.
Ви сидите на вухах у краватках, причепурені, напахчені, гаманці переповнені,
тисне вам у дупу, і вам усе мало,
я не сліпий, не дурний і не наймолодший,
але в мене є свій план, який мене врятує,
наш CD буде всюди легко дістати.
Ми покажемо тобі речі, яких ти досі не знав,
мені байдуже, що я роблю речі, які нелегальні,
заборонений плід тут усюди легко дістати,
і тому копи люблять ганяти через моє село,
мабуть, їм здається не зовсім нормальним,
що за те, що я роблю, я не плачу податків.

Плани й тактика мені нібито нічого не кажуть,
я дивуюсь, коли чую, що люди мені це закидають,
учора я робив те, що роблю сьогодні,
з ранку до вечора я тинявся біля «Теско»,
я мушу постійно бухати, все одно не хочу кидати,
живу й наживаюсь лише з подачок міста,
багато разів я мусив ночувати на тротуарі,
я соціальний злидар, від мене тхне розкладом,
я і моя банда займаємо позиції,
день у день ми хочемо грошей від усіх довкола,
я сідаю на землю з голодним псом,
ти бачиш лапу з капелюхом, обходиш мене десятою дорогою,
я сам напрошуюсь, у мене синець під оком,
я не зрушую з місця, я там, де був рік тому,
я лінивий покидьок, той ярлик не відмити,
мій план — усе життя орати бетон мордою.

Ти не можеш іти, homie, далі, без цього ти справді не high,
ти й сам не знаєш, куди йти, тактика, власний план.';

-- JML - No ty vole ft. Farri, Skeli, Babaraptor (vi)
UPDATE `lyrics` l JOIN `songs` s ON s.`id` = l.`song_id`
SET l.`words` = 'Trời đất ơi, trời đất ơi,
vậy thì hiểu đi, tao chơi hết một trăm phần trăm,
năm này qua năm khác tao đéo quan tâm tất cả, đéo quan tâm mày, đéo quan tâm tất cả thời buổi này,
xin lỗi vì tao như thế này, kiêu ngạo, phê thuốc phiện,
chúng nó không thể hiểu nổi rằng tao đéo quan tâm luật pháp Séc.
Chính trị Séc a. k. a. lũ cuồng tín béo phì,
cái điểm mấu chốt chết tiệt của cả thế giới này,
tao chẳng muốn dính dáng gì đến nó nữa, tao thấy đèn giao thông nhấp nháy,
vậy nên bọn tao tiếp tục, chẳng có gì phải chờ, người anh em.
Tao đi theo đội hình như kryptonite, tao nổ tung như thuốc nổ,
mày thấy mình như siêu anh hùng, mày muốn chặn bọn tao lại, người anh em,
mày là nguồn thức ăn của bọn tao, một thằng wannabe vớ vẩn,
kẻ ghét vẫn chưa biết rằng nấc thang sự nghiệp của hắn sắp kết thúc,
những lĩnh vực của tụi mày, những phe đang chơi dở của tụi mày, về sự thuần khiết chủng tộc,
những lộ trình của tụi mày, sự cứu rỗi tôn giáo,
với tao toàn là lời nhảm chết tiệt, tao đi thẳng vào vấn đề một trăm phần trăm.

Mày không thể đi tiếp đâu, homie, thiếu nó mày thật sự chẳng high,
chính mày cũng chẳng biết đi đâu, chiến thuật, kế hoạch riêng.
Mày không thể đi tiếp đâu, homie, thiếu nó mày thật sự chẳng high,
chính mày cũng chẳng biết đi đâu, chiến thuật, kế hoạch riêng.

Cộng hòa Séc, hợp ngay cho dân nghiện rượu,
việc bọn tao sống ở đây chẳng phải là may mắn gì lớn,
lừa đảo, hối lộ, đó là trò chơi của chính phủ,
tăng giá mọi thứ thật nhanh, mẹ kiếp, bọn tao lấy tiền đâu ra.
Nhất về nhậu, nhất về ma túy, ai cũng cuốn một điếu,
ở đây mục ruỗng cả rồi, đó là toàn bộ vấn đề,
tao đã quen với nó rồi, và tao chẳng thèm bận tâm nữa,
cứ yên tâm đi, anh bạn, tao sẽ lo cho rap chất lượng,
rap là cuộc đời tao, mà đời thì ngắn ngủi,
lúc lên, lúc xuống, ừ, nó hơi thất thường,
đây là phong cách của tao, nên cứ yên tâm về điều đó,
và tao thật sự chẳng quan tâm, anh bạn, mày nghĩ gì về tao,
tao đơn giản có con đường của mình, con đường được chọn,
dù tao biết rõ nhiều người sẽ không hiểu nổi,
tao chơi theo cách tao chơi, tao sống nơi tao sống,
tao chẳng làm gì được với nó, yeah, tao chấp nhận nó như thế.

Mày không thể đi tiếp đâu, homie, thiếu nó mày thật sự chẳng high,
chính mày cũng chẳng biết đi đâu, chiến thuật, kế hoạch riêng.
Mày không thể đi tiếp đâu, homie, thiếu nó mày thật sự chẳng high,
chính mày cũng chẳng biết đi đâu, chiến thuật, kế hoạch riêng.

Trời đất ơi, nhìn xem dưới đáy người ta sống thế nào,
ít nhất hãy thử đặt mình vào vai tao một lúc,
bi tao toát mồ hôi vì phải cày cuốc,
và tao phát ốm khi biết mình sẽ nhận được bao ít cho chuyện đó.
Tụi mày ngồi trên tai mình trong cà vạt, chải chuốt, thơm tho, ví căng phồng,
nó đè vào đít tụi mày mà tụi mày vẫn chưa thấy đủ,
tao không mù, không ngu, cũng chẳng phải trẻ nhất,
nhưng tao có kế hoạch của mình, nó sẽ cứu tao,
CD của bọn tao sẽ dễ kiếm ở khắp nơi.
Bọn tao sẽ cho mày thấy những thứ đến giờ mày chưa từng biết,
tao chẳng bận tâm việc tao làm những thứ không hợp pháp,
trái cấm ở đây đâu cũng dễ kiếm,
và vì thế lũ cớm thích phóng qua làng tao,
chắc chúng thấy không bình thường lắm
khi tao chẳng nộp thuế cho những gì tao làm.

Kế hoạch và chiến thuật nghe nói chẳng có nghĩa gì với tao,
tao ngạc nhiên khi nghe người ta trách tao vì điều đó,
hôm qua tao làm đúng những gì hôm nay tao làm,
từ sáng đến tối tao lảng vảng ở Tesco,
tao lúc nào cũng phải nhậu, dù sao tao cũng chẳng muốn dừng,
tao sống và kiếm lời chỉ từ đồ bố thí của thành phố,
nhiều lần tao phải ngủ trên vỉa hè,
tao là đồ ăn bám trợ cấp, người tao bốc mùi mục rữa,
tao và băng của tao chiếm lấy vị trí,
ngày qua ngày bọn tao đòi tiền của mọi người xung quanh,
tao ngồi xuống đất với một con chó đói,
mày thấy một cái chân với chiếc mũ, mày đi vòng thật xa tránh tao,
tao tự chuốc lấy, tao bị bầm một bên mắt,
tao chẳng nhúc nhích khỏi chỗ, tao vẫn ở đúng nơi tao ở năm ngoái,
tao là đồ cặn bã lười biếng, cái nhãn đó không rửa sạch được,
kế hoạch của tao là cả đời cày bê tông bằng mặt.

Mày không thể đi tiếp đâu, homie, thiếu nó mày thật sự chẳng high,
chính mày cũng chẳng biết đi đâu, chiến thuật, kế hoạch riêng.'
WHERE s.`name` = 'JML - No ty vole ft. Farri, Skeli, Babaraptor' AND l.`lang` = 'vi' AND l.`words` = 'Trời đất ơi, trời đất ơi,
vậy thì hiểu đi, tao chơi hết một trăm phần trăm,
năm này qua năm khác tao đéo quan tâm tất cả, đéo quan tâm mày, đéo quan tâm tất cả thời buổi này,
xin lỗi vì tao như thế này, kiêu ngạo, phê thuốc phiện,
chúng nó không thể hiểu nổi rằng tao đéo quan tâm luật pháp Séc.
Chính trị Séc a. k. a. lũ cuồng tín béo phì,
cái điểm mấu chốt chết tiệt của cả thế giới này,
tao chẳng muốn dính dáng gì đến nó nữa, tao thấy đèn giao thông nhấp nháy,
vậy nên bọn tao tiếp tục, chẳng có gì phải chờ, người anh em.
Tao đi theo đội hình như kryptonite, tao nổ tung như thuốc nổ,
mày thấy mình như siêu anh hùng, mày muốn chặn bọn tao lại, người anh em,
mày là nguồn thức ăn của bọn tao, một thằng wannabe vớ vẩn,
kẻ ghét vẫn chưa biết rằng nấc thang sự nghiệp của hắn sắp kết thúc,
những lĩnh vực của tụi mày, những phe đang chơi dở của tụi mày, về sự thuần khiết chủng tộc,
những lộ trình của tụi mày, sự cứu rỗi tôn giáo,
với tao toàn là lời nhảm chết tiệt, tao đi thẳng vào vấn đề một trăm phần trăm.

Mày không thể đi tiếp đâu, homie, thiếu nó mày thật sự chẳng high,
chính mày cũng chẳng biết đi đâu, chiến thuật, kế hoạch riêng.
(2×)

Cộng hòa Séc, hợp ngay cho dân nghiện rượu,
việc bọn tao sống ở đây chẳng phải là may mắn gì lớn,
lừa đảo, hối lộ, đó là trò chơi của chính phủ,
tăng giá mọi thứ thật nhanh, mẹ kiếp, bọn tao lấy tiền đâu ra.
Nhất về nhậu, nhất về ma túy, ai cũng cuốn một điếu,
ở đây mục ruỗng cả rồi, đó là toàn bộ vấn đề,
tao đã quen với nó rồi, và tao chẳng thèm bận tâm nữa,
cứ yên tâm đi, anh bạn, tao sẽ lo cho rap chất lượng,
rap là cuộc đời tao, mà đời thì ngắn ngủi,
lúc lên, lúc xuống, ừ, nó hơi thất thường,
đây là phong cách của tao, nên cứ yên tâm về điều đó,
và tao thật sự chẳng quan tâm, anh bạn, mày nghĩ gì về tao,
tao đơn giản có con đường của mình, con đường được chọn,
dù tao biết rõ nhiều người sẽ không hiểu nổi,
tao chơi theo cách tao chơi, tao sống nơi tao sống,
tao chẳng làm gì được với nó, yeah, tao chấp nhận nó như thế.

Mày không thể đi tiếp đâu, homie, thiếu nó mày thật sự chẳng high,
chính mày cũng chẳng biết đi đâu, chiến thuật, kế hoạch riêng.
(2×)

Trời đất ơi, nhìn xem dưới đáy người ta sống thế nào,
ít nhất hãy thử đặt mình vào vai tao một lúc,
bi tao toát mồ hôi vì phải cày cuốc,
và tao phát ốm khi biết mình sẽ nhận được bao ít cho chuyện đó.
Tụi mày ngồi trên tai mình trong cà vạt, chải chuốt, thơm tho, ví căng phồng,
nó đè vào đít tụi mày mà tụi mày vẫn chưa thấy đủ,
tao không mù, không ngu, cũng chẳng phải trẻ nhất,
nhưng tao có kế hoạch của mình, nó sẽ cứu tao,
CD của bọn tao sẽ dễ kiếm ở khắp nơi.
Bọn tao sẽ cho mày thấy những thứ đến giờ mày chưa từng biết,
tao chẳng bận tâm việc tao làm những thứ không hợp pháp,
trái cấm ở đây đâu cũng dễ kiếm,
và vì thế lũ cớm thích phóng qua làng tao,
chắc chúng thấy không bình thường lắm
khi tao chẳng nộp thuế cho những gì tao làm.

Kế hoạch và chiến thuật nghe nói chẳng có nghĩa gì với tao,
tao ngạc nhiên khi nghe người ta trách tao vì điều đó,
hôm qua tao làm đúng những gì hôm nay tao làm,
từ sáng đến tối tao lảng vảng ở Tesco,
tao lúc nào cũng phải nhậu, dù sao tao cũng chẳng muốn dừng,
tao sống và kiếm lời chỉ từ đồ bố thí của thành phố,
nhiều lần tao phải ngủ trên vỉa hè,
tao là đồ ăn bám trợ cấp, người tao bốc mùi mục rữa,
tao và băng của tao chiếm lấy vị trí,
ngày qua ngày bọn tao đòi tiền của mọi người xung quanh,
tao ngồi xuống đất với một con chó đói,
mày thấy một cái chân với chiếc mũ, mày đi vòng thật xa tránh tao,
tao tự chuốc lấy, tao bị bầm một bên mắt,
tao chẳng nhúc nhích khỏi chỗ, tao vẫn ở đúng nơi tao ở năm ngoái,
tao là đồ cặn bã lười biếng, cái nhãn đó không rửa sạch được,
kế hoạch của tao là cả đời cày bê tông bằng mặt.

Mày không thể đi tiếp đâu, homie, thiếu nó mày thật sự chẳng high,
chính mày cũng chẳng biết đi đâu, chiến thuật, kế hoạch riêng.';

-- Skeli a Babar - Divná planeta (cs)
UPDATE `lyrics` l JOIN `songs` s ON s.`id` = l.`song_id`
SET l.`words` = 'Zhostí se tě divnej pocit, když otevřeš svoje oči,
máme v tom prsty, nesnažte se viny zprostit,
chovejme se tak, jak maj se chovat hosti,
pozdě budem prosit, až tu zbudou trosky.
Zhostí se tě divnej pocit, když otevřeš svoje oči,
máme v tom prsty, nesnažte se viny zprostit,
chovejme se tak, jak maj se chovat hosti,
pozdě budem prosit, až tu zbudou trosky.

Šinu si to sám cestou temnou a dlouhou,
kráčím s hlavou sklopenou, zkalenou, zmatenou,
plnou myšlenek, který tak neodejdou,
jen lidi odcházejí, krásný vzpomínky si berou s sebou,
přitom si vemou cenu pro mě nesnesitelnou,
je to fake jak kérka hennou,
chvilku jsou a pak se smejou,
holt na divný planetě se divný věci dějou.
Mířím do nečasu, kde všichni hledí na krásu,
holky měří vztah podle délky ocasů,
kam poděl se elán, dřív ho měl každej pán,
gentleman na každém rohu dveře dámám otvíral, a dnes,
kam se kouknu, někdo někoho unes,
je to děs, běs, všude vykácenej les,
na naší planetě může jenom průmysl kvést,
a ta planeta je jako klec, ze který nemůžeš utéct,
války, rasismus, drogy, vrazi,
mnoho pastí, co lidi na kolena srazí,
odražená kulka, co zabila malýho kluka,
pro rodinu jsou to nepředstavitelný muka,
za volantem alkohol, v ulicích fet,
vedle silnice bordel, kam to spěje tenhle svět,
nad tím, co se děje, mi začíná rozum stát,
páč stojím s váma na lodi, co brzo ztroskotá.

A co to je? A kde to jsem?
Je to skutečnost, nebo jenom blbej sen?
Jsem snad kretén, nebo máš taky ten dojem,
že žene se před nosem do záhuby naše zem?

Krok za krokem procházíš životem,
rveš se o svý místo pod sluncem,
nechceš bejt otrokem, strachuješ se o budoucnost,
ale nemáš moc vědět, co stane se za rohem,
podívej se, tvoje plány můžou rychle zdechnout,
ve chvíli je všechno jinak, nestihneš se ani hnout,
tahle divná planeta s osudama zametá,
smrt jako zmrd přijde, podřízne ti krk.
Lidstvo se nepoučí, nevraživost vládne světu,
malý děti tisknou prsty na spoušť kulometu,
celou věčnost vidíme to tu,
zavíráme oči, prosedíme celý hodiny na netu,
pracujeme, přispíváme k rozkvětu,
skurveně zabíjíme většinu času,
vyhlížíš to datum, kdy zabereš výplatu,
divíš se, robote, že nenacpal sis kapsu.
Lidi spěchaj neustále, i když neví kam,
život pomalu a jistě ztrácí svůj význam,
život a kvalita měří se dnes v penězích,
že pravda s láskou zvítězí, nikdo už nevěří,
není místo na pocity, budujeme kariéry,
devastujeme krajinu, pokládáme bariéry,
bezohledně vypouštíme sračky do atmosféry,
copak asi budou dejchat naši synové a dcery.
Nesnažím se hrát si na Armádu spásy,
sere mě jen, jak si člověk větev pod prdelí kácí,
fakta a problém ignorovat se nevyplácí,
nepomohou ani svatí, všechno se nám vrátí.'
WHERE s.`name` = 'Skeli a Babar - Divná planeta' AND l.`lang` = 'cs' AND l.`words` = 'Zhostí se tě divnej pocit, když otevřeš svoje oči,
máme v tom prsty, nesnažte se viny zprostit,
chovejme se tak, jak maj se chovat hosti,
pozdě budem prosit, až tu zbudou trosky.
(2×)

Šinu si to sám cestou temnou a dlouhou,
kráčím s hlavou sklopenou, zkalenou, zmatenou,
plnou myšlenek, který tak neodejdou,
jen lidi odcházejí, krásný vzpomínky si berou s sebou,
přitom si vemou cenu pro mě nesnesitelnou,
je to fake jak kérka hennou,
chvilku jsou a pak se smejou,
holt na divný planetě se divný věci dějou.
Mířím do nečasu, kde všichni hledí na krásu,
holky měří vztah podle délky ocasů,
kam poděl se elán, dřív ho měl každej pán,
gentleman na každém rohu dveře dámám otvíral, a dnes,
kam se kouknu, někdo někoho unes,
je to děs, běs, všude vykácenej les,
na naší planetě může jenom průmysl kvést,
a ta planeta je jako klec, ze který nemůžeš utéct,
války, rasismus, drogy, vrazi,
mnoho pastí, co lidi na kolena srazí,
odražená kulka, co zabila malýho kluka,
pro rodinu jsou to nepředstavitelný muka,
za volantem alkohol, v ulicích fet,
vedle silnice bordel, kam to spěje tenhle svět,
nad tím, co se děje, mi začíná rozum stát,
páč stojím s váma na lodi, co brzo ztroskotá.

A co to je? A kde to jsem?
Je to skutečnost, nebo jenom blbej sen?
Jsem snad kretén, nebo máš taky ten dojem,
že žene se před nosem do záhuby naše zem?

Krok za krokem procházíš životem,
rveš se o svý místo pod sluncem,
nechceš bejt otrokem, strachuješ se o budoucnost,
ale nemáš moc vědět, co stane se za rohem,
podívej se, tvoje plány můžou rychle zdechnout,
ve chvíli je všechno jinak, nestihneš se ani hnout,
tahle divná planeta s osudama zametá,
smrt jako zmrd přijde, podřízne ti krk.
Lidstvo se nepoučí, nevraživost vládne světu,
malý děti tisknou prsty na spoušť kulometu,
celou věčnost vidíme to tu,
zavíráme oči, prosedíme celý hodiny na netu,
pracujeme, přispíváme k rozkvětu,
skurveně zabíjíme většinu času,
vyhlížíš to datum, kdy zabereš výplatu,
divíš se, robote, že nenacpal sis kapsu.
Lidi spěchaj neustále, i když neví kam,
život pomalu a jistě ztrácí svůj význam,
život a kvalita měří se dnes v penězích,
že pravda s láskou zvítězí, nikdo už nevěří,
není místo na pocity, budujeme kariéry,
devastujeme krajinu, pokládáme bariéry,
bezohledně vypouštíme sračky do atmosféry,
copak asi budou dejchat naši synové a dcery.
Nesnažím se hrát si na Armádu spásy,
sere mě jen, jak si člověk větev pod prdelí kácí,
fakta a problém ignorovat se nevyplácí,
nepomohou ani svatí, všechno se nám vrátí.';

-- Skeli a Babar - Divná planeta (de)
UPDATE `lyrics` l JOIN `songs` s ON s.`id` = l.`song_id`
SET l.`words` = 'Ein seltsames Gefühl überkommt dich, wenn du die Augen öffnest,
wir haben unsere Finger im Spiel, versucht nicht, euch von Schuld freizusprechen,
lasst uns benehmen, wie sich Gäste benehmen sollen,
zu spät werden wir betteln, wenn hier nur Trümmer bleiben.
Ein seltsames Gefühl überkommt dich, wenn du die Augen öffnest,
wir haben unsere Finger im Spiel, versucht nicht, euch von Schuld freizusprechen,
lasst uns benehmen, wie sich Gäste benehmen sollen,
zu spät werden wir betteln, wenn hier nur Trümmer bleiben.

Ich schlurfe allein einen dunklen und langen Weg entlang,
ich gehe mit gesenktem Kopf, getrübt, verwirrt,
voller Gedanken, die einfach nicht weggehen,
nur Menschen gehen, schöne Erinnerungen nehmen sie mit,
und dabei nehmen sie einen Preis mit, der für mich unerträglich ist,
es ist fake wie ein Henna-Tattoo,
eine Weile sind sie da und dann lachen sie,
tja, auf einem seltsamen Planeten passieren seltsame Dinge.
Ich steuere ins Unwetter, wo alle auf Schönheit schauen,
Mädchen messen eine Beziehung an der Länge der Schwänze,
wo ist der Elan geblieben, früher hatte ihn jeder Herr,
ein Gentleman an jeder Ecke öffnete den Damen die Tür, und heute,
wo ich auch hinschaue, hat jemand jemanden entführt,
es ist Grauen, Wahnsinn, überall abgeholzter Wald,
auf unserem Planeten kann nur die Industrie blühen,
und dieser Planet ist wie ein Käfig, aus dem du nicht fliehen kannst,
Kriege, Rassismus, Drogen, Mörder,
so viele Fallen, die Menschen in die Knie zwingen,
eine abgeprallte Kugel, die einen kleinen Jungen tötete,
für die Familie ist das eine unvorstellbare Qual,
Alkohol am Steuer, Drogen auf den Straßen,
neben der Straße Dreck, wohin steuert diese Welt,
bei dem, was passiert, bleibt mir langsam der Verstand stehen,
denn ich stehe mit euch auf einem Schiff, das bald untergeht.

Und was ist das? Und wo bin ich?
Ist das die Wirklichkeit oder nur ein blöder Traum?
Bin ich etwa ein Idiot, oder hast du auch das Gefühl,
dass unsere Erde direkt vor unserer Nase ins Verderben rast?

Schritt für Schritt gehst du durchs Leben,
du kämpfst um deinen Platz an der Sonne,
du willst kein Sklave sein, du sorgst dich um die Zukunft,
aber du kannst kaum wissen, was hinter der Ecke passiert,
schau, deine Pläne können schnell verrecken,
in einem Moment ist alles anders, du schaffst es nicht mal, dich zu bewegen,
dieser seltsame Planet fegt mit den Schicksalen herum,
der Tod kommt wie ein Arschloch und schneidet dir die Kehle durch.
Die Menschheit lernt nicht dazu, Feindseligkeit regiert die Welt,
kleine Kinder drücken die Finger auf den Abzug eines Maschinengewehrs,
eine Ewigkeit sehen wir das hier schon,
wir schließen die Augen, wir sitzen ganze Stunden im Netz ab,
wir arbeiten, wir tragen zum Aufschwung bei,
wir töten verdammt nochmal den Großteil unserer Zeit,
du wartest auf das Datum, an dem du deinen Lohn kassierst,
du wunderst dich, Roboter, dass du dir nicht die Taschen gefüllt hast.
Die Leute hetzen ständig, obwohl sie nicht wissen, wohin,
das Leben verliert langsam, aber sicher seinen Sinn,
Leben und Qualität werden heute in Geld gemessen,
dass Wahrheit und Liebe siegen werden, glaubt niemand mehr,
es gibt keinen Platz für Gefühle, wir bauen Karrieren,
wir verwüsten die Landschaft, wir errichten Barrieren,
rücksichtslos blasen wir Scheiße in die Atmosphäre,
was werden wohl unsere Söhne und Töchter atmen.
Ich versuche nicht, die Heilsarmee zu spielen,
mich kotzt nur an, wie der Mensch den Ast absägt, auf dem er sitzt,
Fakten und das Problem zu ignorieren, zahlt sich nicht aus,
nicht einmal die Heiligen helfen, alles kommt zu uns zurück.'
WHERE s.`name` = 'Skeli a Babar - Divná planeta' AND l.`lang` = 'de' AND l.`words` = 'Ein seltsames Gefühl überkommt dich, wenn du die Augen öffnest,
wir haben unsere Finger im Spiel, versucht nicht, euch von Schuld freizusprechen,
lasst uns benehmen, wie sich Gäste benehmen sollen,
zu spät werden wir betteln, wenn hier nur Trümmer bleiben.
(2×)

Ich schlurfe allein einen dunklen und langen Weg entlang,
ich gehe mit gesenktem Kopf, getrübt, verwirrt,
voller Gedanken, die einfach nicht weggehen,
nur Menschen gehen, schöne Erinnerungen nehmen sie mit,
und dabei nehmen sie einen Preis mit, der für mich unerträglich ist,
es ist fake wie ein Henna-Tattoo,
eine Weile sind sie da und dann lachen sie,
tja, auf einem seltsamen Planeten passieren seltsame Dinge.
Ich steuere ins Unwetter, wo alle auf Schönheit schauen,
Mädchen messen eine Beziehung an der Länge der Schwänze,
wo ist der Elan geblieben, früher hatte ihn jeder Herr,
ein Gentleman an jeder Ecke öffnete den Damen die Tür, und heute,
wo ich auch hinschaue, hat jemand jemanden entführt,
es ist Grauen, Wahnsinn, überall abgeholzter Wald,
auf unserem Planeten kann nur die Industrie blühen,
und dieser Planet ist wie ein Käfig, aus dem du nicht fliehen kannst,
Kriege, Rassismus, Drogen, Mörder,
so viele Fallen, die Menschen in die Knie zwingen,
eine abgeprallte Kugel, die einen kleinen Jungen tötete,
für die Familie ist das eine unvorstellbare Qual,
Alkohol am Steuer, Drogen auf den Straßen,
neben der Straße Dreck, wohin steuert diese Welt,
bei dem, was passiert, bleibt mir langsam der Verstand stehen,
denn ich stehe mit euch auf einem Schiff, das bald untergeht.

Und was ist das? Und wo bin ich?
Ist das die Wirklichkeit oder nur ein blöder Traum?
Bin ich etwa ein Idiot, oder hast du auch das Gefühl,
dass unsere Erde direkt vor unserer Nase ins Verderben rast?

Schritt für Schritt gehst du durchs Leben,
du kämpfst um deinen Platz an der Sonne,
du willst kein Sklave sein, du sorgst dich um die Zukunft,
aber du kannst kaum wissen, was hinter der Ecke passiert,
schau, deine Pläne können schnell verrecken,
in einem Moment ist alles anders, du schaffst es nicht mal, dich zu bewegen,
dieser seltsame Planet fegt mit den Schicksalen herum,
der Tod kommt wie ein Arschloch und schneidet dir die Kehle durch.
Die Menschheit lernt nicht dazu, Feindseligkeit regiert die Welt,
kleine Kinder drücken die Finger auf den Abzug eines Maschinengewehrs,
eine Ewigkeit sehen wir das hier schon,
wir schließen die Augen, wir sitzen ganze Stunden im Netz ab,
wir arbeiten, wir tragen zum Aufschwung bei,
wir töten verdammt nochmal den Großteil unserer Zeit,
du wartest auf das Datum, an dem du deinen Lohn kassierst,
du wunderst dich, Roboter, dass du dir nicht die Taschen gefüllt hast.
Die Leute hetzen ständig, obwohl sie nicht wissen, wohin,
das Leben verliert langsam, aber sicher seinen Sinn,
Leben und Qualität werden heute in Geld gemessen,
dass Wahrheit und Liebe siegen werden, glaubt niemand mehr,
es gibt keinen Platz für Gefühle, wir bauen Karrieren,
wir verwüsten die Landschaft, wir errichten Barrieren,
rücksichtslos blasen wir Scheiße in die Atmosphäre,
was werden wohl unsere Söhne und Töchter atmen.
Ich versuche nicht, die Heilsarmee zu spielen,
mich kotzt nur an, wie der Mensch den Ast absägt, auf dem er sitzt,
Fakten und das Problem zu ignorieren, zahlt sich nicht aus,
nicht einmal die Heiligen helfen, alles kommt zu uns zurück.';

-- Skeli a Babar - Divná planeta (en)
UPDATE `lyrics` l JOIN `songs` s ON s.`id` = l.`song_id`
SET l.`words` = 'A strange feeling takes over you when you open your eyes,
we''ve got our fingers in it, don''t try to clear yourselves of guilt,
let''s behave the way guests should behave,
we''ll beg too late, when only ruins are left here.
A strange feeling takes over you when you open your eyes,
we''ve got our fingers in it, don''t try to clear yourselves of guilt,
let''s behave the way guests should behave,
we''ll beg too late, when only ruins are left here.

I''m shuffling along alone down a dark and long road,
walking with my head bowed, clouded, confused,
full of thoughts that just won''t go away,
only people leave, they take beautiful memories with them,
and they take a price with them that''s unbearable for me,
it''s fake like a henna tattoo,
they''re here for a while and then they laugh,
well, on a strange planet strange things happen.
I''m heading into bad weather, where everyone looks at beauty,
girls measure a relationship by the length of the dicks,
where did the drive go, every gentleman used to have it,
a gentleman on every corner opened doors for ladies, and today,
wherever I look, someone kidnapped someone,
it''s horror, madness, forests cut down everywhere,
on our planet only industry can bloom,
and this planet is like a cage you can''t escape from,
wars, racism, drugs, murderers,
so many traps that knock people to their knees,
a ricocheting bullet that killed a little boy,
for the family it''s unimaginable torment,
alcohol behind the wheel, drugs in the streets,
a mess next to the road, where is this world heading,
my mind is starting to stop at what''s going on,
''cause I''m standing with you on a ship that''ll soon be wrecked.

And what is this? And where am I?
Is this reality, or just a stupid dream?
Am I some kind of idiot, or do you have that feeling too,
that our land is rushing to its doom right under our noses?

Step by step you walk through life,
you fight for your place under the sun,
you don''t want to be a slave, you worry about the future,
but you can hardly know what will happen around the corner,
look, your plans can die quickly,
in a moment everything''s different, you won''t even have time to move,
this strange planet sweeps destinies around,
death comes like a bastard and slits your throat.
Mankind doesn''t learn, hostility rules the world,
little kids press their fingers on the trigger of a machine gun,
we''ve been seeing it here for an eternity,
we close our eyes, we sit whole hours away on the net,
we work, we contribute to the boom,
we fucking kill most of our time,
you look forward to the date when you collect your paycheck,
you''re surprised, robot, that you didn''t fill your pockets.
People are always in a hurry, even though they don''t know where,
life is slowly but surely losing its meaning,
life and quality are measured in money today,
nobody believes anymore that truth and love will win,
there''s no room for feelings, we''re building careers,
we devastate the land, we put up barriers,
we recklessly pump shit into the atmosphere,
what will our sons and daughters breathe, I wonder.
I''m not trying to play the Salvation Army,
it just pisses me off how people saw off the branch they''re sitting on,
ignoring the facts and the problem doesn''t pay off,
not even the saints will help, everything will come back to us.'
WHERE s.`name` = 'Skeli a Babar - Divná planeta' AND l.`lang` = 'en' AND l.`words` = 'A strange feeling takes over you when you open your eyes,
we''ve got our fingers in it, don''t try to clear yourselves of guilt,
let''s behave the way guests should behave,
we''ll beg too late, when only ruins are left here.
(2×)

I''m shuffling along alone down a dark and long road,
walking with my head bowed, clouded, confused,
full of thoughts that just won''t go away,
only people leave, they take beautiful memories with them,
and they take a price with them that''s unbearable for me,
it''s fake like a henna tattoo,
they''re here for a while and then they laugh,
well, on a strange planet strange things happen.
I''m heading into bad weather, where everyone looks at beauty,
girls measure a relationship by the length of the dicks,
where did the drive go, every gentleman used to have it,
a gentleman on every corner opened doors for ladies, and today,
wherever I look, someone kidnapped someone,
it''s horror, madness, forests cut down everywhere,
on our planet only industry can bloom,
and this planet is like a cage you can''t escape from,
wars, racism, drugs, murderers,
so many traps that knock people to their knees,
a ricocheting bullet that killed a little boy,
for the family it''s unimaginable torment,
alcohol behind the wheel, drugs in the streets,
a mess next to the road, where is this world heading,
my mind is starting to stop at what''s going on,
''cause I''m standing with you on a ship that''ll soon be wrecked.

And what is this? And where am I?
Is this reality, or just a stupid dream?
Am I some kind of idiot, or do you have that feeling too,
that our land is rushing to its doom right under our noses?

Step by step you walk through life,
you fight for your place under the sun,
you don''t want to be a slave, you worry about the future,
but you can hardly know what will happen around the corner,
look, your plans can die quickly,
in a moment everything''s different, you won''t even have time to move,
this strange planet sweeps destinies around,
death comes like a bastard and slits your throat.
Mankind doesn''t learn, hostility rules the world,
little kids press their fingers on the trigger of a machine gun,
we''ve been seeing it here for an eternity,
we close our eyes, we sit whole hours away on the net,
we work, we contribute to the boom,
we fucking kill most of our time,
you look forward to the date when you collect your paycheck,
you''re surprised, robot, that you didn''t fill your pockets.
People are always in a hurry, even though they don''t know where,
life is slowly but surely losing its meaning,
life and quality are measured in money today,
nobody believes anymore that truth and love will win,
there''s no room for feelings, we''re building careers,
we devastate the land, we put up barriers,
we recklessly pump shit into the atmosphere,
what will our sons and daughters breathe, I wonder.
I''m not trying to play the Salvation Army,
it just pisses me off how people saw off the branch they''re sitting on,
ignoring the facts and the problem doesn''t pay off,
not even the saints will help, everything will come back to us.';

-- Skeli a Babar - Divná planeta (uk)
UPDATE `lyrics` l JOIN `songs` s ON s.`id` = l.`song_id`
SET l.`words` = 'Тебе охоплює дивне відчуття, коли ти розплющуєш очі,
ми до цього доклали руку, не намагайтеся зняти з себе провину,
поводьмося так, як мають поводитися гості,
пізно будемо благати, коли тут лишаться руїни.
Тебе охоплює дивне відчуття, коли ти розплющуєш очі,
ми до цього доклали руку, не намагайтеся зняти з себе провину,
поводьмося так, як мають поводитися гості,
пізно будемо благати, коли тут лишаться руїни.

Я плентаюся сам дорогою темною і довгою,
іду з похиленою головою, затьмареною, розгубленою,
повною думок, які так і не підуть,
лише люди йдуть, гарні спогади забирають із собою,
і при цьому забирають ціну, для мене нестерпну,
це фейк, як тату хною,
недовго вони є, а потім сміються,
що ж, на дивній планеті відбуваються дивні речі.
Я прямую в негоду, де всі дивляться на красу,
дівчата міряють стосунки довжиною членів,
куди подівся запал, раніше він був у кожного пана,
джентльмен на кожному розі відчиняв дамам двері, а сьогодні,
куди не глянь, хтось когось викрав,
це жах, нестяма, всюди вирубаний ліс,
на нашій планеті може процвітати лише промисловість,
і ця планета як клітка, з якої не втечеш,
війни, расизм, наркотики, вбивці,
так багато пасток, що збивають людей на коліна,
рикошетна куля, що вбила маленького хлопчика,
для родини це немислимі муки,
за кермом алкоголь, на вулицях наркота,
біля дороги безлад, куди котиться цей світ,
від того, що відбувається, у мене починає ставати розум,
бо я стою з вами на кораблі, що скоро зазнає краху.

І що це таке? І де я?
Це реальність чи лише дурний сон?
Може, я кретин, чи в тебе теж таке враження,
що наша земля мчить до загибелі просто перед носом?

Крок за кроком ти йдеш крізь життя,
ти б''єшся за своє місце під сонцем,
ти не хочеш бути рабом, ти боїшся за майбутнє,
але навряд чи можеш знати, що станеться за рогом,
поглянь, твої плани можуть швидко здохнути,
за мить усе інакше, ти навіть не встигнеш поворухнутися,
ця дивна планета замітає долі,
смерть прийде, як покидьок, і переріже тобі горло.
Людство не вчиться, ворожнеча править світом,
маленькі діти тиснуть пальцями на гачок кулемета,
цілу вічність ми бачимо це тут,
ми заплющуємо очі, просиджуємо цілі години в мережі,
ми працюємо, ми сприяємо розквіту,
ми, бляха, вбиваємо більшу частину часу,
ти чекаєш на ту дату, коли отримаєш зарплату,
ти дивуєшся, роботе, що не набив собі кишені.
Люди постійно поспішають, хоч і не знають куди,
життя повільно, але впевнено втрачає свій сенс,
життя та якість сьогодні міряються грошима,
що правда з любов''ю переможуть, уже ніхто не вірить,
немає місця для почуттів, ми будуємо кар''єри,
ми спустошуємо краєвид, ми ставимо бар''єри,
ми безоглядно викидаємо лайно в атмосферу,
чим же дихатимуть наші сини й доньки.
Я не намагаюся грати в Армію спасіння,
мене просто бісить, як людина рубає гілку, на якій сидить,
ігнорувати факти й проблему не вигідно,
не допоможуть навіть святі, все до нас повернеться.'
WHERE s.`name` = 'Skeli a Babar - Divná planeta' AND l.`lang` = 'uk' AND l.`words` = 'Тебе охоплює дивне відчуття, коли ти розплющуєш очі,
ми до цього доклали руку, не намагайтеся зняти з себе провину,
поводьмося так, як мають поводитися гості,
пізно будемо благати, коли тут лишаться руїни.
(2×)

Я плентаюся сам дорогою темною і довгою,
іду з похиленою головою, затьмареною, розгубленою,
повною думок, які так і не підуть,
лише люди йдуть, гарні спогади забирають із собою,
і при цьому забирають ціну, для мене нестерпну,
це фейк, як тату хною,
недовго вони є, а потім сміються,
що ж, на дивній планеті відбуваються дивні речі.
Я прямую в негоду, де всі дивляться на красу,
дівчата міряють стосунки довжиною членів,
куди подівся запал, раніше він був у кожного пана,
джентльмен на кожному розі відчиняв дамам двері, а сьогодні,
куди не глянь, хтось когось викрав,
це жах, нестяма, всюди вирубаний ліс,
на нашій планеті може процвітати лише промисловість,
і ця планета як клітка, з якої не втечеш,
війни, расизм, наркотики, вбивці,
так багато пасток, що збивають людей на коліна,
рикошетна куля, що вбила маленького хлопчика,
для родини це немислимі муки,
за кермом алкоголь, на вулицях наркота,
біля дороги безлад, куди котиться цей світ,
від того, що відбувається, у мене починає ставати розум,
бо я стою з вами на кораблі, що скоро зазнає краху.

І що це таке? І де я?
Це реальність чи лише дурний сон?
Може, я кретин, чи в тебе теж таке враження,
що наша земля мчить до загибелі просто перед носом?

Крок за кроком ти йдеш крізь життя,
ти б''єшся за своє місце під сонцем,
ти не хочеш бути рабом, ти боїшся за майбутнє,
але навряд чи можеш знати, що станеться за рогом,
поглянь, твої плани можуть швидко здохнути,
за мить усе інакше, ти навіть не встигнеш поворухнутися,
ця дивна планета замітає долі,
смерть прийде, як покидьок, і переріже тобі горло.
Людство не вчиться, ворожнеча править світом,
маленькі діти тиснуть пальцями на гачок кулемета,
цілу вічність ми бачимо це тут,
ми заплющуємо очі, просиджуємо цілі години в мережі,
ми працюємо, ми сприяємо розквіту,
ми, бляха, вбиваємо більшу частину часу,
ти чекаєш на ту дату, коли отримаєш зарплату,
ти дивуєшся, роботе, що не набив собі кишені.
Люди постійно поспішають, хоч і не знають куди,
життя повільно, але впевнено втрачає свій сенс,
життя та якість сьогодні міряються грошима,
що правда з любов''ю переможуть, уже ніхто не вірить,
немає місця для почуттів, ми будуємо кар''єри,
ми спустошуємо краєвид, ми ставимо бар''єри,
ми безоглядно викидаємо лайно в атмосферу,
чим же дихатимуть наші сини й доньки.
Я не намагаюся грати в Армію спасіння,
мене просто бісить, як людина рубає гілку, на якій сидить,
ігнорувати факти й проблему не вигідно,
не допоможуть навіть святі, все до нас повернеться.';

-- Skeli a Babar - Divná planeta (vi)
UPDATE `lyrics` l JOIN `songs` s ON s.`id` = l.`song_id`
SET l.`words` = 'Một cảm giác kỳ lạ xâm chiếm bạn khi bạn mở mắt,
chúng ta đều nhúng tay vào, đừng cố chối bỏ tội lỗi,
hãy cư xử như những vị khách nên cư xử,
ta sẽ van xin quá muộn, khi nơi đây chỉ còn đống đổ nát.
Một cảm giác kỳ lạ xâm chiếm bạn khi bạn mở mắt,
chúng ta đều nhúng tay vào, đừng cố chối bỏ tội lỗi,
hãy cư xử như những vị khách nên cư xử,
ta sẽ van xin quá muộn, khi nơi đây chỉ còn đống đổ nát.

Tôi lê bước một mình trên con đường tối tăm và dài dằng dặc,
tôi bước đi với cái đầu cúi gằm, u ám, rối bời,
đầy những suy nghĩ cứ mãi không chịu rời đi,
chỉ có con người rời đi, họ mang theo những ký ức đẹp,
và cùng lúc đó họ mang theo một cái giá mà tôi không chịu nổi,
nó giả tạo như hình xăm bằng henna,
họ ở đây một lúc rồi họ cười,
thôi thì, trên hành tinh kỳ lạ, những điều kỳ lạ xảy ra.
Tôi hướng vào thời tiết xấu, nơi ai cũng chỉ nhìn vào vẻ đẹp,
các cô gái đo một mối quan hệ bằng độ dài của dương vật,
nhiệt huyết đã đi đâu mất, ngày xưa quý ông nào cũng có,
ở mỗi góc phố quý ông mở cửa cho các quý bà, còn hôm nay,
nhìn đâu cũng thấy có kẻ bắt cóc ai đó,
thật kinh hoàng, điên loạn, khắp nơi rừng bị chặt trụi,
trên hành tinh của chúng ta chỉ có công nghiệp được nở hoa,
và hành tinh này như một cái lồng mà bạn không thể thoát ra,
chiến tranh, phân biệt chủng tộc, ma túy, kẻ sát nhân,
bao nhiêu cạm bẫy khiến con người quỵ gối,
một viên đạn lạc đã giết một cậu bé,
với gia đình đó là nỗi đau không thể tưởng tượng,
sau tay lái là rượu, trên đường phố là ma túy,
bên đường là rác rưởi, thế giới này đang đi về đâu,
trước những gì đang xảy ra, đầu óc tôi bắt đầu đứng hình,
vì tôi đang đứng cùng các bạn trên con tàu sắp đắm.

Đây là gì? Và tôi đang ở đâu?
Đây là thực tại hay chỉ là một giấc mơ ngớ ngẩn?
Tôi là thằng ngốc chăng, hay bạn cũng có cảm giác ấy,
rằng đất nước ta đang lao về diệt vong ngay trước mũi mình?

Từng bước một bạn đi qua cuộc đời,
bạn tranh giành chỗ đứng của mình dưới mặt trời,
bạn không muốn làm nô lệ, bạn lo lắng cho tương lai,
nhưng bạn khó mà biết điều gì sẽ xảy ra ở khúc quanh,
nhìn xem, kế hoạch của bạn có thể chết yểu rất nhanh,
trong khoảnh khắc mọi thứ đã khác, bạn còn chẳng kịp nhúc nhích,
hành tinh kỳ lạ này quét đi những số phận,
cái chết đến như một thằng khốn và cứa cổ bạn.
Nhân loại không biết rút ra bài học, thù hận thống trị thế giới,
những đứa trẻ nhỏ đặt ngón tay lên cò súng máy,
cả một thời gian dài vô tận ta đã thấy điều đó ở đây,
ta nhắm mắt lại, ta ngồi cả giờ liền trên mạng,
ta làm việc, ta góp phần vào sự thịnh vượng,
ta giết chết phần lớn thời gian của mình một cách khốn nạn,
bạn ngóng chờ cái ngày lĩnh lương,
bạn ngạc nhiên, hỡi người máy, rằng mình chẳng nhét đầy được túi.
Con người lúc nào cũng vội vã, dù chẳng biết đi đâu,
cuộc sống chậm rãi nhưng chắc chắn đang mất đi ý nghĩa,
cuộc sống và chất lượng ngày nay được đo bằng tiền,
rằng sự thật và tình yêu sẽ chiến thắng, chẳng ai còn tin nữa,
không còn chỗ cho cảm xúc, ta xây dựng sự nghiệp,
ta tàn phá cảnh quan, ta dựng lên những rào cản,
ta vô tư xả rác rưởi vào bầu khí quyển,
không biết con trai con gái ta rồi sẽ thở bằng gì.
Tôi không cố đóng vai Đội quân Cứu thế,
tôi chỉ phát bực khi con người tự cưa cành cây mình đang ngồi,
lờ đi sự thật và vấn đề chẳng có lợi gì,
đến cả các thánh cũng không giúp được, mọi thứ sẽ quay lại với chúng ta.'
WHERE s.`name` = 'Skeli a Babar - Divná planeta' AND l.`lang` = 'vi' AND l.`words` = 'Một cảm giác kỳ lạ xâm chiếm bạn khi bạn mở mắt,
chúng ta đều nhúng tay vào, đừng cố chối bỏ tội lỗi,
hãy cư xử như những vị khách nên cư xử,
ta sẽ van xin quá muộn, khi nơi đây chỉ còn đống đổ nát.
(2×)

Tôi lê bước một mình trên con đường tối tăm và dài dằng dặc,
tôi bước đi với cái đầu cúi gằm, u ám, rối bời,
đầy những suy nghĩ cứ mãi không chịu rời đi,
chỉ có con người rời đi, họ mang theo những ký ức đẹp,
và cùng lúc đó họ mang theo một cái giá mà tôi không chịu nổi,
nó giả tạo như hình xăm bằng henna,
họ ở đây một lúc rồi họ cười,
thôi thì, trên hành tinh kỳ lạ, những điều kỳ lạ xảy ra.
Tôi hướng vào thời tiết xấu, nơi ai cũng chỉ nhìn vào vẻ đẹp,
các cô gái đo một mối quan hệ bằng độ dài của dương vật,
nhiệt huyết đã đi đâu mất, ngày xưa quý ông nào cũng có,
ở mỗi góc phố quý ông mở cửa cho các quý bà, còn hôm nay,
nhìn đâu cũng thấy có kẻ bắt cóc ai đó,
thật kinh hoàng, điên loạn, khắp nơi rừng bị chặt trụi,
trên hành tinh của chúng ta chỉ có công nghiệp được nở hoa,
và hành tinh này như một cái lồng mà bạn không thể thoát ra,
chiến tranh, phân biệt chủng tộc, ma túy, kẻ sát nhân,
bao nhiêu cạm bẫy khiến con người quỵ gối,
một viên đạn lạc đã giết một cậu bé,
với gia đình đó là nỗi đau không thể tưởng tượng,
sau tay lái là rượu, trên đường phố là ma túy,
bên đường là rác rưởi, thế giới này đang đi về đâu,
trước những gì đang xảy ra, đầu óc tôi bắt đầu đứng hình,
vì tôi đang đứng cùng các bạn trên con tàu sắp đắm.

Đây là gì? Và tôi đang ở đâu?
Đây là thực tại hay chỉ là một giấc mơ ngớ ngẩn?
Tôi là thằng ngốc chăng, hay bạn cũng có cảm giác ấy,
rằng đất nước ta đang lao về diệt vong ngay trước mũi mình?

Từng bước một bạn đi qua cuộc đời,
bạn tranh giành chỗ đứng của mình dưới mặt trời,
bạn không muốn làm nô lệ, bạn lo lắng cho tương lai,
nhưng bạn khó mà biết điều gì sẽ xảy ra ở khúc quanh,
nhìn xem, kế hoạch của bạn có thể chết yểu rất nhanh,
trong khoảnh khắc mọi thứ đã khác, bạn còn chẳng kịp nhúc nhích,
hành tinh kỳ lạ này quét đi những số phận,
cái chết đến như một thằng khốn và cứa cổ bạn.
Nhân loại không biết rút ra bài học, thù hận thống trị thế giới,
những đứa trẻ nhỏ đặt ngón tay lên cò súng máy,
cả một thời gian dài vô tận ta đã thấy điều đó ở đây,
ta nhắm mắt lại, ta ngồi cả giờ liền trên mạng,
ta làm việc, ta góp phần vào sự thịnh vượng,
ta giết chết phần lớn thời gian của mình một cách khốn nạn,
bạn ngóng chờ cái ngày lĩnh lương,
bạn ngạc nhiên, hỡi người máy, rằng mình chẳng nhét đầy được túi.
Con người lúc nào cũng vội vã, dù chẳng biết đi đâu,
cuộc sống chậm rãi nhưng chắc chắn đang mất đi ý nghĩa,
cuộc sống và chất lượng ngày nay được đo bằng tiền,
rằng sự thật và tình yêu sẽ chiến thắng, chẳng ai còn tin nữa,
không còn chỗ cho cảm xúc, ta xây dựng sự nghiệp,
ta tàn phá cảnh quan, ta dựng lên những rào cản,
ta vô tư xả rác rưởi vào bầu khí quyển,
không biết con trai con gái ta rồi sẽ thở bằng gì.
Tôi không cố đóng vai Đội quân Cứu thế,
tôi chỉ phát bực khi con người tự cưa cành cây mình đang ngồi,
lờ đi sự thật và vấn đề chẳng có lợi gì,
đến cả các thánh cũng không giúp được, mọi thứ sẽ quay lại với chúng ta.';

-- Trosky (feat. Babar) (cs)
UPDATE `lyrics` l JOIN `songs` s ON s.`id` = l.`song_id`
SET l.`words` = 'Vy hlavy dutý, jste dávno vypnutý, vaše existence pochybný,
nechutně vyhublý, držky propadlý, odpadlíci, co se sami zahubí,
vysmažený nátury s celým životem naruby, vyschlej jako dromedár,
tváří se jak topstar, přitom seš troska top kár, co si život pojebal,
probodaný žíly dodávaj ti další síly, žiješ jenom pro tu chvíli, kdy se nafutruješ bílým.
Trosky s nevyvinutými mozky, vybílí byt pro bílý, bez matra by nepřežili,
vykradou vlastní rodiny, během hodiny rozbili roky, kdy pro ně rodiny ruce do ohně vložily.
Hromada ostudy za vychovaný žaludy,
přeludy bez budoucnosti, kterou si sami pohřbili,
nepochopili, kam to vlastně vstoupili,
že už z toho nejde tak ven, že nejsou jenom opilí.
Jste špatný jak tvý blbý zažívání,
savci, co to sajou bez přestání,
vaše fetiš klání vás dohání až k pobodání při nedostání další dávky,
tyhle kroky nejdou vzít zpátky,
stal se vrahem pro kus skurvený hromádky,
krev z rukou už nejde smýt,
teď nevíš, jak s tímhle činem žít,
teď teprv si procit, bodá tě pocit bezmoci,
od rána do noci přemýšlíš, kdo jsi, jsi zlosyn,
vole, jsi v koncích, v krimu si na tvou prdel zuby už brousí,
ještě než se z toho zhroutíš, malátně po cimře bloudíš,
delirium končí a v pytli už prázdno,
všechno vysáto, v hlavě vymazáno, ano, máš vyděláno.
Bereš nohy na ramena, utíkáš jak dítě,
nechceš za mříže, stejně to přijde,
boží mlýny melou, tebe berou s sebou,
upadlo ti mýdlo, teď jebou tě ve dvou,
za tvý činy na deset let úděl maminy,
pěkný program už si tam pro tebe připravili,
s tvou vyhublou postavou nemůžeš se bránit,
každej den každej tě může v klidu klátit,
už si nemůžeš ani sednout, chtěl bys radši zhebnout,
než si s tebou přijdou zase jebnout,
usínáš každou noc s depkou, že ses stal fetkou, že ses dal na cestu opravdu nepěknou.

Měl jsem buchtu, co si hrála na to, že je vážně třída,
ale víš jak, po pár týdnech registruju, že jí dávno předtím, než jsme se poznali, zachutnala křída,
prej jí párno obstarává křídla a jí se chce lítat,
přestal sem ji líbat, nechtěl sem ji svlíkat, lízat, píchat, vydat,
taky ne, protože je píča, píča, píča.
Měl jsem kamaráda, co mi říkal bráško, věřil jsem mu, věděl o mně téměř všechno,
pak poznal blbý lidi, chytil se jich, v něm se to přeplo,
z rypáku mu piko teklo, denně vidím peklo,
na ulici kdekdo, často malý děcka, co nemůžou přestat,
je jich plný město, jsou na pest, a mám pro ně jenom jedno gesto.

Ať si kdo chce, co chce, bere, smažky mi jsou u prdele,
jak si to usteleš, tak si lehneš na dno,
dá se padnout na dno, vydal ses cestou špatnou,
je to jako bahno, který když tě chytí, většinou tě nepustí,
schopnej věcí, co ti ani nejbližší neodpustí.
Vykašli se na fet, věta, kterou už ti nikdo nehustí,
jseš v tom po uši, stejně tak tví kámoši,
odvykací kúra, no stress, prej pedikúra,
pokud nechceš sám, hned čeká tě noční můra,
za plotem na tebe třese se dílerů fůra,
raz dva se ženeš na šňůru,
pak se nediv, že je v noci celej barák vzhůru,
nediv se, že detox tvoří ještě větší stvůry,
otevřou se vrata Bohnic, utíkaj pro bůra,
psago čistý jak natura.

Ať si kdo chce, co chce, bere, smažky mi jsou u prdele,
jak si to usteleš, tak si lehneš na dno,
dá se padnout na dno, je to jako bahno,
už cítíš to chladno.
Ať si kdo chce, co chce, bere, smažky mi jsou u prdele,
jak si to usteleš, tak si lehneš na dno,
dá se padnout na dno, je to jako bahno,
už cítíš to chladno.
Ať si kdo chce, co chce, bere, smažky mi jsou u prdele,
jak si to usteleš, tak si lehneš na dno,
dá se padnout na dno, je to jako bahno,
už cítíš to chladno.
Ať si kdo chce, co chce, bere, smažky mi jsou u prdele,
jak si to usteleš, tak si lehneš na dno,
dá se padnout na dno, je to jako bahno,
už cítíš to chladno.'
WHERE s.`name` = 'Trosky (feat. Babar)' AND l.`lang` = 'cs' AND l.`words` = 'Vy hlavy dutý, jste dávno vypnutý, vaše existence pochybný,
nechutně vyhublý, držky propadlý, odpadlíci, co se sami zahubí,
vysmažený nátury s celým životem naruby, vyschlej jako dromedár,
tváří se jak topstar, přitom seš troska top kár, co si život pojebal,
probodaný žíly dodávaj ti další síly, žiješ jenom pro tu chvíli, kdy se nafutruješ bílým.
Trosky s nevyvinutými mozky, vybílí byt pro bílý, bez matra by nepřežili,
vykradou vlastní rodiny, během hodiny rozbili roky, kdy pro ně rodiny ruce do ohně vložily.
Hromada ostudy za vychovaný žaludy,
přeludy bez budoucnosti, kterou si sami pohřbili,
nepochopili, kam to vlastně vstoupili,
že už z toho nejde tak ven, že nejsou jenom opilí.
Jste špatný jak tvý blbý zažívání,
savci, co to sajou bez přestání,
vaše fetiš klání vás dohání až k pobodání při nedostání další dávky,
tyhle kroky nejdou vzít zpátky,
stal se vrahem pro kus skurvený hromádky,
krev z rukou už nejde smýt,
teď nevíš, jak s tímhle činem žít,
teď teprv si procit, bodá tě pocit bezmoci,
od rána do noci přemýšlíš, kdo jsi, jsi zlosyn,
vole, jsi v koncích, v krimu si na tvou prdel zuby už brousí,
ještě než se z toho zhroutíš, malátně po cimře bloudíš,
delirium končí a v pytli už prázdno,
všechno vysáto, v hlavě vymazáno, ano, máš vyděláno.
Bereš nohy na ramena, utíkáš jak dítě,
nechceš za mříže, stejně to přijde,
boží mlýny melou, tebe berou s sebou,
upadlo ti mýdlo, teď jebou tě ve dvou,
za tvý činy na deset let úděl maminy,
pěkný program už si tam pro tebe připravili,
s tvou vyhublou postavou nemůžeš se bránit,
každej den každej tě může v klidu klátit,
už si nemůžeš ani sednout, chtěl bys radši zhebnout,
než si s tebou přijdou zase jebnout,
usínáš každou noc s depkou, že ses stal fetkou, že ses dal na cestu opravdu nepěknou.

Měl jsem buchtu, co si hrála na to, že je vážně třída,
ale víš jak, po pár týdnech registruju, že jí dávno předtím, než jsme se poznali, zachutnala křída,
prej jí párno obstarává křídla a jí se chce lítat,
přestal sem ji líbat, nechtěl sem ji svlíkat, lízat, píchat, vydat,
taky ne, protože je píča, píča, píča.
Měl jsem kamaráda, co mi říkal bráško, věřil jsem mu, věděl o mně téměř všechno,
pak poznal blbý lidi, chytil se jich, v něm se to přeplo,
z rypáku mu piko teklo, denně vidím peklo,
na ulici kdekdo, často malý děcka, co nemůžou přestat,
je jich plný město, jsou na pest, a mám pro ně jenom jedno gesto.

Ať si kdo chce, co chce, bere, smažky mi jsou u prdele,
jak si to usteleš, tak si lehneš na dno,
dá se padnout na dno, vydal ses cestou špatnou,
je to jako bahno, který když tě chytí, většinou tě nepustí,
schopnej věcí, co ti ani nejbližší neodpustí.
Vykašli se na fet, věta, kterou už ti nikdo nehustí,
jseš v tom po uši, stejně tak tví kámoši,
odvykací kúra, no stress, prej pedikúra,
pokud nechceš sám, hned čeká tě noční můra,
za plotem na tebe třese se dílerů fůra,
raz dva se ženeš na šňůru,
pak se nediv, že je v noci celej barák vzhůru,
nediv se, že detox tvoří ještě větší stvůry,
otevřou se vrata Bohnic, utíkaj pro bůra,
psago čistý jak natura.

Ať si kdo chce, co chce, bere, smažky mi jsou u prdele,
jak si to usteleš, tak si lehneš na dno,
dá se padnout na dno, je to jako bahno,
už cítíš to chladno.
(4×)';

-- Trosky (feat. Babar) (de)
UPDATE `lyrics` l JOIN `songs` s ON s.`id` = l.`song_id`
SET l.`words` = 'Ihr hohlen Köpfe, ihr seid längst abgeschaltet, eure Existenz ist zweifelhaft,
widerlich abgemagert, eingefallene Fressen, Aussteiger, die sich selbst zugrunde richten,
verbrutzelte Naturen mit dem ganzen Leben auf links, ausgetrocknet wie ein Dromedar,
tut wie ein Topstar, dabei bist du das Wrack einer Topkarre, das sein Leben verkackt hat,
durchstochene Venen geben dir neue Kraft, du lebst nur für den Moment, in dem du dich mit Weißem vollstopfst.
Wracks mit unterentwickelten Hirnen, räumen die Wohnung fürs Weiße leer, ohne den Stoff würden sie nicht überleben,
sie bestehlen die eigenen Familien, in einer Stunde zerstören sie die Jahre, in denen die Familien für sie die Hand ins Feuer legten.
Ein Haufen Schande für wohlerzogene Eicheln,
Trugbilder ohne Zukunft, die sie selbst begraben haben,
sie haben nie kapiert, worauf sie sich eigentlich eingelassen haben,
dass man da nicht so leicht rauskommt, dass sie nicht nur besoffen sind.
Ihr seid so schlecht wie deine blöde Verdauung,
Säugetiere, die das ohne Pause ziehen,
euer Fetisch-Wettkampf treibt euch bis zum Messerstich, wenn die nächste Dosis ausbleibt,
diese Schritte kann man nicht zurücknehmen,
er wurde zum Mörder für ein Stück von einem verfickten Häufchen,
das Blut lässt sich nicht mehr von den Händen waschen,
jetzt weißt du nicht, wie du mit dieser Tat leben sollst,
erst jetzt wachst du auf, das Gefühl der Ohnmacht sticht dich,
von morgens bis nachts grübelst du, wer du bist, du bist ein Verbrecher,
Alter, du bist am Ende, im Knast wetzen sie schon die Zähne an deinem Arsch,
noch bevor du zusammenbrichst, irrst du benommen durch die Zelle,
das Delirium endet und das Tütchen ist schon leer,
alles weggezogen, im Kopf gelöscht, ja, das hast du dir verdient.
Du nimmst die Beine in die Hand, rennst weg wie ein Kind,
du willst nicht hinter Gitter, es kommt trotzdem,
Gottes Mühlen mahlen, sie nehmen dich mit,
dir ist die Seife runtergefallen, jetzt ficken dich zwei,
für deine Taten zehn Jahre als Mamachen,
ein nettes Programm haben sie dort schon für dich vorbereitet,
mit deiner abgemagerten Figur kannst du dich nicht wehren,
jeden Tag kann dich jeder in aller Ruhe durchnehmen,
du kannst nicht mal mehr sitzen, du würdest lieber verrecken,
bevor sie wieder kommen, um dich zu ficken,
jede Nacht schläfst du deprimiert ein, weil du ein Junkie geworden bist, weil du einen wirklich üblen Weg genommen hast.

Ich hatte eine Braut, die so tat, als wäre sie echt Klasse,
aber du weißt ja, nach ein paar Wochen merke ich, dass ihr lange bevor wir uns kannten die Kreide geschmeckt hat,
angeblich verleiht ihr das Crystal Flügel und sie will fliegen,
ich hörte auf, sie zu küssen, wollte sie nicht ausziehen, lecken, ficken, mich ihr nicht hingeben,
auch nicht, weil sie eine Schlampe ist, eine Schlampe, eine Schlampe.
Ich hatte einen Kumpel, der mich Bruder nannte, ich vertraute ihm, er wusste fast alles über mich,
dann lernte er blöde Leute kennen, hängte sich an sie, in ihm hat es umgeschaltet,
aus dem Rüssel lief ihm das Crystal, täglich sehe ich die Hölle,
auf der Straße jeder Zweite, oft kleine Kinder, die nicht aufhören können,
die Stadt ist voll von ihnen, sie sind fertig, und ich habe für sie nur eine Geste.

Soll doch jeder nehmen, was er will, Junkies sind mir scheißegal,
wie man sich bettet, so liegt man – ganz unten,
man kann ganz unten landen, du hast den falschen Weg genommen,
es ist wie Schlamm, der dich, wenn er dich packt, meistens nicht mehr loslässt,
fähig zu Dingen, die dir nicht mal die Nächsten verzeihen.
Scheiß auf die Drogen, ein Satz, den dir keiner mehr einhämmert,
du steckst bis zum Hals drin, genau wie deine Kumpels,
Entzugskur, kein Stress, angeblich Pediküre,
wenn du es nicht selbst willst, wartet sofort der Albtraum auf dich,
hinterm Zaun wartet schon eine Fuhre Dealer auf dich,
im Nu jagst du zur nächsten Line,
dann wunder dich nicht, dass nachts das ganze Haus wach ist,
wunder dich nicht, dass der Entzug noch größere Monster schafft,
die Tore von Bohnice gehen auf, sie rennen nach bůra,
psago rein wie die Natur.

Soll doch jeder nehmen, was er will, Junkies sind mir scheißegal,
wie man sich bettet, so liegt man – ganz unten,
man kann ganz unten landen, es ist wie Schlamm,
jetzt spürst du schon die Kälte.
Soll doch jeder nehmen, was er will, Junkies sind mir scheißegal,
wie man sich bettet, so liegt man – ganz unten,
man kann ganz unten landen, es ist wie Schlamm,
jetzt spürst du schon die Kälte.
Soll doch jeder nehmen, was er will, Junkies sind mir scheißegal,
wie man sich bettet, so liegt man – ganz unten,
man kann ganz unten landen, es ist wie Schlamm,
jetzt spürst du schon die Kälte.
Soll doch jeder nehmen, was er will, Junkies sind mir scheißegal,
wie man sich bettet, so liegt man – ganz unten,
man kann ganz unten landen, es ist wie Schlamm,
jetzt spürst du schon die Kälte.'
WHERE s.`name` = 'Trosky (feat. Babar)' AND l.`lang` = 'de' AND l.`words` = 'Ihr hohlen Köpfe, ihr seid längst abgeschaltet, eure Existenz ist zweifelhaft,
widerlich abgemagert, eingefallene Fressen, Aussteiger, die sich selbst zugrunde richten,
verbrutzelte Naturen mit dem ganzen Leben auf links, ausgetrocknet wie ein Dromedar,
tut wie ein Topstar, dabei bist du das Wrack einer Topkarre, das sein Leben verkackt hat,
durchstochene Venen geben dir neue Kraft, du lebst nur für den Moment, in dem du dich mit Weißem vollstopfst.
Wracks mit unterentwickelten Hirnen, räumen die Wohnung fürs Weiße leer, ohne den Stoff würden sie nicht überleben,
sie bestehlen die eigenen Familien, in einer Stunde zerstören sie die Jahre, in denen die Familien für sie die Hand ins Feuer legten.
Ein Haufen Schande für wohlerzogene Eicheln,
Trugbilder ohne Zukunft, die sie selbst begraben haben,
sie haben nie kapiert, worauf sie sich eigentlich eingelassen haben,
dass man da nicht so leicht rauskommt, dass sie nicht nur besoffen sind.
Ihr seid so schlecht wie deine blöde Verdauung,
Säugetiere, die das ohne Pause ziehen,
euer Fetisch-Wettkampf treibt euch bis zum Messerstich, wenn die nächste Dosis ausbleibt,
diese Schritte kann man nicht zurücknehmen,
er wurde zum Mörder für ein Stück von einem verfickten Häufchen,
das Blut lässt sich nicht mehr von den Händen waschen,
jetzt weißt du nicht, wie du mit dieser Tat leben sollst,
erst jetzt wachst du auf, das Gefühl der Ohnmacht sticht dich,
von morgens bis nachts grübelst du, wer du bist, du bist ein Verbrecher,
Alter, du bist am Ende, im Knast wetzen sie schon die Zähne an deinem Arsch,
noch bevor du zusammenbrichst, irrst du benommen durch die Zelle,
das Delirium endet und das Tütchen ist schon leer,
alles weggezogen, im Kopf gelöscht, ja, das hast du dir verdient.
Du nimmst die Beine in die Hand, rennst weg wie ein Kind,
du willst nicht hinter Gitter, es kommt trotzdem,
Gottes Mühlen mahlen, sie nehmen dich mit,
dir ist die Seife runtergefallen, jetzt ficken dich zwei,
für deine Taten zehn Jahre als Mamachen,
ein nettes Programm haben sie dort schon für dich vorbereitet,
mit deiner abgemagerten Figur kannst du dich nicht wehren,
jeden Tag kann dich jeder in aller Ruhe durchnehmen,
du kannst nicht mal mehr sitzen, du würdest lieber verrecken,
bevor sie wieder kommen, um dich zu ficken,
jede Nacht schläfst du deprimiert ein, weil du ein Junkie geworden bist, weil du einen wirklich üblen Weg genommen hast.

Ich hatte eine Braut, die so tat, als wäre sie echt Klasse,
aber du weißt ja, nach ein paar Wochen merke ich, dass ihr lange bevor wir uns kannten die Kreide geschmeckt hat,
angeblich verleiht ihr das Crystal Flügel und sie will fliegen,
ich hörte auf, sie zu küssen, wollte sie nicht ausziehen, lecken, ficken, mich ihr nicht hingeben,
auch nicht, weil sie eine Schlampe ist, eine Schlampe, eine Schlampe.
Ich hatte einen Kumpel, der mich Bruder nannte, ich vertraute ihm, er wusste fast alles über mich,
dann lernte er blöde Leute kennen, hängte sich an sie, in ihm hat es umgeschaltet,
aus dem Rüssel lief ihm das Crystal, täglich sehe ich die Hölle,
auf der Straße jeder Zweite, oft kleine Kinder, die nicht aufhören können,
die Stadt ist voll von ihnen, sie sind fertig, und ich habe für sie nur eine Geste.

Soll doch jeder nehmen, was er will, Junkies sind mir scheißegal,
wie man sich bettet, so liegt man – ganz unten,
man kann ganz unten landen, du hast den falschen Weg genommen,
es ist wie Schlamm, der dich, wenn er dich packt, meistens nicht mehr loslässt,
fähig zu Dingen, die dir nicht mal die Nächsten verzeihen.
Scheiß auf die Drogen, ein Satz, den dir keiner mehr einhämmert,
du steckst bis zum Hals drin, genau wie deine Kumpels,
Entzugskur, kein Stress, angeblich Pediküre,
wenn du es nicht selbst willst, wartet sofort der Albtraum auf dich,
hinterm Zaun wartet schon eine Fuhre Dealer auf dich,
im Nu jagst du zur nächsten Line,
dann wunder dich nicht, dass nachts das ganze Haus wach ist,
wunder dich nicht, dass der Entzug noch größere Monster schafft,
die Tore von Bohnice gehen auf, sie rennen nach bůra,
psago rein wie die Natur.

Soll doch jeder nehmen, was er will, Junkies sind mir scheißegal,
wie man sich bettet, so liegt man – ganz unten,
man kann ganz unten landen, es ist wie Schlamm,
jetzt spürst du schon die Kälte.
(4×)';

-- Trosky (feat. Babar) (en)
UPDATE `lyrics` l JOIN `songs` s ON s.`id` = l.`song_id`
SET l.`words` = 'You hollow heads, you switched off long ago, your existence is dubious,
disgustingly skinny, sunken faces, dropouts who''ll finish themselves off,
fried natures with your whole life inside out, dried up like a dromedary,
acting like a top star, while you''re the wreck of a top car who fucked up his life,
pierced veins give you more strength, you only live for the moment you stuff yourself with white.
Wrecks with undeveloped brains, they''ll clear out a flat for the white, without the stuff they wouldn''t survive,
they rob their own families, in an hour they smashed the years when their families put their hands in the fire for them.
A pile of shame for well-raised acorns,
illusions without a future, which they buried themselves,
they never understood what they actually stepped into,
that there''s no easy way out, that they''re not just drunk.
You''re as bad as your stupid digestion,
mammals who suck it up without a break,
your fetish contest drives you all the way to stabbing when you don''t get the next dose,
these steps can''t be taken back,
he became a killer for a piece of a fucking little pile,
the blood can''t be washed off your hands anymore,
now you don''t know how to live with this deed,
only now you''ve woken up, the feeling of helplessness stabs you,
from morning till night you wonder who you are, you''re a villain,
dude, you''re done for, in jail they''re already sharpening their teeth on your ass,
before you even break down, you wander around the cell in a daze,
the delirium ends and the bag is already empty,
everything sucked up, your head wiped, yes, you''ve earned it.
You take to your heels, you run like a child,
you don''t want to go behind bars, it''ll come anyway,
God''s mills grind, they take you with them,
you dropped the soap, now two of them are fucking you,
for your deeds ten years as the mommy,
they''ve already prepared a nice program for you in there,
with your skinny frame you can''t defend yourself,
every day anyone can bang you at their leisure,
you can''t even sit down anymore, you''d rather croak
than have them come to fuck you again,
every night you fall asleep depressed that you became a junkie, that you took a really ugly road.

I had a chick who acted like she was real class,
but you know how it goes, after a few weeks I notice that long before we met she got a taste for chalk,
they say the crank gives her wings and she wants to fly,
I stopped kissing her, didn''t want to undress her, lick her, fuck her, give in to her,
no way, because she''s a bitch, a bitch, a bitch.
I had a friend who called me bro, I trusted him, he knew almost everything about me,
then he met stupid people, latched onto them, something flipped in him,
crank was running out of his snout, every day I see hell,
anyone on the street, often little kids who can''t stop,
the city is full of them, they''re wasted, and I only have one gesture for them.

Let anyone take whatever they want, I don''t give a shit about junkies,
you made your bed, now you''ll lie on the bottom,
you can hit the bottom, you took the wrong road,
it''s like mud that, once it catches you, mostly won''t let you go,
capable of things even your closest won''t forgive you for.
Quit the drugs, a line nobody drills into you anymore,
you''re in it up to your ears, and so are your buddies,
rehab, no stress, a pedicure, they say,
if you don''t want it yourself, a nightmare''s waiting for you right away,
behind the fence a whole load of dealers is waiting for you,
in no time you''re rushing to the line,
then don''t be surprised the whole building is awake at night,
don''t be surprised that detox creates even bigger monsters,
the gates of Bohnice open, they run for bůra,
psago clean as nature.

Let anyone take whatever they want, I don''t give a shit about junkies,
you made your bed, now you''ll lie on the bottom,
you can hit the bottom, it''s like mud,
now you feel the cold.
Let anyone take whatever they want, I don''t give a shit about junkies,
you made your bed, now you''ll lie on the bottom,
you can hit the bottom, it''s like mud,
now you feel the cold.
Let anyone take whatever they want, I don''t give a shit about junkies,
you made your bed, now you''ll lie on the bottom,
you can hit the bottom, it''s like mud,
now you feel the cold.
Let anyone take whatever they want, I don''t give a shit about junkies,
you made your bed, now you''ll lie on the bottom,
you can hit the bottom, it''s like mud,
now you feel the cold.'
WHERE s.`name` = 'Trosky (feat. Babar)' AND l.`lang` = 'en' AND l.`words` = 'You hollow heads, you switched off long ago, your existence is dubious,
disgustingly skinny, sunken faces, dropouts who''ll finish themselves off,
fried natures with your whole life inside out, dried up like a dromedary,
acting like a top star, while you''re the wreck of a top car who fucked up his life,
pierced veins give you more strength, you only live for the moment you stuff yourself with white.
Wrecks with undeveloped brains, they''ll clear out a flat for the white, without the stuff they wouldn''t survive,
they rob their own families, in an hour they smashed the years when their families put their hands in the fire for them.
A pile of shame for well-raised acorns,
illusions without a future, which they buried themselves,
they never understood what they actually stepped into,
that there''s no easy way out, that they''re not just drunk.
You''re as bad as your stupid digestion,
mammals who suck it up without a break,
your fetish contest drives you all the way to stabbing when you don''t get the next dose,
these steps can''t be taken back,
he became a killer for a piece of a fucking little pile,
the blood can''t be washed off your hands anymore,
now you don''t know how to live with this deed,
only now you''ve woken up, the feeling of helplessness stabs you,
from morning till night you wonder who you are, you''re a villain,
dude, you''re done for, in jail they''re already sharpening their teeth on your ass,
before you even break down, you wander around the cell in a daze,
the delirium ends and the bag is already empty,
everything sucked up, your head wiped, yes, you''ve earned it.
You take to your heels, you run like a child,
you don''t want to go behind bars, it''ll come anyway,
God''s mills grind, they take you with them,
you dropped the soap, now two of them are fucking you,
for your deeds ten years as the mommy,
they''ve already prepared a nice program for you in there,
with your skinny frame you can''t defend yourself,
every day anyone can bang you at their leisure,
you can''t even sit down anymore, you''d rather croak
than have them come to fuck you again,
every night you fall asleep depressed that you became a junkie, that you took a really ugly road.

I had a chick who acted like she was real class,
but you know how it goes, after a few weeks I notice that long before we met she got a taste for chalk,
they say the crank gives her wings and she wants to fly,
I stopped kissing her, didn''t want to undress her, lick her, fuck her, give in to her,
no way, because she''s a bitch, a bitch, a bitch.
I had a friend who called me bro, I trusted him, he knew almost everything about me,
then he met stupid people, latched onto them, something flipped in him,
crank was running out of his snout, every day I see hell,
anyone on the street, often little kids who can''t stop,
the city is full of them, they''re wasted, and I only have one gesture for them.

Let anyone take whatever they want, I don''t give a shit about junkies,
you made your bed, now you''ll lie on the bottom,
you can hit the bottom, you took the wrong road,
it''s like mud that, once it catches you, mostly won''t let you go,
capable of things even your closest won''t forgive you for.
Quit the drugs, a line nobody drills into you anymore,
you''re in it up to your ears, and so are your buddies,
rehab, no stress, a pedicure, they say,
if you don''t want it yourself, a nightmare''s waiting for you right away,
behind the fence a whole load of dealers is waiting for you,
in no time you''re rushing to the line,
then don''t be surprised the whole building is awake at night,
don''t be surprised that detox creates even bigger monsters,
the gates of Bohnice open, they run for bůra,
psago clean as nature.

Let anyone take whatever they want, I don''t give a shit about junkies,
you made your bed, now you''ll lie on the bottom,
you can hit the bottom, it''s like mud,
now you feel the cold.
(4×)';

-- Trosky (feat. Babar) (uk)
UPDATE `lyrics` l JOIN `songs` s ON s.`id` = l.`song_id`
SET l.`words` = 'Ви, порожні голови, ви давно вимкнені, ваше існування сумнівне,
огидно схудлі, запалі пики, відщепенці, що самі себе занапастять,
підсмажені натури з усім життям навиворіт, висохлі, як верблюд,
корчиш із себе топзірку, а сам — уламок топової тачки, що просрав своє життя,
проколоті вени дають тобі нові сили, живеш лише заради миті, коли напхаєшся білим.
Уламки з недорозвиненим мозком, винесуть усе з квартири заради білого, без дурі не вижили б,
обкрадають власні родини, за годину зруйнували роки, коли родини клали за них руку у вогонь.
Купа ганьби за виховані жолуді,
марева без майбутнього, яке самі ж і поховали,
так і не зрозуміли, куди насправді вступили,
що звідти вже так просто не вийти, що вони не просто п''яні.
Ви погані, як твоє дурне травлення,
ссавці, що смокчуть це без упину,
ваше фетиш-змагання доводить вас аж до ножа, коли не дістанете чергової дози,
ці кроки вже не повернеш назад,
став убивцею за шматок клятої купки,
кров із рук уже не змити,
тепер не знаєш, як жити з цим вчинком,
тільки тепер ти прокинувся, тебе колить відчуття безсилля,
з ранку до ночі думаєш, хто ти, ти лиходій,
чуваче, тобі кінець, у тюрязі на твою дупу вже гострять зуби,
ще до того, як зламаєшся, ти мляво блукаєш камерою,
делірій закінчується, і в пакетику вже порожньо,
усе висмоктано, у голові стерто, так, ти це заробив.
Береш ноги в руки, тікаєш, як дитина,
не хочеш за ґрати, все одно це прийде,
Божі млини мелють, тебе беруть із собою,
тобі впало мило, тепер тебе трахають удвох,
за твої вчинки на десять років доля «мамки»,
гарну програму там для тебе вже підготували,
з твоєю худою статурою ти не можеш захиститися,
щодня будь-хто може спокійно тебе трахнути,
ти вже навіть сісти не можеш, волів би здохнути,
ніж вони знову прийдуть тебе трахнути,
щоночі засинаєш у депресії, що став наркоманом, що пішов дуже поганою дорогою.

Була в мене дівка, що вдавала, ніби вона справжній клас,
але знаєш, як буває, за кілька тижнів помічаю, що задовго до нашого знайомства їй засмакувала крейда,
кажуть, фен дає їй крила, і їй хочеться літати,
я перестав її цілувати, не хотів її роздягати, лизати, трахати, піддаватися їй,
теж ні, бо вона сука, сука, сука.
Був у мене друг, що звав мене братиком, я йому вірив, він знав про мене майже все,
потім зійшовся з дурними людьми, вчепився за них, у ньому щось перемкнуло,
з носа в нього текла дурь, щодня бачу пекло,
на вулиці будь-хто, часто малі діти, що не можуть зупинитися,
ними повне місто, вони пропащі, і в мене для них лише один жест.

Хай хто хоче бере що хоче, на наркош мені начхати,
як постелиш, так і ляжеш на дно,
можна впасти на дно, ти пішов поганою дорогою,
це як болото, яке, коли тебе схопить, здебільшого не відпускає,
здатний на речі, яких тобі не пробачать навіть найближчі.
Кинь наркоту — фраза, яку тобі вже ніхто не втовкмачує,
ти в цьому по вуха, так само як твої кореші,
курс відвикання, без стресу, мовляв, педикюр,
якщо сам не хочеш, одразу на тебе чекає жах,
за парканом на тебе чекає ціла купа дилерів,
раз-два — і ти мчиш до доріжки,
то не дивуйся, що вночі весь будинок не спить,
не дивуйся, що детокс творить ще більших потвор,
відчиняються ворота Богниць, біжать по bůra,
psago чисте, як природа.

Хай хто хоче бере що хоче, на наркош мені начхати,
як постелиш, так і ляжеш на дно,
можна впасти на дно, це як болото,
вже відчуваєш цей холод.
Хай хто хоче бере що хоче, на наркош мені начхати,
як постелиш, так і ляжеш на дно,
можна впасти на дно, це як болото,
вже відчуваєш цей холод.
Хай хто хоче бере що хоче, на наркош мені начхати,
як постелиш, так і ляжеш на дно,
можна впасти на дно, це як болото,
вже відчуваєш цей холод.
Хай хто хоче бере що хоче, на наркош мені начхати,
як постелиш, так і ляжеш на дно,
можна впасти на дно, це як болото,
вже відчуваєш цей холод.'
WHERE s.`name` = 'Trosky (feat. Babar)' AND l.`lang` = 'uk' AND l.`words` = 'Ви, порожні голови, ви давно вимкнені, ваше існування сумнівне,
огидно схудлі, запалі пики, відщепенці, що самі себе занапастять,
підсмажені натури з усім життям навиворіт, висохлі, як верблюд,
корчиш із себе топзірку, а сам — уламок топової тачки, що просрав своє життя,
проколоті вени дають тобі нові сили, живеш лише заради миті, коли напхаєшся білим.
Уламки з недорозвиненим мозком, винесуть усе з квартири заради білого, без дурі не вижили б,
обкрадають власні родини, за годину зруйнували роки, коли родини клали за них руку у вогонь.
Купа ганьби за виховані жолуді,
марева без майбутнього, яке самі ж і поховали,
так і не зрозуміли, куди насправді вступили,
що звідти вже так просто не вийти, що вони не просто п''яні.
Ви погані, як твоє дурне травлення,
ссавці, що смокчуть це без упину,
ваше фетиш-змагання доводить вас аж до ножа, коли не дістанете чергової дози,
ці кроки вже не повернеш назад,
став убивцею за шматок клятої купки,
кров із рук уже не змити,
тепер не знаєш, як жити з цим вчинком,
тільки тепер ти прокинувся, тебе колить відчуття безсилля,
з ранку до ночі думаєш, хто ти, ти лиходій,
чуваче, тобі кінець, у тюрязі на твою дупу вже гострять зуби,
ще до того, як зламаєшся, ти мляво блукаєш камерою,
делірій закінчується, і в пакетику вже порожньо,
усе висмоктано, у голові стерто, так, ти це заробив.
Береш ноги в руки, тікаєш, як дитина,
не хочеш за ґрати, все одно це прийде,
Божі млини мелють, тебе беруть із собою,
тобі впало мило, тепер тебе трахають удвох,
за твої вчинки на десять років доля «мамки»,
гарну програму там для тебе вже підготували,
з твоєю худою статурою ти не можеш захиститися,
щодня будь-хто може спокійно тебе трахнути,
ти вже навіть сісти не можеш, волів би здохнути,
ніж вони знову прийдуть тебе трахнути,
щоночі засинаєш у депресії, що став наркоманом, що пішов дуже поганою дорогою.

Була в мене дівка, що вдавала, ніби вона справжній клас,
але знаєш, як буває, за кілька тижнів помічаю, що задовго до нашого знайомства їй засмакувала крейда,
кажуть, фен дає їй крила, і їй хочеться літати,
я перестав її цілувати, не хотів її роздягати, лизати, трахати, піддаватися їй,
теж ні, бо вона сука, сука, сука.
Був у мене друг, що звав мене братиком, я йому вірив, він знав про мене майже все,
потім зійшовся з дурними людьми, вчепився за них, у ньому щось перемкнуло,
з носа в нього текла дурь, щодня бачу пекло,
на вулиці будь-хто, часто малі діти, що не можуть зупинитися,
ними повне місто, вони пропащі, і в мене для них лише один жест.

Хай хто хоче бере що хоче, на наркош мені начхати,
як постелиш, так і ляжеш на дно,
можна впасти на дно, ти пішов поганою дорогою,
це як болото, яке, коли тебе схопить, здебільшого не відпускає,
здатний на речі, яких тобі не пробачать навіть найближчі.
Кинь наркоту — фраза, яку тобі вже ніхто не втовкмачує,
ти в цьому по вуха, так само як твої кореші,
курс відвикання, без стресу, мовляв, педикюр,
якщо сам не хочеш, одразу на тебе чекає жах,
за парканом на тебе чекає ціла купа дилерів,
раз-два — і ти мчиш до доріжки,
то не дивуйся, що вночі весь будинок не спить,
не дивуйся, що детокс творить ще більших потвор,
відчиняються ворота Богниць, біжать по bůra,
psago чисте, як природа.

Хай хто хоче бере що хоче, на наркош мені начхати,
як постелиш, так і ляжеш на дно,
можна впасти на дно, це як болото,
вже відчуваєш цей холод.
(4×)';

-- Trosky (feat. Babar) (vi)
UPDATE `lyrics` l JOIN `songs` s ON s.`id` = l.`song_id`
SET l.`words` = 'Lũ đầu rỗng, tụi mày đã tắt máy từ lâu, sự tồn tại của tụi mày thật đáng ngờ,
gầy rộc đến ghê tởm, mặt mũi hốc hác, lũ bỏ đi tự hủy hoại chính mình,
những bản chất cháy khét với cả cuộc đời lộn ngược, khô quắt như lạc đà,
làm bộ như ngôi sao hàng đầu, trong khi mày là đống sắt vụn của một chiếc xe xịn, kẻ đã phá nát đời mình,
những mạch máu đầy vết kim cho mày thêm sức, mày chỉ sống vì khoảnh khắc được nhồi đầy thứ bột trắng.
Lũ tàn tạ với bộ não chưa phát triển, dọn sạch căn hộ để đổi lấy bột trắng, không có hàng thì chẳng sống nổi,
chúng trộm cả gia đình mình, trong một giờ phá nát bao năm gia đình sẵn sàng đặt tay vào lửa vì chúng.
Một đống ô nhục thay cho những hạt sồi được dạy dỗ tử tế,
những ảo ảnh không tương lai mà chính chúng đã chôn vùi,
chúng chẳng hiểu mình thực sự đã bước vào cái gì,
rằng chẳng dễ gì thoát ra, rằng chúng không chỉ say rượu.
Tụi mày tệ như cái hệ tiêu hóa ngu ngốc của mày,
lũ động vật có vú hút nó không ngừng nghỉ,
cuộc đua nghiện ngập đẩy tụi mày tới chỗ đâm dao khi không có liều tiếp theo,
những bước này không thể rút lại,
hắn thành kẻ giết người vì một nhúm bột chết tiệt,
máu trên tay không thể rửa sạch nữa,
giờ mày không biết sống sao với tội ác này,
giờ mày mới tỉnh ra, cảm giác bất lực đâm vào mày,
từ sáng tới đêm mày nghĩ mình là ai, mày là kẻ ác,
mày tiêu rồi, thằng kia, trong tù người ta đã mài răng chờ cái mông mày,
trước cả khi gục ngã, mày lờ đờ lang thang trong phòng giam,
cơn mê sảng kết thúc và túi đã trống trơn,
tất cả hút sạch, trong đầu bị xóa trắng, đúng rồi, mày đáng bị vậy.
Mày co giò chạy, chạy như một đứa trẻ,
mày không muốn vào sau song sắt, nhưng đằng nào nó cũng đến,
cối xay của Chúa vẫn nghiền, chúng mang mày theo,
mày đánh rơi xà phòng, giờ hai đứa chơi mày,
vì tội của mày, mười năm làm "mẹ" trong đó,
một chương trình thú vị đã được chuẩn bị sẵn cho mày,
với thân hình gầy gò, mày không thể tự vệ,
ngày nào ai cũng có thể thoải mái chơi mày,
mày còn chẳng ngồi nổi nữa, mày thà chết quách
còn hơn để chúng lại đến chơi mày,
đêm nào mày cũng ngủ trong trầm cảm vì đã thành con nghiện, vì đã đi một con đường thật tồi tệ.

Tao từng có một em ra vẻ mình đẳng cấp lắm,
nhưng mày biết đấy, vài tuần sau tao nhận ra từ lâu trước khi bọn tao quen nhau nó đã nghiện "phấn",
nghe nói đá cho nó đôi cánh và nó muốn bay,
tao thôi hôn nó, chẳng muốn cởi đồ, liếm, chơi hay chiều theo nó,
cũng không, vì nó là đồ khốn, đồ khốn, đồ khốn.
Tao từng có một thằng bạn gọi tao là anh em, tao tin nó, nó biết gần hết mọi thứ về tao,
rồi nó quen đám người ngu, bám lấy chúng, trong nó có gì đó bị đảo ngược,
đá chảy ra từ mũi nó, ngày nào tao cũng thấy địa ngục,
ngoài phố ai cũng thế, thường là những đứa trẻ con không thể dừng lại,
thành phố đầy chúng, chúng tàn rồi, và tao chỉ có một cử chỉ dành cho chúng.

Ai muốn dùng gì thì dùng, bọn nghiện tao cóc quan tâm,
mày trải giường thế nào thì nằm dưới đáy thế ấy,
có thể rơi xuống đáy, mày đã đi sai đường,
nó như bùn lầy, một khi đã tóm được mày thì thường chẳng buông,
khiến mày làm những chuyện mà ngay cả người thân nhất cũng không tha thứ.
Bỏ ma túy đi, câu mà chẳng ai còn nhồi vào đầu mày nữa,
mày ngập đến tận tai, đám bạn mày cũng vậy,
cai nghiện, không căng thẳng, nghe nói như đi làm móng chân,
nếu chính mày không muốn, ác mộng chờ mày ngay,
sau hàng rào cả đống tay buôn đang chờ mày,
chớp mắt mày đã lao tới vệt bột,
rồi đừng ngạc nhiên khi cả tòa nhà thức trắng đêm,
đừng ngạc nhiên khi cai nghiện tạo ra những con quái vật còn lớn hơn,
cổng Bohnice mở ra, chúng chạy đi tìm bůra,
psago sạch như thiên nhiên.

Ai muốn dùng gì thì dùng, bọn nghiện tao cóc quan tâm,
mày trải giường thế nào thì nằm dưới đáy thế ấy,
có thể rơi xuống đáy, nó như bùn lầy,
giờ mày đã thấy cái lạnh rồi.
Ai muốn dùng gì thì dùng, bọn nghiện tao cóc quan tâm,
mày trải giường thế nào thì nằm dưới đáy thế ấy,
có thể rơi xuống đáy, nó như bùn lầy,
giờ mày đã thấy cái lạnh rồi.
Ai muốn dùng gì thì dùng, bọn nghiện tao cóc quan tâm,
mày trải giường thế nào thì nằm dưới đáy thế ấy,
có thể rơi xuống đáy, nó như bùn lầy,
giờ mày đã thấy cái lạnh rồi.
Ai muốn dùng gì thì dùng, bọn nghiện tao cóc quan tâm,
mày trải giường thế nào thì nằm dưới đáy thế ấy,
có thể rơi xuống đáy, nó như bùn lầy,
giờ mày đã thấy cái lạnh rồi.'
WHERE s.`name` = 'Trosky (feat. Babar)' AND l.`lang` = 'vi' AND l.`words` = 'Lũ đầu rỗng, tụi mày đã tắt máy từ lâu, sự tồn tại của tụi mày thật đáng ngờ,
gầy rộc đến ghê tởm, mặt mũi hốc hác, lũ bỏ đi tự hủy hoại chính mình,
những bản chất cháy khét với cả cuộc đời lộn ngược, khô quắt như lạc đà,
làm bộ như ngôi sao hàng đầu, trong khi mày là đống sắt vụn của một chiếc xe xịn, kẻ đã phá nát đời mình,
những mạch máu đầy vết kim cho mày thêm sức, mày chỉ sống vì khoảnh khắc được nhồi đầy thứ bột trắng.
Lũ tàn tạ với bộ não chưa phát triển, dọn sạch căn hộ để đổi lấy bột trắng, không có hàng thì chẳng sống nổi,
chúng trộm cả gia đình mình, trong một giờ phá nát bao năm gia đình sẵn sàng đặt tay vào lửa vì chúng.
Một đống ô nhục thay cho những hạt sồi được dạy dỗ tử tế,
những ảo ảnh không tương lai mà chính chúng đã chôn vùi,
chúng chẳng hiểu mình thực sự đã bước vào cái gì,
rằng chẳng dễ gì thoát ra, rằng chúng không chỉ say rượu.
Tụi mày tệ như cái hệ tiêu hóa ngu ngốc của mày,
lũ động vật có vú hút nó không ngừng nghỉ,
cuộc đua nghiện ngập đẩy tụi mày tới chỗ đâm dao khi không có liều tiếp theo,
những bước này không thể rút lại,
hắn thành kẻ giết người vì một nhúm bột chết tiệt,
máu trên tay không thể rửa sạch nữa,
giờ mày không biết sống sao với tội ác này,
giờ mày mới tỉnh ra, cảm giác bất lực đâm vào mày,
từ sáng tới đêm mày nghĩ mình là ai, mày là kẻ ác,
mày tiêu rồi, thằng kia, trong tù người ta đã mài răng chờ cái mông mày,
trước cả khi gục ngã, mày lờ đờ lang thang trong phòng giam,
cơn mê sảng kết thúc và túi đã trống trơn,
tất cả hút sạch, trong đầu bị xóa trắng, đúng rồi, mày đáng bị vậy.
Mày co giò chạy, chạy như một đứa trẻ,
mày không muốn vào sau song sắt, nhưng đằng nào nó cũng đến,
cối xay của Chúa vẫn nghiền, chúng mang mày theo,
mày đánh rơi xà phòng, giờ hai đứa chơi mày,
vì tội của mày, mười năm làm "mẹ" trong đó,
một chương trình thú vị đã được chuẩn bị sẵn cho mày,
với thân hình gầy gò, mày không thể tự vệ,
ngày nào ai cũng có thể thoải mái chơi mày,
mày còn chẳng ngồi nổi nữa, mày thà chết quách
còn hơn để chúng lại đến chơi mày,
đêm nào mày cũng ngủ trong trầm cảm vì đã thành con nghiện, vì đã đi một con đường thật tồi tệ.

Tao từng có một em ra vẻ mình đẳng cấp lắm,
nhưng mày biết đấy, vài tuần sau tao nhận ra từ lâu trước khi bọn tao quen nhau nó đã nghiện "phấn",
nghe nói đá cho nó đôi cánh và nó muốn bay,
tao thôi hôn nó, chẳng muốn cởi đồ, liếm, chơi hay chiều theo nó,
cũng không, vì nó là đồ khốn, đồ khốn, đồ khốn.
Tao từng có một thằng bạn gọi tao là anh em, tao tin nó, nó biết gần hết mọi thứ về tao,
rồi nó quen đám người ngu, bám lấy chúng, trong nó có gì đó bị đảo ngược,
đá chảy ra từ mũi nó, ngày nào tao cũng thấy địa ngục,
ngoài phố ai cũng thế, thường là những đứa trẻ con không thể dừng lại,
thành phố đầy chúng, chúng tàn rồi, và tao chỉ có một cử chỉ dành cho chúng.

Ai muốn dùng gì thì dùng, bọn nghiện tao cóc quan tâm,
mày trải giường thế nào thì nằm dưới đáy thế ấy,
có thể rơi xuống đáy, mày đã đi sai đường,
nó như bùn lầy, một khi đã tóm được mày thì thường chẳng buông,
khiến mày làm những chuyện mà ngay cả người thân nhất cũng không tha thứ.
Bỏ ma túy đi, câu mà chẳng ai còn nhồi vào đầu mày nữa,
mày ngập đến tận tai, đám bạn mày cũng vậy,
cai nghiện, không căng thẳng, nghe nói như đi làm móng chân,
nếu chính mày không muốn, ác mộng chờ mày ngay,
sau hàng rào cả đống tay buôn đang chờ mày,
chớp mắt mày đã lao tới vệt bột,
rồi đừng ngạc nhiên khi cả tòa nhà thức trắng đêm,
đừng ngạc nhiên khi cai nghiện tạo ra những con quái vật còn lớn hơn,
cổng Bohnice mở ra, chúng chạy đi tìm bůra,
psago sạch như thiên nhiên.

Ai muốn dùng gì thì dùng, bọn nghiện tao cóc quan tâm,
mày trải giường thế nào thì nằm dưới đáy thế ấy,
có thể rơi xuống đáy, nó như bùn lầy,
giờ mày đã thấy cái lạnh rồi.
(4×)';

-- Úplně vzadu (cs)
UPDATE `lyrics` l JOIN `songs` s ON s.`id` = l.`song_id`
SET l.`words` = 'Můžeš prosit, můžeš klečet, můžeš brečet dál,
nikoho to nezajímá, na všechno jsi tady sám.
Všechny problémy ti v mžiku před očima proběhnou,
však každej kráčí svou cestou trnitou.
Můžeš prosit, můžeš klečet, můžeš brečet dál,
nikoho to nezajímá, na všechno jsi tady sám.
Všechny problémy ti v mžiku před očima proběhnou,
však každej kráčí svou cestou trnitou.
Můžeš prosit, můžeš klečet, můžeš brečet dál,
nikoho to nezajímá, na všechno jsi tady sám.
Všechny problémy ti v mžiku před očima proběhnou,
však každej kráčí svou cestou trnitou.
Můžeš prosit, můžeš klečet, můžeš brečet dál,
nikoho to nezajímá, na všechno jsi tady sám.
Všechny problémy ti v mžiku před očima proběhnou,
však každej kráčí svou cestou trnitou.

Topíš se v dluzích, zlepšení nehrozí,
dvanáct hodin v kuse v práci, občané nebozí,
na děti nemaj čas, musí makat, spát, ráno vstát,
mnohokrát si přesčas brát, aby to jakž takž utáh.
Zažil jsi toho tolik, že už tě nic nepřekvapí,
nečekaný podepsání výpovědi v zaměstnání,
zaměstnání tě dohání až k doznání o posrání při poznání sociální mzdy,
za kterou máš cálovat složenky.
Zbývaj oči pro pláč, už nezbyl ani drobák,
zbyl jen další somrák, co to daleko nedotáh,
i tak každý další ráno poslušná ovce doplňuje stádo,
někdo pro žrádlo, někdo pro párno,
nechá ze sebe i kůži stáhnout.
Hromada fází, jak se sny ztrácí, někde tam v dáli ty stromy přání, co se furt kácí,
i když se bráníš, i když máš zdání, že to doháníš,
může nastat zvrat, a jak pak vstát s pocitem, že není o co stát.
Bylo to OK, teďka na práškách v bílym hávu, úplně vzadu,
postupně slábne, postupně sáhne po tom, co zdá se v tu chvíli správné,
za čórky drogy a chlast, rodina stranou, jde z něj strach,
už to není ten chlap, už to bohužel vzdal,
už to bylo fakt moc, našli ho na stromě minulou noc,
na papír napsal poslední sloh a nakonec, že dělal, co moh.

Můžeš prosit, můžeš klečet, můžeš brečet dál,
nikoho to nezajímá, na všechno jsi tady sám.
Všechny problémy ti v mžiku před očima proběhnou,
však každej kráčí svou cestou trnitou.
Můžeš prosit, můžeš klečet, můžeš brečet dál,
nikoho to nezajímá, na všechno jsi tady sám.
Všechny problémy ti v mžiku před očima proběhnou,
však každej kráčí svou cestou trnitou.'
WHERE s.`name` = 'Úplně vzadu' AND l.`lang` = 'cs' AND l.`words` = 'Můžeš prosit, můžeš klečet, můžeš brečet dál,
nikoho to nezajímá, na všechno jsi tady sám.
Všechny problémy ti v mžiku před očima proběhnou,
však každej kráčí svou cestou trnitou.
(4×)

Topíš se v dluzích, zlepšení nehrozí,
dvanáct hodin v kuse v práci, občané nebozí,
na děti nemaj čas, musí makat, spát, ráno vstát,
mnohokrát si přesčas brát, aby to jakž takž utáh.
Zažil jsi toho tolik, že už tě nic nepřekvapí,
nečekaný podepsání výpovědi v zaměstnání,
zaměstnání tě dohání až k doznání o posrání při poznání sociální mzdy,
za kterou máš cálovat složenky.
Zbývaj oči pro pláč, už nezbyl ani drobák,
zbyl jen další somrák, co to daleko nedotáh,
i tak každý další ráno poslušná ovce doplňuje stádo,
někdo pro žrádlo, někdo pro párno,
nechá ze sebe i kůži stáhnout.
Hromada fází, jak se sny ztrácí, někde tam v dáli ty stromy přání, co se furt kácí,
i když se bráníš, i když máš zdání, že to doháníš,
může nastat zvrat, a jak pak vstát s pocitem, že není o co stát.
Bylo to OK, teďka na práškách v bílym hávu, úplně vzadu,
postupně slábne, postupně sáhne po tom, co zdá se v tu chvíli správné,
za čórky drogy a chlast, rodina stranou, jde z něj strach,
už to není ten chlap, už to bohužel vzdal,
už to bylo fakt moc, našli ho na stromě minulou noc,
na papír napsal poslední sloh a nakonec, že dělal, co moh.

Můžeš prosit, můžeš klečet, můžeš brečet dál,
nikoho to nezajímá, na všechno jsi tady sám.
Všechny problémy ti v mžiku před očima proběhnou,
však každej kráčí svou cestou trnitou.
(2×)';

-- Úplně vzadu (de)
UPDATE `lyrics` l JOIN `songs` s ON s.`id` = l.`song_id`
SET l.`words` = 'Du kannst betteln, du kannst knien, du kannst weiterweinen,
es interessiert niemanden, mit allem bist du hier allein.
Alle Probleme ziehen dir im Nu vor den Augen vorbei,
doch jeder geht seinen eigenen dornigen Weg.
Du kannst betteln, du kannst knien, du kannst weiterweinen,
es interessiert niemanden, mit allem bist du hier allein.
Alle Probleme ziehen dir im Nu vor den Augen vorbei,
doch jeder geht seinen eigenen dornigen Weg.
Du kannst betteln, du kannst knien, du kannst weiterweinen,
es interessiert niemanden, mit allem bist du hier allein.
Alle Probleme ziehen dir im Nu vor den Augen vorbei,
doch jeder geht seinen eigenen dornigen Weg.
Du kannst betteln, du kannst knien, du kannst weiterweinen,
es interessiert niemanden, mit allem bist du hier allein.
Alle Probleme ziehen dir im Nu vor den Augen vorbei,
doch jeder geht seinen eigenen dornigen Weg.

Du ertrinkst in Schulden, Besserung droht nicht,
zwölf Stunden am Stück auf der Arbeit, arme Bürger,
für die Kinder haben sie keine Zeit, sie müssen schuften, schlafen, morgens aufstehen,
immer wieder Überstunden nehmen, damit es irgendwie reicht.
Du hast so viel erlebt, dass dich nichts mehr überrascht,
eine unerwartete Kündigung auf der Arbeit,
die Arbeit treibt dich bis zum Geständnis, dass du dir in die Hose machst, als du vom Sozialgeld erfährst,
von dem du die Rechnungen zahlen sollst.
Es bleiben nur Augen zum Weinen, nicht mal Kleingeld ist übrig,
übrig ist nur noch ein Penner, der es nicht weit gebracht hat,
und trotzdem ergänzt jeden weiteren Morgen ein gehorsames Schaf die Herde,
manche fürs Fressen, manche fürs Crystal,
sie lassen sich sogar die Haut abziehen.
Ein Haufen Phasen, wie Träume verschwinden, irgendwo dort in der Ferne werden die Wunschbäume ständig gefällt,
auch wenn du dich wehrst, auch wenn du glaubst, dass du aufholst,
kann eine Wende kommen, und wie stehst du dann auf mit dem Gefühl, dass es nichts gibt, wofür es sich lohnt.
Es war OK, jetzt auf Tabletten im weißen Gewand, ganz hinten,
er wird allmählich schwächer, greift allmählich nach dem, was ihm in dem Moment richtig scheint,
für Geklautes Drogen und Schnaps, die Familie beiseite, er macht Angst,
er ist nicht mehr der Kerl von früher, er hat leider aufgegeben,
es war wirklich zu viel, sie fanden ihn letzte Nacht an einem Baum,
auf Papier schrieb er seinen letzten Aufsatz und am Ende, dass er tat, was er konnte.

Du kannst betteln, du kannst knien, du kannst weiterweinen,
es interessiert niemanden, mit allem bist du hier allein.
Alle Probleme ziehen dir im Nu vor den Augen vorbei,
doch jeder geht seinen eigenen dornigen Weg.
Du kannst betteln, du kannst knien, du kannst weiterweinen,
es interessiert niemanden, mit allem bist du hier allein.
Alle Probleme ziehen dir im Nu vor den Augen vorbei,
doch jeder geht seinen eigenen dornigen Weg.'
WHERE s.`name` = 'Úplně vzadu' AND l.`lang` = 'de' AND l.`words` = 'Du kannst betteln, du kannst knien, du kannst weiterweinen,
es interessiert niemanden, mit allem bist du hier allein.
Alle Probleme ziehen dir im Nu vor den Augen vorbei,
doch jeder geht seinen eigenen dornigen Weg.
(4×)

Du ertrinkst in Schulden, Besserung droht nicht,
zwölf Stunden am Stück auf der Arbeit, arme Bürger,
für die Kinder haben sie keine Zeit, sie müssen schuften, schlafen, morgens aufstehen,
immer wieder Überstunden nehmen, damit es irgendwie reicht.
Du hast so viel erlebt, dass dich nichts mehr überrascht,
eine unerwartete Kündigung auf der Arbeit,
die Arbeit treibt dich bis zum Geständnis, dass du dir in die Hose machst, als du vom Sozialgeld erfährst,
von dem du die Rechnungen zahlen sollst.
Es bleiben nur Augen zum Weinen, nicht mal Kleingeld ist übrig,
übrig ist nur noch ein Penner, der es nicht weit gebracht hat,
und trotzdem ergänzt jeden weiteren Morgen ein gehorsames Schaf die Herde,
manche fürs Fressen, manche fürs Crystal,
sie lassen sich sogar die Haut abziehen.
Ein Haufen Phasen, wie Träume verschwinden, irgendwo dort in der Ferne werden die Wunschbäume ständig gefällt,
auch wenn du dich wehrst, auch wenn du glaubst, dass du aufholst,
kann eine Wende kommen, und wie stehst du dann auf mit dem Gefühl, dass es nichts gibt, wofür es sich lohnt.
Es war OK, jetzt auf Tabletten im weißen Gewand, ganz hinten,
er wird allmählich schwächer, greift allmählich nach dem, was ihm in dem Moment richtig scheint,
für Geklautes Drogen und Schnaps, die Familie beiseite, er macht Angst,
er ist nicht mehr der Kerl von früher, er hat leider aufgegeben,
es war wirklich zu viel, sie fanden ihn letzte Nacht an einem Baum,
auf Papier schrieb er seinen letzten Aufsatz und am Ende, dass er tat, was er konnte.

Du kannst betteln, du kannst knien, du kannst weiterweinen,
es interessiert niemanden, mit allem bist du hier allein.
Alle Probleme ziehen dir im Nu vor den Augen vorbei,
doch jeder geht seinen eigenen dornigen Weg.
(2×)';

-- Úplně vzadu (en)
UPDATE `lyrics` l JOIN `songs` s ON s.`id` = l.`song_id`
SET l.`words` = 'You can beg, you can kneel, you can keep on crying,
nobody cares, you''re on your own with everything.
All your problems flash before your eyes in an instant,
but everyone walks their own thorny path.
You can beg, you can kneel, you can keep on crying,
nobody cares, you''re on your own with everything.
All your problems flash before your eyes in an instant,
but everyone walks their own thorny path.
You can beg, you can kneel, you can keep on crying,
nobody cares, you''re on your own with everything.
All your problems flash before your eyes in an instant,
but everyone walks their own thorny path.
You can beg, you can kneel, you can keep on crying,
nobody cares, you''re on your own with everything.
All your problems flash before your eyes in an instant,
but everyone walks their own thorny path.

You''re drowning in debt, no improvement in sight,
twelve hours straight at work, poor citizens,
no time for their kids, they have to work, sleep, get up in the morning,
take overtime again and again just to scrape by.
You''ve been through so much that nothing surprises you anymore,
an unexpected notice of dismissal at work,
work drives you to admit you''re shitting yourself when you find out about the welfare wage,
that you''re supposed to pay your bills with.
All that''s left is tears, there''s not even small change left,
just another beggar left who didn''t get far,
and still, every next morning an obedient sheep joins the herd,
some for grub, some for meth,
they''ll even let the skin be stripped off them.
A pile of phases, how dreams fade, somewhere far away the trees of wishes keep being cut down,
even when you fight back, even when you think you''re catching up,
a twist can come, and how do you get up then, feeling there''s nothing worth standing for.
It was OK, now on pills in a white gown, way at the back,
slowly getting weaker, slowly reaching for what seems right at that moment,
drugs and booze for stolen stuff, family pushed aside, he''s frightening,
he''s not that guy anymore, he''s sadly given up,
it was really too much, they found him on a tree last night,
on paper he wrote his last essay, and at the end, that he did what he could.

You can beg, you can kneel, you can keep on crying,
nobody cares, you''re on your own with everything.
All your problems flash before your eyes in an instant,
but everyone walks their own thorny path.
You can beg, you can kneel, you can keep on crying,
nobody cares, you''re on your own with everything.
All your problems flash before your eyes in an instant,
but everyone walks their own thorny path.'
WHERE s.`name` = 'Úplně vzadu' AND l.`lang` = 'en' AND l.`words` = 'You can beg, you can kneel, you can keep on crying,
nobody cares, you''re on your own with everything.
All your problems flash before your eyes in an instant,
but everyone walks their own thorny path.
(4×)

You''re drowning in debt, no improvement in sight,
twelve hours straight at work, poor citizens,
no time for their kids, they have to work, sleep, get up in the morning,
take overtime again and again just to scrape by.
You''ve been through so much that nothing surprises you anymore,
an unexpected notice of dismissal at work,
work drives you to admit you''re shitting yourself when you find out about the welfare wage,
that you''re supposed to pay your bills with.
All that''s left is tears, there''s not even small change left,
just another beggar left who didn''t get far,
and still, every next morning an obedient sheep joins the herd,
some for grub, some for meth,
they''ll even let the skin be stripped off them.
A pile of phases, how dreams fade, somewhere far away the trees of wishes keep being cut down,
even when you fight back, even when you think you''re catching up,
a twist can come, and how do you get up then, feeling there''s nothing worth standing for.
It was OK, now on pills in a white gown, way at the back,
slowly getting weaker, slowly reaching for what seems right at that moment,
drugs and booze for stolen stuff, family pushed aside, he''s frightening,
he''s not that guy anymore, he''s sadly given up,
it was really too much, they found him on a tree last night,
on paper he wrote his last essay, and at the end, that he did what he could.

You can beg, you can kneel, you can keep on crying,
nobody cares, you''re on your own with everything.
All your problems flash before your eyes in an instant,
but everyone walks their own thorny path.
(2×)';

-- Úplně vzadu (uk)
UPDATE `lyrics` l JOIN `songs` s ON s.`id` = l.`song_id`
SET l.`words` = 'Можеш благати, можеш стояти на колінах, можеш далі плакати,
нікого це не цікавить, з усім ти тут сам.
Усі проблеми вмить промайнуть перед твоїми очима,
та кожен іде своїм тернистим шляхом.
Можеш благати, можеш стояти на колінах, можеш далі плакати,
нікого це не цікавить, з усім ти тут сам.
Усі проблеми вмить промайнуть перед твоїми очима,
та кожен іде своїм тернистим шляхом.
Можеш благати, можеш стояти на колінах, можеш далі плакати,
нікого це не цікавить, з усім ти тут сам.
Усі проблеми вмить промайнуть перед твоїми очима,
та кожен іде своїм тернистим шляхом.
Можеш благати, можеш стояти на колінах, можеш далі плакати,
нікого це не цікавить, з усім ти тут сам.
Усі проблеми вмить промайнуть перед твоїми очима,
та кожен іде своїм тернистим шляхом.

Ти тонеш у боргах, покращення не загрожує,
дванадцять годин поспіль на роботі, бідолашні громадяни,
на дітей не мають часу, мусять пахати, спати, вранці вставати,
знову й знову брати понаднормові, щоб сяк-так протягнути.
Ти пережив стільки, що тебе вже ніщо не дивує,
несподіване підписання звільнення з роботи,
робота доводить тебе до зізнання, що ти обісрався, коли дізнався про соціальну зарплату,
з якої ти маєш платити рахунки.
Лишаються очі для плачу, не лишилося навіть дрібняків,
лишився лише ще один жебрак, який далеко не зайшов,
і все одно кожного наступного ранку слухняна вівця поповнює стадо,
хтось заради жратви, хтось заради перуку,
дасть навіть шкуру з себе здерти.
Купа фаз, як зникають мрії, десь там удалині дерева бажань, які весь час рубають,
навіть коли ти боронишся, навіть коли тобі здається, що ти наздоганяєш,
може статися поворот, і як тоді встати з відчуттям, що немає за що стояти.
Було все ОК, тепер на пігулках у білому вбранні, у самому кінці,
поступово слабне, поступово тягнеться до того, що в ту мить здається правильним,
за крадене — наркота й випивка, сім''я осторонь, від нього віє страхом,
він уже не той чоловік, він, на жаль, здався,
це вже було справді забагато, його знайшли на дереві минулої ночі,
на папері він написав свій останній твір, а наприкінці — що робив, що міг.

Можеш благати, можеш стояти на колінах, можеш далі плакати,
нікого це не цікавить, з усім ти тут сам.
Усі проблеми вмить промайнуть перед твоїми очима,
та кожен іде своїм тернистим шляхом.
Можеш благати, можеш стояти на колінах, можеш далі плакати,
нікого це не цікавить, з усім ти тут сам.
Усі проблеми вмить промайнуть перед твоїми очима,
та кожен іде своїм тернистим шляхом.'
WHERE s.`name` = 'Úplně vzadu' AND l.`lang` = 'uk' AND l.`words` = 'Можеш благати, можеш стояти на колінах, можеш далі плакати,
нікого це не цікавить, з усім ти тут сам.
Усі проблеми вмить промайнуть перед твоїми очима,
та кожен іде своїм тернистим шляхом.
(4×)

Ти тонеш у боргах, покращення не загрожує,
дванадцять годин поспіль на роботі, бідолашні громадяни,
на дітей не мають часу, мусять пахати, спати, вранці вставати,
знову й знову брати понаднормові, щоб сяк-так протягнути.
Ти пережив стільки, що тебе вже ніщо не дивує,
несподіване підписання звільнення з роботи,
робота доводить тебе до зізнання, що ти обісрався, коли дізнався про соціальну зарплату,
з якої ти маєш платити рахунки.
Лишаються очі для плачу, не лишилося навіть дрібняків,
лишився лише ще один жебрак, який далеко не зайшов,
і все одно кожного наступного ранку слухняна вівця поповнює стадо,
хтось заради жратви, хтось заради перуку,
дасть навіть шкуру з себе здерти.
Купа фаз, як зникають мрії, десь там удалині дерева бажань, які весь час рубають,
навіть коли ти боронишся, навіть коли тобі здається, що ти наздоганяєш,
може статися поворот, і як тоді встати з відчуттям, що немає за що стояти.
Було все ОК, тепер на пігулках у білому вбранні, у самому кінці,
поступово слабне, поступово тягнеться до того, що в ту мить здається правильним,
за крадене — наркота й випивка, сім''я осторонь, від нього віє страхом,
він уже не той чоловік, він, на жаль, здався,
це вже було справді забагато, його знайшли на дереві минулої ночі,
на папері він написав свій останній твір, а наприкінці — що робив, що міг.

Можеш благати, можеш стояти на колінах, можеш далі плакати,
нікого це не цікавить, з усім ти тут сам.
Усі проблеми вмить промайнуть перед твоїми очима,
та кожен іде своїм тернистим шляхом.
(2×)';

-- Úplně vzadu (vi)
UPDATE `lyrics` l JOIN `songs` s ON s.`id` = l.`song_id`
SET l.`words` = 'Bạn có thể van xin, có thể quỳ gối, có thể khóc mãi,
chẳng ai quan tâm, mọi thứ bạn phải tự gánh lấy.
Mọi vấn đề lướt qua trước mắt bạn trong chớp mắt,
nhưng ai cũng phải bước trên con đường đầy gai của riêng mình.
Bạn có thể van xin, có thể quỳ gối, có thể khóc mãi,
chẳng ai quan tâm, mọi thứ bạn phải tự gánh lấy.
Mọi vấn đề lướt qua trước mắt bạn trong chớp mắt,
nhưng ai cũng phải bước trên con đường đầy gai của riêng mình.
Bạn có thể van xin, có thể quỳ gối, có thể khóc mãi,
chẳng ai quan tâm, mọi thứ bạn phải tự gánh lấy.
Mọi vấn đề lướt qua trước mắt bạn trong chớp mắt,
nhưng ai cũng phải bước trên con đường đầy gai của riêng mình.
Bạn có thể van xin, có thể quỳ gối, có thể khóc mãi,
chẳng ai quan tâm, mọi thứ bạn phải tự gánh lấy.
Mọi vấn đề lướt qua trước mắt bạn trong chớp mắt,
nhưng ai cũng phải bước trên con đường đầy gai của riêng mình.

Bạn chìm trong nợ nần, chẳng có dấu hiệu khá lên,
mười hai tiếng liền ở chỗ làm, những công dân khốn khổ,
chẳng có thời gian cho con cái, phải cày, ngủ, sáng dậy,
hết lần này đến lần khác làm thêm giờ chỉ để tạm đủ sống.
Bạn đã trải qua quá nhiều đến mức chẳng gì làm bạn ngạc nhiên nữa,
bất ngờ phải ký giấy thôi việc ở chỗ làm,
công việc đẩy bạn đến mức thú nhận rằng bạn sợ vãi ra quần khi biết mức lương trợ cấp,
mà với nó bạn phải trả các hóa đơn.
Chỉ còn đôi mắt để khóc, đến một xu lẻ cũng chẳng còn,
chỉ còn thêm một kẻ ăn xin chẳng đi được xa,
vậy mà mỗi sáng tiếp theo một con cừu ngoan ngoãn lại nhập vào đàn,
người vì miếng ăn, người vì thuốc đá,
để người ta lột cả da mình.
Một đống giai đoạn, giấc mơ tan biến thế nào, đâu đó xa xa những cây ước nguyện cứ bị đốn hạ,
dù bạn có chống cự, dù bạn tưởng mình đang bắt kịp,
một bước ngoặt có thể đến, và khi đó làm sao đứng dậy với cảm giác chẳng còn gì đáng để đứng lên.
Mọi thứ từng ổn, giờ thì uống thuốc trong bộ áo trắng, tận cuối hàng,
dần dần yếu đi, dần dần với lấy thứ có vẻ đúng vào khoảnh khắc ấy,
đồ ăn cắp đổi lấy ma túy và rượu, gia đình bị gạt sang bên, ở anh ta toát ra nỗi sợ,
anh ta không còn là gã đàn ông ấy nữa, tiếc là anh ta đã buông xuôi,
quá sức thật rồi, người ta tìm thấy anh ta trên một cái cây đêm qua,
trên giấy anh ta viết bài văn cuối cùng, và ở cuối, rằng anh ta đã làm những gì có thể.

Bạn có thể van xin, có thể quỳ gối, có thể khóc mãi,
chẳng ai quan tâm, mọi thứ bạn phải tự gánh lấy.
Mọi vấn đề lướt qua trước mắt bạn trong chớp mắt,
nhưng ai cũng phải bước trên con đường đầy gai của riêng mình.
Bạn có thể van xin, có thể quỳ gối, có thể khóc mãi,
chẳng ai quan tâm, mọi thứ bạn phải tự gánh lấy.
Mọi vấn đề lướt qua trước mắt bạn trong chớp mắt,
nhưng ai cũng phải bước trên con đường đầy gai của riêng mình.'
WHERE s.`name` = 'Úplně vzadu' AND l.`lang` = 'vi' AND l.`words` = 'Bạn có thể van xin, có thể quỳ gối, có thể khóc mãi,
chẳng ai quan tâm, mọi thứ bạn phải tự gánh lấy.
Mọi vấn đề lướt qua trước mắt bạn trong chớp mắt,
nhưng ai cũng phải bước trên con đường đầy gai của riêng mình.
(4×)

Bạn chìm trong nợ nần, chẳng có dấu hiệu khá lên,
mười hai tiếng liền ở chỗ làm, những công dân khốn khổ,
chẳng có thời gian cho con cái, phải cày, ngủ, sáng dậy,
hết lần này đến lần khác làm thêm giờ chỉ để tạm đủ sống.
Bạn đã trải qua quá nhiều đến mức chẳng gì làm bạn ngạc nhiên nữa,
bất ngờ phải ký giấy thôi việc ở chỗ làm,
công việc đẩy bạn đến mức thú nhận rằng bạn sợ vãi ra quần khi biết mức lương trợ cấp,
mà với nó bạn phải trả các hóa đơn.
Chỉ còn đôi mắt để khóc, đến một xu lẻ cũng chẳng còn,
chỉ còn thêm một kẻ ăn xin chẳng đi được xa,
vậy mà mỗi sáng tiếp theo một con cừu ngoan ngoãn lại nhập vào đàn,
người vì miếng ăn, người vì thuốc đá,
để người ta lột cả da mình.
Một đống giai đoạn, giấc mơ tan biến thế nào, đâu đó xa xa những cây ước nguyện cứ bị đốn hạ,
dù bạn có chống cự, dù bạn tưởng mình đang bắt kịp,
một bước ngoặt có thể đến, và khi đó làm sao đứng dậy với cảm giác chẳng còn gì đáng để đứng lên.
Mọi thứ từng ổn, giờ thì uống thuốc trong bộ áo trắng, tận cuối hàng,
dần dần yếu đi, dần dần với lấy thứ có vẻ đúng vào khoảnh khắc ấy,
đồ ăn cắp đổi lấy ma túy và rượu, gia đình bị gạt sang bên, ở anh ta toát ra nỗi sợ,
anh ta không còn là gã đàn ông ấy nữa, tiếc là anh ta đã buông xuôi,
quá sức thật rồi, người ta tìm thấy anh ta trên một cái cây đêm qua,
trên giấy anh ta viết bài văn cuối cùng, và ở cuối, rằng anh ta đã làm những gì có thể.

Bạn có thể van xin, có thể quỳ gối, có thể khóc mãi,
chẳng ai quan tâm, mọi thứ bạn phải tự gánh lấy.
Mọi vấn đề lướt qua trước mắt bạn trong chớp mắt,
nhưng ai cũng phải bước trên con đường đầy gai của riêng mình.
(2×)';
