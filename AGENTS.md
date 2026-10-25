# WARP.md / AGENTS.md

Guidance for agents working in this repository.

## Project overview
- Maven WAR JSP app (Jetty via `pom.xml` / `jetty:run`).
- Views under `src/main/webapp` (includes `header.jsp` / `footer.jsp`); CSS in `css/`, images in `img/`.
- Flyway SQL in `src/main/resources/db/migration` (`V{n}__Description.sql`).
- Song is the content hub: UUID + per-language lyrics/SEO; YouTube/Spotify/Apple attach to the song.

## Environments
- Local: typically DB `skeliweb`, Jetty `:8080`.
- Test (`main` → https://test.skeli.cz): DB **`skelitest`**, service `skeli-test` (port 8082 behind proxy).
- Production (`production` → https://skeli.cz): production DB / `skeli-production`.

Config is loaded from `.env` via `Config` / dotenv (see `.env.example`).

### Deploy (GitHub Actions `deploy.yml`, runs only in `SkeliIT/Skeli.cz`)
- Host `magnymph.vitexsoftware.com`, user `skeli`; repo secrets `DEPLOY_KEY` (ed25519 private key), `DEPLOY_HOST`, `DEPLOY_USER`.
- Server apps are git checkouts run by `mvn jetty:run` (no WAR, no system jetty9):
  - `main` → `/home/skeli/WWW/skeli.cz/web`, `skeli-test.service`
  - `production` → `/home/skeli/WWW/production.skeli.cz/web`, `skeli-production.service`
- Workflow: build check → ssh → stash manual edits → `git reset --hard $GITHUB_SHA` → Flyway (creds from that dir's `.env`) → `sudo /bin/systemctl restart <service>` (sudoers allows only that exact path).

## Key commands
```bash
mvn -q clean package
mvn -q -Djetty.port=8080 jetty:run
mvn -q flyway:info
mvn -q flyway:migrate
mvn -q -Dtest='!*IT' test
mvn -q -Dtest=ClassName#method test
```

## Public song URLs
- Canonical: `/{lang}/song/{seoSlug|uuid}` for `cs|en|de|uk` (`SongRouterServlet`).
- Legacy `/song/{key}` → 301 `/cs/song/{key}`.
- Legacy `/lyrics/{id}` still works; canonical prefers `/…/song/…` when UUID/slug exists.
- Sitemap + `hreflang` list language variants (`SeoServlet`, `header.jsp`).

## Feeds (RSS 2.0 + Atom)
- `/{lang}/feed/{songs|videos|news|all}.{rss|atom}` (`FeedServlet`), `/feed` → 301 to `/{lang}/feed/all.rss`; `?limit=` 1–100 (default 30).
- Data: `dao/FeedDao` → `model/FeedItem`; XML: `service/FeedWriter` (Media RSS, `content:encoded`, never full lyrics).
- Entry ids are `tag:skeli.cz,2025:…` URIs — never change them, readers would show everything as new.
- Rendered feeds cached in memory 5 min; ETag/Last-Modified → 304; DB down → stale copy or 503.
- Autodiscovery `<link rel="alternate">` in `header.jsp` (page feed by servlet path / `feedKind` attribute), RSS icon in footer.
  PJAX navigation swaps only `<main>`, so `<head>` keeps the first page's feed links until a full reload.
- Tests: `FeedWriterTest`, `FeedServletTest`, `dao/FeedDaoTest` (unit), `FeedIT` (plain HTTP against a running instance).
- Song order: `GREATEST(songs.published_at, lyrics.created_at)`; set the release date in the admin song form.

## Admin song hub
- `/admin/songs`, `/admin/song?uuid=…` (`AdminSongDetailServlet`, `admin_song.jsp`).
- Preview upload: `/admin/songs/preview` (multipart, Cropper.js 16:9, max 20 MB).
- Per-lang save: `action=save_locale`; machine translate: `action=translate_locale` (`TranslationService` — DeepL / LibreTranslate).

## Schema notes (recent)
- `songs.uuid` required (`V40`); optional legacy `songs.seo_slug` (`V41`).
- `lyrics.seo_slug`, `lyrics.meta_description` per language (`V42`); unique `(lang, seo_slug)` and `(song_id, lang)`.
- `songs.published_at` (default NOW, backfilled from first video / year), `lyrics.created_at` / `updated_at` (`V43`) — used by feeds.

## Update process
1. Change sources / add next Flyway `V{n}__….sql`.
2. `mvn -q clean package` (or compile on the server tree).
3. Run Flyway on the target DB **before** restarting the app.
4. Push to `main` / `production` (CI deploys) or manually pull + restart `skeli-test` / `skeli-production`.

## Architecture
- Mostly JSP + servlets (no heavy MVC framework).
- Shared layout: `includes/header.jsp`, `footer.jsp`.
- DAO: `dao/SongDao`, `dao/LyricDao`; models include `Song`, `SongLocale`, `LyricView`.
