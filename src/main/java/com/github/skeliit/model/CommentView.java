package com.github.skeliit.model;

import java.sql.Timestamp;

public class CommentView {
    public int id;
    public int userId;
    public String username;
    public String avatarUrl;
    public Timestamp createdAt;
    public String content;
}
