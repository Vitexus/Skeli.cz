package com.github.skeliit;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.net.*;
import java.nio.charset.StandardCharsets;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.JsonNode;

@WebServlet(name = "EllipticPlayerServlet", urlPatterns = {"/elliptic"})
public class EllipticPlayerServlet extends HttpServlet {
    private Connection getConn() throws SQLException {
        String url = "jdbc:mariadb://127.0.0.1:3306/skeliweb?useUnicode=true&characterEncoding=utf8mb4";
        return DriverManager.getConnection(url, "Skeli", "skeli");
    }

    private String fetchYtTitle(String ytId) {
        try {
            String oembed = "https://www.youtube.com/oembed?format=json&url="+
                    URLEncoder.encode("https://www.youtube.com/watch?v="+ytId, StandardCharsets.UTF_8);
            URL u = new URL(oembed);
            HttpURLConnection c = (HttpURLConnection) u.openConnection();
            c.setRequestMethod("GET");
            c.setConnectTimeout(2000); c.setReadTimeout(2000);
            try (java.io.InputStream in = c.getInputStream()) {
                ObjectMapper m = new ObjectMapper();
                JsonNode n = m.readTree(in);
                return n.path("title").asText(null);
            }
        } catch (Exception ignore) { }
        return null;
    }

    static class Vid { String id; String title; String year; }

