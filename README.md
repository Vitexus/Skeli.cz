# Skeli.cz

Java (Jakarta Servlet + JSP), MariaDB, Flyway. Oficiální web Skeli.

## Požadavky
- Java 21+, Maven 3.9+
- MariaDB 10.6+ (dev: DB `skeliweb`; test prostředí: `skelitest`)

## Rychlý start (dev)
```bash
cp .env.example .env   # doplň DB_*, SMTP_*, … 
mvn -q flyway:migrate
mvn -q -Djetty.port=8080 jetty:run
```
Aplikace: http://localhost:8080/

## Databáze
Flyway skripty: `src/main/resources/db/migration` (`V{n}__….sql`).

```bash
mvn -q flyway:info
mvn -q flyway:migrate
# override:
mvn -q -Dflyway.url=jdbc:mariadb://localhost:3306/skelitest \
  -Dflyway.user=Skeli -Dflyway.password=… flyway:migrate
```

Prostředí:
| Větev / host | DB (typicky) |
|---|---|
| lokálně | `skeliweb` |
| [test.skeli.cz](https://test.skeli.cz) (`main`) | `skelitest` |
| [skeli.cz](https://skeli.cz) (`production`) | produkční DB |

## Veřejné URL písní (SEO)
Kanonická adresa je **per jazyk**:
- `/{lang}/song/{seo-alias}` — např. `/cs/song/musis-odejit`, `/en/song/you-must-leave`
- `/{lang}/song/{uuid}` — fallback, pokud alias chybí
- `/song/{uuid}` → 301 na `/cs/song/{uuid}`

`hreflang` odkazy a `sitemap.xml` vypisují všechny jazykové varianty s textem.

UUID písně je stabilní identifikátor (sdílení, admin). SEO alias a meta popisek se ukládají u řádku `lyrics` (jazyk).

## RSS / Atom feedy
`/{lang}/feed/{druh}.{formát}` pro `cs | en | de | uk`:

| Druh | Obsah |
|---|---|
| `songs` | nové texty písní v daném jazyce (popis + odkaz, ne celý text) |
| `videos` | YouTube videa a shorts |
| `news` | aktuality: příspěvky ze sociálních sítí (`social_posts`) + shorts |
| `all` | vše dohromady, bez duplicit |

Formát `rss` (RSS 2.0) nebo `atom` (Atom 1.0), např. `/cs/feed/all.rss`, `/en/feed/songs.atom`.
`/feed` → 301 na `/{jazyk návštěvníka}/feed/all.rss`. Parametr `?limit=` 1–100 (výchozí 30).

- Položky mají náhled (Media RSS `media:thumbnail`), u videí `media:player`, krátké HTML v `content:encoded` / `content`.
- Hotový feed se drží 5 min v paměti; `ETag` / `Last-Modified` → odpověď 304. Při výpadku DB se pošle poslední verze, jinak 503.
- Stránky feedy inzerují v `<head>` (`<link rel="alternate" type="application/rss+xml|atom+xml">`):
  texty/detail písně → `songs`, hudba → `videos`, aktuality → `news`, všude navíc `all`. V patičce je ikona RSS.
- Písně se řadí podle data vydání (`songs.published_at`, v adminu pole **Vydáno**) nebo podle přidání jazykové verze, co je později.
- ID položek (`tag:skeli.cz,2025:…`) se nesmí měnit, čtečky by vše ukázaly jako nové.

Kód: `FeedServlet`, `dao/FeedDao`, `service/FeedWriter`, `model/FeedItem`.

## Admin — hub písně
`/admin/songs` → `/admin/song?uuid=…`

- Základní údaje (název, rok, datum vydání pro RSS), preview/OG obrázek (ořez 16:9), Apple Music / Spotify, YouTube
- Záložky **cs / en / de / uk**: text, SEO URL, meta popis
- Tlačítko **Přeložit z CS** (DeepL nebo LibreTranslate)

```env
DEEPL_API_KEY=xxxxxxxx:fx
DEEPL_FREE=1
# nebo:
LIBRETRANSLATE_URL=http://localhost:5000
```

## Testy
Unit (bez serveru):
```bash
mvn -q -Dtest='!*IT' test
```

Selenium IT (běžící Jetty + DB):
```bash
mvn -q -Djetty.port=8080 jetty:run &
mvn -q -Dtest='*IT' -Dit.baseUrl=http://localhost:8080 test
# proti testu:
mvn -q -Dtest=MusicPageIT -Dit.baseUrl=https://test.skeli.cz test
```

## Deploy
GitHub Actions (`.github/workflows/deploy.yml`):
- push `main` → test.skeli.cz (Flyway z `.env`, pak WAR / restart `skeli-test`)
- push `production` → skeli.cz

## Bezpečnost
- `/admin/*` — `AdminFilter` (role `ADMIN`)
- CSRF na state-changing requesty (`CsrfFilter`; multipart ověřuje servlet)
- Prepared statements, `c:out` / escape v JSP
