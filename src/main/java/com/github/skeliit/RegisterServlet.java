package com.github.skeliit;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.mindrot.jbcrypt.BCrypt;

import java.io.IOException;
import java.security.SecureRandom;
import java.sql.*;
import java.util.Base64;

@WebServlet(name = "RegisterServlet", urlPatterns = {"/register"})
public class RegisterServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        resp.sendRedirect("register.jsp");
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String username = req.getParameter("username");
        String email = req.getParameter("email");
        String password = req.getParameter("password");
        String password2 = req.getParameter("password2");
        String consent = req.getParameter("consent");
        if (username == null || password == null || password2 == null || !password.equals(password2) || consent == null) {
            resp.sendRedirect("register.jsp");
            return;
        }
        String hash = BCrypt.hashpw(password, BCrypt.gensalt());
        Integer newUserId = null;
        try (Connection conn = Db.get();
             PreparedStatement ps = conn.prepareStatement("INSERT INTO users (username, email, password_hash, role, created_at) VALUES (?, ?, ?, 'USER', NOW())", Statement.RETURN_GENERATED_KEYS)) {
            ps.setString(1, username);
            ps.setString(2, email);
            ps.setString(3, hash);
            ps.executeUpdate();
            try (ResultSet gk = ps.getGeneratedKeys()) { if (gk.next()) newUserId = gk.getInt(1); }
            // create password reset token to include in email
            if (newUserId != null) {
                String token = generateToken();
                try (PreparedStatement ps2 = conn.prepareStatement("INSERT INTO password_resets (user_id, token, expires_at) VALUES (?,?, DATE_ADD(NOW(), INTERVAL 30 MINUTE))")) {
                    ps2.setInt(1, newUserId);
                    ps2.setString(2, token);
                    ps2.executeUpdate();
                }
                try { 
                    EmailUtil.sendMail(email, buildRegistrationSubject(), buildRegistrationBody(req, username)); 
                } catch (Exception mailErr) { 
                    // Log error but continue - registration was successful
                }
            }
        } catch (SQLException e) {
            throw new ServletException(e);
        }
        resp.sendRedirect("login.jsp");
    }

    private static String generateToken() {
        byte[] b = new byte[32]; new SecureRandom().nextBytes(b);
        return Base64.getUrlEncoder().withoutPadding().encodeToString(b);
    }

    private static String buildRegistrationSubject() { 
        return "Vítejte na Skeli.cz - Registrace úspěšně dokončena"; 
    }
    
    private static String buildRegistrationBody(HttpServletRequest req, String username) {
        String base = req.getRequestURL().toString().replace(req.getRequestURI(), req.getContextPath());
        String loginLink = base + "/login.jsp";
        return "Vítejte na Skeli.cz!\n\n" +
               "Váš účet \"" + username + "\" byl úspěšně vytvořen.\n\n" +
               "Nyní se můžete přihlásit na našich stránkách:\n" + loginLink + "\n\n" +
               "Děkujeme za registraci a těšíme se na vaši účast v naší komunitě!\n\n" +
               "S pozdravem,\nTým Skeli.cz";
    }
}
