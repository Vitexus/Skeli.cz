<%@ include file="includes/header.jsp" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<main>
  <h2>Admin</h2>
  <p>Tato sekce je dostupná pouze pro ADMIN.</p>
  <section class="section">
    <h3>Synchronizace YouTube</h3>
    <p><a class="admin-sync" href="/admin/sync">Spustit sync</a></p>
  </section>

  <section class="section">
    <h3>Upravit / napojit video</h3>
    <form method="post" action="/admin/video">
      <label>YouTube ID: <input name="youtube_id" required></label>
      <label>Název (přepíše title v DB): <input name="title"></label>
      <label>Song name (vytvoří/propojí): <input name="song_name"></label>
      <label>Year: <input name="year" type="number" min="1900" max="2100"></label>
      <label>nebo napojit na lyric ID: <input name="lyric_id" type="number" min="1"></label>
      <button type="submit">Uložit</button>
    </form>
  </section>

  <section class="section">
    <h3>Moderace komentářů</h3>
    <form method="post" action="/admin/comment">
      <label>ID komentáře k odstranění: <input name="comment_id" required></label>
      <button type="submit">Smazat</button>
    </form>
  </section>
  <section class="section">
    <h3>Uživatelé</h3>
    <p><a href="/admin_users.jsp">Správa uživatelů</a></p>
  </section>
</main>

<%@ include file="includes/footer.jsp" %>
