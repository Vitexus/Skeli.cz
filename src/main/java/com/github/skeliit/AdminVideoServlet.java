package com.github.skeliit;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.sql.*;

@WebServlet(name = "AdminVideoServlet", urlPatterns = {"/admin/video"})
public class AdminVideoServlet extends HttpServlet {
    private Connection getConn() throws SQLException {
        String mariadbUrl = "jdbc:mariadb://localhost:3306/skeliweb?useUnicode=true&characterEncoding=utf8mb4";
        String user = "Skeli";
        String password = "skeli";
        return DriverManager.getConnection(mariadbUrl, user, password);
    }
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        Object role = req.getSession().getAttribute("role");
        if (role == null || !"ADMIN".equals(role.toString())) { resp.setStatus(403); return; }
        String youtubeId = req.getParameter("youtube_id");
        String title = req.getParameter("title");
        String songName = req.getParameter("song_name");
        String yearStr = req.getParameter("year");
        Integer year = null; if (yearStr != null && !yearStr.isEmpty()) try { year = Integer.parseInt(yearStr); } catch (Exception ignored) {}
        try (Connection conn = getConn()) {
            try (PreparedStatement ps = conn.prepareStatement("UPDATE videos SET title=? WHERE youtube_id=?")) {
                ps.setString(1, title);
                ps.setString(2, youtubeId);
                ps.executeUpdate();
            }
            if (songName != null && !songName.isEmpty()) {
                Integer songId = ensureSong(conn, songName, year);
                try (PreparedStatement ps = conn.prepareStatement("UPDATE videos SET song_id=? WHERE youtube_id=?")) {
                    ps.setInt(1, songId);
                    ps.setString(2, youtubeId);
                    ps.executeUpdate();
                }
            }
        } catch (SQLException e) { throw new ServletException(e); }
        resp.sendRedirect("/admin.jsp");
    }
    private Integer ensureSong(Connection conn, String name, Integer year) throws SQLException {
        try (PreparedStatement sel = conn.prepareStatement("SELECT id FROM songs WHERE name=? AND ((year IS NULL AND ? IS NULL) OR year=?)")) {
            sel.setString(1, name);
            if (year == null) { sel.setNull(2, Types.INTEGER); sel.setNull(3, Types.INTEGER);} else { sel.setInt(2, year); sel.setInt(3, year);} 
            try (ResultSet rs = sel.executeQuery()) { if (rs.next()) return rs.getInt(1); }
        }
        try (PreparedStatement ins = conn.prepareStatement("INSERT INTO songs (name, year) VALUES (?, ?)", Statement.RETURN_GENERATED_KEYS)) {
            ins.setString(1, name);
            if (year == null) ins.setNull(2, Types.INTEGER); else ins.setInt(2, year);
            ins.executeUpdate();
            try (ResultSet rs = ins.getGeneratedKeys()) { if (rs.next()) return rs.getInt(1); }
        }
        return null;
    }
}
