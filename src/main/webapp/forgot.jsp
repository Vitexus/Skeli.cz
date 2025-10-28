<%@ include file="includes/header.jsp" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<main>
  <h2>Zapomenuté heslo</h2>
  <form method="post" action="forgot">
    <label>Uživatelské jméno: <input name="username" required></label>
    <button type="submit">Poslat odkaz na reset</button>
  </form>
</main>

<%@ include file="includes/footer.jsp" %>
