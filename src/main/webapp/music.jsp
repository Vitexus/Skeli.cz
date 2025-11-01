<%@ page import="java.sql.*" %>
<%@ include file="includes/header.jsp" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<style>
.section { background: rgba(0,0,0,0.65); border: 1px solid var(--panel-border); border-radius: 12px; padding: 16px 18px; margin-bottom: 18px; box-shadow: 0 6px 18px rgba(0,0,0,0.25); transition: all 0.3s ease; }
  .section:hover { transform: translateY(-2px); box-shadow: 0 12px 32px rgba(0,0,0,0.45); }
  .section.spotify { background: linear-gradient(135deg, rgba(204,43,43,0.35), rgba(0,0,0,0.65)); border-color: rgba(204,43,43,0.5); }
  .section.youtube { background: linear-gradient(135deg, rgba(255,0,0,0.25), rgba(0,0,0,0.65)); border-color: rgba(255,0,0,0.4); }
.section-title { margin: 0 0 10px; display:flex; align-items:center; justify-content:center; gap: 8px; font-weight:700; color: var(--accent); }
.media-columns { display:block; }
  .section-title .ico { font-size: 1.2em; }
  body.light .section { background: rgba(255,255,255,0.85); border-color: rgba(0,0,0,0.15); }
  body.light .section.spotify { background: linear-gradient(135deg, rgba(204,43,43,0.15), rgba(255,255,255,0.85)); }
  body.light .section.youtube { background: linear-gradient(135deg, rgba(255,0,0,0.1), rgba(255,255,255,0.85)); }
</style>

<%
    String mysqlUrl = "jdbc:mysql://127.0.0.1:3306/skeliweb?useUnicode=true&characterEncoding=utf8mb4&useSSL=false&serverTimezone=UTC";
    String mariadbUrl = "jdbc:mariadb://127.0.0.1:3306/skeliweb?useUnicode=true&characterEncoding=utf8mb4";
    String user = "Skeli";
    String password = "skeli";
    boolean mariaLoaded = false;
    boolean mysqlLoaded = false;
try { Class.forName("org.mariadb.jdbc.Driver"); mariaLoaded = true; } catch (Throwable th) { /* ignore */ }
    try { Class.forName("com.mysql.cj.jdbc.Driver"); mysqlLoaded = true; } catch (Throwable th) { /* ignore */ }

    String sql = "SELECT v.youtube_id, COALESCE(v.title, s.name, v.youtube_id) AS title, s.year " +
                 "FROM videos v LEFT JOIN songs s ON s.id = v.song_id " +
                 "ORDER BY COALESCE(v.title, s.name, v.youtube_id) ASC";

    java.util.List<String> ids = new java.util.ArrayList<>();
    java.util.List<String> names = new java.util.ArrayList<>();
    java.util.List<String> years = new java.util.ArrayList<>();

    try (Connection conn = mariaLoaded ? java.sql.DriverManager.getConnection(mariadbUrl, user, password)
                                       : (mysqlLoaded ? java.sql.DriverManager.getConnection(mysqlUrl, user, password) : null)) {
        if (conn != null) {
            try (PreparedStatement ps = conn.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    ids.add(rs.getString(1));
                    names.add(rs.getString(2));
                    years.add(rs.getString(3));
                }
            }
        }
    } catch (SQLException e) {
        // fallback empty, handled below
    }
    if (ids.isEmpty()) {
        // show an info banner if DB unavailable; grid stays empty
        request.setAttribute("videoInfo", "Nelze načíst videa z DB. Zkuste to prosím později.");
    }
%>

<main>
  <h2 class="bruno-ace-sc-regular" style="text-align:center;"><%= ((java.util.Properties)request.getAttribute("t")).getProperty("menu.music","Music") %></h2>

  <div class="media-columns">
  <section class="section youtube">
    <h3 class="section-title"><span class="ico"><i class="fab fa-youtube" style="color:#FF0000"></i></span> <%= ((java.util.Properties)request.getAttribute("t")).getProperty("section.youtube","YouTube") %></h3>
    <jsp:include page="/elliptic" flush="true" />
  </section>
  </div>

</main>

<%@ include file="includes/footer.jsp" %>
