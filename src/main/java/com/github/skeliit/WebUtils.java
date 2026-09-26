package com.github.skeliit;

import java.text.Normalizer;

public class WebUtils {
    public static String slugify(String s) {
        if (s == null) return "";
        // Normalize to NFD, remove diacritic marks, then ASCII-only slug
        String normalized = Normalizer.normalize(s, Normalizer.Form.NFD)
                .replaceAll("\\p{M}+", "");
        String slug = normalized.toLowerCase()
                .replaceAll("[^a-z0-9]+", "-")
                .replaceAll("(^-|-$)", "");
        return slug;
    }

    /** Escapes text for safe output into HTML element content and quoted attributes. */
    public static String escapeHtml(Object o) {
        if (o == null) return "";
        String s = o.toString();
        StringBuilder sb = new StringBuilder(s.length() + 16);
        for (int i = 0; i < s.length(); i++) {
            char c = s.charAt(i);
            switch (c) {
                case '&' -> sb.append("&amp;");
                case '<' -> sb.append("&lt;");
                case '>' -> sb.append("&gt;");
                case '"' -> sb.append("&quot;");
                case '\'' -> sb.append("&#39;");
                default -> sb.append(c);
            }
        }
        return sb.toString();
    }

    /** Returns the URL only if it is a site-relative path or http(s) URL, otherwise the fallback. */
    public static String safeUrl(String url, String fallback) {
        if (url == null || url.isBlank()) return fallback;
        String u = url.trim();
        if ((u.startsWith("/") && !u.startsWith("//")) || u.startsWith("https://") || u.startsWith("http://")) {
            return u;
        }
        return fallback;
    }

    /**
     * Base URL of the site used in e-mails. Taken from APP_BASE_URL so that links
     * cannot be poisoned through the Host header.
     */
    public static String baseUrl() {
        String v = Config.get("APP_BASE_URL", "https://www.skeli.cz");
        return v.endsWith("/") ? v.substring(0, v.length() - 1) : v;
    }
}
