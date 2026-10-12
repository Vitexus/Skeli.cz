package com.github.skeliit;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import org.junit.jupiter.api.Test;

import java.nio.file.DirectoryStream;
import java.nio.file.Files;
import java.nio.file.Path;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

import static org.junit.jupiter.api.Assertions.assertTrue;

/**
 * The karaoke files (karaoke/<clip>.json, made by tools/karaoke-align.py) fit the Czech lyrics of their song:
 * one line time per sung line and, where there are word times, one per word (split at spaces), in order and
 * inside the line. Catches a text changed after the times were made.
 */
class KaraokeWordsIT {

    @Test
    void timesFitTheLyrics() throws Exception {
        ObjectMapper json = new ObjectMapper();
        List<String> wrong = new ArrayList<>();
        try (DirectoryStream<Path> files = Files.newDirectoryStream(Path.of("src/main/webapp/karaoke"), "*.json")) {
            for (Path f : files) {
                String yt = f.getFileName().toString().replace(".json", "");
                String words = UiTestSupport.queryString("SELECT l.words FROM videos v JOIN lyrics l ON l.song_id = v.song_id AND l.lang = 'cs' "
                        + "WHERE BINARY v.youtube_id = ?", yt);
                if (words == null) { wrong.add(yt + ": no Czech lyrics for the clip"); continue; }
                List<String> lines = words.lines().filter(l -> !l.isBlank()).toList();
                JsonNode k = json.readTree(f.toFile());
                if (k.get("times").size() != lines.size()) { wrong.add(yt + ": " + k.get("times").size() + " line times, " + lines.size() + " lines"); continue; }
                JsonNode w = k.get("words");
                if (w == null) continue;
                for (int i = 0; i < lines.size(); i++) {
                    int tokens = (int) Arrays.stream(lines.get(i).trim().split("\\s+")).filter(s -> !s.isEmpty()).count();
                    JsonNode line = w.get(i);
                    if (line.size() != tokens) { wrong.add(yt + " line " + (i + 1) + ": " + line.size() + " word times, " + tokens + " words"); continue; }
                    double prev = -1, ls = k.get("times").get(i).get(0).asDouble() - 0.01, le = k.get("times").get(i).get(1).asDouble() + 0.1;
                    for (JsonNode t : line) {
                        double s = t.get(0).asDouble(), e = t.get(1).asDouble();
                        if (s < prev || e < s || s < ls || s > le) { wrong.add(yt + " line " + (i + 1) + ": word at " + s + " out of order or outside the line"); break; }
                        prev = s;
                    }
                }
            }
        }
        assertTrue(wrong.isEmpty(), "karaoke times that do not fit the lyrics: " + wrong);
    }
}
