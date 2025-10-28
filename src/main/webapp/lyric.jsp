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
      .card pre { background: transparent; margin: 0; max-width: 25ch; white-space: pre-wrap; overflow-wrap: anywhere; word-break: break-word; }
      .accent { border-left: 4px solid #ffd700; padding-left: 16px; }
    </style>

    <div class="nav-top">
      <h3>Názvy písní</h3>
      <ul class="song-list">
        <%
            String mysqlUrl = "jdbc:mysql://localhost:3306/skeliweb?useUnicode=true&characterEncoding=utf8mb4&useSSL=false&serverTimezone=UTC";
            String mariadbUrl = "jdbc:mariadb://localhost:3306/skeliweb?useUnicode=true&characterEncoding=utf8mb4";
            String user = "Skeli";
            String password = "skeli";

            String idParam = request.getParameter("id");

            boolean mariaLoaded = false;
            boolean mysqlLoaded = false;
            try { Class.forName("org.mariadb.jdbc.Driver"); mariaLoaded = true; } catch (Throwable t) { /* ignore */ }
            try { Class.forName("com.mysql.cj.jdbc.Driver"); mysqlLoaded = true; } catch (Throwable t) { /* ignore */ }

            String listSql = "SELECT s.name AS song_name, s.year AS song_year, MIN(l.id) AS lyric_id " +
                             "FROM lyrics l LEFT JOIN songs s ON s.id = l.song_id " +
                             "GROUP BY s.name, s.year " +
                             "ORDER BY s.name ASC";

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
            if (connected) {
                if (activeId == null) {
                    out.println("<p>Vyberte prosím píseň vlevo.</p>");
                } else {
                    String detailSql = "SELECT s.name AS song_name, s.year AS song_year, l.words, l.score " +
                                       "FROM lyrics l JOIN songs s ON s.id = l.song_id " +
                                       "WHERE l.id = ?";
                    try (PreparedStatement ps = conn.prepareStatement(detailSql)) {
                        ps.setInt(1, activeId);
                        try (ResultSet rs = ps.executeQuery()) {
                            if (rs.next()) {
                                String name = rs.getString("song_name");
                                String year = rs.getString("song_year");
                                String words = rs.getString("words");
        %>
                                <div class="card accent">
                                  <h3><%= name %><% if (year != null) { %> (<%= year %>)<% } %></h3>
                                  <pre style="white-space: pre-wrap; font-family: 'Inter', system-ui, sans-serif; font-size: 1.05em;"><%= words %></pre>

                                  <hr style="border:none; border-top:1px solid rgba(0,0,0,0.08); margin:16px 0;">

                                  <div class="votes" style="margin-bottom:10px;">
                                    <form method="post" action="vote" style="display:inline;">
                                      <input type="hidden" name="lyric_id" value="<%= activeId %>">
                                      <input type="hidden" name="action" value="up">
                                      <button type="submit">👍</button>
                                    </form>
                                    <form method="post" action="vote" style="display:inline; margin-left:8px;">
                                      <input type="hidden" name="lyric_id" value="<%= activeId %>">
                                      <input type="hidden" name="action" value="down">
                                      <button type="submit">👎</button>
                                    </form>
                                    <span style="margin-left:10px;">
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

                                  <div class="comments" style="margin-top:14px;">
                                    <h4>Komentáře</h4>
                                    <div>
                                      <%
                                        try (PreparedStatement psC = conn.prepareStatement(
                                          "SELECT c.content, c.created_at, u.username FROM comments c JOIN users u ON u.id=c.user_id WHERE c.lyric_id=? ORDER BY c.created_at DESC")) {
                                          psC.setInt(1, activeId);
                                          try (ResultSet rsc = psC.executeQuery()) {
                                            while (rsc.next()) {
                                      %>
                                              <div style="padding:8px 0; border-bottom:1px dashed rgba(0,0,0,0.08);">
                                                <strong><%= rsc.getString("username") %></strong>
                                                <span style="color:#777; font-size:0.9em;">(<%= rsc.getTimestamp("created_at") %>)</span>
                                                <div><%= rsc.getString("content") %></div>
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
                                      <form method="post" action="comment" style="margin-top:10px;">
                                        <input type="hidden" name="lyric_id" value="<%= activeId %>">
                                        <textarea name="content" rows="3" style="width:100%;" placeholder="Napište komentář..." required></textarea>
                                        <button type="submit">Odeslat</button>
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
