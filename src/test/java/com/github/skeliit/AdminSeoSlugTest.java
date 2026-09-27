package com.github.skeliit;

import org.junit.jupiter.api.Test;

import static org.junit.jupiter.api.Assertions.*;

class AdminSeoSlugTest {

    @Test
    void blankClearsSlug() {
        assertNull(AdminSongDetailServlet.normalizeSeoSlug(null));
        assertNull(AdminSongDetailServlet.normalizeSeoSlug(""));
        assertNull(AdminSongDetailServlet.normalizeSeoSlug("   "));
    }

    @Test
    void slugifiesDiacritics() {
        assertEquals("musis-odejit", AdminSongDetailServlet.normalizeSeoSlug("Musíš odejít"));
    }

    @Test
    void rejectsUuidShapedInput() {
        assertEquals("", AdminSongDetailServlet.normalizeSeoSlug("01daa1c7-74a6-4f61-b940-53c4a8d27e4c"));
    }

    @Test
    void rejectsEmptyAfterSlugify() {
        assertEquals("", AdminSongDetailServlet.normalizeSeoSlug("!!!"));
    }
}
