<%@ page import="java.sql.*" %>
<%@ include file="includes/header.jsp" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<main>
    <h2 class="bruno-ace-sc-regular" style="text-align:center;"><%= ((java.util.Properties)request.getAttribute("t")).getProperty("menu.lyrics","Lyrics") %></h2>
    <style>
      .texts-card { background: rgba(0,0,0,0.65); border:1px solid var(--panel-border); border-radius:12px; padding:20px; margin-top:12px; box-shadow: 0 6px 18px rgba(0,0,0,0.25); }
      .texts-list { list-style:none; padding:0; margin:0; display:block; }
      .texts-list li { margin:12px 0; text-align:center; padding:8px; background: rgba(255,255,255,0.04); border-radius:8px; border:1px solid rgba(255,255,255,0.08); transition: all 0.2s ease; }
      .texts-list li:hover { background: rgba(255,255,255,0.08); border-color: rgba(255,255,255,0.15); }
      .texts-list a { font-weight: 600; text-decoration: none; transition: color .15s ease, text-shadow .15s ease; color: var(--text); }
      .texts-list a:visited { color: var(--text); }
      .texts-list a:hover, .texts-list a:focus { color: var(--accent); text-shadow: 0 0 8px var(--accent); text-decoration: underline; outline: none; }
      body.light .texts-card { background: rgba(255,255,255,0.85); border-color: rgba(0,0,0,0.15); }
      body.light .texts-list li { background: rgba(0,0,0,0.03); border-color: rgba(0,0,0,0.1); }
      body.light .texts-list li:hover { background: rgba(0,0,0,0.06); border-color: rgba(0,0,0,0.15); }
    </style>
    <div class="texts-card">
      <ul class="texts-list">
        <%
            String mysqlUrl = "jdbc:mysql://127.0.0.1:3306/skeliweb?useUnicode=true&characterEncoding=utf8mb4&useSSL=false&serverTimezone=UTC";
            String mariadbUrl = "jdbc:mariadb://127.0.0.1:3306/skeliweb?useUnicode=true&characterEncoding=utf8mb4";
            String user = "Skeli";
            String password = "skeli";
            boolean hadRows = false;
            try {
                boolean mariaLoaded = false;
                boolean mysqlLoaded = false;
try { Class.forName("org.mariadb.jdbc.Driver"); mariaLoaded = true; } catch (Throwable ex1) { out.println("<!-- MariaDB driver not found: " + ex1.getMessage() + " -->"); }
                try { Class.forName("com.mysql.cj.jdbc.Driver"); mysqlLoaded = true; } catch (Throwable ex2) { out.println("<!-- MySQL driver not found: " + ex2.getMessage() + " -->"); }

                SQLException connError = null;
                if (mariaLoaded) {
                    try (Connection conn = DriverManager.getConnection(mariadbUrl, user, password);
                         PreparedStatement ps = conn.prepareStatement(
                             "SELECT s.id AS song_id, s.name AS song_name, s.year AS song_year, MIN(l.id) AS lyric_id " +
                             "FROM lyrics l JOIN songs s ON s.id = l.song_id " +
                             "GROUP BY s.id, s.name, s.year " +
                             "ORDER BY s.year DESC, s.name ASC"
                         );
                         ResultSet rs = ps.executeQuery()) {
                        while (rs.next()) {
                            hadRows = true;
                            String name = rs.getString("song_name");
                            if (name != null) name = name.replaceFirst("(?i)^\\s*skeli\\s*-\\s*","" );
                            Object yearObj = rs.getObject("song_year");
                            Integer y = null;
                            if (yearObj != null) {
                                if (yearObj instanceof java.sql.Date) {
                                    y = ((java.sql.Date) yearObj).toLocalDate().getYear();
                                } else if (yearObj instanceof Number) {
                                    y = ((Number) yearObj).intValue();
                                } else {
                                    y = Integer.parseInt(yearObj.toString());
                                }
                            }
                            int lyricId = rs.getInt("lyric_id");
                            if (rs.wasNull() || lyricId <= 0) continue;
        %>
                            <li><a href="/lyrics/<%= lyricId %>"><%= name %></a><% if (y != null) { %> (<%= y %>)<% } %></li>
        <%
                        }
                    } catch (SQLException e1) {
                        connError = e1;
                    }
                }
                if (!hadRows && mysqlLoaded) {
                    try (Connection conn = DriverManager.getConnection(mysqlUrl, user, password);
                         PreparedStatement ps = conn.prepareStatement(
                             "SELECT s.id AS song_id, s.name AS song_name, s.year AS song_year, MIN(l.id) AS lyric_id " +
                             "FROM lyrics l JOIN songs s ON s.id = l.song_id " +
                             "GROUP BY s.id, s.name, s.year " +
                             "ORDER BY s.year DESC, s.name ASC"
                         );
                         ResultSet rs = ps.executeQuery()) {
                        while (rs.next()) {
                            hadRows = true;
                            String name = rs.getString("song_name");
                            if (name != null) name = name.replaceFirst("(?i)^\\s*skeli\\s*-\\s*","" );
                            Object yearObj = rs.getObject("song_year");
                            Integer y = null;
                            if (yearObj != null) {
                                if (yearObj instanceof java.sql.Date) {
                                    y = ((java.sql.Date) yearObj).toLocalDate().getYear();
                                } else if (yearObj instanceof Number) {
                                    y = ((Number) yearObj).intValue();
                                } else {
                                    y = Integer.parseInt(yearObj.toString());
                                }
                            }
                            int lyricId = rs.getInt("lyric_id");
                            if (rs.wasNull() || lyricId <= 0) continue;
        %>
                            <li><a href="/lyrics/<%= lyricId %>"><%= name %></a><% if (y != null) { %> (<%= y %>)<% } %></li>
        <%
                        }
                    } catch (SQLException e2) {
                        if (connError == null) connError = e2;
                    }
                }

                if (!hadRows) {
                    if (!mariaLoaded && !mysqlLoaded) {
                        out.println("<li>JDBC driver není na classpath (MariaDB/MySQL).</li>");
                    } else if (connError != null) {
                        out.println("<li>Chyba připojení: " + connError.getMessage() + "</li>");
                    } else {
                        out.println("<li>Žádné texty nenalezeny.</li>");
                    }
                }
            } catch (Exception e) {
                out.println("<li>Chyba při načítání textů: " + e.getMessage() + "</li>");
            }
        %>
      </ul>
    </div>
</main>

<%@ include file="includes/footer.jsp" %>