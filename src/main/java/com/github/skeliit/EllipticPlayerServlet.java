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
        // Styles + layout for new EllipticPlayer carousel (responsive, percentage-based)
        out.println("<style>");
        out.println(".ep-wrap{width:100%;max-width:980px;margin:0 auto;}");
        out.println(".ep-layout{display:grid;grid-template-columns:2fr 1fr;grid-auto-rows:auto;gap:10px;align-items:start;}");
        out.println("@media (max-width: 900px){ .ep-layout{ grid-template-columns:1fr; } }");
        out.println(".ep-left{}\n");
        out.println(".ep-frame-wrap{position:relative;width:100%;aspect-ratio:16/9;border-radius:12px;overflow:hidden;background:#000;box-shadow:0 8px 24px rgba(0,0,0,.3);grid-column:1;grid-row:1;}");
        out.println(".ep-frame-wrap iframe{position:absolute;inset:0;width:100%;height:100%;border:0;}");
        out.println(".ep-carousel{position:relative;margin-top:10px;padding:3% 14%;background:rgba(0,0,0,0.3);border:1px solid var(--panel-border);border-radius:12px;grid-column:1;grid-row:2;}");
        out.println(".ep-viewport{position:relative;width:100%;height:0;padding-top:30%;overflow:hidden;}");
        out.println(".ep-item{position:absolute;top:50%;transform:translate(-50%,-50%);transition:transform .45s ease, opacity .45s ease, box-shadow .45s ease, filter .45s ease;border-radius:12px;overflow:hidden;box-shadow:0 6px 18px rgba(0,0,0,.28);opacity:0;width:40%;aspect-ratio:16/9;background:#000;border:2px solid transparent;}");
        out.println(".ep-item img{width:100%;height:100%;object-fit:cover;display:block;}");
        out.println(".ep-title{position:absolute;left:0;right:0;bottom:0;padding:3% 3%;background:linear-gradient(transparent,rgba(0,0,0,0.7));color:#fff;font-size:90%;white-space:nowrap;overflow:hidden;text-overflow:ellipsis;}");
        out.println(".ep-item.is-active{left:50%;opacity:1;border-color:var(--accent, rgba(255,215,0,0.6));filter:none;z-index:3;}");
        out.println(".ep-item.is-prev{left:26%;opacity:0.9;width:30%;filter:grayscale(.1);z-index:2;}");
        out.println(".ep-item.is-next{left:74%;opacity:0.9;width:30%;filter:grayscale(.1);z-index:2;}");
        out.println(".ep-item.is-prev2{left:14%;opacity:0.8;width:24%;filter:grayscale(.2);z-index:1;-webkit-mask-image:linear-gradient(to right,rgba(0,0,0,0) 0%, rgba(0,0,0,1) 70%);mask-image:linear-gradient(to right,rgba(0,0,0,0) 0%, rgba(0,0,0,1) 70%);}");
        out.println(".ep-item.is-next2{left:86%;opacity:0.8;width:24%;filter:grayscale(.2);z-index:1;-webkit-mask-image:linear-gradient(to right,rgba(0,0,0,1) 30%, rgba(0,0,0,0) 100%);mask-image:linear-gradient(to right,rgba(0,0,0,1) 30%, rgba(0,0,0,0) 100%);}");
        out.println(".ep-item.is-hidden{display:none;z-index:0;}");
        out.println(".ep-arrow{position:absolute;top:50%;transform:translateY(-50%);width:5%;aspect-ratio:1/1;border-radius:50%;background:rgba(255,255,255,0.1);border:1px solid var(--panel-border);color:var(--text, #fff);cursor:pointer;font-size:150%;display:flex;align-items:center;justify-content:center;transition:all .25s;z-index:4;}");
        out.println("#ep-prev{left:2%;}");
        out.println("#ep-next{right:2%;}");
        out.println(".ep-arrow:hover{background:rgba(255,255,255,0.2);transform:translateY(-50%) scale(1.05);}");
        out.println(".ep-comments{background:rgba(255,255,255,0.06);border:1px solid var(--panel-border);border-radius:12px;padding:10px;grid-column:2;grid-row:1 / span 2;height:100%;display:flex;flex-direction:column;}");
        out.println("body.light .ep-comments{background:rgba(0,0,0,0.04);}");
        out.println(".ep-comments-list{display:flex;flex-direction:column;gap:8px;overflow:auto;margin-bottom:8px;flex:1;}");
        out.println(".ep-comment{background:rgba(0,0,0,0.18);border:1px solid var(--panel-border);border-radius:8px;padding:8px;}");
        out.println("body.light .ep-comment{background:rgba(0,0,0,0.06);}");
        out.println(".ep-comment .act{display:flex;gap:8px;align-items:center;}");
        out.println("</style>");

        // HTML structure
        out.println("<div class='ep-wrap'>");
        out.println("  <div class='ep-layout'>");
        out.println("    <div class='ep-left'>");
        out.println("      <div class='ep-frame-wrap'>");
        out.println("        <iframe id='ep-main' allow='autoplay; encrypted-media; picture-in-picture' allowfullscreen></iframe>");
        out.println("      </div>");
        out.println("      <div class='ep-carousel'>");
        out.println("        <button class='ep-arrow' id='ep-prev' aria-label='Previous'>‹</button>");
        out.println("        <div class='ep-viewport' id='ep-viewport'></div>");
        out.println("        <button class='ep-arrow' id='ep-next' aria-label='Next'>›</button>");
        out.println("      </div>");
        out.println("    </div>");
        out.println("    <aside class='ep-comments'>");
        out.println("      <h4 class='bruno-ace-sc-regular' style='margin:0 0 8px 0;text-align:center;'>Komentáře</h4>");
        out.println("      <div id='ep-comments-list' class='ep-comments-list'></div>");
        out.println("      <form id='ep-comment-form' style='display:flex; gap:6px; align-items:flex-start;'>");
        out.println("        <textarea id='ep-comment-text' rows='3' style='flex:1; width:100%; border:1px solid var(--panel-border); border-radius:8px; padding:8px; background:rgba(0,0,0,0.12); color:var(--text);' placeholder='Napiš komentář...'></textarea>");
        out.println("        <button type='submit' class='bruno-ace-sc-regular' style='border:1px solid var(--panel-border);border-radius:8px;background:transparent;padding:6px 10px;'>Odeslat</button>");
        out.println("      </form>");
        out.println("    </aside>");
        out.println("  </div>");
        out.println("</div>");

        // JavaScript logic
        out.println("<script>");
        out.println("(function(){");
        out.println("const videos = [];");
        for (Vid v: vids) {
            String escTitle = v.title == null ? "" : v.title.replace("\\", "\\\\").replace("\"","\\\"").replace("'","\\'");
            out.printf("videos.push({id:'%s', title:'%s'});%n", v.id, escTitle);
        }
        out.println("const frame = document.getElementById('ep-main');");
        out.println("const viewport = document.getElementById('ep-viewport');");
        out.println("const commentsList = document.getElementById('ep-comments-list');");
        out.println("const commentForm = document.getElementById('ep-comment-form');");
        out.println("const commentText = document.getElementById('ep-comment-text');");
        out.println("const isAuthed = " + (req.getSession(false)!=null && req.getSession(false).getAttribute("userId")!=null ? "true" : "false") + ";");
        out.println("let currentIndex = 0;");

        out.println("function build(){");
        out.println("  videos.forEach((video, index) => {");
        out.println("    const item = document.createElement('div');");
        out.println("    item.className = 'ep-item';");
        out.println("    item.dataset.index = index;");
        out.println("    item.innerHTML = `");
        out.println("      <img src='https://img.youtube.com/vi/${video.id}/hqdefault.jpg' alt='${video.title}'>");
        out.println("      <div class='ep-title'>${video.title}</div>");
        out.println("    `;");
        out.println("    item.addEventListener('click', () => goTo(index, true));");
        out.println("    viewport.appendChild(item);");
        out.println("  });");
        out.println("}");

        out.println("function updateUI(){");
        out.println("  const items = viewport.querySelectorAll('.ep-item');");
        out.println("  items.forEach((el, i) => {");
        out.println("    el.classList.remove('is-prev2','is-prev','is-active','is-next','is-next2','is-hidden');");
        out.println("    if (i === currentIndex) el.classList.add('is-active');");
        out.println("    else if (i === (currentIndex - 1 + videos.length) % videos.length) el.classList.add('is-prev');");
        out.println("    else if (i === (currentIndex + 1) % videos.length) el.classList.add('is-next');");
        out.println("    else if (i === (currentIndex - 2 + videos.length) % videos.length) el.classList.add('is-prev2');");
        out.println("    else if (i === (currentIndex + 2) % videos.length) el.classList.add('is-next2');");
        out.println("    else el.classList.add('is-hidden');");
        out.println("  });");
        out.println("}");

        out.println("function play(id, autoplay){");
        out.println("  const ap = autoplay ? 1 : 0;");
        out.println("  frame.src = `https://www.youtube.com/embed/${id}?autoplay=${ap}&rel=0&playsinline=1&enablejsapi=1`;");
        out.println("}");

        out.println("function goTo(index, autoplay){");
        out.println("  currentIndex = (index + videos.length) % videos.length;");
        out.println("  updateUI();");
        out.println("  play(videos[currentIndex].id, autoplay);");
        out.println("  loadComments(videos[currentIndex].id);");
        out.println("}");

        out.println("document.getElementById('ep-prev').addEventListener('click', () => goTo(currentIndex - 1, true));");
        out.println("document.getElementById('ep-next').addEventListener('click', () => goTo(currentIndex + 1, true));");

        out.println("// Keyboard navigation");
        out.println("document.addEventListener('keydown', (e) => {");
        out.println("  if (e.key === 'ArrowLeft') goTo(currentIndex - 1, true);");
        out.println("  else if (e.key === 'ArrowRight') goTo(currentIndex + 1, true);");
        out.println("});");

        out.println("function renderComments(items){\n  commentsList.innerHTML = items.map(c => `\n    <div class=\"ep-comment\">\n      <div style=\"display:flex;justify-content:space-between;gap:8px;\">\n        <strong>${c.user||'user'}</strong> <span style=\"opacity:.7;\">${c.createdAt||''}</span>\n      </div>\n      <div style=\"margin:6px 0;\">${(c.content||'').replace(/</g,'&lt;')}</div>\n      <div class=\"act\">\n        <button data-action=\"vote\" data-v=\"up\" data-id=\"${c.id}\" title=\"Like\">👍 ${c.up||0}</button>\n        <button data-action=\"vote\" data-v=\"down\" data-id=\"${c.id}\" title=\"Dislike\">👎 ${c.down||0}</button>\n        ${c.mine?`<button data-action=\"delete\" data-id=\"${c.id}\" style=\"margin-left:auto;background:#7b1e1e;color:#fff;border:none;padding:4px 8px;border-radius:6px;\">Smazat</button>`:''}\n      </div>\n    </div>`).join('');\n}\n\nasync function loadComments(yt){\n  try{ const r = await fetch('/video-comment?yt='+encodeURIComponent(yt)); if(!r.ok) return; const items = await r.json(); renderComments(items); }catch(e){}\n}\n\nif (commentForm){\n  commentForm.addEventListener('submit', async (e)=>{ e.preventDefault(); const yt = videos[currentIndex]?.id; const content = (commentText.value||'').trim(); if(!content) return; try{ const fd = new FormData(); fd.append('action','add'); fd.append('yt', yt); fd.append('content', content); fd.append('csrf','" + (String.valueOf(req.getSession().getAttribute("csrf"))==null?"":String.valueOf(req.getSession().getAttribute("csrf"))) + "'); const r = await fetch('/video-comment', {method:'POST', body:fd}); if(r.ok){ commentText.value=''; loadComments(yt); } }catch(e){} });\n  commentsList.addEventListener('click', async (e)=>{ const b=e.target.closest('button'); if(!b) return; const id=b.getAttribute('data-id'); const act=b.getAttribute('data-action'); const v=b.getAttribute('data-v'); const fd = new FormData(); fd.append('comment_id', id); fd.append('action', act==='vote'?'vote':act); if(v) fd.append('vote', v); fd.append('csrf','" + (String.valueOf(req.getSession().getAttribute("csrf"))==null?"":String.valueOf(req.getSession().getAttribute("csrf"))) + "'); const r=await fetch('/video-comment',{method:'POST', body:fd}); if(r.ok){ loadComments(videos[currentIndex].id); } });\n}\n");
        out.println("// Initialize");
        out.println("if (!isAuthed && commentForm){ commentText.disabled=true; commentText.placeholder='Přihlas se pro přidání komentáře'; commentForm.querySelector('button').disabled=true; }\n");
        out.println("if (videos.length > 0) {");
        out.println("  build();");
        out.println("  goTo(0, false);");
        out.println("} else {");
        out.println("  frame.src = 'https://www.youtube.com/embed/dQw4w9WgXcQ?enablejsapi=1';");
        out.println("}");

        out.println("})();");
        out.println("</script>");
    }
}
