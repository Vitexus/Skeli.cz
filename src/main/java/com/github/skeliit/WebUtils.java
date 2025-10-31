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
}
