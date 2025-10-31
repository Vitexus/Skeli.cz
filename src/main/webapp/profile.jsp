<%@ include file="includes/header.jsp" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<main>
  <h2>Profil</h2>
  <section class="section" style="background:rgba(255,255,255,0.55); border:1px solid var(--panel-border); border-radius:12px; padding:16px;">
    <h3>Nahrát avatar</h3>
    <form method="post" action="/profile/avatar" enctype="multipart/form-data">
      <input type="file" name="avatar" accept="image/*" required>
      <button type="submit">Nahrát</button>
    </form>
</section>
  <section class="section" style="margin-top:14px;">
    <h3>Navigace webu</h3>
    <div style="display:grid; grid-template-columns:repeat(auto-fit,minmax(200px,1fr)); gap:12px;">
      <a href="/index.jsp" style="text-decoration:none; color:inherit; padding:10px; background:rgba(0,0,0,0.2); border-radius:8px; display:block;"><strong>🏠 Domů</strong><br><small>Hlavní stránka s novinkami</small></a>
      <a href="/music.jsp" style="text-decoration:none; color:inherit; padding:10px; background:rgba(0,0,0,0.2); border-radius:8px; display:block;"><strong>🎧 Hudba</strong><br><small>Videoklipy a Spotify</small></a>
      <a href="/texty.jsp" style="text-decoration:none; color:inherit; padding:10px; background:rgba(0,0,0,0.2); border-radius:8px; display:block;"><strong>📝 Texty</strong><br><small>Všechny texty písní</small></a>
      <a href="/about.jsp" style="text-decoration:none; color:inherit; padding:10px; background:rgba(0,0,0,0.2); border-radius:8px; display:block;"><strong>👤 O nás</strong><br><small>Informace o Skelim</small></a>
    </div>
  </section>
</main>
<%@ include file="includes/footer.jsp" %>
