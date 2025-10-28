<%@ include file="includes/header.jsp" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<main>
  <h2>Nastavit nové heslo</h2>
  <form method="post" action="reset">
    <input type="hidden" name="token" value="<%= request.getParameter("token") != null ? request.getParameter("token") : "" %>">
    <label>Nové heslo: <input type="password" name="password" minlength="8" required></label>
    <button type="submit">Uložit</button>
  </form>
</main>

<%@ include file="includes/footer.jsp" %>
