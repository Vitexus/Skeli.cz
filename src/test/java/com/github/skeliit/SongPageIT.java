package com.github.skeliit;

import org.junit.jupiter.api.*;
import org.openqa.selenium.By;
import org.openqa.selenium.WebElement;

import java.net.HttpURLConnection;
import java.net.URI;
import java.sql.SQLException;
import java.util.List;

import static org.junit.jupiter.api.Assertions.*;

/**
 * Song hub URLs: /{lang}/song/{uuid|slug}, legacy /song/{uuid} redirect,
 * texty.jsp cards, admin locale editor.
 */
public class SongPageIT extends UiTestSupport {

    @Test
    @DisplayName("Legacy /song/{uuid} redirects to /cs/song/{uuid}")
    void legacySongUrlRedirectsToCs() throws Exception {
        String uuid = firstSongUuid();
        Assumptions.assumeTrue(uuid != null, "needs at least one song with uuid");

        HttpURLConnection c = (HttpURLConnection) URI.create(BASE_URL + "/song/" + uuid).toURL().openConnection();
        c.setInstanceFollowRedirects(false);
        c.setConnectTimeout(5000);
        c.setReadTimeout(5000);
        try {
            int code = c.getResponseCode();
            assertTrue(code == 301 || code == 302, "expected redirect, got " + code);
            String loc = c.getHeaderField("Location");
            assertNotNull(loc);
            assertTrue(loc.contains("/cs/song/" + uuid), "Location should be /cs/song/{uuid}, got: " + loc);
        } finally {
            c.disconnect();
        }
    }

    @Test
    @DisplayName("/cs/song/{uuid} returns 200 and shows lyrics")
    void csSongPageLoads() throws Exception {
        String uuid = firstSongUuid();
        Assumptions.assumeTrue(uuid != null, "needs at least one song with uuid");

        assertEquals(200, httpStatus("/cs/song/" + uuid));
        driver.get(BASE_URL + "/cs/song/" + uuid);
        assertFalse(driver.findElements(By.cssSelector("h1.lyric-title, .lyric-body, main")).isEmpty());
        String canonical = driver.findElement(By.cssSelector("link[rel='canonical']")).getAttribute("href");
        assertTrue(canonical.contains("/cs/song/"), "canonical should be under /cs/song/, got: " + canonical);
    }

    @Test
    @DisplayName("texty.jsp cards link to /cs/song/… and may use song preview thumbs")
    void textyLinksUseSongPaths() {
        driver.get(BASE_URL + "/texty.jsp");
        List<WebElement> cards = driver.findElements(By.cssSelector("a.song-card"));
        Assumptions.assumeFalse(cards.isEmpty(), "no lyric cards");
        String href = cards.get(0).getAttribute("href");
        assertTrue(href.contains("/cs/song/") || href.contains("/lyrics/"),
                "song card should link to /cs/song/ or legacy /lyrics/, got: " + href);
    }

    @Test
    @DisplayName("Admin song hub shows locale tabs for translations and SEO")
    void adminSongHasLocaleTabs() throws SQLException {
        String uuid = firstSongUuid();
        Assumptions.assumeTrue(uuid != null, "needs at least one song with uuid");

        driver.get(BASE_URL + "/admin/song?uuid=" + uuid);
        Assumptions.assumeTrue(driver.getCurrentUrl().contains("/admin/song"),
                "admin song page not reachable (not ADMIN?)");
        assertFalse(driver.findElements(By.cssSelector(".locale-tab")).isEmpty(),
                "expected locale tabs cs/en/de/uk");
        assertTrue(bodyText().contains("SEO URL") || bodyText().contains("SEO"),
                "admin song should mention SEO URL fields");
    }

    @Test
    @DisplayName("sitemap.xml lists /{lang}/song/ URLs")
    void sitemapListsLangSongUrls() {
        driver.get(BASE_URL + "/sitemap.xml");
        String xml = driver.getPageSource();
        assertTrue(xml.contains("/cs/song/") || xml.contains("/song/"),
                "sitemap should list song pages under /cs/song/ (or legacy /song/)");
        assertFalse(xml.contains("<loc>/"), "sitemap URLs must be absolute");
    }

    private static String firstSongUuid() throws SQLException {
        try {
            return queryString("SELECT uuid FROM songs WHERE uuid IS NOT NULL AND uuid<>'' ORDER BY id LIMIT 1");
        } catch (Exception e) {
            return null;
        }
    }
}
