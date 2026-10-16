package com.github.skeliit.web.auth;

import org.junit.jupiter.api.Test;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertNull;

/** The address the visitor is on, read for the Google sign-in (skeli.cz without www is sent over to www first). */
class GoogleHostTest {
    @Test
    void behindApacheTheForwardedHostCounts() {
        assertEquals("skeli.cz", GoogleSignInServlet.requestHost("skeli.cz", "127.0.0.1:8083"));
        assertEquals("www.skeli.cz", GoogleSignInServlet.requestHost("www.skeli.cz, proxy.local", "127.0.0.1:8083"));
    }

    @Test
    void withoutAProxyTheHostHeaderWithoutItsPort() {
        assertEquals("localhost", GoogleSignInServlet.requestHost(null, "localhost:8080"));
        assertEquals("[::1]", GoogleSignInServlet.requestHost("", "[::1]:8080"));
        assertNull(GoogleSignInServlet.requestHost(null, null));
    }
}
