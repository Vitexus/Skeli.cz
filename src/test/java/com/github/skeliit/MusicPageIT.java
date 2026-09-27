package com.github.skeliit;

import org.junit.jupiter.api.*;
import org.openqa.selenium.*;
import org.openqa.selenium.chrome.ChromeDriver;
import org.openqa.selenium.chrome.ChromeOptions;
import org.openqa.selenium.support.ui.ExpectedConditions;
import org.openqa.selenium.support.ui.WebDriverWait;

import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.time.Duration;
import java.util.List;
import java.util.regex.Pattern;

import static org.junit.jupiter.api.Assertions.*;

/**
 * Music / homepage UI checks. Override target with -Dit.baseUrl=https://test.skeli.cz
 */
public class MusicPageIT {
    private static final String BASE_URL = System.getProperty("it.baseUrl", "http://localhost:8080")
            .replaceAll("/$", "");

    /** DB auth failure that appears when .env is missing and Db falls back to user skeli / no password. */
    private static final Pattern DB_ACCESS_DENIED = Pattern.compile(
            "Access denied for user ['\"]?skeli['\"]?@['\"]?localhost['\"]?.*password:\\s*NO",
            Pattern.CASE_INSENSITIVE | Pattern.DOTALL);

    private WebDriver driver;

    @BeforeEach
    void setup() {
        ChromeOptions options = new ChromeOptions();
        options.addArguments("--headless=new", "--no-sandbox", "--disable-dev-shm-usage", "--window-size=1400,900");
        driver = new ChromeDriver(options);
        driver.manage().timeouts().implicitlyWait(Duration.ofSeconds(5));
    }

    @AfterEach
    void teardown() { if (driver != null) driver.quit(); }

    @Test
    void homepageScreenshotIsTaken() throws Exception {
        driver.get(BASE_URL + "/");
        dismissCookieBanner();
        saveScreenshot("home-page-overview.png");
        assertTrue(driver.getTitle().toLowerCase().contains("skeli"),
                "Home page should render and have title containing Skeli");
        assertNoDbAccessDenied("homepage");
    }

    @Test
    void homepageVideosDoNotShowDbAccessDenied() {
        driver.get(BASE_URL + "/");
        dismissCookieBanner();
        String src = driver.getPageSource();
        assertNoDbAccessDenied("homepage");
        // Either real video cards, or the i18n empty/error note — never a raw JDBC dump
        boolean hasVideos = src.contains("class=\"video\"") || src.contains("video-thumb");
        boolean hasFriendlyError = src.contains("Videa se teď nepodařilo načíst")
                || src.contains("Videos could not be loaded");
        assertTrue(hasVideos || hasFriendlyError,
                "Homepage should show video cards or a friendly load error, got neither on " + BASE_URL);
        assertFalse(DB_ACCESS_DENIED.matcher(src).find(),
                "Homepage must not expose JDBC Access denied (missing .env / DB_PASS). Body snippet: "
                        + snippetAround(src, "Access denied"));
    }

    @Test
    void youtubePlayerIsInYoutubeSection() throws Exception {
        driver.get(BASE_URL + "/music.jsp");
        dismissCookieBanner();
        String src = driver.getPageSource();
        assertNoDbAccessDenied("music.jsp");
        assertTrue(src.contains("ep-wrap") || src.contains("ep-carousel"),
                "Page should include EllipticPlayer carousel");
        assertTrue(src.contains("fab fa-youtube"), "Page should include YouTube section header");
        saveScreenshot("music-page-overview.png");
    }

    @Test
    void musicPageVideosLoadWithoutDbAccessDenied() {
        driver.get(BASE_URL + "/music.jsp");
        dismissCookieBanner();
        String src = driver.getPageSource();
        assertNoDbAccessDenied("music.jsp");
        assertFalse(src.contains("Chyba načítání videí"),
                "music.jsp must not show 'Chyba načítání videí' (DB misconfig)");
        assertTrue(src.contains("videos.push({id:") || src.contains("ep-item"),
                "music.jsp should include video data or carousel items on " + BASE_URL);
    }

