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

@WebServlet(name = "EllipticPlayerServlet", urlPatterns = { "/elliptic" })
public class EllipticPlayerServlet extends HttpServlet {
        private String fetchYtTitle(String ytId) {
                try {
                        String oembed = "https://www.youtube.com/oembed?format=json&url=" +
                                        URLEncoder.encode("https://www.youtube.com/watch?v=" + ytId,
                                                        StandardCharsets.UTF_8);
                        URL u = new URL(oembed);
                        HttpURLConnection c = (HttpURLConnection) u.openConnection();
                        c.setRequestMethod("GET");
                        c.setConnectTimeout(2000);
                        c.setReadTimeout(2000);
                        try (java.io.InputStream in = c.getInputStream()) {
                                ObjectMapper m = new ObjectMapper();
                                JsonNode n = m.readTree(in);
                                return n.path("title").asText(null);
                        }
                } catch (Exception ignore) {
                }
                return null;
        }

        static class Vid {
                String id;
                String title;
                String year;
        }

        @Override
        protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
                resp.setContentType("text/html; charset=UTF-8");
                List<Vid> vids = new ArrayList<>();
                String sql = "SELECT v.youtube_id, COALESCE(v.title, s.name, v.youtube_id) AS title, s.year " +
                                "FROM videos v LEFT JOIN songs s ON s.id=v.song_id " +
                                "ORDER BY s.year DESC, COALESCE(v.title, s.name, v.youtube_id) ASC";
                try (Connection c = Db.get();
                                PreparedStatement ps = c.prepareStatement(sql);
                                ResultSet rs = ps.executeQuery()) {
                        while (rs.next()) {
                                Vid v = new Vid();
                                v.id = rs.getString(1);
                                v.title = rs.getString(2);
                                v.year = rs.getString(3);
                                if (v.title == null || v.title.isBlank()) {
                                        String t = fetchYtTitle(v.id);
                                        if (t != null && !t.isBlank()) {
                                                v.title = t;
                                                try (PreparedStatement up = c
                                                                .prepareStatement(
                                                                                "UPDATE videos SET title=? WHERE youtube_id=?")) {
                                                        up.setString(1, t);
                                                        up.setString(2, v.id);
                                                        up.executeUpdate();
                                                } catch (SQLException ignore) {
                                                }
                                        }
                                }
                                vids.add(v);
                        }
                } catch (SQLException e) {
                        /* silent -> render empty */ }

                PrintWriter out = resp.getWriter();
                java.util.Properties tr = I18n.bundle(req);
                // CSRF token for JS
                String __csrfToken = CsrfFilter.token(req.getSession());
                // Elliptic player styles are defined in external CSS under src/main/webapp/css/pages.css.

                // HTML structure
                out.println("<div class='ep-wrap'>");
                out.println("  <div class='ep-layout'>");
                out.println("    <div class='ep-left'>");
                out.println("      <div class='ep-frame-wrap'>");
                out.println(
                                "        <iframe id='ep-main' allow='autoplay; encrypted-media; picture-in-picture' allowfullscreen></iframe>");
                out.println("      </div>");
                out.println("      <div class='ep-carousel'>");
                out.println("        <button class='ep-arrow' id='ep-prev' aria-label='" + WebUtils.escapeHtml(tr.getProperty("player.prev")) + "'>‹</button>");
                out.println("        <div class='ep-viewport' id='ep-viewport'></div>");
                out.println("        <button class='ep-arrow' id='ep-next' aria-label='" + WebUtils.escapeHtml(tr.getProperty("player.next")) + "'>›</button>");
                out.println("      </div>");
                out.println("    </div>");
                out.println("    <aside class='ep-comments'>");
                out.println(
                                "      <h4 class='ep-comments-title'>" + WebUtils.escapeHtml(tr.getProperty("comments.title")) + "</h4>");
                out.println("      <div id='ep-comments-list' class='ep-comments-list'></div>");
                out.println("      <form id='ep-comment-form' class='ep-comment-form'>");
                out.println(
                                "        <textarea id='ep-comment-text' rows='3' placeholder='" + WebUtils.escapeHtml(tr.getProperty("comment.placeholder")) + "'></textarea>");
                out.println(
                                "        <button type='submit'>" + WebUtils.escapeHtml(tr.getProperty("common.send")) + "</button>");
                out.println("      </form>");
                out.println("    </aside>");
                out.println("  </div>");
                out.println("</div>");

