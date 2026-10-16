<%@ include file="includes/header.jsp" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
  // the dashboard numbers (dao/AdminDao); the page still works when they can't be read
  java.util.Map<String, Integer> st = new java.util.HashMap<>();
  try {
    st = new com.github.skeliit.dao.AdminDao().stats();
  } catch (java.sql.SQLException e) {
    application.log("Admin stats", e);
  }
  String adminName = com.github.skeliit.WebUtils.escapeHtml(session.getAttribute("username"));
  int nReports = st.getOrDefault("reports", 0), nClipsAlone = st.getOrDefault("clipsWithoutSong", 0), nNoText = st.getOrDefault("songsWithoutLyrics", 0);
  // {link, icon, label, key}
  String[][] tiles = {
      {"/admin/songs", "fa-music", "Písně", "songs"},
      {"/admin/songs", "fa-film", "Klipy", "clips"},
      {"/admin/lyrics", "fa-align-left", "Songy s textem", "lyrics"},
      {"/admin/comments", "fa-comments", "Komentáře", "comments"},
      {"/admin_users.jsp", "fa-users", "Uživatelé", "users"},
      {"/admin/newsletter", "fa-envelope-open-text", "Odběratelé", "subscribers"},
      {"/admin/comments#reports", "fa-flag", "Nahlášené", "reports"}
  };
%>
<main class="admin-page">
  <%@ include file="/includes/admin-nav.jspf" %>

  <header class="admin-head">
    <h2>Admin</h2>
    <p class="admin-hello">Ahoj, <b><%= adminName %></b>. Tady máš přehled webu a všechno, co se dá upravit.</p>
  </header>

  <%-- the numbers at a glance; each tile leads where you work with it --%>
  <div class="admin-stats">
    <% for (String[] tile : tiles) { int n = st.getOrDefault(tile[3], 0); boolean alert = "reports".equals(tile[3]) && n > 0; %>
    <a class="admin-stat<%= alert ? " alert" : "" %>" href="<%= tile[0] %>">
      <i class="fa-solid <%= tile[1] %>" aria-hidden="true"></i>
      <b><%= n %></b>
      <span><%= tile[2] %></span>
    </a>
    <% } %>
  </div>

  <%-- what is waiting for the admin (the same list MC Kevin reads out) --%>
  <section class="admin-card admin-todo">
    <h3><i class="fa-solid fa-list-check" aria-hidden="true"></i> Co čeká</h3>
    <% if (nReports + nClipsAlone + nNoText == 0) { %>
      <p class="admin-done"><i class="fa-solid fa-circle-check" aria-hidden="true"></i> Všechno hotovo. Můžeš jít nahrávat.</p>
    <% } else { %>
    <ul>
      <% if (nReports > 0) { %><li class="urgent"><a href="/admin/comments#reports"><i class="fa-solid fa-flag"></i> <b><%= nReports %></b> nahlášených komentářů čeká na rozhodnutí</a></li><% } %>
      <% if (nClipsAlone > 0) { %><li><a href="/admin/lyrics"><i class="fa-solid fa-film"></i> <b><%= nClipsAlone %></b> klipů nemá song – v editoru textů z nich jedním klikem uděláš song</a></li><% } %>
      <% if (nNoText > 0) { %><li><a href="/admin/lyrics"><i class="fa-solid fa-align-left"></i> <b><%= nNoText %></b> songů nemá text</a></li><% } %>
    </ul>
    <% } %>
  </section>

<%
  // visits at a glance (the details and charts are on /admin/stats)
  java.util.Map<String, Object> vs = new java.util.HashMap<>();
  long[] visitDays = new long[14];
  try {
    vs = com.github.skeliit.service.VisitStats.summary();
    visitDays = com.github.skeliit.service.VisitStats.dailyVisits(14);
  } catch (java.sql.SQLException e) {
    application.log("Visit stats", e);
  }
  long visitMax = 1;
  for (long d : visitDays) visitMax = Math.max(visitMax, d);
  String[][] visitTiles = {
      {"online", "fa-signal", "Právě na webu"},
      {"today", "fa-user", "Lidí dnes"},
      {"days7", "fa-calendar-week", "Návštěv za 7 dní"},
      {"pagesToday", "fa-file-lines", "Stránek dnes"}
  };
  // under the arrow: the other numbers and the top 5 of the last 7 days of each kind
  String[][] moreTiles = {
      {"yesterday", "fa-clock-rotate-left", "Lidí včera"},
      {"days30", "fa-calendar", "Návštěv za 30 dní"},
      {"allVisits", "fa-infinity", "Návštěv celkem"},
      {"pagesAll", "fa-layer-group", "Stránek celkem"}
  };
  String[][] topKinds = {{"lyric", "fa-align-left", "Texty"}, {"karaoke", "fa-microphone", "Karaoke"}, {"clip", "fa-play", "Klipy"}};
  java.util.Map<String, java.util.List<String[]>> tops = new java.util.LinkedHashMap<>();
  for (String[] k : topKinds) {
    try {
      tops.put(k[0], com.github.skeliit.service.VisitStats.topPlays(k[0], 7, 5));
    } catch (java.sql.SQLException e) {
      application.log("Play stats", e);
      tops.put(k[0], new java.util.ArrayList<>());
    }
  }
