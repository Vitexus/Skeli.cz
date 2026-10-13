package com.github.skeliit.web.admin;

import com.github.skeliit.Db;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * News by e-mail: the subscribers (delete one) and writing an issue: a test copy to the admin, then to every
 * confirmed subscriber (service/Newsletter sends it in the background).
 * POST action=test|send (subject, body, youtube_id), or email=… to delete a subscriber.
 */
@WebServlet(name = "AdminNewsletterServlet", urlPatterns = {"/admin/newsletter"})
public class AdminNewsletterServlet extends HttpServlet {
    private Connection getConn() throws SQLException {
        return Db.get();
    }
    private boolean isAdmin(HttpSession s){ return s!=null && "ADMIN".equals(s.getAttribute("role")); }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        if (!isAdmin(req.getSession(false))) { resp.sendError(403); return; }
        List<String[]> emails = new ArrayList<>();
        try (Connection conn = getConn();
             PreparedStatement ps = conn.prepareStatement("SELECT email, subscribed_at, unsubscribed_at, confirmed_at FROM newsletter_emails ORDER BY subscribed_at DESC");
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                emails.add(new String[]{rs.getString(1), String.valueOf(rs.getTimestamp(2)), String.valueOf(rs.getTimestamp(3)), String.valueOf(rs.getTimestamp(4))});
            }
        } catch (SQLException e) { throw new ServletException(e); }
        req.setAttribute("emails", emails);
        try {
            req.setAttribute("issues", com.github.skeliit.service.Newsletter.issues());
            req.setAttribute("recipients", com.github.skeliit.service.Newsletter.recipients().size());
            req.setAttribute("clips", new com.github.skeliit.dao.HomeDao().latestVideos(40));
        } catch (SQLException e) { throw new ServletException(e); }
        req.setAttribute("smtp", com.github.skeliit.EmailUtil.isConfigured());
        req.getRequestDispatcher("/WEB-INF/views/admin/newsletter.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        if (!isAdmin(req.getSession(false))) { resp.sendError(403); return; }
        String action = req.getParameter("action");
        if ("test".equals(action) || "send".equals(action)) { compose(req, resp, action); return; }
        String email = req.getParameter("email");
        if (email != null && !email.isBlank()) {
            try (Connection conn = getConn();
                 PreparedStatement ps = conn.prepareStatement("DELETE FROM newsletter_emails WHERE email=?")) {
                ps.setString(1, email);
                ps.executeUpdate();
            } catch (SQLException e) { throw new ServletException(e); }
        }
        resp.sendRedirect("/admin/newsletter");
    }

    private void compose(HttpServletRequest req, HttpServletResponse resp, String action) throws ServletException, IOException {
        String subject = trim(req.getParameter("subject"), 200), body = trim(req.getParameter("body"), 20000);
        String yt = req.getParameter("youtube_id");
        if (yt != null && !yt.matches("[A-Za-z0-9_-]{6,20}")) yt = null;
        if (subject == null || body == null) { resp.sendRedirect("/admin/newsletter?msg=missing#compose"); return; }
        if (!com.github.skeliit.EmailUtil.isConfigured()) { resp.sendRedirect("/admin/newsletter?msg=nosmtp#compose"); return; }
        String clipTitle = null;
        try {
            if (yt != null) for (com.github.skeliit.dao.HomeDao.HomeVideo v : new com.github.skeliit.dao.HomeDao().latestVideos(200)) if (v.youtubeId().equals(yt)) clipTitle = v.title();
            if ("test".equals(action)) {
                String to = adminEmail(req);
                if (to == null) { resp.sendRedirect("/admin/newsletter?msg=noemail#compose"); return; }
                com.github.skeliit.service.Newsletter.sendTest(to, subject, body, yt, clipTitle);
                resp.sendRedirect("/admin/newsletter?msg=tested#compose");
            } else {
                int n = com.github.skeliit.service.Newsletter.sendToAll(subject, body, yt, clipTitle);
                resp.sendRedirect("/admin/newsletter?msg=sending&n=" + n + "#issues");
            }
        } catch (SQLException e) {
            throw new ServletException(e);
        } catch (Exception e) {
            getServletContext().log("Newsletter test: " + e.getMessage());
            resp.sendRedirect("/admin/newsletter?msg=failed#compose");
        }
    }

    private String adminEmail(HttpServletRequest req) throws SQLException {
        Object uid = req.getSession().getAttribute("userId");
        if (!(uid instanceof Integer)) return null;
        try (Connection c = getConn(); PreparedStatement ps = c.prepareStatement("SELECT email FROM users WHERE id = ?")) {
            ps.setInt(1, (Integer) uid);
            try (ResultSet rs = ps.executeQuery()) { return rs.next() ? rs.getString(1) : null; }
        }
    }

    private static String trim(String v, int max) {
        if (v == null) return null;
        String s = v.replace("\r\n", "\n").strip();
        return s.isEmpty() ? null : s.length() > max ? s.substring(0, max) : s;
    }
}