                // JavaScript logic
                out.println("<script>");
                out.println("(function(){");
                out.println("const videos = [];");
                for (Vid v : vids) {
                        String escTitle = v.title == null ? ""
                                        : v.title.replace("\\", "\\\\").replace("\"", "\\\"").replace("'", "\\'");
                        out.printf("videos.push({id:'%s', title:'%s'});%n", v.id, escTitle);
                }
                out.println("const frame = document.getElementById('ep-main');");
                out.println("const viewport = document.getElementById('ep-viewport');");
                out.println("const commentsList = document.getElementById('ep-comments-list');");
                out.println("const commentForm = document.getElementById('ep-comment-form');");
                out.println("const commentText = document.getElementById('ep-comment-text');");
                out.println("const isAuthed = "
                                + (req.getSession(false) != null && req.getSession(false).getAttribute("userId") != null
                                                ? "true"
                                                : "false")
                                + ";");
                out.println(
                                "const CSRF = '" + __csrfToken.replace("\\", "\\\\").replace("\"", "\\\"").replace("'",
                                                "\\'") + "';");
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
                out.println(
                                "    else if (i === (currentIndex - 1 + videos.length) % videos.length) el.classList.add('is-prev');");
                out.println("    else if (i === (currentIndex + 1) % videos.length) el.classList.add('is-next');");
                out.println(
                                "    else if (i === (currentIndex - 2 + videos.length) % videos.length) el.classList.add('is-prev2');");
                out.println("    else if (i === (currentIndex + 2) % videos.length) el.classList.add('is-next2');");
                out.println("    else el.classList.add('is-hidden');");
                out.println("  });");
                out.println("}");

                out.println("function play(id, autoplay){");
                out.println("  const ap = autoplay ? 1 : 0;");
                out.println(
                                "  frame.src = `https://www.youtube.com/embed/${id}?autoplay=${ap}&rel=0&playsinline=1&enablejsapi=1`;");
                out.println("}");

                out.println("function goTo(index, autoplay){");
                out.println("  currentIndex = (index + videos.length) % videos.length;");
                out.println("  updateUI();");
                out.println("  play(videos[currentIndex].id, autoplay);");
                out.println("  loadComments(videos[currentIndex].id);");
                out.println("  syncAsideHeight();");
                out.println("}");

                out.println(
                                "document.getElementById('ep-prev').addEventListener('click', () => goTo(currentIndex - 1, true));");
                out.println(
                                "document.getElementById('ep-next').addEventListener('click', () => goTo(currentIndex + 1, true));");
                out.println(
                                "function syncAsideHeight(){ try{ if(window.innerWidth < 800) { const aside=document.querySelector('.ep-comments'); if(aside) aside.style.height='auto'; return; } const layout=document.querySelector('.ep-layout'); const frame=document.querySelector('.ep-frame-wrap'); const car=document.querySelector('.ep-carousel'); const aside=document.querySelector('.ep-comments'); if(!layout||!frame||!car||!aside) return; const cs=getComputedStyle(layout); const g=parseFloat(cs.rowGap||cs.gap||'0')||0; const mt=parseFloat(getComputedStyle(car).marginTop)||0; const h = frame.getBoundingClientRect().height + mt + car.getBoundingClientRect().height + g; aside.style.height = Math.round(h) + 'px'; }catch(e){} }");
                out.println("window.addEventListener('resize', syncAsideHeight);");

