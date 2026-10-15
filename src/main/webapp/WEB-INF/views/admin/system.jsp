<%@ include file="/includes/header.jsp" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%-- /admin/system (AdminPagesServlet): synchronisation with YouTube, Instagram and Apple Music, the lyrics export --%>
<main class="admin-page admin-system-page">
  <%@ include file="/includes/admin-nav.jspf" %>
  <h2 class="admin-page-title">Synchronizace a export</h2>
  <section class="admin-card admin-sync-card">
    <div class="admin-sync-item">
      <i class="fab fa-youtube icon-youtube" aria-hidden="true"></i>
      <div><b>YouTube</b><span>Načte videa z kanálu a spáruje je se songy.</span></div>
      <a class="admin-btn" href="/admin/sync">Spustit</a>
    </div>
    <div class="admin-sync-item">
      <i class="fab fa-instagram icon-instagram" aria-hidden="true"></i>
      <div><b>Instagram</b><span>Běží samo každou hodinu: posledních 25 příspěvků do Aktualit.</span></div>
      <a class="admin-btn" href="/admin/instagram-sync">Spustit</a>
    </div>
    <div class="admin-sync-item">
      <i class="fab fa-apple" aria-hidden="true"></i>
      <div><b>Apple Music</b><span>Najde písně v katalogu Apple Music a doplní odkazy (zdarma, bez klíčů). Časovaný text jen s placeným účtem Apple Developer.</span>
<%
  // result of /admin/apple-sync (numbers only, never echoed as text)
  String appleRes = request.getParameter("apple");
  if ("error".equals(appleRes)) {
%>
        <span class="admin-sync-result warn">Katalog Apple Music teď nejde načíst. Zkus to prosím později.</span>
<% } else if (appleRes != null && appleRes.matches("[0-9]{1,4}")) {
     String miss = request.getParameter("appleMissing"), lyr = request.getParameter("appleLyrics");
     miss = miss != null && miss.matches("[0-9]{1,4}") ? miss : "0";
     lyr = lyr != null && lyr.matches("[0-9]{1,4}") ? lyr : "0";
%>
        <span class="admin-sync-result">Hotovo: doplněno <b><%= appleRes %></b>, bez Apple Music zůstává <b><%= miss %></b> (featy u jiných interpretů, songy, které na Apple Music nejsou)<% if (!"0".equals(lyr)) { %>, časovaných textů: <b><%= lyr %></b><% } %>.</span>
<% } %>
      </div>
      <a class="admin-btn" href="/admin/apple-sync">Spustit</a>
    </div>
    <div class="admin-sync-item">
      <i class="fa-solid fa-file-zipper" aria-hidden="true"></i>
      <div><b>Export textů</b><span>Stáhne všechny texty jako soubory TTML v archivu ZIP, např. pro Apple Music přes DistroKid.</span></div>
      <a class="admin-btn" href="/admin/lyrics-export">Stáhnout</a>
    </div>
  </section>
</main>
<%@ include file="/includes/footer.jsp" %>
