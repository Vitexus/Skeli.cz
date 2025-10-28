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

## Texty
- `texty.jsp` vertikální seznam; `lyric.jsp` komentáře, hlasování, návštěvy, moderní font

## Poznámky
- DB přístup je zatím v kódu (JSP/Servlety); pro produkci použít konfiguraci/env
- Admin: `UPDATE users SET role='ADMIN' WHERE username='...';`
