package com.github.skeliit.model;

public class Song {
    public int id;
    public String uuid;
    public String name;
    public Integer year;
    public Integer firstLyricId;
    public String appleMusicId;
    public String spotifyId;
    public String previewImageUrl;

    // Getters for EL expressions
    public int getId() { return id; }
    public String getUuid() { return uuid; }
    public String getName() { return name; }
    public Integer getYear() { return year; }
    public Integer getFirstLyricId() { return firstLyricId; }
    public String getAppleMusicId() { return appleMusicId; }
    public String getSpotifyId() { return spotifyId; }
    public String getPreviewImageUrl() { return previewImageUrl; }
}
