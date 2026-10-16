<%@ include file="/includes/header.jsp" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%-- /admin/stats (AdminPagesServlet): the people-per-day chart of the dashboard on top; the arrow under it opens
     the rest (the numbers, what is played most, the most read lyrics) --%>
<main class="admin-page admin-stats-page">
  <%@ include file="/includes/admin-nav.jspf" %>
  <h2 class="admin-page-title">Statistiky</h2>
<%
  long[] heroDays = new long[14];
  try {
    heroDays = com.github.skeliit.service.VisitStats.dailyVisits(14);
  } catch (java.sql.SQLException e) {
    application.log("Visit stats", e);
  }
  long heroMax = 1;
  for (long d : heroDays) heroMax = Math.max(heroMax, d);
  java.time.LocalDate heroFirst = java.time.LocalDate.now(java.time.ZoneId.of("Europe/Prague")).minusDays(13);
  java.time.format.DateTimeFormatter heroFmt = java.time.format.DateTimeFormatter.ofPattern("d. M.");
  // open when coming back from a tab or a reset (those reload the page), closed on a plain visit
  boolean moreOpen = request.getParameter("plays") != null || request.getParameter("period") != null || request.getParameter("statsReset") != null;
%>
  <section class="admin-card stats-hero">
    <h3><i class="fa-solid fa-chart-column" aria-hidden="true"></i> Lidé po dnech</h3>
    <figure class="play-chart">
      <div class="play-days" role="img" aria-label="Lidé po dnech za posledních 14 dní">
        <% for (int i = 0; i < heroDays.length; i++) { long pct = Math.round(heroDays[i] * 100.0 / heroMax); %><span class="play-day<%= heroDays[i] == 0 ? " zero" : "" %>" style="--h: <%= pct %>%; --v: <%= pct %>" title="<%= heroFirst.plusDays(i).format(heroFmt) %>: <%= heroDays[i] %> lidí"><b><%= heroDays[i] > 0 ? heroDays[i] : "" %></b></span><% } %>
      </div>
      <div class="play-axis"><span><%= heroFirst.format(heroFmt) %></span><span><%= heroFirst.plusDays(7).format(heroFmt) %></span><span>dnes</span></div>
      <figcaption>Posledních 14 dní, každý člověk jednou za den.</figcaption>
    </figure>
  </section>
  <details class="stats-more"<%= moreOpen ? " open" : "" %>>
    <summary><span>Další statistiky</span><i class="fa-solid fa-chevron-down" aria-hidden="true"></i></summary>
<%
  // what is played most (VisitStats.countPlay): lyrics read, karaoke entered, clips started – per day, no personal data
  String playKind = request.getParameter("plays");
  if (playKind == null || !com.github.skeliit.service.VisitStats.PLAY_KINDS.contains(playKind)) playKind = "lyric";
  String periodParam = request.getParameter("period");
  int period = "7".equals(periodParam) ? 7 : "0".equals(periodParam) ? 0 : 30;
  int chartDays = period == 7 ? 7 : 30;
  java.util.List<String[]> topPlays = new java.util.ArrayList<>();
  long[] daily = new long[chartDays];
  try {
    topPlays = com.github.skeliit.service.VisitStats.topPlays(playKind, period, 10);
    daily = com.github.skeliit.service.VisitStats.dailyPlays(playKind, chartDays);
  } catch (java.sql.SQLException e) {
    application.log("Play stats", e);
  }
  long dayMax = 1, dayTotal = 0;
  for (long d : daily) { dayMax = Math.max(dayMax, d); dayTotal += d; }
  long topMax = topPlays.isEmpty() ? 1 : Math.max(1, Long.parseLong(topPlays.get(0)[1]));
  String[][] playTabs = {{"lyric", "fa-align-left", "Texty"}, {"karaoke", "fa-microphone", "Karaoke"}, {"clip", "fa-play", "Hudba (klipy)"}};
  String[][] periods = {{"7", "7 dní"}, {"30", "30 dní"}, {"0", "Celkem"}};
  java.time.LocalDate firstDay = java.time.LocalDate.now(java.time.ZoneId.of("Europe/Prague")).minusDays(chartDays - 1);
  java.time.format.DateTimeFormatter dm = java.time.format.DateTimeFormatter.ofPattern("d. M.");
