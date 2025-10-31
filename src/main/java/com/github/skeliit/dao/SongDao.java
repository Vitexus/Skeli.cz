package com.github.skeliit.dao;

import com.github.skeliit.Db;
import com.github.skeliit.model.Song;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class SongDao {
    public List<Song> listWithFirstLyric() throws SQLException {
        String sql = "SELECT s.id, s.name, s.year, (SELECT MIN(l.id) FROM lyrics l WHERE l.song_id=s.id) AS firstLyricId FROM songs s ORDER BY s.name ASC";
        try (Connection c = Db.get(); PreparedStatement ps = c.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            List<Song> out = new ArrayList<>();
            while (rs.next()) {
                Song s = new Song();
                s.id = rs.getInt("id");
                s.name = rs.getString("name");
                int y = rs.getInt("year"); s.year = rs.wasNull()? null : y;
                int fl = rs.getInt("firstLyricId"); s.firstLyricId = rs.wasNull()? null : fl;
                out.add(s);
            }
            return out;
        }
    }
}
