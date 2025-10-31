<%@ page import="java.sql.*" %>
<%@ include file="includes/header.jsp" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<style>
.section { background: var(--panel); border: 1px solid var(--panel-border); border-radius: 12px; padding: 16px 18px; margin-bottom: 18px; box-shadow: 0 6px 18px rgba(0,0,0,0.20); }
  .section.spotify { background: linear-gradient(0deg, rgba(204,43,43,0.24), rgba(255,255,255,0.04)); border-color: rgba(204,43,43,0.45); }
  .section.youtube { background: linear-gradient(0deg, rgba(255,0,0,0.14), rgba(255,255,255,0.05)); border-color: rgba(255,0,0,0.28); }
  .section-title { margin: 0 0 10px; display:flex; align-items:center; gap: 8px; font-weight:700; }
  .media-columns { display:block; }
  @media (min-width: 1100px){ .media-columns { display:grid; grid-template-columns: 1fr 1fr; gap:16px; align-items:start; } }
  .section-title .ico { font-size: 1.2em; }
</style>

<%
    String mysqlUrl = "jdbc:mysql://127.0.0.1:3306/skeliweb?useUnicode=true&characterEncoding=utf8mb4&useSSL=false&serverTimezone=UTC";
    String mariadbUrl = "jdbc:mariadb://127.0.0.1:3306/skeliweb?useUnicode=true&characterEncoding=utf8mb4";
    String user = "Skeli";
    String password = "skeli";
    boolean mariaLoaded = false;
    boolean mysqlLoaded = false;
try { Class.forName("org.mariadb.jdbc.Driver"); mariaLoaded = true; } catch (Throwable th) { /* ignore */ }
    try { Class.forName("com.mysql.cj.jdbc.Driver"); mysqlLoaded = true; } catch (Throwable th) { /* ignore */ }

    String sql = "SELECT v.youtube_id, COALESCE(v.title, s.name, v.youtube_id) AS title, s.year " +
                 "FROM videos v LEFT JOIN songs s ON s.id = v.song_id " +
                 "ORDER BY COALESCE(v.title, s.name, v.youtube_id) ASC";

    java.util.List<String> ids = new java.util.ArrayList<>();
    java.util.List<String> names = new java.util.ArrayList<>();
    java.util.List<String> years = new java.util.ArrayList<>();

    try (Connection conn = mariaLoaded ? java.sql.DriverManager.getConnection(mariadbUrl, user, password)
                                       : (mysqlLoaded ? java.sql.DriverManager.getConnection(mysqlUrl, user, password) : null)) {
        if (conn != null) {
            try (PreparedStatement ps = conn.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    ids.add(rs.getString(1));
                    names.add(rs.getString(2));
                    years.add(rs.getString(3));
                }
            }
        }
    } catch (SQLException e) {
        // fallback empty, handled below
    }
    if (ids.isEmpty()) {
        // show an info banner if DB unavailable; grid stays empty
        request.setAttribute("videoInfo", "Nelze načíst videa z DB. Zkuste to prosím později.");
    }
%>

<main>
  <h2>Moje Hudba!</h2>

  <div class="media-columns">
  <section class="section spotify">
    <h3 class="section-title"><span class="ico"><i class="fab fa-spotify" style="color:var(--spotify)"></i></span> <%= ((java.util.Properties)request.getAttribute("t")).getProperty("section.spotify","Spotify") %></h3>
    <div id="spotifyEmbed" data-src="https://open.spotify.com/embed/artist/5IouXw8U9uKCTwmncG5bUl?utm_source=generator" style="min-height:160px;">
      <button id="spotifyLoad" style="padding:6px 10px;">Povolit a načíst Spotify</button>
      <button id="spotifyDock" style="padding:6px 10px; margin-left:8px;">Přehrát dole</button>
    </div>
  </section>

  <section class="section youtube">
    <h3 class="section-title"><span class="ico"><i class="fab fa-youtube" style="color:#FF0000"></i></span> <%= ((java.util.Properties)request.getAttribute("t")).getProperty("section.youtube","YouTube") %></h3>
    <jsp:include page="/elliptic" flush="true" />
  </section>
  </div>

</main>

<script>
$(function(){
  function tryLoadSpotify(){
    var c = $('#spotifyEmbed'); if (!c.length) return;
    if (!c.data('loaded')) {
      var src = c.data('src');
      c.html('<iframe style="border-radius:12px" src="'+src+'" width="100%" height="152" frameBorder="0" allow="autoplay; clipboard-write; encrypted-media; fullscreen; picture-in-picture" loading="lazy"></iframe>');
      c.data('loaded',true);
    }
  }
  $('#spotifyLoad').on('click', function(){ tryLoadSpotify(); });
  $('#spotifyDock').on('click', function(){ var src=$('#spotifyEmbed').data('src'); if(window.playSpotify) window.playSpotify(src); else { tryLoadSpotify(); } });
  tryLoadSpotify();
});
</script>
<%@ include file="includes/footer.jsp" %>
