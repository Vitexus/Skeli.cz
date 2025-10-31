<%@ page import="java.sql.*" %>
<%@ include file="includes/header.jsp" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<main class="avoid-footer">
    <h2 style="text-align:center;">Text</h2>

    <style>
      .layout { display:flex; gap:20px; }
      .layout aside { width:32%; max-width:320px; position: sticky; top: 20px; align-self: flex-start; }
      .layout section { flex:1; }
      .song-list { list-style:none; padding:0; margin:0; }
      .song-list li { margin: 6px 0; }
.active { font-weight:bold; color: gold; }
      .back { margin: 10px 0 20px; display:inline-block; }
      .avoid-footer { padding-bottom: 220px; }
.nav-top { margin-bottom: 20px; background: rgba(255,255,255,0.35); padding: 12px 16px; border-radius: 10px; box-shadow: 0 6px 18px rgba(0,0,0,0.10); overflow-x: auto; }
      .nav-top .song-list { display:flex; flex-wrap:wrap; gap: 10px 16px; }
.nav-top .song-list li { margin: 0; }
      .nav-top .song-list li:not(:last-child)::after { content: " | "; color: #777; margin: 0 6px; }
      .card { background: linear-gradient(180deg, rgba(255,255,255,0.50), rgba(255,255,255,0.40)); border: 1px solid rgba(0,0,0,0.08); border-radius: 12px; box-shadow: 0 10px 30px rgba(0,0,0,0.12); padding: 24px 28px; backdrop-filter: blur(4px); }
      .card h3 { margin-top: 0; padding-bottom: 8px; border-bottom: 1px solid rgba(0,0,0,0.06); }
      .card pre { background: transparent; margin: 0 auto; max-width: 60ch; white-space: pre-wrap; overflow-wrap: anywhere; word-break: break-word; text-align:center; font-weight: var(--fw); }
      @media (min-width: 1100px){ .lyric-layout { display:grid; grid-template-columns: 1fr 1fr; gap:24px; align-items:start; } }
      .accent { border-left: 4px solid #ffd700; padding-left: 16px; }
      /* Comments: high-contrast panel inside light lyric card */
      .comments { margin-top:14px; background: rgba(0,0,0,0.70); color: var(--text); border: 1px solid var(--panel-border); border-radius: 12px; padding: 14px 16px; box-shadow: 0 8px 24px rgba(0,0,0,.35); }
      .comments h4 { margin: 0 0 10px; color: #fff; }
      .comments .comment-item { background: rgba(255,255,255,0.06); border:1px solid rgba(255,255,255,0.12); border-radius:10px; padding:10px; margin:8px 0; }
      .comments .comment-item strong { color:#fff; }
      .comments .comment-item .meta { color: rgba(255,255,255,0.75); }
      body.light .comments { background: #ffffff; color:#111; border-color: rgba(0,0,0,0.12); }
      body.light .comments h4 { color:#111; }
      body.light .comments .comment-item { background: rgba(0,0,0,0.03); border-color: rgba(0,0,0,0.12); }
    </style>

    <% String flash = request.getParameter("msg"); if (flash != null) { %>
      <div style="background:rgba(0,128,0,0.35); padding:8px 10px; border-radius:8px; margin-bottom:10px; text-align:center;">Komentář <%= ("deleted".equals(flash)?"odstraněn":("updated".equals(flash)?"upraven":"přidán")) %>.</div>
    <% } %>
    <div class="nav-top">
      <h3>Názvy písní</h3>
      <ul class="song-list">
        <%
            String mysqlUrl = "jdbc:mysql://127.0.0.1:3306/skeliweb?useUnicode=true&characterEncoding=utf8mb4&useSSL=false&serverTimezone=UTC";
            String mariadbUrl = "jdbc:mariadb://127.0.0.1:3306/skeliweb?useUnicode=true&characterEncoding=utf8mb4";
            String user = "Skeli";
            String password = "skeli";

            String idParam = request.getParameter("id");

            boolean mariaLoaded = false;
            boolean mysqlLoaded = false;
            try { Class.forName("org.mariadb.jdbc.Driver"); mariaLoaded = true; } catch (Throwable ex1) { /* ignore */ }
            try { Class.forName("com.mysql.cj.jdbc.Driver"); mysqlLoaded = true; } catch (Throwable ex2) { /* ignore */ }

            String listSql = "SELECT s.name AS song_name, s.year AS song_year, MIN(l.id) AS lyric_id " +
                             "FROM lyrics l LEFT JOIN songs s ON s.id = l.song_id " +
                             "GROUP BY s.name, s.year " +
                             "ORDER BY s.year DESC, s.name ASC";

            Connection conn = null;
            boolean connected = false;
            try {
                if (mariaLoaded) {
                    conn = DriverManager.getConnection(mariadbUrl, user, password);
                    connected = true;
                } else if (mysqlLoaded) {
                    conn = DriverManager.getConnection(mysqlUrl, user, password);
                    connected = true;
                }
            } catch (SQLException ce) {
                // keep connected=false
            }

            Integer activeId = null;
            try { if (idParam != null) activeId = Integer.parseInt(idParam); } catch (Exception ignore) {}

            if (connected) {
                try (PreparedStatement ps = conn.prepareStatement(listSql);
                     ResultSet rs = ps.executeQuery()) {
                    while (rs.next()) {
                        String name = rs.getString("song_name");
                        int lyricId = rs.getInt("lyric_id");
                        boolean isActive = (activeId != null && activeId == lyricId);
        %>
                        <li><a class="<%= isActive ? "active" : "" %>" href="lyric.jsp?id=<%= lyricId %>"><%= name %></a></li>
        <%
                    }
                } catch (SQLException e) {
                    out.println("<li>Chyba při načítání seznamu: " + e.getMessage() + "</li>");
                }
            } else {
                out.println("<li>Chyba připojení k DB.</li>");
            }
        %>
        </ul>
    </div>

    <section>
        <%
            // Support SEO path /lyrics/{id-slug}
            if (activeId == null) {
                String pi = request.getPathInfo();
                if (pi != null && pi.length() > 1) {
                    String p = pi.substring(1);
                    try { activeId = Integer.parseInt(p.split("-",2)[0]); } catch (Exception ignore) {}
                }
            }
            if (connected) {
                if (activeId == null) {
                    out.println("<p>Vyberte prosím píseň vlevo.</p>");
                } else {
                    String detailSql = "SELECT s.name AS song_name, s.year AS song_year, l.words, l.score, " +
                                       "(SELECT v.youtube_id FROM videos v WHERE v.song_id = l.song_id ORDER BY v.published_at DESC, v.id DESC LIMIT 1) AS yt " +
                                       "FROM lyrics l JOIN songs s ON s.id = l.song_id " +
                                       "WHERE l.id = ?";
                    try (PreparedStatement ps = conn.prepareStatement(detailSql)) {
                        ps.setInt(1, activeId);
                        try (ResultSet rs = ps.executeQuery()) {
                            if (rs.next()) {
                                String name = rs.getString("song_name");
                                String year = rs.getString("song_year");
                                String words = rs.getString("words");
                                String yt = rs.getString("yt");
                                // try translated words if available for selected language
                                String curLang = (String) session.getAttribute("lang");
                                if (curLang != null && !curLang.equals("cs")) {
                                  try (PreparedStatement tr = conn.prepareStatement("SELECT words FROM lyrics_translations WHERE lyric_id=? AND lang=?")) {
                                    tr.setInt(1, activeId);
                                    tr.setString(2, curLang);
                                    try (ResultSet rtr = tr.executeQuery()) { if (rtr.next() && rtr.getString(1) != null) { words = rtr.getString(1); } }
                                  }
                                }
        %>
                                <div class="card accent lyric-layout">
                                  <div>
                                    <h3><%= name %><% if (year != null) { %> (<%= year %>)<% } %></h3>
                                    <% if (yt != null && !yt.isEmpty()) { %>
                                    <div style="background:var(--panel); border:1px solid var(--panel-border); border-radius:12px; padding:8px; box-shadow:0 6px 18px rgba(0,0,0,.20); position:relative; margin:10px auto 14px; width:50%; min-width:320px;">
                                      <div style="position:relative; padding-top:28.125%;">
                                        <iframe style="position:absolute; inset:0; width:100%; height:100%; border-radius:8px;" src="https://www.youtube.com/embed/<%= yt %>" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" allowfullscreen></iframe>
                                      </div>
                                    </div>
                                    <% } %>
                                    <div style="background:var(--panel); border:1px solid var(--panel-border); border-radius:12px; padding:14px; box-shadow:0 6px 18px rgba(0,0,0,.20);">
                                      <pre style="white-space: pre-wrap; font-family: 'Inter', system-ui, sans-serif; font-size: 1.05em; margin:0;"><%= words %></pre>
                                    </div>
                                  </div>
                                  <div>

                                  <hr style="border:none; border-top:1px solid rgba(0,0,0,0.08); margin:16px 0;">

                                  <div class="votes" style="margin-bottom:10px; display:flex; align-items:center; gap:10px;">
                                    <form method="post" action="vote" style="display:inline;">
                                      <input type="hidden" name="lyric_id" value="<%= activeId %>">
                                      <input type="hidden" name="action" value="up">
                                      <button type="submit" class="btn-vote up" title="Líbí se mi">
                                        <i class="fa-solid fa-thumbs-up"></i>
                                      </button>
                                    </form>
                                    <form method="post" action="vote" style="display:inline;">
                                      <input type="hidden" name="lyric_id" value="<%= activeId %>">
                                      <input type="hidden" name="action" value="down">
                                      <button type="submit" class="btn-vote down" title="Nelíbí se mi">
                                        <i class="fa-solid fa-thumbs-down"></i>
                                      </button>
                                    </form>
                                    <span style="margin-left:6px; white-space:nowrap;">
                                      <%
                                        int up=0, down=0;
                                        try (PreparedStatement psV = conn.prepareStatement(
                                          "SELECT SUM(vote=1) AS up, SUM(vote=-1) AS down FROM lyrics_votes WHERE lyric_id=?")) {
                                          psV.setInt(1, activeId);
                                          try (ResultSet rsv = psV.executeQuery()) {
                                            if (rsv.next()) { up = rsv.getInt("up"); down = rsv.getInt("down"); }
                                          }
                                        }
                                      %>
                                      <strong><%= up %></strong> / <strong><%= down %></strong>
                                    </span>
                                  </div>
                                  <style>
                                    .btn-vote { width:40px; height:40px; border-radius:9999px; border:1px solid var(--panel-border); display:inline-flex; align-items:center; justify-content:center; cursor:pointer; font-size:16px; backdrop-filter: blur(2px); transition: transform .12s ease, background-color .2s ease, box-shadow .2s ease, opacity .2s ease; }
                                    .btn-vote i { pointer-events:none; }
                                    /* Dark mode base */
                                    .btn-vote { background: rgba(255,255,255,0.06); color:#fff; box-shadow: 0 6px 18px rgba(0,0,0,.25); }
                                    .btn-vote:hover { background: rgba(255,255,255,0.12); transform: translateY(-1px); }
                                    .btn-vote:active { transform: translateY(0); opacity: .9; }
                                    .btn-vote.up { border-color: rgba(0,255,170,0.35); }
                                    .btn-vote.down { border-color: rgba(255,80,80,0.35); }
                                    .btn-vote.up:hover { box-shadow: 0 8px 22px rgba(0,255,170,.25); }
                                    .btn-vote.down:hover { box-shadow: 0 8px 22px rgba(255,80,80,.25); }
                                    /* Light mode overrides */
                                    body.light .btn-vote { background: rgba(0,0,0,0.06); color:#111; box-shadow: 0 6px 18px rgba(0,0,0,.12); }
                                    body.light .btn-vote:hover { background: rgba(0,0,0,0.12); }
                                  </style>

                                  <div class="views" style="font-size:0.9em; color:#555;">
                                    <%
                                      long views = 0;
                                      try (PreparedStatement psViews = conn.prepareStatement(
                                        "INSERT INTO lyric_views (lyric_id, views) VALUES (?,1) ON DUPLICATE KEY UPDATE views = views + 1")) {
                                        psViews.setInt(1, activeId);
                                        psViews.executeUpdate();
                                      }
                                      try (PreparedStatement psViews2 = conn.prepareStatement(
                                        "SELECT views FROM lyric_views WHERE lyric_id=?")) {
                                        psViews2.setInt(1, activeId);
                                        try (ResultSet rsv2 = psViews2.executeQuery()) { if (rsv2.next()) views = rsv2.getLong(1); }
                                      }
                                    %>
                                    Návštěvy: <%= views %>
                                  </div>

                                  <div class="comments">
                                    <h4>Komentáře</h4>
                                    <div>
                                      <%
                                        try (PreparedStatement psC = conn.prepareStatement(
                                          "SELECT c.id, c.user_id, c.content, c.created_at, u.username, u.avatar_url FROM comments c JOIN users u ON u.id=c.user_id WHERE c.lyric_id=? ORDER BY c.created_at DESC")) {
                                          psC.setInt(1, activeId);
                                        try (ResultSet rsc = psC.executeQuery()) {
                                          while (rsc.next()) {
                                            int __cid = rsc.getInt("id");
                                    %>
                                              <div class="comment-item" style="display:flex; gap:10px; align-items:flex-start;">
                                                <img src="<%= rsc.getString("avatar_url") != null ? rsc.getString("avatar_url") : "/img/avatar-default.png" %>" alt="avatar" style="width:36px; height:36px; border-radius:50%; object-fit:cover;">
                                                <div style="flex:1;">
                                                  <strong><%= rsc.getString("username") %></strong>
                                                  <span class="meta" style="font-size:0.9em;">(<%= rsc.getTimestamp("created_at") %>)</span>
                                                  <div id="c-body-<%= __cid %>"><%= rsc.getString("content") %></div>
                                                <%
                                                  Integer uid2 = (Integer) session.getAttribute("userId");
                                                  String role2 = (String) session.getAttribute("role");
                                                  boolean canEdit = (uid2 != null && (uid2 == rsc.getInt("user_id") || "ADMIN".equals(role2)));
                                                  if (canEdit) {
                                                %>
                                                <div style="margin-top:6px;">
                                                  <form method="post" action="/comment" style="display:inline;">
                                                    <input type="hidden" name="lyric_id" value="<%= activeId %>">
                                                    <input type="hidden" name="comment_id" value="<%= __cid %>">
                                                    <input type="hidden" name="action" value="delete">
                                                    <button type="submit" style="background:#7b1e1e;color:#fff;border:none;padding:4px 8px;border-radius:6px;">Smazat</button>
                                                  </form>
                                                  <button type="button" onclick="(function(){ var f=document.getElementById('edit-<%= __cid %>'); f.style.display = f.style.display==='none'?'block':'none'; })()" style="margin-left:6px;">Upravit</button>
                                                </div>
                                                <form id="edit-<%= __cid %>" method="post" action="/comment" style="display:none; margin-top:6px;">
                                                  <input type="hidden" name="lyric_id" value="<%= activeId %>">
                                                  <input type="hidden" name="comment_id" value="<%= __cid %>">
                                                  <input type="hidden" name="action" value="update">
                                                  <%
                                                    String __content = rsc.getString("content");
                                                    if (__content == null) __content = "";
                                                    __content = __content.replace("&","&amp;").replace("<","&lt;");
                                                  %>
                                                  <textarea name="content" rows="3" style="width:100%;"><%= __content %></textarea>
                                                    <input type="hidden" name="csrf" value="${csrf}">
                                                    <button type="submit">Uložit</button>
                                      <button type="submit">👎</button>
                                      <button type="submit">👍</button>
                                                </form>
                                                <%
                                                  }
                                                %>
                                              </div>
                                            </div>
                                    <%
                                            }
                                          }
                                        }
                                      %>
                                    </div>

                                    <%
                                      Integer uid = (Integer) session.getAttribute("userId");
                                      if (uid != null) {
                                    %>
                                      <form method="post" action="/comment" style="margin-top:10px;">
                                        <input type="hidden" name="lyric_id" value="<%= activeId %>">
                                        <textarea name="content" rows="3" style="width:100%; font-family: 'Inter', system-ui, sans-serif; font-size:1.02em; border:1px solid var(--panel-border); border-radius:8px; padding:10px; background:rgba(0,0,0,0.12); color:inherit;" placeholder="Napište komentář..." required></textarea>
                                        <button type="submit" style="margin-top:6px; padding:6px 10px; border:1px solid var(--panel-border); border-radius:8px; background:rgba(0,0,0,0.2); color:inherit;">Odeslat</button>
                                      </form>
                                    <%
                                      } else {
                                    %>
                                      <p><a href="login.jsp">Přihlaste se</a> pro přidání komentáře a hlasování.</p>
                                    <%
                                      }
                                    %>
                                  </div>
                                </div>
        <%
                            } else {
                                out.println("<p>Text nenalezen.</p>");
                            }
                        }
                    } catch (SQLException de) {
                        out.println("<p>Chyba načtení textu: " + de.getMessage() + "</p>");
                    }
                }
                try { conn.close(); } catch (Exception ignore) {}
            }
        %>
      </section>
</main>

<%@ include file="includes/footer.jsp" %>
