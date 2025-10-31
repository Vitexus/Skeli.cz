<%@ include file="includes/header.jsp" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<main>
  <h2>Nastavení účtu</h2>
  <section class="section" style="background:rgba(0,0,0,0.70); border:1px solid var(--panel-border); border-radius:12px;">
    <h3>Profil</h3>
<form method="post" action="uzivatel.jsp?action=update" enctype="multipart/form-data">
      <label>Zobrazované jméno: <input name="display_name" maxlength="60"></label><br>
      <label>Věk: <input type="number" name="age" min="1" max="120" style="width:80px"></label><br>
      <label>Město: <input name="city" maxlength="80"></label><br>
      <label>Bio:<br><textarea name="bio" rows="4" style="width:100%"></textarea></label><br>
      <label>Avatar: <input type="file" name="avatar" accept="image/*"></label><br>
      <label>Téma: 
        <select name="theme"><option value="dark">Dark</option><option value="light">Light</option></select>
      </label>
      <label>Jazyk: 
        <select name="lang"><option value="cs">Čeština</option><option value="en">English</option><option value="de">Deutsch</option><option value="sk">Slovensky</option></select>
      </label>
      <div style="margin-top:8px"><button type="submit">Uložit</button></div>
    </form>
  </section>
  <section class="section">
    <h3>Zabezpečení</h3>
    <ul>
      <li>Změna hesla (s minimální délkou a kontrolou síly)</li>
      <li>Zapnutí 2FA (TOTP)</li>
      <li>Seznam aktivních relací s možností „Odhlásit všude“</li>
    </ul>
  </section>
  <section class="section">
    <h3>Soukromí</h3>
    <ul>
      <li>Export dat (GDPR)</li>
      <li>Smazání účtu</li>
      <li>Nastavení viditelnosti profilu</li>
    </ul>
  </section>
</main>
<%@ include file="includes/footer.jsp" %>