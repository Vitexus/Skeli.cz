package com.github.skeliit;

import org.junit.jupiter.api.Test;

import static org.junit.jupiter.api.Assertions.*;

/** Visitors' e-mails in the admin: enough to tell them apart, never the whole address. */
class MaskEmailTest {

    @Test
    void masksTheNameAndTheDomain() {
        assertEquals("ja•••@s•••.cz", WebUtils.maskEmail("jan.novak@seznam.cz"));
        assertEquals("in•••@v•••.cz", WebUtils.maskEmail("info@vitexsoftware.cz"));
        assertEquals("j•••@g•••.com", WebUtils.maskEmail("jan@gmail.com"));
    }

    @Test
    void oddInputStaysMasked() {
        assertEquals("", WebUtils.maskEmail(null));
        assertEquals("", WebUtils.maskEmail(" "));
        assertEquals("x•••", WebUtils.maskEmail("xyz"));
        assertEquals("•••@l•••", WebUtils.maskEmail("@localhost"));
        assertFalse(WebUtils.maskEmail("someone@example.org").contains("someone"));
    }
}
