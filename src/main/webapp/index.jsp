<%@ include file="includes/header.jsp" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<main>
  <section style="text-align:center; padding:10px 0 6px;">
    <h2 class="comforter-brush-regular" style="font-size:3rem; margin:0;">SKELOSQUAD</h2>
    <p style="margin:6px 0 0;"><%= ((java.util.Properties)request.getAttribute("t")).getProperty("index.hero","Official website – music, lyrics, news.") %></p>
  </section>
  <section style="display:grid; grid-template-columns: repeat(auto-fit, minmax(260px, 1fr)); gap:16px; margin-top:14px;">
    <a class="section" href="music.jsp" style="text-decoration:none; color:inherit; background:rgba(255,255,255,0.55); border-radius:12px; padding:16px;">
      <h3><i class="fas fa-music"></i> Hudba</h3>
      <p>Videa z YouTube a Spotify playlist.</p>
    </a>
    <a class="section" href="texty.jsp" style="text-decoration:none; color:inherit; background:rgba(255,255,255,0.55); border-radius:12px; padding:16px;">
      <h3><i class="fas fa-align-left"></i> Texty</h3>
      <p>Procházej texty, hlasuj a komentuj.</p>
    </a>
    <a class="section" href="about.jsp" style="text-decoration:none; color:inherit; background:rgba(255,255,255,0.55); border-radius:12px; padding:16px;">
      <h3><i class="fas fa-user"></i> O nás</h3>
      <p>Kdo jsem a jak tvořím.</p>
    </a>
  </section>
</main>

<%@ include file="includes/footer.jsp" %>