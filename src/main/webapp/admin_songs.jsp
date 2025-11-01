<%@ include file="includes/header.jsp" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<main>
  <style>
  .songs-table {
      width: 100%;
      border-collapse: collapse;
      margin: 20px 0;
  }
  .songs-table th, .songs-table td {
      border: 1px solid var(--panel-border);
      padding: 10px;
      text-align: left;
  }
  .songs-table th { background: rgba(0,0,0,0.3); font-weight: bold; }
  body.light .songs-table th { background: rgba(0,0,0,0.06); }
  .songs-table tr:hover { background: rgba(255,255,255,0.05); }
  body.light .songs-table tr:hover { background: rgba(0,0,0,0.04); }
  .indicator { display:inline-block; padding:2px 8px; border-radius:3px; margin:0 2px; font-size:0.9em; }
  .indicator.yes { background: rgba(0,255,0,0.18); color:#0f0; }
  .indicator.no { background: rgba(255,0,0,0.18); color:#f66; }
  .lang-flag { display:inline-block; padding:2px 6px; margin:0 2px; background: rgba(255,255,255,0.1); border-radius:3px; font-size:0.8em; text-transform:uppercase; }
  body.light .lang-flag { background: rgba(0,0,0,0.06); }
  .link-btn { color: var(--accent); text-decoration:none; padding:4px 8px; border:1px solid var(--accent); border-radius:3px; margin:0 4px; font-size:0.85em; display:inline-block; }
  .link-btn:hover { background: var(--accent); color:#000; }
  </style>
  <h2>Přehled písní</h2>
  <p><a href="/admin.jsp">← Zpět na admin</a></p>

  <table class="songs-table">
    <thead>
      <tr>
        <th>ID</th>
        <th>Název</th>
        <th>Rok</th>
        <th>Video</th>
        <th>Text</th>
        <th>Jazyky</th>
        <th>Akce</th>
      </tr>
    </thead>
    <tbody>
      <c:forEach var="song" items="${songs}">
        <tr>
          <td>${song.id}</td>
          <td>${song.name}</td>
          <td>${song.year != null ? song.year : '-'}</td>
          <td>
            <c:choose>
              <c:when test="${song.hasVideo}">
                <span class="indicator yes">✓</span>
              </c:when>
              <c:otherwise>
                <span class="indicator no">✗</span>
              </c:otherwise>
            </c:choose>
          </td>
          <td>
            <c:choose>
              <c:when test="${song.hasLyrics}">
                <span class="indicator yes">✓</span>
              </c:when>
              <c:otherwise>
                <span class="indicator no">✗</span>
              </c:otherwise>
            </c:choose>
          </td>
          <td>
            <c:if test="${song.hasLyrics}">
              <c:forEach var="lang" items="${song.languages}">
                <span class="lang-flag">${lang}</span>
              </c:forEach>
            </c:if>
          </td>
          <td>
            <c:if test="${song.hasVideo}">
              <a href="/music.jsp" class="link-btn" target="_blank">Video</a>
            </c:if>
            <c:if test="${song.hasLyrics}">
              <a href="/lyrics/${song.id}" class="link-btn" target="_blank">Text</a>
            </c:if>
          </td>
        </tr>
      </c:forEach>
    </tbody>
  </table>
</main>

<%@ include file="includes/footer.jsp" %>
