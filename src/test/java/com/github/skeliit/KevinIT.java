package com.github.skeliit;

import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.openqa.selenium.By;
import org.openqa.selenium.JavascriptExecutor;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.support.ui.ExpectedConditions;
import org.openqa.selenium.support.ui.WebDriverWait;

import java.time.Duration;
import java.util.List;

import static org.junit.jupiter.api.Assertions.*;

/** MC Kevin's menu: find a song, play a clip, what's new since the last visit, the admin's to-do list. */
class KevinIT extends UiTestSupport {

    /** Opens a page with the cookie bar already answered (Kevin waits for it) and waits for him. */
    private void openWithKevin(String path, String beforeReload) {
        driver.get(BASE_URL + path);
        ((JavascriptExecutor) driver).executeScript(
                "localStorage.setItem('cookieConsent','true'); localStorage.setItem('sp_min','1'); sessionStorage.clear();" + beforeReload);
        driver.navigate().refresh();
        new WebDriverWait(driver, Duration.ofSeconds(10))
                .until(ExpectedConditions.presenceOfElementLocated(By.cssSelector(".kevin-body")));
    }

    private WebElement waitFor(String css) {
        return new WebDriverWait(driver, Duration.ofSeconds(10))
                .until(ExpectedConditions.visibilityOfElementLocated(By.cssSelector(css)));
    }

    /** What Kevin said on his own: in the bubble when he peeked out, or behind the gold dot on his paw. */
    private String heard() {
        new WebDriverWait(driver, Duration.ofSeconds(15)).until(d -> !d.findElements(By.cssSelector(".kevin-paw.has-news")).isEmpty()
                || d.findElement(By.cssSelector(".kevin-bubble")).isDisplayed());
        if (!driver.findElements(By.cssSelector(".kevin-paw.has-news")).isEmpty()) jsClick(driver.findElement(By.cssSelector(".kevin-paw")));
        return waitFor(".kevin-bubble .kevin-text").getText();
    }

    private void menuItem(int index) {
        jsClick(driver.findElement(By.cssSelector(".kevin-body")));
        List<WebElement> chips = new WebDriverWait(driver, Duration.ofSeconds(5))
                .until(ExpectedConditions.numberOfElementsToBeMoreThan(By.cssSelector(".kevin-menu .kevin-chip"), index));
        jsClick(chips.get(index));
    }

    @Test
    @DisplayName("Kevin finds a song by its name and links to it")
    void findsASong() throws Exception {
        String name = queryString("SELECT s.name FROM songs s WHERE EXISTS (SELECT 1 FROM lyrics l WHERE l.song_id = s.id) "
                + "AND s.name NOT LIKE '%(%' ORDER BY s.id LIMIT 1");
        assertNotNull(name, "the local DB needs a song with lyrics");
        openWithKevin("/", "");
        menuItem(0);
        WebElement input = waitFor(".kevin-find input");
        input.sendKeys(name.replaceFirst("(?i)^\\s*skeli\\s*-\\s*", "").substring(0, 4));
        WebElement first = waitFor(".kevin-results a");
        assertTrue(first.getAttribute("href").contains("/song/") || first.getAttribute("href").contains("/lyrics/"),
                "a result links to the song: " + first.getAttribute("href"));
    }

    @Test
    @DisplayName("'Play something' opens the small TV with a YouTube clip, the cross closes it")
    void playsAClip() throws Exception {
        assertTrue(queryInt("SELECT COUNT(*) FROM videos") > 0, "the local DB needs a clip");
        openWithKevin("/", "");
        menuItem(1);
        WebElement frame = waitFor(".kevin-tv iframe");
        assertTrue(frame.getAttribute("src").startsWith("https://www.youtube-nocookie.com/embed/"), frame.getAttribute("src"));
        jsClick(driver.findElement(By.cssSelector(".kevin-tv-close")));
        assertTrue(driver.findElements(By.cssSelector(".kevin-tv")).isEmpty());
    }

    @Test
    @DisplayName("Back after a while: Kevin says what came out since the last visit")
    void whatsNew() throws Exception {
        int clips = queryInt("SELECT COUNT(*) FROM videos WHERE published_at > NOW() - INTERVAL 25 DAY");
        int posts = queryInt("SELECT (SELECT COUNT(*) FROM social_posts WHERE created_at > NOW() - INTERVAL 25 DAY)"
                + " + (SELECT COUNT(*) FROM shorts WHERE published_at > NOW() - INTERVAL 25 DAY)");
        long lastVisit = System.currentTimeMillis() - 25L * 24 * 3600 * 1000;
        openWithKevin("/", "localStorage.setItem('kevinLastVisit','" + lastVisit + "');");
        String said = heard();
        if (clips + posts > 0) {
            assertTrue(said.startsWith("Od tvý minulý návštěvy"), "news, got: " + said);
        } else {
            assertFalse(said.isBlank());
        }
    }

