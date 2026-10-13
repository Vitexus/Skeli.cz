package com.github.skeliit.dao;

import com.github.skeliit.Db;
import com.github.skeliit.model.SiteFeedback;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

/** "Co říkáš na web?" (site_feedback): one rating per user, the counts, and the messages with the artist's heart. */
public class FeedbackDao {
    private static final String SELECT = "SELECT f.id, f.user_id, u.username, CASE WHEN u.role = 'DELETED' THEN NULL ELSE u.avatar_url END, "
            + "f.vote, f.message, COALESCE(f.updated_at, f.created_at), f.hearted_at IS NOT NULL "
            + "FROM site_feedback f JOIN users u ON u.id = f.user_id ";

    /** Saves (or changes) the user's rating; a changed message loses its heart, so the artist sees it again. */
    public void save(int userId, int vote, String message) throws SQLException {
        try (Connection c = Db.get(); PreparedStatement ps = c.prepareStatement(
                "INSERT INTO site_feedback (user_id, vote, message) VALUES (?, ?, ?) ON DUPLICATE KEY UPDATE "
                        + "hearted_at = IF(message <=> VALUES(message), hearted_at, NULL), "
                        + "vote = VALUES(vote), message = VALUES(message), updated_at = NOW()")) {
            ps.setInt(1, userId);
            ps.setInt(2, vote > 0 ? 1 : -1);
            ps.setString(3, message);
            ps.executeUpdate();
        }
    }

    public SiteFeedback mine(int userId) throws SQLException {
        try (Connection c = Db.get(); PreparedStatement ps = c.prepareStatement(SELECT + "WHERE f.user_id = ?")) {
            ps.setInt(1, userId);
            List<SiteFeedback> l = read(ps);
            return l.isEmpty() ? null : l.get(0);
        }
    }

    /** {thumbs up, thumbs down} of the accounts that still exist */
    public int[] counts() throws SQLException {
        try (Connection c = Db.get(); PreparedStatement ps = c.prepareStatement(
                "SELECT COALESCE(SUM(f.vote > 0), 0), COALESCE(SUM(f.vote < 0), 0) FROM site_feedback f JOIN users u ON u.id = f.user_id WHERE u.role <> 'DELETED'");
             ResultSet rs = ps.executeQuery()) {
            rs.next();
            return new int[] { rs.getInt(1), rs.getInt(2) };
        }
    }

    /** The newest messages with the artist's heart (the home page). */
    public List<SiteFeedback> hearted(int limit) throws SQLException {
        try (Connection c = Db.get(); PreparedStatement ps = c.prepareStatement(SELECT
                + "WHERE f.hearted_at IS NOT NULL AND f.message IS NOT NULL AND u.role <> 'DELETED' ORDER BY f.hearted_at DESC LIMIT ?")) {
            ps.setInt(1, limit);
            return read(ps);
        }
    }

    /** All ratings, newest first (the admin). */
    public List<SiteFeedback> all() throws SQLException {
        try (Connection c = Db.get(); PreparedStatement ps = c.prepareStatement(SELECT + "ORDER BY COALESCE(f.updated_at, f.created_at) DESC")) {
            return read(ps);
        }
    }

    public void heart(int id, boolean on) throws SQLException {
        try (Connection c = Db.get(); PreparedStatement ps = c.prepareStatement(
                "UPDATE site_feedback SET hearted_at = " + (on ? "NOW()" : "NULL") + " WHERE id = ?")) {
            ps.setInt(1, id);
            ps.executeUpdate();
        }
    }

    public void delete(int id) throws SQLException {
        try (Connection c = Db.get(); PreparedStatement ps = c.prepareStatement("DELETE FROM site_feedback WHERE id = ?")) {
            ps.setInt(1, id);
            ps.executeUpdate();
        }
    }

    private static List<SiteFeedback> read(PreparedStatement ps) throws SQLException {
        List<SiteFeedback> out = new ArrayList<>();
        try (ResultSet rs = ps.executeQuery()) {
            while (rs.next()) out.add(new SiteFeedback(rs.getInt(1), rs.getInt(2), rs.getString(3), rs.getString(4),
                    rs.getInt(5), rs.getString(6), rs.getTimestamp(7), rs.getBoolean(8)));
        }
        return out;
    }
}