    @Override protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        resp.setContentType("text/html; charset=UTF-8");
        List<Vid> vids = new ArrayList<>();
        String sql = "SELECT v.youtube_id, COALESCE(v.title, s.name, v.youtube_id) AS title, s.year " +
                     "FROM videos v LEFT JOIN songs s ON s.id=v.song_id " +
                     "ORDER BY s.year DESC, COALESCE(v.title, s.name, v.youtube_id) ASC";
        try (Connection c = getConn(); PreparedStatement ps = c.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Vid v = new Vid(); v.id = rs.getString(1); v.title = rs.getString(2); v.year = rs.getString(3);
                if (v.title == null || v.title.isBlank()) {
                    String t = fetchYtTitle(v.id);
                    if (t != null && !t.isBlank()) {
                        v.title = t;
                        try (PreparedStatement up = c.prepareStatement("UPDATE videos SET title=? WHERE youtube_id=?")) {
                            up.setString(1, t); up.setString(2, v.id); up.executeUpdate();
                        } catch (SQLException ignore) {}
                    }
                }
                vids.add(v);
            }
        } catch (SQLException e) { /* silent -> render empty */ }

        PrintWriter out = resp.getWriter();
        // Main video player - original size
        out.println("<div class='video-player' style='position:relative;border:1px solid var(--panel-border);border-radius:12px;background:#000;overflow:hidden;box-shadow:0 8px 24px rgba(0,0,0,.3);margin-bottom:20px;max-width:800px;width:70%;margin-left:auto;margin-right:auto;'>");
        out.println("  <div style='position:relative;padding-top:56.25%;'>");
        out.println("    <iframe id='main-frame' style='position:absolute;inset:0;width:100%;height:100%;border:0;' allow='autoplay; encrypted-media; picture-in-picture' allowfullscreen></iframe>");
        out.println("  </div>");
        out.println("</div>");
        
        // Thumbnail navigation strip with perspective scaling
        out.println("<div style='position:relative;background:rgba(0,0,0,0.3);border:1px solid var(--panel-border);border-radius:12px;padding:20px 16px;min-height:140px;'>");
        out.println("  <div style='display:flex;align-items:center;gap:12px;'>");
        out.println("    <button id='prev-btn' style='flex-shrink:0;width:36px;height:36px;border-radius:50%;background:rgba(255,255,255,0.1);border:1px solid var(--panel-border);color:var(--text);cursor:pointer;font-size:16px;display:flex;align-items:center;justify-content:center;transition:all 0.2s;z-index:100;'>◀</button>");
        out.println("    <div id='thumbs-container' style='flex:1;overflow:hidden;position:relative;height:120px;'>");
        out.println("      <div id='thumbs-track' style='display:flex;gap:8px;align-items:center;justify-content:center;position:absolute;left:50%;transform:translateX(-50%);transition:all 0.4s ease;'></div>");
        out.println("    </div>");
        out.println("    <button id='next-btn' style='flex-shrink:0;width:36px;height:36px;border-radius:50%;background:rgba(255,255,255,0.1);border:1px solid var(--panel-border);color:var(--text);cursor:pointer;font-size:16px;display:flex;align-items:center;justify-content:center;transition:all 0.2s;z-index:100;'>▶</button>");
        out.println("  </div>");
        out.println("</div>");

        // JavaScript for thumbnail navigation
        out.println("<script>");
        out.println("(function(){");
        out.println("const videos = [];");
        for (Vid v: vids) {
            String escTitle = v.title == null ? "" : v.title.replace("\\", "\\\\").replace("\"","\\\"");
            out.printf("videos.push({id:'%s', title:'%s'});%n", v.id, escTitle);
        }
        out.println(
            "const frame = document.getElementById('main-frame');\n" +
            "const track = document.getElementById('thumbs-track');\n" +
            "const container = document.getElementById('thumbs-container');\n" +
            "let currentIndex = 0;\n" +
            "let scrollOffset = 0;\n" +
            "const BASE_WIDTH = 160;\n" +
            "const BASE_HEIGHT = 90;\n" +
            "const VISIBLE_SIDES = 3;\n" +
            "\n" +
            "// Create thumbnails\n" +
            "videos.forEach((video, index) => {\n" +
            "  const thumb = document.createElement('div');\n" +
            "  thumb.className = 'video-thumb';\n" +
            "  thumb.dataset.index = index;\n" +
            "  thumb.style.cssText = `\n" +
            "    flex-shrink:0;\n" +
            "    border-radius:8px;\n" +
            "    overflow:hidden;\n" +
            "    cursor:pointer;\n" +
            "    border:2px solid transparent;\n" +
            "    transition:all 0.4s cubic-bezier(0.4, 0, 0.2, 1);\n" +
            "    position:relative;\n" +
            "    background:#000;\n" +
            "    transform-origin:center center;\n" +
            "  `;\n" +
            "  thumb.innerHTML = `\n" +
            "    <img src='https://img.youtube.com/vi/${video.id}/mqdefault.jpg' \n" +
            "         style='width:100%;height:100%;object-fit:cover;display:block;' \n" +
            "         alt='${video.title}'>\n" +
            "    <div style='position:absolute;bottom:0;left:0;right:0;background:linear-gradient(transparent,rgba(0,0,0,0.8));padding:20px 4px 4px;font-size:11px;color:#fff;text-overflow:ellipsis;overflow:hidden;white-space:nowrap;'>${video.title}</div>\n" +
            "  `;\n" +
            "  thumb.addEventListener('click', () => playVideo(index));\n" +
            "  track.appendChild(thumb);\n" +
            "});\n" +
            "\n" +
            "function playVideo(index) {\n" +
            "  currentIndex = index;\n" +
            "  const video = videos[index];\n" +
            "  frame.src = `https://www.youtube.com/embed/${video.id}?autoplay=1&enablejsapi=1`;\n" +
            "  updateThumbs();\n" +
            "  centerThumb(index);\n" +
            "}\n" +
            "\n" +
            "function updateThumbs() {\n" +
            "  const thumbs = track.querySelectorAll('.video-thumb');\n" +
            "  thumbs.forEach((thumb, i) => {\n" +
            "    const distance = Math.abs(i - currentIndex);\n" +
            "    \n" +
            "    if (distance === 0) {\n" +
            "      // Center - largest\n" +
            "      thumb.style.width = BASE_WIDTH + 'px';\n" +
            "      thumb.style.height = BASE_HEIGHT + 'px';\n" +
            "      thumb.style.border = '2px solid var(--accent)';\n" +
            "      thumb.style.opacity = '1';\n" +
            "      thumb.style.zIndex = '50';\n" +
            "      thumb.style.transform = 'scale(1)';\n" +
            "    } else if (distance === 1) {\n" +
            "      // 1 step away - 85% size\n" +
            "      const scale = 0.85;\n" +
            "      thumb.style.width = (BASE_WIDTH * scale) + 'px';\n" +
            "      thumb.style.height = (BASE_HEIGHT * scale) + 'px';\n" +
            "      thumb.style.border = '2px solid rgba(255,215,0,0.3)';\n" +
            "      thumb.style.opacity = '0.8';\n" +
            "      thumb.style.zIndex = '40';\n" +
            "      thumb.style.transform = 'scale(1)';\n" +
            "    } else if (distance === 2) {\n" +
            "      // 2 steps away - 70% size\n" +
            "      const scale = 0.70;\n" +
            "      thumb.style.width = (BASE_WIDTH * scale) + 'px';\n" +
            "      thumb.style.height = (BASE_HEIGHT * scale) + 'px';\n" +
            "      thumb.style.border = '2px solid transparent';\n" +
            "      thumb.style.opacity = '0.6';\n" +
            "      thumb.style.zIndex = '30';\n" +
            "      thumb.style.transform = 'scale(1)';\n" +
            "    } else {\n" +
            "      // Far away - 55% size\n" +
            "      const scale = 0.55;\n" +
            "      thumb.style.width = (BASE_WIDTH * scale) + 'px';\n" +
            "      thumb.style.height = (BASE_HEIGHT * scale) + 'px';\n" +
            "      thumb.style.border = '2px solid transparent';\n" +
            "      thumb.style.opacity = '0.4';\n" +
            "      thumb.style.zIndex = '20';\n" +
            "      thumb.style.transform = 'scale(1)';\n" +
            "    }\n" +
            "  });\n" +
            "}\n" +
            "\n" +
            "function centerThumb(index) {\n" +
            "  // Recalculate positions based on scaled widths\n" +
            "  const thumbs = track.querySelectorAll('.video-thumb');\n" +
            "  let totalOffset = 0;\n" +
            "  for (let i = 0; i < index; i++) {\n" +
            "    const distance = Math.abs(i - index);\n" +
            "    let scale = 1;\n" +
            "    if (distance === 1) scale = 0.85;\n" +
            "    else if (distance === 2) scale = 0.70;\n" +
            "    else if (distance > 2) scale = 0.55;\n" +
            "    totalOffset += (BASE_WIDTH * scale) + 8;\n" +
            "  }\n" +
            "  track.style.transform = `translateX(calc(-50% - ${totalOffset}px + ${BASE_WIDTH/2}px))`;\n" +
            "}\n" +
            "\n" +
            "function scrollThumbs(direction) {\n" +
            "  const maxIndex = videos.length - 1;\n" +
            "  if (direction === 'prev' && currentIndex > 0) {\n" +
            "    playVideo(currentIndex - 1);\n" +
            "  } else if (direction === 'next' && currentIndex < maxIndex) {\n" +
            "    playVideo(currentIndex + 1);\n" +
            "  }\n" +
            "}\n" +
            "\n" +
            "// Button listeners\n" +
            "document.getElementById('prev-btn').addEventListener('click', () => scrollThumbs('prev'));\n" +
            "document.getElementById('next-btn').addEventListener('click', () => scrollThumbs('next'));\n" +
            "\n" +
            "// Keyboard navigation\n" +
            "document.addEventListener('keydown', (e) => {\n" +
            "  if (e.key === 'ArrowLeft') scrollThumbs('prev');\n" +
            "  else if (e.key === 'ArrowRight') scrollThumbs('next');\n" +
            "});\n" +
            "\n" +
            "// Hover effects for buttons\n" +
            "['prev-btn', 'next-btn'].forEach(id => {\n" +
            "  const btn = document.getElementById(id);\n" +
            "  btn.addEventListener('mouseenter', () => {\n" +
            "    btn.style.background = 'rgba(255,255,255,0.2)';\n" +
            "    btn.style.transform = 'scale(1.1)';\n" +
            "  });\n" +
            "  btn.addEventListener('mouseleave', () => {\n" +
            "    btn.style.background = 'rgba(255,255,255,0.1)';\n" +
            "    btn.style.transform = 'scale(1)';\n" +
            "  });\n" +
            "});\n" +
            "\n" +
            "// Initialize\n" +
            "if (videos.length > 0) {\n" +
            "  playVideo(0);\n" +
            "} else {\n" +
            "  frame.src = 'https://www.youtube.com/embed/dQw4w9WgXcQ?enablejsapi=1';\n" +
            "}\n"
        );
        out.println("})();");
        out.println("</script>");
    }
}
