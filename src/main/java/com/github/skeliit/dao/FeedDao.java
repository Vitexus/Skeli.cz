package com.github.skeliit.dao;

import com.github.skeliit.Db;
import com.github.skeliit.LyricRouterServlet;
import com.github.skeliit.VideoTitles;
import com.github.skeliit.WebUtils;
import com.github.skeliit.model.FeedItem;

import java.sql.*;
import java.time.Instant;
import java.util.ArrayList;
import java.util.Comparator;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.regex.Pattern;

/** Entries for the RSS/Atom feeds, newest first. Links and images are absolute. */
public class FeedDao {
    /** Prefix of every entry id (RFC 4151); must never change or readers show everything as new. */
    static final String TAG = "tag:skeli.cz,2025:";
    private static final Pattern YT_ID = Pattern.compile("[A-Za-z0-9_-]{6,20}");

    /**
     * One entry per language variant of a lyric. A variant counts from the song's release
     * or from when it was added, whichever is later, so a new translation of an old song
     * shows up as new in that language's feed. Songs of unknown date come last.
     */
    public List<FeedItem> songs(String lang, int limit) throws SQLException {
        String sql = "SELECT s.uuid, s.name, s.preview_image_url, l.seo_slug, l.meta_description, " +
                "LEFT(l.words, 600) AS words, " +
                "GREATEST(s.published_at, l.created_at) AS pub, COALESCE(l.updated_at, l.created_at) AS upd, " +
                "(SELECT v.youtube_id FROM videos v WHERE v.song_id = s.id ORDER BY v.published_at DESC, v.id DESC LIMIT 1) AS yt " +
                "FROM lyrics l JOIN songs s ON s.id = l.song_id " +
                "WHERE l.lang = ? AND l.words IS NOT NULL AND l.words <> '' AND s.uuid IS NOT NULL " +
                "ORDER BY pub DESC, s.id DESC LIMIT ?";
        List<FeedItem> out = new ArrayList<>();
        try (Connection c = Db.get(); PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setString(1, lang);
            ps.setInt(2, limit);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    String uuid = rs.getString("uuid");
                    String summary = rs.getString("meta_description");
                    if (summary == null || summary.isBlank()) {
                        summary = LyricRouterServlet.firstLines(rs.getString("words"), 200);
                    }
                    String yt = validYt(rs.getString("yt"));
                    String image = LyricRouterServlet.absoluteImage(rs.getString("preview_image_url"));
                    if (image == null && yt != null) image = ytThumb(yt);
                    Instant pub = instant(rs.getTimestamp("pub"));
                    Instant upd = instant(rs.getTimestamp("upd"));
                    out.add(new FeedItem(TAG + "song/" + uuid + "/" + lang, rs.getString("name"),
                            songUrl(lang, rs.getString("seo_slug"), uuid), summary, image,
                            pub, later(pub, upd), "song", yt));
                }
            }
        }
        return out;
    }

    /** YouTube videos and shorts. Links go to the song page when it has lyrics in this language. */
    public List<FeedItem> videos(String lang, int limit) throws SQLException {
        List<FeedItem> out = new ArrayList<>();
        out.addAll(youtube("videos", "video", lang, limit));
        out.addAll(youtube("shorts", "short", lang, limit));
        return newestFirst(out, limit);
    }

    /** What /aktuality.jsp shows: posts from social networks in this language plus shorts. */
    public List<FeedItem> news(String lang, int limit) throws SQLException {
        List<FeedItem> out = new ArrayList<>();
        String sql = "SELECT source, post_id, permalink, image_url, caption, created_at FROM social_posts " +
                "WHERE lang = ? ORDER BY created_at DESC LIMIT ?";
        try (Connection c = Db.get(); PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setString(1, lang);
            ps.setInt(2, limit);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    String source = rs.getString("source");
                    String caption = rs.getString("caption");
                    Instant created = instant(rs.getTimestamp("created_at"));
                    out.add(new FeedItem(TAG + "social/" + source + "/" + rs.getString("post_id"),
                            socialTitle(caption, source), LyricRouterServlet.absoluteImage(WebUtils.safeUrl(rs.getString("permalink"), "/aktuality.jsp")),
                            caption, httpOnly(rs.getString("image_url")), created, created, source, null));
                }
            }
        }
        out.addAll(youtube("shorts", "short", lang, limit));
        return newestFirst(out, limit);
    }

    /** Songs, videos and news together; a short that is in both videos and news appears once. */
    public List<FeedItem> all(String lang, int limit) throws SQLException {
        Map<String, FeedItem> byId = new LinkedHashMap<>();
        for (FeedItem i : songs(lang, limit)) byId.putIfAbsent(i.id(), i);
        for (FeedItem i : videos(lang, limit)) byId.putIfAbsent(i.id(), i);
        for (FeedItem i : news(lang, limit)) byId.putIfAbsent(i.id(), i);
        return newestFirst(new ArrayList<>(byId.values()), limit);
    }

    private List<FeedItem> youtube(String table, String category, String lang, int limit) throws SQLException {
        // table is one of two constants, never user input
        String sql = "SELECT v.youtube_id, v.title, v.published_at, s.name, s.uuid, l.seo_slug, l.id AS lyric_id " +
                "FROM " + table + " v LEFT JOIN songs s ON s.id = v.song_id " +
                "LEFT JOIN lyrics l ON l.song_id = s.id AND l.lang = ? AND l.words IS NOT NULL AND l.words <> '' " +
                "WHERE v.published_at IS NOT NULL ORDER BY v.published_at DESC, v.id DESC LIMIT ?";
        List<FeedItem> out = new ArrayList<>();
        try (Connection c = Db.get(); PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setString(1, lang);
            ps.setInt(2, limit);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    String yt = validYt(rs.getString("youtube_id"));
                    if (yt == null) continue;
                    String title = videoTitle(rs.getString("title"), "short".equals(category));
                    if (title == null || title.isBlank()) title = rs.getString("name");
                    if (title == null || title.isBlank()) title = yt;
                    boolean hasLyric = rs.getObject("lyric_id") != null && rs.getString("uuid") != null;
                    String link = hasLyric
                            ? songUrl(lang, rs.getString("seo_slug"), rs.getString("uuid"))
                            : ("short".equals(category) ? "https://www.youtube.com/shorts/" : "https://www.youtube.com/watch?v=") + yt;
                    Instant pub = instant(rs.getTimestamp("published_at"));
                    out.add(new FeedItem(TAG + category + "/" + yt, title, link, null, ytThumb(yt),
                            pub, pub, category, yt));
                }
            }
        }
        return out;
    }

    static List<FeedItem> newestFirst(List<FeedItem> items, int limit) {
        items.sort(Comparator.comparing(FeedItem::published, Comparator.nullsLast(Comparator.reverseOrder())));
        return items.size() > limit ? new ArrayList<>(items.subList(0, limit)) : items;
    }

    /** Card title without the "SHORT #music #rap" tail the channel puts on shorts. */
    static String videoTitle(String raw, boolean isShort) {
        String t = VideoTitles.display(raw);
        if (t == null) return null;
        // any case on a short ("Já už vím Short"); on a normal video only the all-caps tag
        String clean = t.replaceAll("\\s*#[\\p{L}\\p{N}_]+", "")
                .replaceAll((isShort ? "(?i)" : "") + "[\\s-]*\\bSHORTS?\\b", "")
                .replaceAll("\\s+", " ").replaceAll("[\\s-]+$", "").trim();
        return clean.isEmpty() ? t : clean;
    }

    /** First line of a post's caption, shortened; the network's name if there is no caption. */
    static String socialTitle(String caption, String source) {
        if (caption != null) {
            String first = caption.strip().split("\\R", 2)[0].strip();
            if (!first.isEmpty()) {
                if (first.length() <= 90) return first;
                int cut = first.lastIndexOf(' ', 90);
                return first.substring(0, cut > 0 ? cut : 90) + "…";
            }
        }
        if (source == null || source.isBlank()) return "Skeli";
        return Character.toUpperCase(source.charAt(0)) + source.substring(1);
    }

    private static String songUrl(String lang, String seoSlug, String uuid) {
        String slug = seoSlug != null && !seoSlug.isBlank() ? seoSlug.trim() : uuid;
        return WebUtils.baseUrl() + "/" + lang + "/song/" + slug;
    }

    private static String validYt(String id) {
        return id != null && YT_ID.matcher(id).matches() ? id : null;
    }

    private static String ytThumb(String yt) {
        return "https://i.ytimg.com/vi/" + yt + "/hqdefault.jpg";
    }

    private static String httpOnly(String url) {
        return url != null && (url.startsWith("https://") || url.startsWith("http://")) ? url : null;
    }

    private static Instant instant(Timestamp ts) {
        return ts == null ? null : ts.toInstant();
    }

    private static Instant later(Instant a, Instant b) {
        if (a == null) return b;
        if (b == null) return a;
        return a.isAfter(b) ? a : b;
    }
}
