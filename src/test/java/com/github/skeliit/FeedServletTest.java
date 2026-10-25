package com.github.skeliit;

import org.junit.jupiter.api.Test;

import java.nio.charset.StandardCharsets;

import static org.junit.jupiter.api.Assertions.*;

class FeedServletTest {

    @Test
    void parsesValidFeedPaths() {
        FeedServlet.Request r = FeedServlet.parse("/en/feed", "/songs.atom");
        assertNotNull(r);
        assertEquals("en", r.lang());
        assertEquals("songs", r.kind());
        assertEquals("atom", r.format());
        assertEquals("application/atom+xml", r.contentType());
        assertEquals("/en/feed/songs.rss", r.otherFormatPath());
        assertEquals("/uk/feed/all.rss", FeedServlet.parse("/uk/feed", "/all.rss").path());
    }

    @Test
    void rejectsUnknownKindsFormatsAndLanguages() {
        assertNull(FeedServlet.parse("/cs/feed", "/comments.rss"));
        assertNull(FeedServlet.parse("/cs/feed", "/all.json"));
        assertNull(FeedServlet.parse("/cs/feed", "/all.rss/x"));
        assertNull(FeedServlet.parse("/cs/feed", null));
        assertNull(FeedServlet.parse("/sk/feed", "/all.rss"));
        assertNull(FeedServlet.parse("/feed", "/all.rss"));
    }

    @Test
    void limitIsClamped() {
        assertEquals(30, FeedServlet.limit(null));
        assertEquals(30, FeedServlet.limit("abc"));
        assertEquals(1, FeedServlet.limit("-5"));
        assertEquals(100, FeedServlet.limit("5000"));
        assertEquals(10, FeedServlet.limit(" 10 "));
    }

    @Test
    void etagDependsOnContent() {
        String a = FeedServlet.etag("a".getBytes(StandardCharsets.UTF_8));
        assertEquals(a, FeedServlet.etag("a".getBytes(StandardCharsets.UTF_8)));
        assertNotEquals(a, FeedServlet.etag("b".getBytes(StandardCharsets.UTF_8)));
        assertTrue(a.startsWith("\"") && a.endsWith("\""));
    }

    @Test
    void conditionalGet() {
        String tag = "\"abc\"";
        long modified = 1_700_000_000_500L;
        assertTrue(FeedServlet.notModified(tag, -1, tag, modified));
        assertTrue(FeedServlet.notModified("\"x\", W/\"abc\"", -1, tag, modified));
        assertFalse(FeedServlet.notModified("\"x\"", modified + 10_000, tag, modified)); // ETag wins
        assertTrue(FeedServlet.notModified(null, 1_700_000_000_000L, tag, modified)); // same second
        assertFalse(FeedServlet.notModified(null, 1_699_999_999_000L, tag, modified));
        assertFalse(FeedServlet.notModified(null, -1, tag, modified));
    }
}
