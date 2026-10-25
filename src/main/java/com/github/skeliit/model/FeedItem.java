package com.github.skeliit.model;

import java.time.Instant;

/**
 * One entry of an RSS/Atom feed (/{lang}/feed/*).
 *
 * @param id        stable tag: URI; the same video/short has the same id in every feed
 * @param title     plain text
 * @param link      absolute URL of the entry's page
 * @param summary   plain text, may be null
 * @param imageUrl  absolute thumbnail URL, may be null
 * @param published first publication, may be null (sorted last)
 * @param updated   last change, falls back to published
 * @param category  song | video | short | instagram | facebook …
 * @param videoId   YouTube id for media:player, may be null
 */
public record FeedItem(String id, String title, String link, String summary, String imageUrl,
                       Instant published, Instant updated, String category, String videoId) {

    public Instant updatedOrPublished() {
        return updated != null ? updated : published;
    }
}