    @Test
    @DisplayName("The admin's to-do list is only for admins; on the dashboard Kevin reads it out")
    void adminStatus() throws Exception {
        driver.get(BASE_URL + "/");
        assertEquals(403, httpStatus("/admin/kevin"), "anonymous");
        String admin = "kv" + uniq();
        int id = registerAndLogin(admin);
        assertEquals(403, httpStatus("/admin/kevin"), "a plain user");
        update("UPDATE users SET role='ADMIN' WHERE id=?", id);
        // the role is kept in the session at login, so log in again
        logout();
        login(admin, PASSWORD);
        assertEquals(200, httpStatus("/admin/kevin"), "admin");
        openWithKevin("/admin.jsp", "");
        String said = heard();
        assertTrue(said.startsWith("Šéfe") || said.startsWith("Všechno čistý"), "admin status, got: " + said);
    }
    @Test
    @DisplayName("Phone: Kevin is a paw in the header bar; his hello waits behind a dot, a tap brings him out and back")
    void phoneKeepsHimInThePaw() throws Exception {
        driver.manage().window().setSize(new org.openqa.selenium.Dimension(390, 844));
        try {
            openWithKevin("/", "localStorage.removeItem('kevin');");
            WebDriverWait wait = new WebDriverWait(driver, Duration.ofSeconds(15));
            // no free edge on a phone: the hello waits behind a gold dot on the paw, in the header bar
            WebElement paw = wait.until(ExpectedConditions.visibilityOfElementLocated(By.cssSelector(".site-header .kevin-paw.has-news")));
            assertFalse(driver.findElement(By.cssSelector(".kevin")).isDisplayed(), "nothing of him over the page");
            jsClick(paw);
            assertFalse(waitFor(".kevin-bubble .kevin-text").getText().isBlank(), "a tap: he says it");
            jsClick(paw);   // a second tap: back in
            wait.until(d -> !d.findElement(By.cssSelector(".kevin")).isDisplayed());
            jsClick(paw);   // nothing waiting: his menu
            assertTrue(waitFor(".kevin-menu .kevin-chip").isDisplayed(), "the paw opens his menu");
        } finally {
            driver.manage().window().setSize(new org.openqa.selenium.Dimension(1400, 900));
        }
    }

    @Test
    @DisplayName("Wide screen: a tip makes him peek out only where nothing of the page is under him")
    void peeksOnlyIntoFreeSpace() throws Exception {
        driver.manage().window().setSize(new org.openqa.selenium.Dimension(1920, 1080));
        try {
            for (String page : new String[]{"/texty.jsp", "/", "/about.jsp"}) {
                openWithKevin(page, "localStorage.removeItem('kevin');");
                Thread.sleep(2500);
                ((JavascriptExecutor) driver).executeScript("window.dispatchEvent(new CustomEvent('kevin', { detail: { tip: true } }))");
                Thread.sleep(1500);
                Object hit = ((JavascriptExecutor) driver).executeScript(
                        "const k = document.querySelector('.kevin'); if (!k || k.hidden) return document.querySelector('.kevin-paw.has-news') ? 'dot' : 'nothing';"
                        + "const boxes = [k.querySelector('.kevin-body'), k.querySelector('.kevin-bubble')].filter(e => e && !e.hidden).map(e => e.getBoundingClientRect());"
                        + "const sel = 'a, button, img, p, h1, h2, h3, li, pre, iframe, video, canvas, input, .card';"
                        + "for (const el of document.querySelectorAll(sel)) { if (k.contains(el) || el.closest('.site-header, .kevin-paw')) continue;"
                        + "  const r = el.getBoundingClientRect(); if (!r.width || !r.height || getComputedStyle(el).visibility === 'hidden') continue;"
                        + "  for (const b of boxes) if (r.left < b.right - 30 && r.right > b.left + 30 && r.top < b.bottom - 10 && r.bottom > b.top + 10) return 'covers ' + el.tagName + '.' + el.className; }"
                        + "return 'peek';");
                assertFalse(String.valueOf(hit).startsWith("covers"), page + ": " + hit);
                assertNotEquals("nothing", hit, page + ": the tip got lost");
            }
        } finally {
            driver.manage().window().setSize(new org.openqa.selenium.Dimension(1400, 900));
        }
    }
}
