<%@ page import="java.sql.*" %>
<%@ include file="includes/header.jsp" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<main>
    <h2 style="text-align:center;">Texty</h2>
    <style>
      .texts-list { list-style:none; padding:0; margin:0; display:block; }
      .texts-list li { margin:6px 0; text-align:center; }
    </style>
    <ul class="texts-list">
        <%
            String mysqlUrl = "jdbc:mysql://localhost:3306/skeliweb?useUnicode=true&characterEncoding=utf8mb4&useSSL=false&serverTimezone=UTC";
            String mariadbUrl = "jdbc:mariadb://localhost:3306/skeliweb?useUnicode=true&characterEncoding=utf8mb4";
            String user = "Skeli";
            String password = "skeli";
            boolean hadRows = false;
            try {
                boolean mariaLoaded = false;
                boolean mysqlLoaded = false;
                try { Class.forName("org.mariadb.jdbc.Driver"); mariaLoaded = true; } catch (Throwable t) { out.println("<!-- MariaDB driver not found: " + t.getMessage() + " -->"); }
                try { Class.forName("com.mysql.cj.jdbc.Driver"); mysqlLoaded = true; } catch (Throwable t) { out.println("<!-- MySQL driver not found: " + t.getMessage() + " -->"); }

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
                            <li><a href="/lyrics/<%= lyricId %>-<%= name.toLowerCase().replaceAll("[^a-z0-9]+","-").replaceAll("^-|-$","") %>"><%= name %></a></li>
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
                            <li><a href="/lyrics/<%= lyricId %>-<%= name.toLowerCase().replaceAll("[^a-z0-9]+","-").replaceAll("^-|-$","") %>"><%= name %></a></li>
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
</main>

<%@ include file="includes/footer.jsp" %>