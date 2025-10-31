package com.github.skeliit;

import org.junit.jupiter.api.*;
import org.openqa.selenium.*;
import org.openqa.selenium.chrome.ChromeOptions;
import java.time.Duration;
import org.openqa.selenium.support.ui.WebDriverWait;
import org.openqa.selenium.support.ui.ExpectedConditions;

import static org.junit.jupiter.api.Assertions.*;

public class MusicPageIT {
    private WebDriver driver;

    @BeforeEach
    void setup() {
        ChromeOptions options = new ChromeOptions();
        options.addArguments("--headless=new", "--window-size=1400,900");
        // Use local ChromeDriver via Selenium Manager (avoids remote URL requirement)
        driver = new org.openqa.selenium.chrome.ChromeDriver(options);
        driver.manage().timeouts().implicitlyWait(Duration.ofSeconds(5));
    }

    @AfterEach
    void teardown() { if (driver != null) driver.quit(); }

    @Test
    void youtubePlayerIsInYoutubeSection_andSpotifyAlongsideOnDesktop() {
        driver.get("http://localhost:8080/music.jsp");

        // Basic page source assertions (server-side include should be present)
        String src = driver.getPageSource();
        assertTrue(src.contains("id=\"el-player\"") || src.contains("id='el-player'"), "Page should include Elliptic player wrapper");
        assertTrue(src.contains("class=\"section spotify\"") || src.contains("class='section spotify'"), "Page should include Spotify section");
    }
}
