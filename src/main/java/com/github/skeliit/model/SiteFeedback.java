package com.github.skeliit.model;

import java.sql.Timestamp;

/** One user's rating of the site ("Co říkáš na web?"): thumbs up or down and an optional message. */
public class SiteFeedback {
    public final int id;
    public final int userId;
    public final String username;
    public final String avatar;
    /** +1 or -1 */
    public final int vote;
    public final String message;
    public final Timestamp at;
    /** the artist gave it a heart: it is shown on the home page */
    public final boolean hearted;

    public SiteFeedback(int id, int userId, String username, String avatar, int vote, String message, Timestamp at, boolean hearted) {
        this.id = id; this.userId = userId; this.username = username; this.avatar = avatar;
        this.vote = vote; this.message = message; this.at = at; this.hearted = hearted;
    }

    public int getId() { return id; }
    public String getUsername() { return username; }
    public String getAvatar() { return avatar; }
    public int getVote() { return vote; }
    public String getMessage() { return message; }
    public Timestamp getAt() { return at; }
    public boolean isHearted() { return hearted; }
    public boolean isUp() { return vote > 0; }
}
