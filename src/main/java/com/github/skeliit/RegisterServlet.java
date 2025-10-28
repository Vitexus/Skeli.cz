package com.github.skeliit;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.mindrot.jbcrypt.BCrypt;

import java.io.IOException;
import java.sql.*;

@WebServlet(name = "RegisterServlet", urlPatterns = {"/register"})
public class RegisterServlet extends HttpServlet {
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
            resp.sendRedirect("register.jsp");
            return;
        }
        String hash = BCrypt.hashpw(password, BCrypt.gensalt());
        try (Connection conn = getConn();
             PreparedStatement ps = conn.prepareStatement("INSERT INTO users (username, password_hash, role) VALUES (?, ?, 'USER')")) {
            ps.setString(1, username);
            ps.setString(2, hash);
            ps.executeUpdate();
        } catch (SQLException e) {
            throw new ServletException(e);
        }
        resp.sendRedirect("login.jsp");
    }
}
