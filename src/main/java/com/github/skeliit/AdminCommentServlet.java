package com.github.skeliit;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.sql.*;

@WebServlet(name = "AdminCommentServlet", urlPatterns = {"/admin/comment"})
public class AdminCommentServlet extends HttpServlet {
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
        String idStr = req.getParameter("comment_id");
        if (idStr == null) { resp.sendRedirect("/admin.jsp"); return; }
        try (Connection conn = getConn(); PreparedStatement ps = conn.prepareStatement("DELETE FROM comments WHERE id=?")) {
            ps.setInt(1, Integer.parseInt(idStr));
            ps.executeUpdate();
        } catch (SQLException e) { throw new ServletException(e); }
        resp.sendRedirect("/admin.jsp");
    }
}
