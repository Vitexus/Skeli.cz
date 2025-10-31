package com.github.skeliit;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.net.URLDecoder;
import java.nio.charset.StandardCharsets;
import java.sql.*;

public class LyricRouterServlet extends HttpServlet {
    private Connection getConn() throws SQLException {
        String mariadbUrl = "jdbc:mariadb://localhost:3306/skeliweb?useUnicode=true&characterEncoding=utf8mb4";
        String user = "Skeli";
        String password = "skeli";
        return DriverManager.getConnection(mariadbUrl, user, password);
    }
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String path = req.getPathInfo(); // /{id-or-slug}
        if (path == null || path.equals("/")) { resp.sendRedirect("/texty.jsp"); return; }
        path = URLDecoder.decode(path.substring(1), StandardCharsets.UTF_8);
        Integer id = null;
        try { if (path.matches("^\\d+.*")) id = Integer.parseInt(path.split("-",2)[0]); } catch (Exception ignored) {}
        try (Connection conn = getConn()) {
            if (id == null) {
                // try match by song name slug -> pick MIN(lyric id)
                String slug = path.toLowerCase().replaceAll("[^a-z0-9]+","-").replaceAll("^-|-$","");
                try (PreparedStatement ps = conn.prepareStatement(
                        "SELECT MIN(l.id) FROM lyrics l JOIN songs s ON s.id=l.song_id WHERE REPLACE(LOWER(s.name), ' ', '-') LIKE ?")) {
                    ps.setString(1, slug + "%");
                    try (ResultSet rs = ps.executeQuery()) { if (rs.next()) id = rs.getInt(1); }
                }
            }
        } catch (SQLException e) { throw new ServletException(e); }
        if (id == null || id == 0) { resp.sendError(404); return; }
        req.getRequestDispatcher("/lyric.jsp?id=" + id).forward(req, resp);
    }
}
