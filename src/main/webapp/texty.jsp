<%@ page import="java.sql.*" %>
<%@ include file="includes/header.jsp" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<main>
    <h2 class="bruno-ace-sc-regular" style="text-align:center;"><%= ((java.util.Properties)request.getAttribute("t")).getProperty("menu.lyrics","Lyrics") %></h2>
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
                             "SELECT s.id AS song_id, s.name AS song_name, s.year AS song_year, MIN(l.id) AS lyric_id, " +
                             "(SELECT v.youtube_id FROM videos v WHERE v.song_id = s.id LIMIT 1) AS youtube_id " +
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
                            String youtubeId = rs.getString("youtube_id");
                            String dataAttr = "";
                            if (youtubeId != null && !youtubeId.isEmpty()) {
                                dataAttr = " data-thumb=\"https://img.youtube.com/vi/" + youtubeId + "/mqdefault.jpg\"";
                            }
        %>
                            <li<%= dataAttr %>><a href="/lyrics/<%= lyricId %>"><%= name %></a><% if (y != null) { %> (<%= y %>)<% } %></li>
        <%
                        }
                    } catch (SQLException e1) {
                        connError = e1;
                    }
                }
                if (!hadRows && mysqlLoaded) {
                    try (Connection conn = DriverManager.getConnection(mysqlUrl, user, password);
                         PreparedStatement ps = conn.prepareStatement(
                             "SELECT s.id AS song_id, s.name AS song_name, s.year AS song_year, MIN(l.id) AS lyric_id, " +
                             "(SELECT v.youtube_id FROM videos v WHERE v.song_id = s.id LIMIT 1) AS youtube_id " +
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
                            String youtubeId = rs.getString("youtube_id");
                            String dataAttr = "";
                            if (youtubeId != null && !youtubeId.isEmpty()) {
                                dataAttr = " data-thumb=\"https://img.youtube.com/vi/" + youtubeId + "/mqdefault.jpg\"";
                            }
        %>
                            <li<%= dataAttr %>><a href="/lyrics/<%= lyricId %>"><%= name %></a><% if (y != null) { %> (<%= y %>)<% } %></li>
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
    <script>
      // Apply YouTube thumbnails to list items
      document.querySelectorAll('.texts-list li[data-thumb]').forEach(li => {
        const thumb = li.getAttribute('data-thumb');
        if(thumb) {
          li.style.setProperty('--thumb-bg', `url("${thumb}")`);
          const style = document.createElement('style');
          const id = 'thumb-' + Math.random().toString(36).substr(2, 9);
          li.classList.add(id);
          style.textContent = `.${id}::before { background-image: url("${thumb}") !important; }`;
          document.head.appendChild(style);
        }
      });
    </script>
</main>

<%@ include file="includes/footer.jsp" %>
