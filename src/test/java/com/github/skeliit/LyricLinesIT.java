package com.github.skeliit;

import org.junit.jupiter.api.Test;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import static org.junit.jupiter.api.Assertions.assertTrue;

/**
 * Every translation of a song has as many sung lines as the Czech text: the karaoke times are one per
 * Czech line and the translations use them too, and the reader expects verse for verse. Catches a
 * shortened sample ("[gekürzt]"), two lines run into one, or a "(2×)" left in one language.
 */
class LyricLinesIT {

    @Test
    void translationsHaveTheCzechLines() throws Exception {
        Map<Integer, Integer> czech = new HashMap<>();
        List<Object[]> others = new ArrayList<>();
        try (Connection c = UiTestSupport.db();
             PreparedStatement ps = c.prepareStatement("SELECT s.id, s.name, l.lang, l.words FROM lyrics l JOIN songs s ON s.id = l.song_id");
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                int lines = (int) rs.getString(4).lines().filter(x -> !x.isBlank()).count();
                if ("cs".equals(rs.getString(3))) czech.put(rs.getInt(1), lines);
                else others.add(new Object[]{rs.getInt(1), rs.getString(2), rs.getString(3), lines});
            }
        }
        List<String> wrong = new ArrayList<>();
        for (Object[] o : others) {
            Integer cs = czech.get((Integer) o[0]);
            if (cs != null && !cs.equals(o[3])) wrong.add(o[1] + " (" + o[2] + "): " + o[3] + " lines, Czech " + cs);
        }
        assertTrue(wrong.isEmpty(), "translations out of step with the Czech text: " + wrong);
    }
}
