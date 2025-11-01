<%@ include file="includes/header.jsp" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<main>
  <style>
    .settings-wrap{display:flex;justify-content:center;align-items:center;min-height:70vh;}
    .settings-shell{width:100%;max-width:800px;margin:0 auto;border:1px solid var(--panel-border);border-radius:14px;padding:12px;background:rgba(0,0,0,0.12);} 
    body.light .settings-shell{background:rgba(0,0,0,0.06);} 
    .settings-form{max-width:520px;margin:0 auto;}
    .settings-form label{display:block;margin:8px 0;}
    .settings-form input[type=text], .settings-form input[type=number], .settings-form textarea, .settings-form select{width:100%; box-sizing:border-box; border:1px solid var(--panel-border); border-radius:8px; padding:8px; background:rgba(0,0,0,0.12); color:var(--text);} 
    body.light .settings-form input[type=text], body.light .settings-form input[type=number], body.light .settings-form textarea, body.light .settings-form select{background:rgba(0,0,0,0.06); color:#111;}
  </style>
  <div class="settings-wrap">
  <div class="settings-shell">
  <h2 class="bruno-ace-sc-regular" style="text-align:center;margin-top:0;">Nastavení účtu</h2>
  <%-- Načti profil z DB --%>
  <%
    Integer uid = (Integer) session.getAttribute("user_id");
    String displayName = null, city = null, bio = null, theme = "dark", prefLang = (String) session.getAttribute("lang");
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
            String l = r.getString(6); if (l != null) prefLang = l;
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
    <div class="settings-form">
    <form method="post" action="/profile/update" enctype="application/x-www-form-urlencoded">
      <input type="hidden" name="csrf" value="${csrf}">
      <label>Zobrazované jméno<br><input name="display_name" maxlength="60" value="<%= (displayName!=null?displayName:"") %>"></label>
      <label>Věk<br><input type="number" name="age" min="1" max="120" value="<%= (age!=null?age:"") %>"></label>
      <label>Město<br><input name="city" maxlength="80" value="<%= (city!=null?city:"") %>"></label>
      <label>Bio<br><textarea name="bio" rows="3"><%= (bio!=null?bio:"") %></textarea></label>
      <label>Téma<br>
        <select name="theme">
          <option value="dark" <%= "dark".equals(theme)?"selected":"" %>>Dark</option>
          <option value="light" <%= "light".equals(theme)?"selected":"" %>>Light</option>
        </select>
      </label>
      <label>Jazyk<br>
        <select name="lang">
          <option value="cs" <%= "cs".equals(prefLang)?"selected":"" %>>Čeština</option>
          <option value="en" <%= "en".equals(prefLang)?"selected":"" %>>English</option>
          <option value="de" <%= "de".equals(prefLang)?"selected":"" %>>Deutsch</option>
          <option value="uk" <%= "uk".equals(prefLang)?"selected":"" %>>Українська</option>
        </select>
      </label>
      <label style="display:flex;align-items:center;gap:8px;">
        <input type="checkbox" name="public_profile" value="1" <%= "cs".equals(prefLang)?"":"" %>> Veřejný profil
      </label>
      <div style="margin-top:8px; text-align:center;"><button type="submit">Uložit</button></div>
    </form>
    </div>
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
    <div class="settings-form">
      <form method="get" action="/profile/export" style="text-align:center; margin:8px 0;">
        <button type="submit" class="bruno-ace-sc-regular" style="border:1px solid var(--panel-border);border-radius:8px;background:transparent;padding:6px 10px;">Export dat (JSON)</button>
      </form>
      <form method="post" action="/profile/delete" onsubmit="return confirm('Opravdu smazat účet? Zadej DELETE a potvrď.');" style="display:grid; gap:8px;">
        <input type="hidden" name="csrf" value="${csrf}">
        <label>Potvrzení (napiš "DELETE")<br><input type="text" name="confirm" required></label>
        <button type="submit" style="background:#7b1e1e;color:#fff;border:none;padding:8px 12px;border-radius:8px;">Smazat účet</button>
      </form>
    </div>
  </section>
  </div>
  </div>
</main>
<%@ include file="includes/footer.jsp" %>
