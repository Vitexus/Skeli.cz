# Skeli.cz

Java (Jakarta Servlet + JSP), MariaDB, Flyway. Cíl: moderní, bezpečný web.

## Požadavky
- Java 17+, Maven 3.9+
- MariaDB 10.6+ (uživatel `Skeli` / `skeli`, DB `skeliweb`)

## Rychlý start (dev)
```bash
mvn -q -DskipTests compile
mvn org.eclipse.jetty:jetty-maven-plugin:11.0.15:run
```
Aplikace poběží na http://localhost:8080/

## Databáze a migrace
```bash
mvn -q -Dflyway.configFiles=src/main/resources/flyway.conf flyway:migrate
```
(Flyway je také volán přes plugin v `pom.xml`.)

## YouTube sync
1. Vytvoř `src/main/webapp/WEB-INF/youtube.properties` podle šablony:
   ```
   apiKey=YOUR_KEY
   channelId=YOUR_CHANNEL_ID
   ```
2. Přihlas se jako ADMIN a otevři `/admin/sync`.

## Testy
```bash
mvn test
```

## Odstranění problémů po čerstvém klonu (IDE/Build)
- Otevřete projekt přes `pom.xml` (Import as Maven Project), ne jako čistý Java projekt.
- Nastavte Project SDK/Language level na JDK 17.
- V IntelliJ: File → Invalidate Caches / Restart, poté Maven → Reload All Projects.
- Ověřte na CLI:
  ```bash
  mvn -q -DskipTests compile
  mvn -q test
  ```
- Pokud se v IDE zobrazuje „cannot find symbol: LyricService/LyricView“, téměř vždy jde o špatně nastavené JDK nebo chybějící Maven import. Po nastavení JDK 17 a reloadu Mavenu chyba zmizí.
- Ujistěte se, že jste na aktuální větvi (`main`/`master`) a fork je synchronizovaný s upstreamem.

## Docker (volitelné)
```bash
docker compose up --build
```
Aplikace: http://localhost:8080  DB: localhost:3306

## Bezpečnost
- Admin chráněn filtrem (`/admin/*`).
- Základní CSRF pro `/comment` a `/vote`.
- Používejte prepared statements a `c:out` v JSP.

# Skeli.cz

transformace html strany na JAVU

## Stack
- Java/JSP + Jetty
- MariaDB + Flyway (`src/main/resources/db/migration`)

## Migrations
- V1..V7 lyrics/songs normalization
- V8 videos table (YouTube IDs)
- V9 map videos -> songs
- V10 auth (users), comments, votes, views
- V11 videos.title + published_at

Run:
```sh
mvn -q -Dflyway.cleanDisabled=true flyway:migrate
```

## Auth
- Register: POST /register
- Login: POST /login
- Logout: GET /logout
- Session attributes: `userId`, `username`, `role`

## YouTube sync
- Endpoint: GET `/admin/sync` (ADMIN only)
- Env vars: `YOUTUBE_API_KEY`, `YOUTUBE_CHANNEL_ID`
- Syncs latest channel videos into `videos` (youtube_id, title, published_at) and links to `songs`

## Music page
- `music.jsp`: Spotify embed, now-playing, 3-column video grid, modal player
- Titles z DB (`videos.title`), fallback oEmbed
- Spotify sekce má červeno-oranžové zvýraznění (`--spotify`), ne zelené

## UI/Theme
- Tmavý režim: zesílený kontrast, panely výrazně tmavší (`--panel` rgba(0,0,0,0.60))
- Světlý režim: přidané okraje panelů pro lepší čitelnost (`--panel-border`)

## I18n
- Překlady se načítají ze souborů `WEB-INF/i18n/messages_*.properties`
- Současně se načítají/ukládají i do DB tabulky `translations` (Flyway `V13__i18n_translations_table.sql`)
- Chování: soubory -> doplnění chybějících klíčů do DB -> DB hodnoty přepíší souborové

## Texty
- `texty.jsp` vertikální seznam; `lyric.jsp` komentáře, hlasování, návštěvy, moderní font

## Poznámky
- DB přístup je zatím v kódu (JSP/Servlety); pro produkci použít konfiguraci/env
- Admin: `UPDATE users SET role='ADMIN' WHERE username='...';`
