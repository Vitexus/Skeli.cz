package com.github.skeliit.dao;

import com.github.skeliit.Db;
import com.github.skeliit.model.VideoItem;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class VideoDao {
    public List<VideoItem> listVideos() throws SQLException {
        String sql = "SELECT v.youtube_id, COALESCE(v.title, s.name, v.youtube_id) AS title, s.year " +
                     "FROM videos v LEFT JOIN songs s ON s.id=v.song_id " +
                     "ORDER BY s.year DESC, COALESCE(v.title, s.name, v.youtube_id) ASC";
        try (Connection c = Db.get(); PreparedStatement ps = c.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            List<VideoItem> out = new ArrayList<>();
            while (rs.next()) {
                VideoItem v = new VideoItem();
                v.youtubeId = rs.getString(1);
                v.title = rs.getString(2);
                v.year = rs.getString(3);
                out.add(v);
            }
            return out;
        }
    }
}
