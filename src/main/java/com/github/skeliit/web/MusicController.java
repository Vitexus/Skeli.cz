package com.github.skeliit.web;

import com.github.skeliit.service.VideoService;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

public class MusicController extends HttpServlet {
    private final VideoService videos = new VideoService();
    @Override protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        try {
            req.setAttribute("videos", videos.list());
            req.getRequestDispatcher("/WEB-INF/views/music.jsp").forward(req, resp);
        } catch (Exception e) {
            throw new ServletException(e);
        }
    }
}
