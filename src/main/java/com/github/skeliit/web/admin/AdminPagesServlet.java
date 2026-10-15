package com.github.skeliit.web.admin;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

/**
 * Admin pages that only show things (AdminFilter lets admins in): /admin/stats = visits and what is played
 * most, /admin/system = synchronisation and the lyrics export. The templates read their own numbers.
 */
@WebServlet(name = "AdminPagesServlet", urlPatterns = {"/admin/stats", "/admin/system"})
public class AdminPagesServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String view = "/admin/stats".equals(req.getServletPath()) ? "stats" : "system";
        req.getRequestDispatcher("/WEB-INF/views/admin/" + view + ".jsp").forward(req, resp);
    }
}