                out.println("// Keyboard navigation");
                out.println("document.addEventListener('keydown', (e) => {");
                out.println("  if (e.key === 'ArrowLeft') goTo(currentIndex - 1, true);");
                out.println("  else if (e.key === 'ArrowRight') goTo(currentIndex + 1, true);");
                out.println("});");

                out.println(
                                "function esc(v){ return String(v==null?'':v).replace(/&/g,'&amp;').replace(/</g,'&lt;').replace(/>/g,'&gt;').replace(/\"/g,'&quot;').replace(/'/g,'&#39;'); }\nfunction renderComments(items){\n  commentsList.innerHTML = items.map(c => `\n    <div class=\"ep-comment\">\n      <div style=\"display:flex;justify-content:space-between;gap:8px;\">\n        <strong>${esc(c.user||'user')}</strong> <span style=\"opacity:.7;\">${esc(c.createdAt||'')}</span>\n      </div>\n      <div style=\"margin:6px 0;\">${esc(c.content||'')}</div>\n      <div class=\"act\">\n        <button class=\"btn-vote up\" data-action=\"vote\" data-v=\"up\" data-id=\"${Number(c.id)}\" title=\"" + WebUtils.escapeHtml(tr.getProperty("vote.like")) + "\" ${!isAuthed?'disabled':''}><i class=\"fa-solid fa-thumbs-up\"></i></button>\n        <button class=\"btn-vote down\" data-action=\"vote\" data-v=\"down\" data-id=\"${Number(c.id)}\" title=\"" + WebUtils.escapeHtml(tr.getProperty("vote.dislike")) + "\" ${!isAuthed?'disabled':''}><i class=\"fa-solid fa-thumbs-down\"></i></button>\n        <span class=\"vote-sum\"><strong>${Number(c.up)||0}</strong> / <strong>${Number(c.down)||0}</strong></span>\n        ${c.mine?`<button data-action=\"delete\" data-id=\"${Number(c.id)}\" style=\"margin-left:auto;background:#7b1e1e;color:#fff;border:none;padding:4px 8px;border-radius:6px;\">" + WebUtils.escapeHtml(tr.getProperty("common.delete")) + "</button>`:''}\n      </div>\n    </div>`).join('');\n}\n\nasync function loadComments(yt){\n  try{ const r = await fetch('/video-comment?yt='+encodeURIComponent(yt)); if(!r.ok) return; const items = await r.json(); renderComments(items); }catch(e){}\n}\n\nif (commentForm){\n  commentForm.addEventListener('submit', async (e)=>{ e.preventDefault(); const yt = videos[currentIndex]?.id; const content = (commentText.value||'').trim(); if(!content) return; try{ const body = new URLSearchParams(); body.set('action','add'); body.set('yt', yt); body.set('content', content); body.set('csrf', CSRF); const r = await fetch('/video-comment', {method:'POST', headers:{'Content-Type':'application/x-www-form-urlencoded'}, body: body.toString()}); if(r.ok){ commentText.value=''; loadComments(yt); } }catch(e){} });\n  commentsList.addEventListener('click', async (e)=>{ const b=e.target.closest('button'); if(!b) return; if(b.disabled) return; const id=b.getAttribute('data-id'); const act=b.getAttribute('data-action'); const v=b.getAttribute('data-v'); const body = new URLSearchParams(); body.set('comment_id', id); body.set('action', act==='vote'?'vote':act); if(v) body.set('vote', v); body.set('csrf', CSRF); const r=await fetch('/video-comment',{method:'POST', headers:{'Content-Type':'application/x-www-form-urlencoded'}, body: body.toString()}); if(r.ok){ loadComments(videos[currentIndex].id); } });\n}\n");
                out.println("// Initialize");
                out.println(
                                "if (!isAuthed && commentForm){ commentText.disabled=true; commentText.placeholder='" + WebUtils.escapeJs(tr.getProperty("comment.loginRequired")) + "'; commentForm.querySelector('button').disabled=true; }\n");
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
