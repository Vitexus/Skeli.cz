<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="includes/header.jsp" %>
<main>
  <h2>Registrace</h2>
  <form method="post" action="register">
    <label>Uživatel: <input type="text" name="username" required></label><br>
    <label>Heslo: <input type="password" name="password" required minlength="8" autocomplete="new-password"></label><br>
    <label><input type="checkbox" name="consent" value="1" required> Souhlasím se zpracováním osobních údajů a podmínkami (GDPR)</label><br>
    <button type="submit">Registrovat</button>
  </form>
</main>
<%@ include file="includes/footer.jsp" %>
