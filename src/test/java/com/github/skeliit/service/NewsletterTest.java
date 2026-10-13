package com.github.skeliit.service;

import org.junit.jupiter.api.Test;

import static org.junit.jupiter.api.Assertions.*;

/** The news e-mail: what the subscriber gets in both versions. */
class NewsletterTest {

    @Test
    void htmlEscapesTheTextAndKeepsParagraphs() {
        String h = Newsletter.html("Nový <song>", "Ahoj <b>lidi</b>\n\nDruhý odstavec", null, null, "https://www.skeli.cz/newsletter/unsubscribe?token=abc");
        assertTrue(h.contains("Nový &lt;song&gt;"));
        assertTrue(h.contains("Ahoj &lt;b&gt;lidi&lt;/b&gt;"));
        assertFalse(h.contains("<b>lidi"));
        assertEquals(2, h.split("<p ").length - 1, "two paragraphs");
        assertTrue(h.contains("token=abc"), "the unsubscribe link");
    }

    @Test
    void aClipGetsItsThumbnailAndLink() {
        String h = Newsletter.html("S", "T", "HCDDuRsWdRw", "Drama", null);
        assertTrue(h.contains("i.ytimg.com/vi/HCDDuRsWdRw/hqdefault.jpg"));
        assertTrue(h.contains("/music.jsp?clip=HCDDuRsWdRw"));
        assertFalse(h.contains("Odhlásit"), "a test copy has no unsubscribe link");
        String t = Newsletter.text("T", "HCDDuRsWdRw", "https://x/u?token=1");
        assertTrue(t.contains("/music.jsp?clip=HCDDuRsWdRw") && t.contains("https://x/u?token=1"));
    }
}
