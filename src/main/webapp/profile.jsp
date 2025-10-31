<%@ include file="includes/header.jsp" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<main>
  <h2>Profil</h2>
  <section style="background: var(--panel); border: 1px solid var(--panel-border); border-radius: 12px; padding: 16px; box-shadow: 0 6px 18px rgba(0,0,0,0.20);">
    <h3>Nahrát avatar</h3>
    <form method="post" action="/profile/avatar" enctype="multipart/form-data">
      <input type="file" name="avatar" accept="image/*" required>
      <input type="hidden" name="csrf" value="${csrf}">
      <button type="submit" style="padding: 8px 16px; border: 1px solid var(--panel-border); border-radius: 8px; background: var(--panel); color: var(--text); cursor: pointer;">Nahrát</button>
    </form>
  </section>
</main>
<%@ include file="includes/footer.jsp" %>
