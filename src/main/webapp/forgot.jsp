<%@ include file="includes/header.jsp" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<main>
  <h2>Zapomenuté heslo</h2>
  <% if ("true".equals(request.getParameter("sent"))) { %>
    <p style="color: green;">✓ Pokud účet existuje, byl na něj odeslán e-mail s odkazem pro obnovení hesla.</p>
  <% } %>
  <form method="post" action="forgot">
    <label>Uživatelské jméno: <input name="username" required></label>
    <button type="submit">Poslat odkaz na reset</button>
  </form>
</main>

<%@ include file="includes/footer.jsp" %>
