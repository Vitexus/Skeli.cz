package com.github.skeliit;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.node.ArrayNode;
import com.fasterxml.jackson.databind.node.ObjectNode;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.io.InputStream;
import java.io.PrintWriter;
import java.sql.*;
import java.time.Instant;
import java.time.ZoneOffset;
import java.time.format.DateTimeFormatter;

@WebServlet(name = "SocialPostsApiServlet", urlPatterns = {"/api/social-posts"})
public class SocialPostsApiServlet extends HttpServlet {
    private Connection getConn() throws SQLException {
        String url = "jdbc:mariadb://127.0.0.1:3306/skeliweb?useUnicode=true&characterEncoding=utf8mb4";
        return DriverManager.getConnection(url, "Skeli", "skeli");
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        resp.setContentType("application/json; charset=UTF-8");
        int limit = 10;
        try { limit = Math.max(1, Math.min(50, Integer.parseInt(req.getParameter("limit")))); } catch (Exception ignore) {}

        String sql = "SELECT id, source, post_id, permalink, image_url, caption, created_at " +
                "FROM social_posts ORDER BY created_at DESC, id DESC LIMIT ?";
        ObjectMapper mapper = new ObjectMapper();
        ArrayNode arr = mapper.createArrayNode();
        try (Connection c = getConn(); PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, limit);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    ObjectNode o = mapper.createObjectNode();
                    o.put("id", rs.getInt(1));
                    o.put("source", rs.getString(2));
                    o.put("postId", rs.getString(3));
                    o.put("permalink", rs.getString(4));
                    if (rs.getString(5) != null) o.put("image", rs.getString(5));
                    if (rs.getString(6) != null) o.put("caption", rs.getString(6));
                    Timestamp ts = rs.getTimestamp(7);
                    if (ts != null) {
                        String iso = DateTimeFormatter.ISO_INSTANT.format(ts.toInstant());
                        o.put("createdAt", iso);
                    }
                    arr.add(o);
                }
            }
        } catch (SQLException e) {
            resp.setStatus(500);
            resp.getWriter().write("{\"error\":\"DB error\"}");
            return;
        }
        PrintWriter out = resp.getWriter();
        out.write(arr.toString());
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String token = System.getenv("SOCIAL_TOKEN");
        String q = req.getParameter("token");
        if (token != null && (q == null || !token.equals(q))) {
            resp.setStatus(403);
            resp.getWriter().write("{\"error\":\"forbidden\"}");
            return;
        }
        ObjectMapper mapper = new ObjectMapper();
        JsonNode body;
        try (InputStream in = req.getInputStream()) { body = mapper.readTree(in); }
        if (body == null) { resp.setStatus(400); resp.getWriter().write("{\"error\":\"invalid json\"}"); return; }
        String source = body.path("source").asText(null);
        String postId = body.path("postId").asText(null);
        String permalink = body.path("permalink").asText(null);
        String image = body.path("image").asText(null);
        String caption = body.path("caption").asText(null);
        String createdAt = body.path("createdAt").asText(null); // ISO-8601
        if (source == null || postId == null || permalink == null || createdAt == null) {
            resp.setStatus(400); resp.getWriter().write("{\"error\":\"missing fields\"}"); return;
        }
        String sql = "INSERT INTO social_posts(source, post_id, permalink, image_url, caption, created_at) " +
                     "VALUES(?,?,?,?,?,?) ON DUPLICATE KEY UPDATE permalink=VALUES(permalink), image_url=VALUES(image_url), caption=VALUES(caption), created_at=VALUES(created_at)";
        try (Connection c = getConn(); PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setString(1, source);
            ps.setString(2, postId);
            ps.setString(3, permalink);
            ps.setString(4, image);
            ps.setString(5, caption);
            Timestamp ts = Timestamp.from(Instant.parse(createdAt));
            ps.setTimestamp(6, ts);
            ps.executeUpdate();
        } catch (SQLException e) {
            resp.setStatus(500); resp.getWriter().write("{\"error\":\"db error\"}"); return;
        }
        resp.setContentType("application/json; charset=UTF-8");
        resp.getWriter().write("{\"ok\":true}");
    }
}
