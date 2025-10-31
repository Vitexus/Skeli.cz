<%@ include file="includes/header.jsp" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<main>
  <h2>Kontakt</h2>
  <form method="post" action="/contact">
    <label>Jméno: <input name="name" required></label><br>
    <label>E-mail: <input name="email" type="email" required></label><br>
    <label>Zpráva: <textarea name="message" rows="4" required></textarea></label><br>
    <button type="submit">Odeslat</button>
  </form>
</main>

<%@ include file="includes/footer.jsp" %>
