package com.github.skeliit.model;

import java.sql.Timestamp;

public class CommentView {
    public int id;
    public int userId;
    public String username;
    public String avatarUrl;
    public Timestamp createdAt;
    public String content;
    
    // Getters for EL expressions
    public int getId() { return id; }
    public int getUserId() { return userId; }
    public String getUsername() { return username; }
    public String getAvatarUrl() { return avatarUrl; }
    public Timestamp getCreatedAt() { return createdAt; }
    public String getContent() { return content; }
}
