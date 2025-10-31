package com.github.skeliit;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.sql.*;

@WebServlet(name = "YouTubeSyncServlet", urlPatterns = {"/admin/sync"})
public class YouTubeSyncServlet extends HttpServlet {
    private Connection getConn() throws SQLException {
        String mariadbUrl = "jdbc:mariadb://localhost:3306/skeliweb?useUnicode=true&characterEncoding=utf8mb4";
        String user = "Skeli";
        String password = "skeli";
        return DriverManager.getConnection(mariadbUrl, user, password);
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        // Simple admin check
        Object role = req.getSession().getAttribute("role");
        if (role == null || !"ADMIN".equals(role.toString())) {
            resp.setStatus(403);
            resp.getWriter().write("Forbidden");
            return;
        }
        String apiKey = System.getenv("YOUTUBE_API_KEY");
        String channelId = System.getenv("YOUTUBE_CHANNEL_ID");
        if (apiKey == null || channelId == null) {
            // fallback to WEB-INF/youtube.properties
            try (java.io.InputStream in = getServletContext().getResourceAsStream("/WEB-INF/youtube.properties")) {
                if (in != null) {
                    java.util.Properties p = new java.util.Properties();
                    p.load(new java.io.InputStreamReader(in, java.nio.charset.StandardCharsets.UTF_8));
                    if (apiKey == null) apiKey = p.getProperty("apiKey");
                    if (channelId == null) channelId = p.getProperty("channelId");
                }
            }
        }
        if (apiKey == null || channelId == null) {
            resp.setStatus(500);
            resp.getWriter().write("YouTube sync missing configuration (env or /WEB-INF/youtube.properties)");
            return;
        }
        try (Connection conn = getConn()) {
            syncChannel(conn, apiKey, channelId);
            resp.getWriter().write("OK");
        } catch (Exception e) {
            throw new ServletException(e);
        }
    }

    private void syncChannel(Connection conn, String apiKey, String channelId) throws Exception {
        // Fetch latest videos via search endpoint
        String url = "https://www.googleapis.com/youtube/v3/search?part=snippet&channelId=" +
                URLEncoder.encode(channelId, StandardCharsets.UTF_8) +
                "&type=video&maxResults=50&order=date&key=" + URLEncoder.encode(apiKey, StandardCharsets.UTF_8);
        String json = httpGet(url);
        ObjectMapper mapper = new ObjectMapper();
        JsonNode root = mapper.readTree(json);
        for (JsonNode item : root.path("items")) {
            String videoId = item.path("id").path("videoId").asText(null);
            String title = item.path("snippet").path("title").asText("");
            String publishedAt = item.path("snippet").path("publishedAt").asText("");
            if (videoId == null || videoId.isEmpty()) continue;
            upsertVideo(conn, videoId, title, publishedAt);
            // naive parse: expect "Artist - Name (YYYY)" -> extract name + year
            String name = title;
            Integer year = null;
            int p = title.lastIndexOf('(');
            int q = title.lastIndexOf(')');
            if (p != -1 && q != -1 && q > p) {
                try { year = Integer.parseInt(title.substring(p+1, q).trim()); } catch (Exception ignore) {}
            }
            if (name != null && !name.isEmpty()) {
                Integer songId = ensureSong(conn, name, year);
                linkVideoToSong(conn, videoId, songId);
            }
        }
    }

    private static String httpGet(String sUrl) throws IOException {
        URL url = new URL(sUrl);
        HttpURLConnection conn = (HttpURLConnection) url.openConnection();
        conn.setRequestMethod("GET");
        try (BufferedReader br = new BufferedReader(new InputStreamReader(conn.getInputStream(), StandardCharsets.UTF_8))) {
            StringBuilder sb = new StringBuilder();
            String line;
            while ((line = br.readLine()) != null) sb.append(line);
            return sb.toString();
        }
    }

    private void upsertVideo(Connection conn, String videoId, String title, String publishedAt) throws SQLException {
        Timestamp ts = null;
        try {
            if (publishedAt != null && !publishedAt.isEmpty()) {
                ts = Timestamp.valueOf(publishedAt.replace("T"," ").replace("Z", ""));
            }
        } catch (Exception ignore) {}
        try (PreparedStatement ps = conn.prepareStatement(
                "INSERT INTO videos (youtube_id, title, published_at) VALUES (?, ?, ?) " +
                "ON DUPLICATE KEY UPDATE title = VALUES(title), published_at = COALESCE(VALUES(published_at), published_at)")) {
            ps.setString(1, videoId);
            ps.setString(2, title);
            if (ts == null) ps.setNull(3, Types.TIMESTAMP); else ps.setTimestamp(3, ts);
            ps.executeUpdate();
        }
    }

    private Integer ensureSong(Connection conn, String name, Integer year) throws SQLException {
        // Try find existing
        try (PreparedStatement sel = conn.prepareStatement("SELECT id FROM songs WHERE name=? AND ((year IS NULL AND ? IS NULL) OR year=?)")) {
            sel.setString(1, name);
            if (year == null) { sel.setNull(2, Types.INTEGER); sel.setNull(3, Types.INTEGER);} else { sel.setInt(2, year); sel.setInt(3, year);} 
            try (ResultSet rs = sel.executeQuery()) { if (rs.next()) return rs.getInt(1); }
        }
        // Insert
        try (PreparedStatement ins = conn.prepareStatement("INSERT INTO songs (name, year) VALUES (?, ?)", Statement.RETURN_GENERATED_KEYS)) {
            ins.setString(1, name);
            if (year == null) ins.setNull(2, Types.INTEGER); else ins.setInt(2, year);
            ins.executeUpdate();
            try (ResultSet rs = ins.getGeneratedKeys()) { if (rs.next()) return rs.getInt(1); }
        } catch (SQLException e) {
            // race: try select again
            try (PreparedStatement sel2 = conn.prepareStatement("SELECT id FROM songs WHERE name=? AND ((year IS NULL AND ? IS NULL) OR year=?)")) {
                sel2.setString(1, name);
                if (year == null) { sel2.setNull(2, Types.INTEGER); sel2.setNull(3, Types.INTEGER);} else { sel2.setInt(2, year); sel2.setInt(3, year);} 
                try (ResultSet rs = sel2.executeQuery()) { if (rs.next()) return rs.getInt(1); }
            }
            throw e;
        }
        return null;
    }

    private void linkVideoToSong(Connection conn, String videoId, Integer songId) throws SQLException {
        if (songId == null) return;
        try (PreparedStatement ps = conn.prepareStatement("UPDATE videos SET song_id=? WHERE youtube_id=?")) {
            ps.setInt(1, songId);
            ps.setString(2, videoId);
            ps.executeUpdate();
        }
    }
}
