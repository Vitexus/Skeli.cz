package com.github.skeliit;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.sql.*;

@WebServlet(name = "CommentsServlet", urlPatterns = {"/comment"})
public class CommentsServlet extends HttpServlet {
    private Connection getConn() throws SQLException {
        String mariadbUrl = "jdbc:mariadb://localhost:3306/skeliweb?useUnicode=true&characterEncoding=utf8mb4";
        String user = "Skeli";
        String password = "skeli";
        return DriverManager.getConnection(mariadbUrl, user, password);
    }
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        Integer userId = (session != null) ? (Integer) session.getAttribute("userId") : null;
        String content = req.getParameter("content");
        String lyricIdStr = req.getParameter("lyric_id");
        if (userId == null || content == null || lyricIdStr == null) {
            resp.sendRedirect("login.jsp");
            return;
        }
        try (Connection conn = getConn();
             PreparedStatement ps = conn.prepareStatement("INSERT INTO comments (lyric_id, user_id, content) VALUES (?, ?, ?)");) {
            ps.setInt(1, Integer.parseInt(lyricIdStr));
            ps.setInt(2, userId);
            ps.setString(3, content);
            ps.executeUpdate();
        } catch (SQLException e) {
            throw new ServletException(e);
        }
        resp.sendRedirect("lyric.jsp?id=" + lyricIdStr);
    }
}
