package com.github.skeliit;

import com.github.skeliit.dao.SongDao;
import com.github.skeliit.model.Song;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.sql.SQLException;

/**
 * Song hub in admin: view/edit one song and its linked media (YouTube, Apple Music, Spotify).
 * GET  /admin/song?id=N
 * POST /admin/song  action=save|link_video|unlink_video
 */
@WebServlet(name = "AdminSongDetailServlet", urlPatterns = { "/admin/song" })
public class AdminSongDetailServlet extends HttpServlet {

    private final SongDao songs = new SongDao();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        if (!isAdmin(req)) { resp.setStatus(403); return; }
        int id = parseId(req.getParameter("id"));
        if (id <= 0) {
            resp.sendRedirect(req.getContextPath() + "/admin/songs");
            return;
        }
        try {
            Song song = songs.findById(id);
            if (song == null) {
                resp.sendError(404);
                return;
            }
            req.setAttribute("song", song);
            req.setAttribute("videos", songs.videosForSong(id));
            req.setAttribute("lyricLangs", songs.lyricLanguages(id));
            req.getRequestDispatcher("/admin_song.jsp").forward(req, resp);
        } catch (SQLException e) {
            throw new ServletException(e);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        if (!isAdmin(req)) { resp.setStatus(403); return; }
        if (!CsrfFilter.isValid(req)) {
            resp.setStatus(403);
            resp.getWriter().write("CSRF");
            return;
        }
        int id = parseId(req.getParameter("id"));
        if (id <= 0) {
            resp.sendRedirect(req.getContextPath() + "/admin/songs");
            return;
        }
        String action = req.getParameter("action");
        if (action == null) action = "save";
        try {
            switch (action) {
                case "link_video" -> {
                    String yt = normalizeYoutubeId(req.getParameter("youtube_id"));
                    if (yt == null) {
                        resp.sendRedirect(req.getContextPath() + "/admin/song?id=" + id + "&msg=bad_youtube");
                        return;
                    }
                    songs.linkVideo(yt, id, req.getParameter("title"));
                    resp.sendRedirect(req.getContextPath() + "/admin/song?id=" + id + "&msg=video_linked");
                }
                case "unlink_video" -> {
                    String yt = normalizeYoutubeId(req.getParameter("youtube_id"));
                    if (yt != null) songs.unlinkVideo(yt, id);
                    resp.sendRedirect(req.getContextPath() + "/admin/song?id=" + id + "&msg=video_unlinked");
                }
                default -> {
                    String name = req.getParameter("name");
                    if (name == null || name.isBlank()) {
                        resp.sendRedirect(req.getContextPath() + "/admin/song?id=" + id + "&msg=bad_name");
                        return;
                    }
                    Integer year = null;
                    String yearStr = req.getParameter("year");
                    if (yearStr != null && !yearStr.isBlank()) {
                        try { year = Integer.parseInt(yearStr.trim()); } catch (NumberFormatException ignore) {}
                    }
                    songs.updateBasics(id, name.trim(), year,
                            req.getParameter("apple_music_id"),
                            req.getParameter("spotify_id"));
                    resp.sendRedirect(req.getContextPath() + "/admin/song?id=" + id + "&msg=saved");
                }
            }
        } catch (SQLException e) {
            throw new ServletException(e);
        }
    }

    private static boolean isAdmin(HttpServletRequest req) {
        Object role = req.getSession().getAttribute("role");
        return role != null && "ADMIN".equals(role.toString());
    }

    private static int parseId(String s) {
        try { return Integer.parseInt(s); } catch (Exception e) { return -1; }
    }

    /** Accepts raw ID or a youtube URL and returns the 11-char id, or null. */
    static String normalizeYoutubeId(String raw) {
        if (raw == null) return null;
        String s = raw.trim();
        if (s.matches("[A-Za-z0-9_-]{11}")) return s;
        // https://youtu.be/XXXXXXXXXXX or watch?v= or shorts/
        java.util.regex.Matcher m = java.util.regex.Pattern
                .compile("(?:youtu\\.be/|v=|shorts/)([A-Za-z0-9_-]{11})")
                .matcher(s);
        return m.find() ? m.group(1) : null;
    }
}
