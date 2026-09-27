package com.github.skeliit;

import org.junit.jupiter.api.Test;
import static org.junit.jupiter.api.Assertions.*;

public class I18nTest {
    @Test
    void keepsSupportedLang() {
        assertEquals("en", I18n.safeLang("en"));
    }

    @Test
    void rejectsInjectedLang() {
        assertEquals("cs", I18n.safeLang("cs';alert(1);//"));
        assertEquals("cs", I18n.safeLang("../../web"));
    }

    @Test
    void nullAndNonStringFallBackToDefault() {
        assertEquals("cs", I18n.safeLang(null));
        assertEquals("cs", I18n.safeLang(42));
    }
}
