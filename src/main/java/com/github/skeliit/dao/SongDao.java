package com.github.skeliit.dao;

import com.github.skeliit.Db;
import com.github.skeliit.model.Song;
import com.github.skeliit.model.SongVideo;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class SongDao {
    public List<Song> listWithFirstLyric() throws SQLException {
        String sql = "SELECT s.id, s.name, s.year, s.uuid, s.apple_music_id, s.spotify_id, s.preview_image_url, " +
                "(SELECT MIN(l.id) FROM lyrics l WHERE l.song_id=s.id) AS firstLyricId FROM songs s ORDER BY s.name ASC";
        try (Connection c = Db.get(); PreparedStatement ps = c.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            List<Song> out = new ArrayList<>();
            while (rs.next()) {
                out.add(mapSong(rs, true));
            }
            return out;
        }
    }

    public List<Song> listAll() throws SQLException {
        String sql = "SELECT id, name, year, uuid, apple_music_id, spotify_id, preview_image_url FROM songs ORDER BY name ASC";
        try (Connection c = Db.get(); PreparedStatement ps = c.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            List<Song> out = new ArrayList<>();
            while (rs.next()) {
                out.add(mapSong(rs, false));
            }
            return out;
        }
    }

    public Song findById(int id) throws SQLException {
        String sql = "SELECT id, name, year, uuid, apple_music_id, spotify_id, preview_image_url, " +
                "(SELECT MIN(l.id) FROM lyrics l WHERE l.song_id=s.id AND l.lang='cs') AS firstLyricId " +
                "FROM songs s WHERE id=?";
        try (Connection c = Db.get(); PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() ? mapSong(rs, true) : null;
            }
        }
    }

    public void updateBasics(int songId, String name, Integer year, String appleMusicId, String spotifyId) throws SQLException {
        try (Connection c = Db.get();
             PreparedStatement ps = c.prepareStatement(
                     "UPDATE songs SET name=?, year=?, apple_music_id=?, spotify_id=? WHERE id=?")) {
            ps.setString(1, name);
            if (year == null) ps.setNull(2, Types.INTEGER); else ps.setInt(2, year);
            ps.setString(3, blankToNull(appleMusicId));
            ps.setString(4, blankToNull(spotifyId));
            ps.setInt(5, songId);
            ps.executeUpdate();
        }
    }

    public void updateAppleMusicId(int songId, String appleMusicId) throws SQLException {
        try (Connection c = Db.get(); PreparedStatement ps = c.prepareStatement("UPDATE songs SET apple_music_id=? WHERE id=?")) {
            ps.setString(1, blankToNull(appleMusicId));
            ps.setInt(2, songId);
            ps.executeUpdate();
        }
    }

    public void updatePreviewImageUrl(int songId, String previewImageUrl) throws SQLException {
        try (Connection c = Db.get(); PreparedStatement ps = c.prepareStatement("UPDATE songs SET preview_image_url=? WHERE id=?")) {
            ps.setString(1, previewImageUrl);
            ps.setInt(2, songId);
            ps.executeUpdate();
        }
    }

    public String getPreviewImageUrl(int songId) throws SQLException {
        try (Connection c = Db.get(); PreparedStatement ps = c.prepareStatement("SELECT preview_image_url FROM songs WHERE id=?")) {
            ps.setInt(1, songId);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() ? rs.getString(1) : null;
            }
        }
    }

    public List<SongVideo> videosForSong(int songId) throws SQLException {
        String sql = "SELECT id, youtube_id, title, song_id FROM videos WHERE song_id=? ORDER BY published_at DESC, id DESC";
        try (Connection c = Db.get(); PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, songId);
            try (ResultSet rs = ps.executeQuery()) {
                List<SongVideo> out = new ArrayList<>();
                while (rs.next()) out.add(mapVideo(rs));
                return out;
            }
        }
    }

    public void linkVideo(String youtubeId, int songId, String title) throws SQLException {
        try (Connection c = Db.get()) {
            // Upsert-ish: update if exists, else insert
            try (PreparedStatement up = c.prepareStatement(
                    "UPDATE videos SET song_id=?, title=COALESCE(NULLIF(?, ''), title) WHERE youtube_id=?")) {
                up.setInt(1, songId);
                up.setString(2, title);
                up.setString(3, youtubeId);
                int n = up.executeUpdate();
                if (n == 0) {
                    try (PreparedStatement ins = c.prepareStatement(
                            "INSERT INTO videos (youtube_id, title, song_id) VALUES (?, ?, ?)")) {
                        ins.setString(1, youtubeId);
                        ins.setString(2, blankToNull(title) != null ? title : youtubeId);
                        ins.setInt(3, songId);
                        ins.executeUpdate();
                    }
                }
            }
        }
    }

    public void unlinkVideo(String youtubeId, int songId) throws SQLException {
        try (Connection c = Db.get();
             PreparedStatement ps = c.prepareStatement("UPDATE videos SET song_id=NULL WHERE youtube_id=? AND song_id=?")) {
            ps.setString(1, youtubeId);
            ps.setInt(2, songId);
            ps.executeUpdate();
        }
    }

    public String[] lyricLanguages(int songId) throws SQLException {
        try (Connection c = Db.get();
             PreparedStatement ps = c.prepareStatement(
                     "SELECT GROUP_CONCAT(DISTINCT lang ORDER BY lang SEPARATOR ',') FROM lyrics WHERE song_id=?")) {
            ps.setInt(1, songId);
            try (ResultSet rs = ps.executeQuery()) {
                if (!rs.next() || rs.getString(1) == null || rs.getString(1).isEmpty()) return new String[0];
                return rs.getString(1).split(",");
            }
        }
    }

    private Song mapSong(ResultSet rs, boolean withFirstLyric) throws SQLException {
        Song s = new Song();
        s.id = rs.getInt("id");
        s.name = rs.getString("name");
        int y = rs.getInt("year"); s.year = rs.wasNull() ? null : y;
        try { s.uuid = rs.getString("uuid"); } catch (SQLException ignore) {}
        s.appleMusicId = rs.getString("apple_music_id");
        try { s.spotifyId = rs.getString("spotify_id"); } catch (SQLException ignore) {}
        s.previewImageUrl = rs.getString("preview_image_url");
        if (withFirstLyric) {
            int fl = rs.getInt("firstLyricId"); s.firstLyricId = rs.wasNull() ? null : fl;
        }
        return s;
    }

    private SongVideo mapVideo(ResultSet rs) throws SQLException {
        SongVideo v = new SongVideo();
        v.id = rs.getInt("id");
        v.youtubeId = rs.getString("youtube_id");
        v.title = rs.getString("title");
        int sid = rs.getInt("song_id");
        v.songId = rs.wasNull() ? null : sid;
        return v;
    }

    private static String blankToNull(String s) {
        return s == null || s.isBlank() ? null : s.trim();
    }
}
