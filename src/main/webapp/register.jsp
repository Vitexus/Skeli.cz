<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="includes/header.jsp" %>
<main>
  <h2>Registrace</h2>
  <form method="post" action="register">
    <label>Uživatel: <input type="text" name="username" required></label><br>
    <label>Heslo: <input type="password" name="password" required></label><br>
    <button type="submit">Registrovat</button>
  </form>
</main>
<%@ include file="includes/footer.jsp" %>
