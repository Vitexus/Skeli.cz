package com.github.skeliit;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import org.mindrot.jbcrypt.BCrypt;

import java.io.IOException;
import java.sql.*;

@WebServlet(name = "LoginServlet", urlPatterns = {"/login"})
public class LoginServlet extends HttpServlet {
    private Connection getConn() throws SQLException {
        String mariadbUrl = "jdbc:mariadb://localhost:3306/skeliweb?useUnicode=true&characterEncoding=utf8mb4";
        String user = "Skeli";
        String password = "skeli";
        return DriverManager.getConnection(mariadbUrl, user, password);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String username = req.getParameter("username");
        String password = req.getParameter("password");
        if (username == null || password == null) {
            resp.sendRedirect("login.jsp");
            return;
        }
        try (Connection conn = getConn();
             PreparedStatement ps = conn.prepareStatement("SELECT id, password_hash, role FROM users WHERE username = ?")) {
            ps.setString(1, username);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    String hash = rs.getString("password_hash");
                    if (hash != null && BCrypt.checkpw(password, hash)) {
                        HttpSession session = req.getSession(true);
                        session.setAttribute("userId", rs.getInt("id"));
                        session.setAttribute("username", username);
                        session.setAttribute("role", rs.getString("role"));
                        resp.sendRedirect("index.jsp");
                        return;
                    }
                }
            }
        } catch (SQLException e) {
            throw new ServletException(e);
        }
        resp.sendRedirect("login.jsp");
    }
}
