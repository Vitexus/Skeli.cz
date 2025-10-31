package com.github.skeliit;

import jakarta.servlet.*;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

public class CsrfFilter implements Filter {
    @Override public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain) throws IOException, ServletException {
        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse resp = (HttpServletResponse) response;
        if ("POST".equalsIgnoreCase(req.getMethod())) {
            String token = req.getParameter("csrf");
            Object st = req.getSession(true).getAttribute("csrf");
            if (st == null || token == null || !st.equals(token)) {
                resp.setStatus(400);
                resp.getWriter().write("Bad Request (CSRF)");
                return;
            }
        }
        chain.doFilter(request, response);
    }
}