package com.github.skeliit;

import com.github.skeliit.model.LyricView;
import com.github.skeliit.model.Song;
import com.github.skeliit.model.SongLocale;
import org.junit.jupiter.api.Test;

import static org.junit.jupiter.api.Assertions.*;

class SongPublicPathTest {

    @Test
    void songUsesLangPrefixAndPrefersCzechSlug() {
        Song s = new Song();
        s.uuid = "01daa1c7-74a6-4f61-b940-53c4a8d27e4c";
        s.seoSlug = "musis-odejit";
        assertEquals("/cs/song/musis-odejit", s.getPublicPath());
        assertEquals("/cs/song/musis-odejit", s.getPublicPath("cs"));
        assertEquals("/en/song/01daa1c7-74a6-4f61-b940-53c4a8d27e4c", s.getPublicPath("en"));
    }

    @Test
    void songFallsBackToUuid() {
        Song s = new Song();
        s.uuid = "01daa1c7-74a6-4f61-b940-53c4a8d27e4c";
        assertEquals("/cs/song/01daa1c7-74a6-4f61-b940-53c4a8d27e4c", s.getPublicPath("cs"));
    }

    @Test
    void lyricViewPathUsesLangAndSlug() {
        LyricView v = new LyricView();
        v.id = 4;
        v.lang = "en";
        v.songUuid = "01daa1c7-74a6-4f61-b940-53c4a8d27e4c";
        v.songSeoSlug = "you-must-leave";
        assertEquals("/en/song/you-must-leave", v.getPublicPath());
    }

    @Test
    void songLocalePublicPath() {
        SongLocale loc = new SongLocale();
        loc.lang = "de";
        loc.seoSlug = "du-musst-gehen";
        assertEquals("/de/song/du-musst-gehen", loc.publicPath("ignored-when-slug-set"));
        loc.seoSlug = null;
        assertEquals("/de/song/abc-uuid", loc.publicPath("abc-uuid"));
    }
}
