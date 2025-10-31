<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="includes/header.jsp" %>
<main>
  <section style="max-width:520px; margin:0 auto; background:rgba(0,0,0,0.70); border:1px solid var(--panel-border); border-radius:12px; padding:16px; box-shadow:0 10px 30px rgba(0,0,0,.25);">
    <h2 style="margin-top:0;">Přihlášení</h2>
    <form method="post" action="login" style="display:grid; gap:10px;">
      <label>Uživatel<br><input type="text" name="username" required></label>
      <label>Heslo<br><input type="password" name="password" required></label>
      <button type="submit" style="padding:8px 12px; border:1px solid var(--panel-border); border-radius:8px; background:rgba(0,0,0,0.2); color:inherit;">Přihlásit</button>
    </form>
  </section>
</main>
<%@ include file="includes/footer.jsp" %>