    @Test
    void carouselThumbnailsAreVisible() throws Exception {
        driver.get(BASE_URL + "/music.jsp");
        dismissCookieBanner();
        assertNoDbAccessDenied("music.jsp carousel");
        WebDriverWait wait = new WebDriverWait(driver, Duration.ofSeconds(15));
        wait.until(ExpectedConditions.presenceOfElementLocated(By.cssSelector(".ep-item")));

        WebElement active = driver.findElement(By.cssSelector(".ep-item.is-active"));
        assertTrue(active.getSize().getHeight() > 0,
                "Active carousel item must have non-zero height (aspect-ratio:16/9 required)");

        WebElement img = active.findElement(By.tagName("img"));
        assertTrue(img.getSize().getHeight() > 0,
                "Thumbnail image inside active carousel item must be visible (non-zero height)");

        String src = img.getAttribute("src");
        assertTrue(src != null && (src.contains("img.youtube.com") || src.contains("i.ytimg.com")
                        || src.contains("/uploads/song-previews/")),
                "Thumbnail should be YouTube CDN or song preview, got: " + src);

        saveScreenshot("music-page-carousel.png");
    }

    @Test
    void carouselNavigationShowsAdjacentItems() throws Exception {
        driver.get(BASE_URL + "/music.jsp");
        dismissCookieBanner();
        assertNoDbAccessDenied("music.jsp nav");
        WebDriverWait wait = new WebDriverWait(driver, Duration.ofSeconds(15));
        wait.until(ExpectedConditions.presenceOfElementLocated(By.cssSelector(".ep-item.is-active")));

        List<WebElement> items = driver.findElements(By.cssSelector(".ep-item"));
        if (items.size() < 2) return;

        WebElement nextBtn = driver.findElement(By.id("ep-next"));
        assertTrue(nextBtn.isDisplayed(), "Next arrow must be visible");
        nextBtn.click();

        wait.until(ExpectedConditions.presenceOfElementLocated(By.cssSelector(".ep-item.is-active")));
        WebElement newActive = driver.findElement(By.cssSelector(".ep-item.is-active"));
        assertTrue(newActive.getSize().getHeight() > 0,
                "After navigation, active item must still have non-zero height");

        saveScreenshot("music-page-navigation.png");
    }

    @Test
    void textyPageLinksPreferSongUuidPaths() {
        driver.get(BASE_URL + "/texty.jsp");
        dismissCookieBanner();
        assertNoDbAccessDenied("texty.jsp");
        String src = driver.getPageSource();
        assertTrue(src.contains("song-card"), "texty.jsp should list song cards");
        assertTrue(src.contains("/cs/song/") || src.contains("/lyrics/"),
                "texty cards should link to /cs/song/… or /lyrics/…");
    }

    @Test
    void legacySongUuidRedirectsToCsPath() {
        driver.get(BASE_URL + "/texty.jsp");
        dismissCookieBanner();
        var links = driver.findElements(By.cssSelector("a.song-card[href*='/cs/song/']"));
        if (links.isEmpty()) return;
        String href = links.get(0).getAttribute("href");
        String key = href.replaceAll(".*/cs/song/", "").replaceAll("[?#].*$", "");
        if (!key.matches("(?i)[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}")) return;
        driver.get(BASE_URL + "/song/" + key);
        assertTrue(driver.getCurrentUrl().contains("/cs/song/" + key),
                "legacy /song/{uuid} should land on /cs/song/{uuid}, got: " + driver.getCurrentUrl());
        assertTrue(driver.getPageSource().length() > 500, "song page should render content");
    }

    private void dismissCookieBanner() {
        try {
            List<WebElement> btns = driver.findElements(By.cssSelector("button"));
            for (WebElement b : btns) {
                String t = b.getText() == null ? "" : b.getText().trim();
                if (t.equalsIgnoreCase("Souhlasím") || t.equalsIgnoreCase("Accept") || t.equalsIgnoreCase("I agree")) {
                    b.click();
                    return;
                }
            }
        } catch (Exception ignore) { /* banner optional */ }
    }

    private void assertNoDbAccessDenied(String where) {
        String src = driver.getPageSource();
        if (DB_ACCESS_DENIED.matcher(src).find() || src.contains("Chyba načítání videí")) {
            fail("DB access error on " + where + " @ " + BASE_URL + ": "
                    + snippetAround(src, src.contains("Access denied") ? "Access denied" : "Chyba načítání"));
        }
    }

    private static String snippetAround(String src, String needle) {
        int i = src.toLowerCase().indexOf(needle.toLowerCase());
        if (i < 0) return "(not found)";
        int from = Math.max(0, i - 80);
        int to = Math.min(src.length(), i + needle.length() + 120);
        return src.substring(from, to).replaceAll("\\s+", " ");
    }

    private void saveScreenshot(String fileName) throws Exception {
        Path outDir = Paths.get("target", "screenshots");
        Files.createDirectories(outDir);
        Path filePath = outDir.resolve(fileName);
        byte[] screenshot = ((TakesScreenshot) driver).getScreenshotAs(OutputType.BYTES);
        Files.write(filePath, screenshot);
    }
}
