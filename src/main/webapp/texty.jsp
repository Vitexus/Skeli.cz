<%@ page import="java.sql.*" %>
<%@ include file="includes/header.jsp" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<main>
    <h2 style="text-align:center;">Texty</h2>
    <style>
      /* Vrať původní vzhled navigace; zvýrazni seznam textů */
      .texts-card { background: rgba(255,255,255,0.55); border:1px solid var(--panel-border); border-radius:12px; padding:16px; margin-top:12px; box-shadow: 0 6px 18px rgba(0,0,0,0.15); }
      .texts-list { list-style:none; padding:0; margin:0; display:block; }
.texts-list li { margin:8px 0; text-align:center; }
      .texts-list a { font-weight: var(--fw); }
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
                             "SELECT s.name AS song_name, s.year AS song_year, MIN(l.id) AS lyric_id " +
                             "FROM lyrics l LEFT JOIN songs s ON s.id = l.song_id " +
                             "GROUP BY s.name, s.year " +
                             "ORDER BY s.name ASC"
                         );
                         ResultSet rs = ps.executeQuery()) {
                        while (rs.next()) {
                            hadRows = true;
                            String name = rs.getString("song_name");
                            int lyricId = rs.getInt("lyric_id");
        %>
                            <li><a href="lyric.jsp?id=<%= lyricId %>"><%= name %></a></li>
        <%
                        }
                    } catch (SQLException e1) {
                        connError = e1;
                    }
                }
                if (!hadRows && mysqlLoaded) {
                    try (Connection conn = DriverManager.getConnection(mysqlUrl, user, password);
                         PreparedStatement ps = conn.prepareStatement(
                             "SELECT s.name AS song_name, s.year AS song_year, MIN(l.id) AS lyric_id " +
                             "FROM lyrics l LEFT JOIN songs s ON s.id = l.song_id " +
                             "GROUP BY s.name, s.year " +
                             "ORDER BY s.name ASC"
                         );
                         ResultSet rs = ps.executeQuery()) {
                        while (rs.next()) {
                            hadRows = true;
                            String name = rs.getString("song_name");
                            int lyricId = rs.getInt("lyric_id");
        %>
                            <li><a href="lyric.jsp?id=<%= lyricId %>"><%= name %></a></li>
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