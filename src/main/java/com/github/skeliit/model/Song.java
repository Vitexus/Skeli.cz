package com.github.skeliit.model;

public class Song {
    public int id;
    public String name;
    public Integer year;
    public Integer firstLyricId;

    // Getters for EL expressions
    public int getId() { return id; }
    public String getName() { return name; }
    public Integer getYear() { return year; }
    public Integer getFirstLyricId() { return firstLyricId; }
}
