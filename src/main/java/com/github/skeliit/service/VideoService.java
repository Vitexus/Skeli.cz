package com.github.skeliit.service;

import com.github.skeliit.dao.VideoDao;
import com.github.skeliit.model.VideoItem;

import java.sql.SQLException;
import java.util.List;

public class VideoService {
    private final VideoDao dao = new VideoDao();
    public List<VideoItem> list() throws SQLException { return dao.listVideos(); }
}
