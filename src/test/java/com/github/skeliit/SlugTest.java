package com.github.skeliit;

import org.junit.jupiter.api.Test;
import static org.junit.jupiter.api.Assertions.*;

public class SlugTest {
    @Test
    void basicSlug() {
        assertEquals("skeli-tisic-kousku", WebUtils.slugify("Skeli - Tisíc kousků"));
    }

    @Test
    void trimsDashes() {
        assertEquals("abc", WebUtils.slugify("--ABC--"));
    }

    @Test
    void nullSafe() {
        assertEquals("", WebUtils.slugify(null));
    }
}