%>
  <section class="admin-card admin-glance">
    <div class="admin-glance-head">
      <h3><i class="fa-solid fa-chart-line" aria-hidden="true"></i> Návštěvnost</h3>
      <a href="/admin/stats">Všechny statistiky a grafy <i class="fa-solid fa-arrow-right" aria-hidden="true"></i></a>
    </div>
    <div class="admin-stats admin-visits">
      <% for (String[] tile : visitTiles) { %>
      <div class="admin-stat<%= "online".equals(tile[0]) ? " live" : "" %>">
        <i class="fa-solid <%= tile[1] %>" aria-hidden="true"></i>
        <b><%= vs.getOrDefault(tile[0], 0) %></b>
        <span><%= tile[2] %></span>
      </div>
      <% } %>
    </div>
    <div class="play-days admin-spark" role="img" aria-label="Lidé po dnech za posledních 14 dní">
      <% for (int i = 0; i < visitDays.length; i++) { %><span class="play-day<%= visitDays[i] == 0 ? " zero" : "" %>" style="--h: <%= Math.round(visitDays[i] * 100.0 / visitMax) %>%; --v: <%= Math.round(visitDays[i] * 100.0 / visitMax) %>" title="<%= visitDays[i] %> lidí"><b><%= visitDays[i] > 0 ? visitDays[i] : "" %></b></span><% } %>
    </div>
    <p class="text-dim admin-spark-note">Lidé po dnech, posledních 14 dní (dnes vpravo).</p>
    <%-- the round arrow under the chart: the rest of the numbers, without leaving the dashboard --%>
    <details class="stats-more">
      <summary><span>Další statistiky</span><i class="fa-solid fa-chevron-down" aria-hidden="true"></i></summary>
      <div class="admin-stats admin-visits">
        <% for (String[] tile : moreTiles) { %>
        <div class="admin-stat">
          <i class="fa-solid <%= tile[1] %>" aria-hidden="true"></i>
          <b><%= vs.getOrDefault(tile[0], 0) %></b>
          <span><%= tile[2] %></span>
        </div>
        <% } %>
      </div>
      <p class="admin-more-k">Nejvíc puštěné za posledních 7 dní</p>
      <div class="admin-more-tops">
        <% for (String[] k : topKinds) { java.util.List<String[]> rows = tops.get(k[0]); long max = rows.isEmpty() ? 1 : Math.max(1, Long.parseLong(rows.get(0)[1])); %>
        <div class="admin-more-top">
          <h4><i class="fa-solid <%= k[1] %>" aria-hidden="true"></i> <%= k[2] %></h4>
          <% if (rows.isEmpty()) { %>
          <p class="text-dim">Zatím nic.</p>
          <% } else { %>
          <ol class="play-top">
            <% for (String[] row : rows) { long n = Long.parseLong(row[1]); long pct = Math.round(n * 100.0 / max); %>
            <li style="--w: <%= pct %>%; --v: <%= pct %>"><span class="play-name"><%= com.github.skeliit.WebUtils.escapeHtml(row[0]) %></span><b><%= n %>×</b></li>
            <% } %>
          </ol>
          <% } %>
        </div>
        <% } %>
      </div>
      <a class="admin-more-all" href="/admin/stats">Všechny statistiky a grafy <i class="fa-solid fa-arrow-right" aria-hidden="true"></i></a>
    </details>
  </section>

  <%-- the things done most often, one tap away --%>
  <div class="admin-quick">
    <a class="admin-btn primary" href="/admin/track"><i class="fa-solid fa-plus" aria-hidden="true"></i> Přidat track z YouTube</a>
    <a class="admin-btn" href="/admin/newsletter#compose"><i class="fa-solid fa-paper-plane" aria-hidden="true"></i> Napsat novinky</a>
    <a class="admin-btn" href="/admin/lyrics"><i class="fa-solid fa-align-left" aria-hidden="true"></i> Upravit text</a>
    <a class="admin-btn" href="/admin/comments"><i class="fa-solid fa-comments" aria-hidden="true"></i> Komentáře</a>
  </div>

  <details class="admin-card admin-manual" id="manual"<%= request.getParameter("manual") != null ? " open" : "" %>>
    <summary><i class="fa-solid fa-screwdriver-wrench" aria-hidden="true"></i> Přidat / upravit song a video ručně</summary>
    <% if ("saved".equals(request.getParameter("manual"))) { %><p class="admin-flash"><i class="fa-solid fa-circle-check" aria-hidden="true"></i> Uloženo.</p><% } %>
    <p class="text-dim">Song, který není na tvém kanálu (feat, cizí kanál, jen Spotify…): vlož odkaz na video a název songu – objeví se v Diskografii. Bez odkazu se přidá song bez videa. Běžně stačí „Přidat track z YouTube“.</p>
      <form method="post" action="/admin/video" class="admin-form admin-form-cols">
        <input type="hidden" name="csrf" value="${csrf}">
        <label class="span-2">Odkaz na YouTube nebo ID videa <input name="youtube_id" placeholder="https://www.youtube.com/watch?v=…"></label>
        <label>Název songu (vytvoří nebo propojí) <input name="song_name"></label>
        <label>Název videa (nepovinné – jinak z YouTube) <input name="title"></label>
        <label>Rok <input name="year" type="number" min="1900" max="2100"></label>
        <label>Napojit na text (lyric ID) <input name="lyric_id" type="number" min="1"></label>
        <button type="submit" class="span-2"><i class="fa-solid fa-floppy-disk"></i> Uložit</button>
      </form>
  </details>
</main>

<%@ include file="includes/footer.jsp" %>
