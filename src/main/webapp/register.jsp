<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="includes/header.jsp" %>
<main>
  <div class="auth-wrap">
    <section class="auth-card">
      <h2>Registrace</h2>
      <form method="post" action="register">
        <label>Uživatel<br><input type="text" name="username" required></label>
        <label>E-mail<br><input type="email" name="email" required></label>
        <div class="row">
          <label style="flex:1;">Heslo<br><input type="password" name="password" required minlength="8" autocomplete="new-password"></label>
          <label style="flex:1;">Potvrdit heslo<br><input type="password" name="password2" required minlength="8" autocomplete="new-password"></label>
        </div>
        <label><input type="checkbox" name="consent" value="1" required> Souhlasím se zpracováním osobních údajů a podmínkami (GDPR)</label>
        <button type="submit">Registrovat</button>
      </form>
    </section>
  </div>
</main>
<%@ include file="includes/footer.jsp" %>
