<%@ include file="includes/header.jsp" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<main>
  <h2>Podpoř můj projekt</h2>
  <p>Dobrovolný příspěvek pomůže s výrobou hudby, videí a provozem webu. Dík!</p>

  <section class="section" style="max-width:520px;">
    <h3>Možnosti</h3>
    <ul>
      <li>PayPal: <a href="https://www.paypal.me/Skeli" target="_blank" rel="noopener">paypal.me/Skeli</a></li>
      <li>Buy Me a Coffee: <a href="https://buymeacoffee.com/skeli" target="_blank" rel="noopener">buymeacoffee.com/skeli</a></li>
      <li>Kartou (Stripe Checkout): <a href="#" onclick="alert('Doplníme Stripe link'); return false;">Stripe</a></li>
    </ul>
  </section>

  <section class="section" style="max-width:520px;">
    <h3>Fakturace / kontakt</h3>
    <p>E-mail: <a href="mailto:skelimc@seznam.cz">skelimc@seznam.cz</a></p>
  </section>
</main>

<%@ include file="includes/footer.jsp" %>