%>
  <section class="admin-card play-card" id="plays">
    <h3><i class="fa-solid fa-chart-column" aria-hidden="true"></i> Co se nejvíc pouští</h3>
    <div class="play-switch">
      <nav class="play-tabs" aria-label="Co počítat">
        <% for (String[] tab : playTabs) { %>
        <a href="?plays=<%= tab[0] %>&amp;period=<%= period %>#plays" class="<%= tab[0].equals(playKind) ? "on" : "" %>"<%= tab[0].equals(playKind) ? " aria-current=\"page\"" : "" %>><i class="fa-solid <%= tab[1] %>" aria-hidden="true"></i> <%= tab[2] %></a>
        <% } %>
      </nav>
      <nav class="play-tabs play-period" aria-label="Období">
        <% for (String[] p : periods) { boolean on = p[0].equals(String.valueOf(period)); %>
        <a href="?plays=<%= playKind %>&amp;period=<%= p[0] %>#plays" class="<%= on ? "on" : "" %>"<%= on ? " aria-current=\"page\"" : "" %>><%= p[1] %></a>
        <% } %>
      </nav>
    </div>
    <%-- one column a day; the newest on the right --%>
    <figure class="play-chart">
      <figcaption>Po dnech, posledních <%= chartDays %> dní: <b><%= dayTotal %></b> celkem</figcaption>
      <div class="play-days" role="img" aria-label="Spuštění po dnech za posledních <%= chartDays %> dní, celkem <%= dayTotal %>">
        <% for (int i = 0; i < daily.length; i++) { java.time.LocalDate d = firstDay.plusDays(i); %>
        <span class="play-day<%= daily[i] == 0 ? " zero" : "" %>" style="--h: <%= Math.round(daily[i] * 100.0 / dayMax) %>%; --v: <%= Math.round(daily[i] * 100.0 / dayMax) %>" title="<%= d.format(dm) %>: <%= daily[i] %>×"><b><%= daily[i] > 0 ? daily[i] : "" %></b></span>
        <% } %>
      </div>
      <div class="play-axis"><span><%= firstDay.format(dm) %></span><span><%= firstDay.plusDays(chartDays / 2).format(dm) %></span><span>dnes</span></div>
    </figure>
    <% if (topPlays.isEmpty()) { %>
      <p class="text-dim">Za tohle období zatím nic. Počítá se od nasazení téhle verze webu.</p>
    <% } else { %>
    <ol class="play-top">
      <% for (String[] row : topPlays) { long n = Long.parseLong(row[1]); %>
      <li style="--w: <%= Math.round(n * 100.0 / topMax) %>%; --v: <%= Math.round(n * 100.0 / topMax) %>"><span class="play-name"><%= com.github.skeliit.WebUtils.escapeHtml(row[0]) %></span><b><%= n %>×</b></li>
      <% } %>
    </ol>
    <% } %>
    <p class="text-dim play-note">Každý člověk se u každé písně nebo klipu započítá jednou za den. Texty = otevřený text písně, Karaoke = vstup do kina, Hudba = spuštěný klip (na Hudbě, u písně i v Kevinově televizi). Roboti a admini se nepočítají.</p>
  </section>
<%
  // visits (VisitStats): no cookies, a visitor counts once a day; the admin's own visits are not counted
  java.util.Map<String, Object> vs = new java.util.HashMap<>();
  java.util.List<String[]> topLyrics = new java.util.ArrayList<>();
  try {
    vs = com.github.skeliit.service.VisitStats.summary();
    topLyrics = com.github.skeliit.service.VisitStats.topLyrics(5);
  } catch (java.sql.SQLException e) {
    application.log("Visit stats", e);
  }
  // {key, icon, label}
  String[][] visitTiles = {
      {"online", "fa-signal", "Právě na webu"},
      {"today", "fa-user", "Lidí dnes"},
      {"yesterday", "fa-clock-rotate-left", "Lidí včera"},
      {"days7", "fa-calendar-week", "Návštěv za 7 dní"},
      {"days30", "fa-calendar", "Návštěv za 30 dní"},
      {"allVisits", "fa-infinity", "Návštěv celkem"},
      {"pagesToday", "fa-file-lines", "Zobrazených stránek dnes"},
      {"pagesAll", "fa-layer-group", "Zobrazených stránek celkem"}
  };
%>
  <h3 class="admin-section-title" id="stats"><i class="fa-solid fa-chart-line" aria-hidden="true"></i> Návštěvnost</h3>
  <% if ("1".equals(request.getParameter("statsReset"))) { %>
  <p class="admin-flash"><i class="fa-solid fa-circle-check" aria-hidden="true"></i> Statistiky jsou vynulované, počítá se od teď.</p>
  <% } %>
  <div class="admin-stats admin-visits">
    <% for (String[] tile : visitTiles) { Object n = vs.getOrDefault(tile[0], 0); %>
    <div class="admin-stat<%= "online".equals(tile[0]) ? " live" : "" %>">
      <i class="fa-solid <%= tile[1] %>" aria-hidden="true"></i>
      <b><%= n %></b>
      <span><%= tile[2] %></span>
    </div>
    <% } %>
  </div>
  <div class="admin-grid">
    <section class="admin-card">
      <h3><i class="fa-solid fa-ranking-star" aria-hidden="true"></i> Nejčtenější texty</h3>
      <% if (topLyrics.isEmpty()) { %>
        <p class="text-dim">Zatím nikdo nic nečetl.</p>
      <% } else { %>
      <ol class="admin-top">
        <% for (String[] row : topLyrics) { %>
        <li><span><%= com.github.skeliit.WebUtils.escapeHtml(row[0]) %> <small><%= com.github.skeliit.WebUtils.escapeHtml(row[1]).toUpperCase() %></small></span> <b><%= row[2] %>×</b></li>
        <% } %>
      </ol>
      <% } %>
    </section>
    <section class="admin-card">
      <h3><i class="fa-solid fa-circle-info" aria-hidden="true"></i> Jak se počítá</h3>
      <p class="text-dim">Každý člověk se započítá jednou za den, text písně taky jen jednou za den. Roboti a tvoje návštěvy jako admina se nepočítají. Bez cookies, takže se počítají všichni, i ti, kdo v cookie liště odmítnou.</p>
      <p class="text-dim">Počítá se od: <b><%= com.github.skeliit.WebUtils.escapeHtml(vs.getOrDefault("since", "–")) %></b></p>
      <form method="post" action="/admin/stats-reset" class="admin-reset">
        <input type="hidden" name="csrf" value="${csrf}">
        <label class="checkbox-label"><input type="checkbox" name="confirm" value="ANO" required> Opravdu vynulovat počítadla (zobrazení textů i návštěvnost)</label>
        <button type="submit" class="btn-delete"><i class="fa-solid fa-rotate-left"></i> Vynulovat statistiky</button>
      </form>
    </section>
  </div>
  </details>
</main>
<%@ include file="/includes/footer.jsp" %>
