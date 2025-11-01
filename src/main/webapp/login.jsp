<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="includes/header.jsp" %>
<main>
  <div class="auth-wrap">
    <section class="auth-card">
      <h2>Přihlášení</h2>
      <form method="post" action="login">
        <label>Uživatel<br><input type="text" name="username" required></label>
        <label>Heslo<br><input type="password" name="password" required></label>
        <label style="display:flex;align-items:center;gap:6px;margin-top:4px;">
          <input type="checkbox" name="remember" value="1"> Zapamatovat na tomto zařízení
        </label>
        <button type="submit">Přihlásit</button>
      </form>
    </section>
  </div>
</main>
<%@ include file="includes/footer.jsp" %>
