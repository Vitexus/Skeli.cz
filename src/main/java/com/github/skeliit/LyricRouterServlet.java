package com.github.skeliit;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.net.URLDecoder;
import java.nio.charset.StandardCharsets;

import com.github.skeliit.service.LyricService;
import com.github.skeliit.model.LyricView;

public class LyricRouterServlet extends HttpServlet {
    private final LyricService svc = new LyricService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String path = req.getPathInfo(); // /{id-or-slug}
        if (path == null || path.equals("/")) { resp.sendRedirect("/texty.jsp"); return; }
        path = URLDecoder.decode(path.substring(1), StandardCharsets.UTF_8);
        Integer id = null;
        try { if (path.matches("^\\d+.*")) id = Integer.parseInt(path.split("-",2)[0]); } catch (Exception ignored) {}
        // If missing id, try slug match via songs list
        if (id == null) {
            try {
                String slug = path.toLowerCase().replaceAll("[^a-z0-9]+","-").replaceAll("^-|-$","");
                var songs = svc.listSongs();
                for (var s : songs) {
                    String sslug = s.name.toLowerCase().replaceAll("[^a-z0-9]+","-").replaceAll("^-|-$","");
                    if (sslug.startsWith(slug) && s.firstLyricId != null) { id = s.firstLyricId; break; }
                }
            } catch (Exception ignore) {}
        }
        if (id == null || id == 0) { resp.sendError(404); return; }
        try {
            // Ensure CSRF token exists in session
            req.setAttribute("csrf", CsrfFilter.token(req.getSession()));
            
            String lang = (String) req.getSession().getAttribute("lang");
            var songs = svc.listSongs();
            LyricView v = svc.getLyric(id, lang);
            if (v == null) { resp.sendError(404); return; }
            req.setAttribute("songs", songs);
            req.setAttribute("lyric", v);
            // <title> and meta description for search results and link previews
            req.setAttribute("pageTitle", v.songName);
            req.setAttribute("pageDescription", firstLines(v.words, 160));
            // link previews: the song's own video thumbnail, typed as a song
            req.setAttribute("pageType", "music.song");
            if (v.youtubeId != null && v.youtubeId.matches("[A-Za-z0-9_-]{6,20}")) {
                req.setAttribute("pageImage", "https://i.ytimg.com/vi/" + v.youtubeId + "/hqdefault.jpg");
            }
            req.setAttribute("comments", svc.comments(id));
            req.getRequestDispatcher("/WEB-INF/views/lyric.jsp").forward(req, resp);
        } catch (Exception e) { throw new ServletException(e); }
    }

    /** The opening lines of the lyrics joined into one line, cut at a word boundary. */
    static String firstLines(String words, int max) {
        if (words == null) return null;
        String s = words.strip().replaceAll("\\s*\\R\\s*", " / ").replaceAll("\\s+", " ");
        if (s.length() <= max) return s;
        int cut = s.lastIndexOf(' ', max);
        return s.substring(0, cut > 0 ? cut : max).replaceAll("[ /,]+$", "") + "…";
    }
}
