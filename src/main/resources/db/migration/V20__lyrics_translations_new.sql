START TRANSACTION;

-- English translations
INSERT INTO lyrics_translations(lyric_id, lang, words)
SELECT l.id, 'en', 'Do you feel that cold when you''re kneeling on the floor,
around you only time flows, you''ve got no support anymore.
You feel alone, like inside a wasteland,
you see the memories you''d like to set on fire.

You want to forget everything that drags you down,
empty bottles falling off the table now.
You want to forget all those days
when he told you he''d make all your dreams come true.

You felt safe in each of his hugs,
now your heart is scarred, cut up with lies.
The only thing you want to live for is the child you have with him,
she is the only thing that matters to you now.

Your smile left long ago, you''ve been through it for the hundredth time,
so don''t be naive — you won''t change a tyrant just like that.
You look into her eyes while tears run down your face,
there''s no other option, you know you must leave.

Now you know.

How hard it is
to be here alone for everything.
Grit your teeth, stand up and don''t be afraid to go on.
You must start dreaming again of those days
when you were full of strength.
Forget how many times he beat you
when he got so drunk.
Pack your things and go away,
you''ll manage without him.
She is your armor now,
your will to carry on.
You''ve suffered your share,
together you''ll burn the bridge.

Stay — go — stay — stay —
no place to go — you''ll find a way —
he''ll change — you don''t believe it anymore —
you can''t do it without him — for her you must!!!

Now you write the script yourself,
he doesn''t have to hurt you anymore,
so the little one will grow up without a drunk dad.
She will understand you couldn''t let him beat you
and that you can never go back to him.

Now you''re stronger than you ever were,
it took courage to resist him — you found it only with her.
Now everything will get better, you took your chance,
no more mornings to fear — he''s no longer sleeping next to you.
It was over the line and you crossed it,
you tolerated it for so many days,
you couldn''t even count how many times he hit you with his fist.

Now you know.

How many times did he hit you with his fist,
so how many times did he hit you with his fist,
he hit you with his fist.'
FROM songs s JOIN lyrics l ON l.song_id=s.id WHERE s.name='Musíš odejít' AND NOT EXISTS(SELECT 1 FROM lyrics_translations t WHERE t.lyric_id=l.id AND t.lang='en');

INSERT INTO lyrics_translations(lyric_id, lang, words)
SELECT l.id, 'en', 'Those cards were dealt a long time ago,
we reach out for things that will make us grow,
even unknowingly, like vassals below,
we deliver performance that others sell as their own.

Thinking of every next better day,
up early — come on sheep, let''s move on our way,
chew through the everyday process,
for alms we strip our skin away,
so they can have it fine, have it fine, have it fine.

From the top of the pyramid the world must look fine,
but what about the rest standing in its shadow line?
Did you ask them if they''re doing fine,
if they''re doing fine, if they''re doing fine?

Yesterday he came in a BMW, tomorrow he''ll buy a class higher ride,
in front of my house an old Fabia that''s starting to rust outside,
bills are piling, they twisted my pay slip tight,
a little for the fridge — my wallet''s light.

Those cards were dealt a long time ago,
we reach out for things that make us grow,
even unknowingly, like vassals below,
we deliver performance they sell as their own.

I say enough!!!

I take it into my own hands, I''ll go my way,
I''m done earning for someone else''s holiday.

So have a nice time, I''m catching the vibe and strike,
a padawan wants to hear that hype,
a padawan wants to get another like,
a padawan becomes a master and the misery fades for good,
hands clean now — with the plumber get lost for good.
I want to get more than pushing dirty pipes into walls,
I want to get more than pushing dirty pipes into walls.'
FROM songs s JOIN lyrics l ON l.song_id=s.id WHERE s.name='Fajn' AND NOT EXISTS(SELECT 1 FROM lyrics_translations t WHERE t.lyric_id=l.id AND t.lang='en');

INSERT INTO lyrics_translations(lyric_id, lang, words)
SELECT l.id, 'en', 'I haven''t even hit the scene and they wish that I''d die,
that I''d stub it out, that I''d stumble, that I''m a jerk with no lines,
not a thing — enough kitsch — I push into beats like wind that flies,
don''t expect dog crap, I bring a hit plus — go find a new prize,
after this shit she wants to be on my …

Get used to it, I''m starting business, got the leverage to switch life,
send it further, rise higher — a hard worker type,
stacking cheese, living better, sow top seed, blaze top weed,
start living, stop just getting by — throw wood onto the heat,
ignore the idiots, ahhh…

Throw wood onto the heat, ignore the idiots, ahhh… (x3)

The more heat, the more haters!
So many haters!'
FROM songs s JOIN lyrics l ON l.song_id=s.id WHERE s.name='Machine gun Skeli RMX' AND NOT EXISTS(SELECT 1 FROM lyrics_translations t WHERE t.lyric_id=l.id AND t.lang='en');

-- German translations
INSERT INTO lyrics_translations(lyric_id, lang, words)
SELECT l.id, 'de', 'Spürst du die Kälte, wenn du auf den Knien liegst,
um dich fließt nur die Zeit, keinen Halt mehr kriegst.
Du fühlst dich allein wie in einer Ödnis,
Erinnerungen, die du am liebsten verbrennen willst.
...
[gekürzt]'
FROM songs s JOIN lyrics l ON l.song_id=s.id WHERE s.name='Musíš odejít' AND NOT EXISTS(SELECT 1 FROM lyrics_translations t WHERE t.lyric_id=l.id AND t.lang='de');

-- Ukrainian translations
INSERT INTO lyrics_translations(lyric_id, lang, words)
SELECT l.id, 'uk', 'Відчуваєш той холод, коли стоїш навколішки,
довкола плине час, опори вже немає.
Ти почуваєшся самотньою, ніби в пустці,
спогади, які хочеться спалити.
...
[скорочено]'
FROM songs s JOIN lyrics l ON l.song_id=s.id WHERE s.name='Musíš odejít' AND NOT EXISTS(SELECT 1 FROM lyrics_translations t WHERE t.lyric_id=l.id AND t.lang='uk');

COMMIT;
