<%@ page import="java.sql.*" %>
<%@ include file="includes/header.jsp" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<main>
  <section style="text-align:center; padding:10px 0 6px;">
    <h2 class="comforter-brush-regular" style="font-size:3rem; margin:0;">SKELOSQUAD</h2>
    <p style="margin:6px 0 0;"><%= ((java.util.Properties)request.getAttribute("t")).getProperty("index.hero","Official website – music, lyrics, news.") %></p>
  </section>
  <section style="display:grid; grid-template-columns: repeat(auto-fit, minmax(260px, 1fr)); gap:16px; margin-top:14px;">
    <a class="section" href="music.jsp" style="text-decoration:none; color:inherit; background:rgba(255,255,255,0.55); border:1px solid var(--panel-border); border-radius:12px; padding:16px;">
      <h3><i class="fas fa-music"></i> <%= ((java.util.Properties)request.getAttribute("t")).getProperty("tile.music.title","Music") %></h3>
      <p><%= ((java.util.Properties)request.getAttribute("t")).getProperty("tile.music.desc","YouTube videos and Spotify playlist.") %></p>
    </a>
    <a class="section" href="texty.jsp" style="text-decoration:none; color:inherit; background:rgba(255,255,255,0.55); border:1px solid var(--panel-border); border-radius:12px; padding:16px;">
      <h3><i class="fas fa-align-left"></i> <%= ((java.util.Properties)request.getAttribute("t")).getProperty("tile.lyrics.title","Lyrics") %></h3>
      <p><%= ((java.util.Properties)request.getAttribute("t")).getProperty("tile.lyrics.desc","Browse lyrics, vote and comment.") %></p>
    </a>
    <a class="section" href="about.jsp" style="text-decoration:none; color:inherit; background:rgba(255,255,255,0.55); border:1px solid var(--panel-border); border-radius:12px; padding:16px;">
      <h3><i class="fas fa-user"></i> <%= ((java.util.Properties)request.getAttribute("t")).getProperty("tile.about.title","About") %></h3>
      <p><%= ((java.util.Properties)request.getAttribute("t")).getProperty("tile.about.desc","Who I am and how I create.") %></p>
    </a>
  </section>

  <style>
    .news-grid { display:grid; grid-template-columns: 2fr 1fr; gap:16px; margin-top:18px; }
    @media (max-width: 800px){ .news-grid { grid-template-columns: 1fr; } }
    .card { background: var(--panel); border:1px solid var(--panel-border); border-radius:12px; padding:16px; box-shadow: 0 6px 18px rgba(0,0,0,0.20); }
    .videos { display:grid; grid-template-columns: repeat(auto-fit, minmax(220px,1fr)); gap:12px; }
    .video { background: rgba(0,0,0,0.55); border:1px solid var(--panel-border); border-radius:10px; overflow:hidden; }
    .video img { width:100%; height:128px; object-fit:cover; display:block; }
    .video .meta { padding:8px; font-size:0.95em; }
    .newsletter input[type=email]{ width:100%; box-sizing:border-box; margin-bottom:8px; }
    .newsletter button { background:transparent; border:1px solid var(--panel-border); color:var(--text); padding:6px 10px; border-radius:8px; cursor:pointer; }
    .newsletter button:hover { background: rgba(255,255,255,0.08); }
  </style>

  <section class="news-grid">
    <div class="card">
      <h3 class="bruno-ace-sc-regular" style="margin-top:0;">🗞️ <%= ((java.util.Properties)request.getAttribute("t")).getProperty("home.news","Novinky") %></h3>
      <div class="videos">
        <%
          String mysqlUrl = "jdbc:mysql://127.0.0.1:3306/skeliweb?useUnicode=true&characterEncoding=utf8mb4&useSSL=false&serverTimezone=UTC";
          String mariadbUrl = "jdbc:mariadb://127.0.0.1:3306/skeliweb?useUnicode=true&characterEncoding=utf8mb4";
          String user = "Skeli";
          String password = "skeli";
          boolean mariaLoaded=false, mysqlLoaded=false;
          try { Class.forName("org.mariadb.jdbc.Driver"); mariaLoaded=true; } catch(Throwable ignore){}
          try { Class.forName("com.mysql.cj.jdbc.Driver"); mysqlLoaded=true; } catch(Throwable ignore){}
          String sql = "SELECT youtube_id, COALESCE(title, youtube_id) AS title, published_at FROM videos ORDER BY published_at DESC, id DESC LIMIT 3";
          try (Connection conn = mariaLoaded ? java.sql.DriverManager.getConnection(mariadbUrl, user, password) : (mysqlLoaded ? java.sql.DriverManager.getConnection(mysqlUrl, user, password) : null)){
            if (conn != null){
              try (PreparedStatement ps = conn.prepareStatement(sql); ResultSet rs = ps.executeQuery()){
                while (rs.next()){
                  String vid = rs.getString(1);
                  String title = rs.getString(2);
                  java.sql.Timestamp ts = rs.getTimestamp(3);
                  String dateStr = ts == null ? "" : new java.text.SimpleDateFormat("yyyy-MM-dd").format(ts);
        %>
                  <a class="video" href="https://www.youtube.com/watch?v=<%= vid %>" target="_blank" rel="noopener">
                    <img src="https://img.youtube.com/vi/<%= vid %>/hqdefault.jpg" alt="<%= title %>">
                    <div class="meta">
                      <div style="font-weight:600;"><%= title %></div>
                      <div style="font-size:0.85em; opacity:0.8;"><%= dateStr %></div>
                    </div>
                  </a>
        <%
                }
              }
            } else {
        %>
              <div><%= ((java.util.Properties)request.getAttribute("t")).getProperty("home.news.none","Žádná videa k zobrazení.") %></div>
        <%
            }
          } catch (SQLException ex) {
        %>
            <div>Chyba načítání videí: <%= ex.getMessage() %></div>
        <%
          }
        %>
      </div>
    </div>
    <div class="card">
      <h3 class="bruno-ace-sc-regular" style="margin-top:0;">🎤 <%= ((java.util.Properties)request.getAttribute("t")).getProperty("home.concerts","Koncerty") %></h3>
      <ul style="margin:0; padding-left:18px;">
        <li><%= ((java.util.Properties)request.getAttribute("t")).getProperty("home.concerts.none","Zatím nejsou naplánovány žádné koncerty.") %></li>
      </ul>
      <hr style="border-color:var(--panel-border); opacity:.5;">
      <div class="newsletter">
        <h4 style="margin:6px 0 8px;">📧 <%= ((java.util.Properties)request.getAttribute("t")).getProperty("home.newsletter.title","Novinky e-mailem") %></h4>
        <form method="post" action="/subscribe">
          <input type="hidden" name="csrf" value="<%= request.getAttribute("csrf") %>">
          <input type="email" name="email" placeholder="<%= ((java.util.Properties)request.getAttribute("t")).getProperty("home.newsletter.placeholder","Tvůj e-mail") %>" required>
          <button type="submit"><%= ((java.util.Properties)request.getAttribute("t")).getProperty("home.newsletter.submit","Odebírat") %></button>
        </form>
      </div>
    </div>
  </section>
</main>

<%@ include file="includes/footer.jsp" %>