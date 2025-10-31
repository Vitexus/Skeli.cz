package com.github.skeliit;

import jakarta.servlet.*;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

public class AdminFilter implements Filter {
    @Override public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain) throws IOException, ServletException {
        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse resp = (HttpServletResponse) response;
        Object role = req.getSession(false) != null ? req.getSession(false).getAttribute("role") : null;
        if (role == null || !"ADMIN".equals(role.toString())) {
            resp.setStatus(403);
            resp.getWriter().write("Forbidden");
            return;
        }
        chain.doFilter(request, response);
    }
}