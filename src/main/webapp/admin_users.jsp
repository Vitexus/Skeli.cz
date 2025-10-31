<%@ page import="java.sql.*" %>
<%@ include file="includes/header.jsp" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<main>
  <h2>Správa uživatelů</h2>
  <style>
    table { width:100%; border-collapse: collapse; }
    th, td { padding:8px 10px; border-bottom:1px solid var(--panel-border); text-align:left; }
    th { opacity:.85; }
    .act { display:flex; gap:8px; }
  </style>
  <%
    String role = (String) session.getAttribute("role");
    if (!"ADMIN".equals(role)) { out.println("<p>Pouze pro ADMIN.</p>"); } else {
      try (Connection conn = java.sql.DriverManager.getConnection("jdbc:mariadb://127.0.0.1:3306/skeliweb?useUnicode=true&characterEncoding=utf8mb4","Skeli","skeli");
           PreparedStatement ps = conn.prepareStatement("SELECT id, username, email, role, created_at FROM users ORDER BY created_at DESC");
           ResultSet rs = ps.executeQuery()) {
  %>
    <table>
      <tr><th>ID</th><th>Jméno</th><th>Email</th><th>Role</th><th>Vytvořen</th><th>Akce</th></tr>
      <%
        while (rs.next()) {
      %>
      <tr>
        <td><%= rs.getInt("id") %></td>
        <td><%= rs.getString("username") %></td>
        <td><%= rs.getString("email") %></td>
        <td><%= rs.getString("role") %></td>
        <td><%= rs.getTimestamp("created_at") %></td>
        <td class="act">
          <form method="post" action="/admin/users">
            <input type="hidden" name="user_id" value="<%= rs.getInt("id") %>">
            <input type="hidden" name="action" value="role">
            <select name="role">
              <option<%= "USER".equals(rs.getString("role"))?" selected":"" %>>USER</option>
              <option<%= "ADMIN".equals(rs.getString("role"))?" selected":"" %>>ADMIN</option>
            </select>
            <button type="submit">Uložit</button>
          </form>
          <form method="post" action="/admin/users" onsubmit="return confirm('Smazat uživatele?');">
            <input type="hidden" name="user_id" value="<%= rs.getInt("id") %>">
            <input type="hidden" name="action" value="delete">
            <button type="submit" style="background:#7b1e1e;color:#fff;border:none;padding:4px 8px;border-radius:6px;">Smazat</button>
          </form>
        </td>
      </tr>
      <%
        }
      %>
    </table>
  <%
      }
    }
  %>
</main>
<%@ include file="includes/footer.jsp" %>