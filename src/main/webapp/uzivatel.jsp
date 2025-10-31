<%@ include file="includes/header.jsp" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<main>
  <h2>Nastavení účtu</h2>
  <%-- Načti profil z DB --%>
  <%
    Integer uid = (Integer) session.getAttribute("user_id");
    String displayName = null, city = null, bio = null, theme = "dark", lang = (String) session.getAttribute("lang");
    Integer age = null;
    if (uid != null) {
      try (java.sql.Connection c = java.sql.DriverManager.getConnection("jdbc:mariadb://127.0.0.1:3306/skeliweb?useUnicode=true&characterEncoding=utf8mb4","Skeli","skeli");
           java.sql.PreparedStatement ps = c.prepareStatement("SELECT display_name, age, city, bio, theme, lang FROM user_profiles WHERE user_id=?")) {
        ps.setInt(1, uid);
        try (java.sql.ResultSet r = ps.executeQuery()) {
          if (r.next()) {
            displayName = r.getString(1);
            age = (Integer) r.getObject(2);
            city = r.getString(3);
            bio = r.getString(4);
            theme = r.getString(5);
            String l = r.getString(6); if (l != null) lang = l;
          }
        }
      } catch (Exception ignore) {}
    }
  %>

  <% if ("true".equals(request.getParameter("saved"))) { %>
    <div style="background: rgba(0,128,0,0.25); border:1px solid rgba(0,128,0,0.4); border-radius:8px; padding:10px; margin-bottom:10px; text-align:center;">Profil uložen.</div>
  <% } %>
  <% if ("true".equals(request.getParameter("password_changed"))) { %>
    <div style="background: rgba(0,128,0,0.25); border:1px solid rgba(0,128,0,0.4); border-radius:8px; padding:10px; margin-bottom:10px; text-align:center;">Heslo změněno.</div>
  <% } %>

  <section style="background: var(--panel); border: 1px solid var(--panel-border); border-radius: 12px; padding: 16px; box-shadow: 0 6px 18px rgba(0,0,0,0.20);">
    <h3>Profil</h3>
    <form method="post" action="/profile/update" enctype="application/x-www-form-urlencoded">
      <input type="hidden" name="csrf" value="${csrf}">
      <label>Zobrazované jméno: <input name="display_name" maxlength="60" value="<%= displayName!=null?displayName:""></label><br>
      <label>Věk: <input type="number" name="age" min="1" max="120" style="width:80px" value="<%= age!=null?age:""></label><br>
      <label>Město: <input name="city" maxlength="80" value="<%= city!=null?city:""></label><br>
      <label>Bio:<br><textarea name="bio" rows="4" style="width:100%"><%= bio!=null?bio:""></textarea></label><br>
      <label>Téma:
        <select name="theme">
          <option value="dark" <%= "dark".equals(theme)?"selected":"" %>>Dark</option>
          <option value="light" <%= "light".equals(theme)?"selected":"" %>>Light</option>
        </select>
      </label>
      <label>Jazyk:
        <select name="lang">
          <option value="cs" <%= "cs".equals(lang)?"selected":"" %>>Čeština</option>
          <option value="en" <%= "en".equals(lang)?"selected":"" %>>English</option>
          <option value="de" <%= "de".equals(lang)?"selected":"" %>>Deutsch</option>
          <option value="uk" <%= "uk".equals(lang)?"selected":"" %>>Українська</option>
        </select>
      </label>
      <div style="margin-top:8px"><button type="submit">Uložit</button></div>
    </form>
  </section>

  <section style="background: var(--panel); border: 1px solid var(--panel-border); border-radius: 12px; padding: 16px; margin-top: 14px; box-shadow: 0 6px 18px rgba(0,0,0,0.20);">
    <h3>Změna hesla</h3>
    <form method="post" action="/profile/change-password">
      <label>Staré heslo: <input type="password" name="old_password" required></label><br>
      <label>Nové heslo: <input type="password" name="new_password" minlength="6" required></label><br>
      <label>Potvrzení: <input type="password" name="confirm_password" minlength="6" required></label><br>
      <div style="margin-top:8px"><button type="submit">Změnit heslo</button></div>
    </form>
  </section>
  <section style="background: var(--panel); border: 1px solid var(--panel-border); border-radius: 12px; padding: 16px; margin-top: 14px; box-shadow: 0 6px 18px rgba(0,0,0,0.20);">
    <h3>Soukromí</h3>
    <ul>
      <li>Export dat (GDPR)</li>
      <li>Smazání účtu</li>
      <li>Nastavení viditelnosti profilu</li>
    </ul>
  </section>
</main>
<%@ include file="includes/footer.jsp" %>