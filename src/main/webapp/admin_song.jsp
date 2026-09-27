<%@ include file="includes/header.jsp" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<main class="admin-song-page">
  <p class="admin-crumb">
    <a href="/admin.jsp">Admin</a> ·
    <a href="/admin/songs">Písně</a> ·
    <strong><c:out value="${song.name}"/></strong>
  </p>

  <c:if test="${not empty param.msg}">
    <p class="admin-flash">
      <c:choose>
        <c:when test="${param.msg == 'saved'}">Uloženo.</c:when>
        <c:when test="${param.msg == 'video_linked'}">YouTube video napojeno.</c:when>
        <c:when test="${param.msg == 'video_unlinked'}">YouTube video odpojeno.</c:when>
        <c:when test="${param.msg == 'preview_saved'}">Náhledový obrázek uložen.</c:when>
        <c:when test="${param.msg == 'preview_deleted'}">Náhledový obrázek smazán.</c:when>
        <c:when test="${param.msg == 'bad_youtube'}">Neplatné YouTube ID / URL.</c:when>
        <c:when test="${param.msg == 'bad_name'}">Název písně je povinný.</c:when>
        <c:when test="${param.msg == 'no_file'}">Nebyl vybrán žádný soubor.</c:when>
        <c:when test="${param.msg == 'too_large'}">Soubor je příliš velký (max 5&nbsp;MB).</c:when>
        <c:when test="${param.msg == 'invalid_image'}">Neplatný obrázek.</c:when>
        <c:otherwise><c:out value="${param.msg}"/></c:otherwise>
      </c:choose>
    </p>
  </c:if>

  <header class="song-hub-head">
    <c:choose>
      <c:when test="${not empty song.previewImageUrl}">
        <img class="song-hub-cover" src="<c:out value='${song.previewImageUrl}'/>" alt="">
      </c:when>
      <c:otherwise>
        <div class="song-hub-cover song-hub-cover-empty"><i class="fa-solid fa-music"></i></div>
      </c:otherwise>
    </c:choose>
    <div>
      <h2><c:out value="${song.name}"/></h2>
      <p class="text-dim">
        ID ${song.id}
        <c:if test="${not empty song.year}"> · ${song.year}</c:if>
        <c:if test="${not empty song.firstLyricId}">
          · <a href="/lyrics/${song.firstLyricId}" target="_blank" rel="noopener">veřejná stránka textu ↗</a>
        </c:if>
      </p>
    </div>
  </header>

  <div class="admin-grid song-hub-grid">

    <!-- Základní údaje -->
    <section class="admin-card">
      <h3>Píseň</h3>
      <form method="post" action="/admin/song" class="admin-form">
        <input type="hidden" name="csrf" value="${csrf}">
        <input type="hidden" name="id" value="${song.id}">
        <input type="hidden" name="action" value="save">
        <label>Název
          <input name="name" value="<c:out value='${song.name}'/>" required>
        </label>
        <label>Rok
          <input name="year" type="number" min="1900" max="2100" value="${song.year != null ? song.year : ''}">
        </label>
        <button type="submit">Uložit</button>
      </form>
    </section>

    <!-- Náhled / OG -->
    <section class="admin-card">
      <h3>Náhledový obrázek (Open Graph)</h3>
      <p class="text-dim">Použije se při sdílení odkazu a jako placeholder před YouTube.</p>
      <c:if test="${not empty song.previewImageUrl}">
        <img class="song-preview-thumb song-preview-thumb-lg" src="<c:out value='${song.previewImageUrl}'/>" alt="">
      </c:if>
      <form method="post" action="/admin/songs/preview" enctype="multipart/form-data" class="song-preview-form">
        <input type="hidden" name="csrf" value="${csrf}">
        <input type="hidden" name="song_id" value="${song.id}">
        <input type="hidden" name="redirect" value="/admin/song?id=${song.id}">
        <label class="song-preview-upload">
          <input type="file" name="preview" accept="image/jpeg,image/png,image/webp" required>
          <span>Vybrat soubor</span>
        </label>
        <button type="submit">Nahrát</button>
      </form>
      <c:if test="${not empty song.previewImageUrl}">
        <form method="post" action="/admin/songs/preview" class="song-preview-form">
          <input type="hidden" name="csrf" value="${csrf}">
          <input type="hidden" name="song_id" value="${song.id}">
          <input type="hidden" name="action" value="delete">
          <input type="hidden" name="redirect" value="/admin/song?id=${song.id}">
          <button type="submit" class="btn-delete" onclick="return confirm('Smazat náhled?')">Smazat náhled</button>
        </form>
      </c:if>
    </section>

    <!-- Streaming IDs -->
    <section class="admin-card">
      <h3>Streaming</h3>
      <form method="post" action="/admin/song" class="admin-form">
        <input type="hidden" name="csrf" value="${csrf}">
        <input type="hidden" name="id" value="${song.id}">
        <input type="hidden" name="action" value="save">
        <input type="hidden" name="name" value="<c:out value='${song.name}'/>">
        <input type="hidden" name="year" value="${song.year != null ? song.year : ''}">
        <label>Apple Music ID
          <input name="apple_music_id" value="<c:out value='${song.appleMusicId}'/>" placeholder="např. 1234567890">
        </label>
        <c:if test="${not empty song.appleMusicId}">
          <p><a href="https://music.apple.com/song/<c:out value='${song.appleMusicId}'/>" target="_blank" rel="noopener">Otevřít v Apple Music ↗</a></p>
        </c:if>
        <label>Spotify track ID
          <input name="spotify_id" value="<c:out value='${song.spotifyId}'/>" placeholder="např. 4iV5W9uYEdYUVa79Axb7Rh">
        </label>
        <c:if test="${not empty song.spotifyId}">
          <p><a href="https://open.spotify.com/track/<c:out value='${song.spotifyId}'/>" target="_blank" rel="noopener">Otevřít ve Spotify ↗</a></p>
        </c:if>
        <button type="submit">Uložit streaming ID</button>
      </form>
    </section>

    <!-- Lyrics -->
    <section class="admin-card">
      <h3>Texty</h3>
      <c:choose>
        <c:when test="${empty lyricLangs}">
          <p class="text-dim">Zatím žádný text.</p>
        </c:when>
        <c:otherwise>
          <p>
            Jazyky:
            <c:forEach var="lang" items="${lyricLangs}">
              <span class="lang-flag">${lang}</span>
            </c:forEach>
          </p>
          <c:if test="${not empty song.firstLyricId}">
            <a class="link-btn" href="/lyrics/${song.firstLyricId}" target="_blank">Zobrazit text</a>
          </c:if>
        </c:otherwise>
      </c:choose>
    </section>

    <!-- YouTube -->
    <section class="admin-card admin-card-wide">
      <h3><i class="fab fa-youtube icon-youtube"></i> YouTube videa</h3>
      <c:choose>
        <c:when test="${empty videos}">
          <p class="text-dim">Žádné napojené video.</p>
        </c:when>
        <c:otherwise>
          <table class="admin-table">
            <thead>
              <tr><th></th><th>Název</th><th>YouTube ID</th><th></th></tr>
            </thead>
            <tbody>
              <c:forEach var="v" items="${videos}">
                <tr>
                  <td>
                    <img class="song-preview-thumb" src="https://img.youtube.com/vi/<c:out value='${v.youtubeId}'/>/mqdefault.jpg" alt="">
                  </td>
                  <td><c:out value="${v.title}"/></td>
                  <td>
                    <a href="https://www.youtube.com/watch?v=<c:out value='${v.youtubeId}'/>" target="_blank" rel="noopener">
                      <c:out value="${v.youtubeId}"/>
                    </a>
                  </td>
                  <td>
                    <form method="post" action="/admin/song" style="display:inline">
                      <input type="hidden" name="csrf" value="${csrf}">
                      <input type="hidden" name="id" value="${song.id}">
                      <input type="hidden" name="action" value="unlink_video">
                      <input type="hidden" name="youtube_id" value="<c:out value='${v.youtubeId}'/>">
                      <button type="submit" class="btn-delete" onclick="return confirm('Odpojit video od této písně?')">Odpojit</button>
                    </form>
                  </td>
                </tr>
              </c:forEach>
            </tbody>
          </table>
        </c:otherwise>
      </c:choose>

      <h4>Napojit video</h4>
      <form method="post" action="/admin/song" class="admin-form admin-form-row">
        <input type="hidden" name="csrf" value="${csrf}">
        <input type="hidden" name="id" value="${song.id}">
        <input type="hidden" name="action" value="link_video">
        <label>YouTube ID nebo URL
          <input name="youtube_id" required placeholder="dQw4w9WgXcQ nebo https://youtu.be/...">
        </label>
        <label>Název (volitelné)
          <input name="title" placeholder="ponechá stávající / ID">
        </label>
        <button type="submit">Napojit</button>
      </form>
    </section>
  </div>
</main>

<%@ include file="includes/footer.jsp" %>
