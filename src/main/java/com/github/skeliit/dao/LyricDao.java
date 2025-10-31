package com.github.skeliit.dao;

import com.github.skeliit.Db;
import com.github.skeliit.model.CommentView;
import com.github.skeliit.model.LyricView;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class LyricDao {
    public LyricView getLyricView(int lyricId, String lang) throws SQLException {
        String sql = "SELECT s.name AS song_name, s.year AS song_year, l.words, l.song_id, l.id, " +
                "(SELECT v.youtube_id FROM videos v WHERE v.song_id = l.song_id ORDER BY v.published_at DESC, v.id DESC LIMIT 1) AS yt " +
                "FROM lyrics l JOIN songs s ON s.id = l.song_id WHERE l.id = ?";
        try (Connection c = Db.get(); PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, lyricId);
            try (ResultSet rs = ps.executeQuery()) {
                if (!rs.next()) return null;
                LyricView v = new LyricView();
                v.id = rs.getInt("id");
                v.songId = rs.getInt("song_id");
                v.songName = rs.getString("song_name");
                int y = rs.getInt("song_year"); v.year = rs.wasNull()? null : y;
                String words = rs.getString("words");
                // translations
                if (lang != null && !"cs".equals(lang)) {
                    try (PreparedStatement tr = c.prepareStatement("SELECT words FROM lyrics_translations WHERE lyric_id=? AND lang=?")) {
                        tr.setInt(1, lyricId); tr.setString(2, lang);
                        try (ResultSet rtr = tr.executeQuery()) { if (rtr.next() && rtr.getString(1) != null) words = rtr.getString(1); }
                    }
                }
                v.words = words;
                v.youtubeId = rs.getString("yt");
                if (v.youtubeId == null || v.youtubeId.isBlank()) {
                    // Fallback 1: simple LIKE matching on title
                    String q = "SELECT youtube_id FROM videos WHERE LOWER(COALESCE(title,'')) LIKE ? OR LOWER(COALESCE(title,'')) LIKE ? ORDER BY published_at DESC, id DESC LIMIT 1";
                    try (PreparedStatement pv = c.prepareStatement(q)) {
                        String nameLc = v.songName == null ? "" : v.songName.toLowerCase();
                        pv.setString(1, "%"+nameLc+"%");
                        pv.setString(2, "%skeli - "+nameLc+"%");
                        try (ResultSet rv = pv.executeQuery()) { if (rv.next()) v.youtubeId = rv.getString(1); }
                    }
                    // Fallback 2: normalization + best contains score in Java
                    if (v.youtubeId == null || v.youtubeId.isBlank()) {
                        try (PreparedStatement all = c.prepareStatement("SELECT youtube_id, COALESCE(title,'') FROM videos")) {
                            try (ResultSet ra = all.executeQuery()) {
                                String bestId = null; int bestScore = -1;
                                String sn = normalize(v.songName);
                                while (ra.next()) {
                                    String vid = ra.getString(1); String title = ra.getString(2);
                                    String tn = normalize(title);
                                    int score = scoreContains(tn, sn);
                                    if (score > bestScore) { bestScore = score; bestId = vid; }
                                }
                                if (bestScore >= 1) v.youtubeId = bestId; // at least token match
                            }
                        }
                    }
                    // Persist pairing for next time
                    if (v.youtubeId != null && !v.youtubeId.isBlank()) {
                        try (PreparedStatement up = c.prepareStatement("UPDATE videos SET song_id=? WHERE youtube_id=?")) {
                            up.setInt(1, v.songId);
                            up.setString(2, v.youtubeId);
                            up.executeUpdate();
                        }
                    }
                }
                // views
                try (PreparedStatement inc = c.prepareStatement("INSERT INTO lyric_views (lyric_id, views) VALUES (?,1) ON DUPLICATE KEY UPDATE views=views+1")) {
                    inc.setInt(1, lyricId); inc.executeUpdate();
                }
                try (PreparedStatement sel = c.prepareStatement("SELECT views FROM lyric_views WHERE lyric_id=?")) {
                    sel.setInt(1, lyricId);
                    try (ResultSet rv = sel.executeQuery()) { if (rv.next()) v.views = rv.getLong(1); }
                }
                // votes
                try (PreparedStatement vv = c.prepareStatement("SELECT SUM(vote=1) AS up, SUM(vote=-1) AS down FROM lyrics_votes WHERE lyric_id=?")) {
                    vv.setInt(1, lyricId);
                    try (ResultSet rv = vv.executeQuery()) { if (rv.next()) { v.votesUp = rv.getInt("up"); v.votesDown = rv.getInt("down"); } }
                }
                return v;
            }
        }
    }

    public List<CommentView> listComments(int lyricId) throws SQLException {
        String sql = "SELECT c.id, c.user_id, c.content, c.created_at, u.username, u.avatar_url FROM comments c JOIN users u ON u.id=c.user_id WHERE c.lyric_id=? ORDER BY c.created_at DESC";
        try (Connection c = Db.get(); PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, lyricId);
            try (ResultSet rs = ps.executeQuery()) {
                List<CommentView> out = new ArrayList<>();
                while (rs.next()) {
                    CommentView cv = new CommentView();
                    cv.id = rs.getInt("id");
                    cv.userId = rs.getInt("user_id");
                    cv.username = rs.getString("username");
                    cv.avatarUrl = rs.getString("avatar_url");
                    cv.createdAt = rs.getTimestamp("created_at");
                    cv.content = rs.getString("content");
                    out.add(cv);
                }
                return out;
            }
        }
    }

    // Normalize text: lowercase, remove diacritics, punctuation, collapse spaces
    private static String normalize(String s) {
        if (s == null) return "";
        String out = java.text.Normalizer.normalize(s, java.text.Normalizer.Form.NFD)
                .replaceAll("\\p{InCombiningDiacriticalMarks}+", "");
        out = out.toLowerCase()
                .replaceAll("[^a-z0-9 ]+", " ")
                .replaceAll("\\s+", " ")
                .trim();
        // remove common prefixes
        out = out.replaceFirst("^skeli ", "");
        return out;
    }

    // Simple contains-based score (token overlap)
    private static int scoreContains(String hay, String needle) {
        if (hay.isEmpty() || needle.isEmpty()) return 0;
        String[] toks = needle.split(" "); int score = 0;
        for (String t : toks) { if (t.length()>1 && hay.contains(t)) score++; }
        return score;
    }
}
