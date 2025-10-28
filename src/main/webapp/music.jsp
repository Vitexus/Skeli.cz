<%@ page import="java.sql.*" %>
<%@ include file="includes/header.jsp" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<style>
  .section { background: rgba(255,255,255,0.55); border: 1px solid rgba(0,0,0,0.06); border-radius: 12px; padding: 16px 18px; margin-bottom: 18px; box-shadow: 0 6px 18px rgba(0,0,0,0.10); }
  .section-title { margin: 0 0 10px; display:flex; align-items:center; gap: 8px; font-weight:700; }
  .section-title .ico { font-size: 1.2em; }
  .now-playing { margin: 10px 0 20px; padding: 10px 14px; background: rgba(255,255,255,0.35); border-radius: 10px; display:inline-block; box-shadow: 0 6px 18px rgba(0,0,0,0.10); }
  .track-title { font-weight: 600; }
  .grid { display: grid; grid-template-columns: repeat(3, 1fr); gap: 1px; }
  .thumb { position: relative; cursor:pointer; border-radius: 12px; overflow: hidden; box-shadow: 0 10px 24px rgba(0,0,0,0.25); background: #111; transition: transform .12s ease; }
  .thumb:hover { transform: translateY(-2px); }
  .thumb img { width: 100%; aspect-ratio: 16/9; object-fit: cover; display:block; filter: saturate(1.05) contrast(1.05); }
  .thumb .overlay { position:absolute; inset:0; background: linear-gradient(to top, rgba(0,0,0,0.75), rgba(0,0,0,0.05)); display:flex; align-items:flex-end; justify-content:stretch; }
  .thumb .meta { width:100%; padding: 10px 12px; color:#fff; text-align:left; }
  .track-title { font-weight:700; text-shadow: 0 1px 2px rgba(0,0,0,0.5); }
  .track-year { opacity:.8; }
  .modal { position: fixed; inset: 0; background: rgba(0,0,0,0.75); display:none; align-items: center; justify-content: center; z-index: 1000; }
  .modal .player { width: min(92vw, 900px); background: rgba(255,255,255,0.95); border-radius: 10px; padding: 12px; box-shadow: 0 10px 30px rgba(0,0,0,0.25); }
  .modal .head { display:flex; justify-content: space-between; align-items:center; padding: 2px 8px 8px; }
  .modal .close { cursor:pointer; font-size: 1.4em; }
</style>

<%
    String mysqlUrl = "jdbc:mysql://localhost:3306/skeliweb?useUnicode=true&characterEncoding=utf8mb4&useSSL=false&serverTimezone=UTC";
    String mariadbUrl = "jdbc:mariadb://localhost:3306/skeliweb?useUnicode=true&characterEncoding=utf8mb4";
    String user = "Skeli";
    String password = "skeli";
    boolean mariaLoaded = false;
    boolean mysqlLoaded = false;
    try { Class.forName("org.mariadb.jdbc.Driver"); mariaLoaded = true; } catch (Throwable t) { /* ignore */ }
    try { Class.forName("com.mysql.cj.jdbc.Driver"); mysqlLoaded = true; } catch (Throwable t) { /* ignore */ }

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
        // fallback empty
    }
%>

<main>
  <h2>Moje Hudba!</h2>

  <section class="section">
    <h3 class="section-title"><span class="ico"><i class="fab fa-spotify" style="color:#1DB954"></i></span> Spotify</h3>
    <div id="spotifyEmbed" data-src="https://open.spotify.com/embed/artist/5IouXw8U9uKCTwmncG5bUl?utm_source=generator" style="min-height:160px;">
      <button id="spotifyLoad" style="padding:6px 10px;">Povolit a načíst Spotify</button>
    </div>
  </section>

  <section class="section">
    <h3 class="section-title"><span class="ico"><i class="fab fa-youtube" style="color:#FF0000"></i></span> YouTube</h3>
    <div class="now-playing">Přehrává se: <span id="np-title">—</span> <span id="np-year"></span></div>
    <div class="grid" id="tracks">
    <% for (int i = 0; i < ids.size(); i++) { String id = ids.get(i); String nm = names.get(i); String yr = years.get(i); %>
      <div class="thumb" data-idx="<%= i %>" data-id="<%= id %>" data-name="<%= nm != null ? nm : "" %>" data-year="<%= yr != null ? yr : "" %>" title="Přehrát: <%= (nm != null && !nm.isEmpty()) ? nm : id %>">
        <img src="https://img.youtube.com/vi/<%= id %>/hqdefault.jpg" alt="<%= (nm != null && !nm.isEmpty()) ? nm : id %>" loading="lazy">
        <div class="overlay">
          <div class="meta">
            <div class="track-title"><%= (nm != null && !nm.isEmpty()) ? nm : "Načítám…" %></div>
            <div class="track-year"><%= (yr != null && !yr.isEmpty()) ? ("(" + yr + ")") : "" %></div>
          </div>
        </div>
      </div>
    <% } %>
    </div>
  </section>

  <div class="modal" id="videoModal">
    <div class="player">
      <div class="head"><div><strong id="modalTitle">—</strong> <span id="modalYear"></span></div><div class="close" id="modalClose">✕</div></div>
      <div style="position:relative; padding-top:56.25%;">
        <iframe id="modalFrame" style="position:absolute; inset:0; width:100%; height:100%;" src="" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" allowfullscreen></iframe>
      </div>
    </div>
  </div>
</main>

<script>
$(function(){
  // Consent-gated Spotify
  function tryLoadSpotify(){
    var granted = localStorage.getItem('cookieConsent') === 'true';
    var c = $('#spotifyEmbed'); if (!c.length) return;
    if (granted && !c.data('loaded')) {
      var src = c.data('src');
      c.html('<iframe style="border-radius:12px" src="'+src+'" width="100%" height="152" frameBorder="0" allow="autoplay; clipboard-write; encrypted-media; fullscreen; picture-in-picture" loading="lazy"></iframe>');
      c.data('loaded',true);
    }
  }
  $('#spotifyLoad').on('click', function(){ localStorage.setItem('cookieConsent','true'); document.dispatchEvent(new Event('consent-granted')); tryLoadSpotify(); });
  document.addEventListener('consent-granted', tryLoadSpotify);
  tryLoadSpotify();
  function openModal(id, title, year){
    $('#modalFrame').attr('src', 'https://www.youtube.com/embed/'+id+'?autoplay=1');
    $('#modalTitle').text(title || '—');
    $('#modalYear').text(year ? '('+year+')' : '');
    $('#videoModal').fadeIn(120);
    $('#np-title').text(title || '—');
    $('#np-year').text(year ? '('+year+')' : '');
    // Pokud titul chybí, zjisti z oEmbed a aktualizuj i DB (pokud ADMIN je přihlášen, řeší ručně)
    if (!title || title.length < 2) {
      $.getJSON('https://www.youtube.com/oembed?url=https://www.youtube.com/watch?v='+id+'&format=json')
        .done(function(d){
          $('#modalTitle').text(d.title);
          $('#np-title').text(d.title);
        });
    }
  }
  $('#modalClose, #videoModal').on('click', function(e){ if(e.target!==this) return; $('#videoModal').fadeOut(120, function(){ $('#modalFrame').attr('src',''); }); });
  $('#tracks .thumb').on('click', function(){
    var id = $(this).data('id');
    var title = $(this).data('name');
    var year = $(this).data('year');
    if (!title || title.length < 2) {
      $.getJSON('https://www.youtube.com/oembed?url=https://www.youtube.com/watch?v='+id+'&format=json')
        .done(function(d){ openModal(id, d.title, year); });
    } else {
      openModal(id, title, year);
    }
  });
  // resync button for admin (if needed)
  if (window.location.hash === '#sync' || $('.admin-sync').length) {
    // optional: could trigger fetch
  }
});
</script>
<%@ include file="includes/footer.jsp" %>
