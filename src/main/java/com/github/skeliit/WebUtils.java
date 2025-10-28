package com.github.skeliit;

public class WebUtils {
    public static String slugify(String s) {
        if (s == null) return "";
        String slug = s.toLowerCase()
                .replaceAll("[^a-z0-9]+", "-")
                .replaceAll("(^-|-$)", "");
        return slug;
    }
}