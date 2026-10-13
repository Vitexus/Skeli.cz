package com.github.skeliit.web.auth;

import org.junit.jupiter.api.Test;

import java.nio.charset.StandardCharsets;
import java.util.Base64;

import static org.junit.jupiter.api.Assertions.*;

/** Sign in with Google: which ID tokens are accepted, and the username a new account gets. */
class GoogleSignInTest {
    private static final String CLIENT = "123.apps.googleusercontent.com";

    private static String token(String payload) {
        Base64.Encoder e = Base64.getUrlEncoder().withoutPadding();
        return e.encodeToString("{\"alg\":\"RS256\"}".getBytes(StandardCharsets.UTF_8)) + "."
                + e.encodeToString(payload.getBytes(StandardCharsets.UTF_8)) + ".sig";
    }

    @Test
    void acceptsAGoogleTokenForUs() throws Exception {
        var c = GoogleSignInServlet.claims(token("{\"iss\":\"https://accounts.google.com\",\"aud\":\"" + CLIENT + "\",\"exp\":2000,\"sub\":\"42\",\"email\":\"a@b.cz\",\"email_verified\":true}"), CLIENT, 1000);
        assertNotNull(c);
        assertEquals("42", c.path("sub").asText());
    }

    @Test
    void refusesOtherIssuersAudiencesAndOldTokens() throws Exception {
        assertNull(GoogleSignInServlet.claims(token("{\"iss\":\"https://evil.example\",\"aud\":\"" + CLIENT + "\",\"exp\":2000,\"sub\":\"42\"}"), CLIENT, 1000));
        assertNull(GoogleSignInServlet.claims(token("{\"iss\":\"accounts.google.com\",\"aud\":\"someone-else\",\"exp\":2000,\"sub\":\"42\"}"), CLIENT, 1000));
        assertNull(GoogleSignInServlet.claims(token("{\"iss\":\"accounts.google.com\",\"aud\":\"" + CLIENT + "\",\"exp\":900,\"sub\":\"42\"}"), CLIENT, 1000));
        assertNull(GoogleSignInServlet.claims(token("{\"iss\":\"accounts.google.com\",\"aud\":\"" + CLIENT + "\",\"exp\":2000}"), CLIENT, 1000));
        assertNull(GoogleSignInServlet.claims("not-a-token", CLIENT, 1000));
    }

    @Test
    void makesAUsernameTheSiteAllows() {
        assertEquals("Radek.Dvorak", GoogleSignInServlet.usernameFrom("Radek Dvořák", "x@y.cz"));
        assertEquals("skeli.mc", GoogleSignInServlet.usernameFrom("🔥", "skeli.mc@gmail.com"));
        assertEquals("fanousek", GoogleSignInServlet.usernameFrom("", null));
        assertTrue(GoogleSignInServlet.usernameFrom("a".repeat(80), null).length() <= 50);
        assertTrue(GoogleSignInServlet.usernameFrom("Žluťoučký kůň", null).matches("[A-Za-z0-9._-]{3,50}"));
    }
}
