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
            String lang = (String) req.getSession().getAttribute("lang");
            var songs = svc.listSongs();
            LyricView v = svc.getLyric(id, lang);
            if (v == null) { resp.sendError(404); return; }
            req.setAttribute("songs", songs);
            req.setAttribute("lyric", v);
            req.setAttribute("comments", svc.comments(id));
            req.getRequestDispatcher("/WEB-INF/views/lyric.jsp").forward(req, resp);
        } catch (Exception e) { throw new ServletException(e); }
    }
}
