<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/includes/header.jsp" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<style>
  .nav-top { margin-bottom: 20px; background: rgba(0,0,0,0.65); padding: 12px 16px; border-radius: 10px; box-shadow: 0 6px 18px rgba(0,0,0,0.10); overflow-x: auto; }
  .nav-top h3 { color: #fff; margin-top:0; font-size:1em; }
  .nav-top .song-list { display:flex; flex-wrap:wrap; gap: 10px 16px; list-style:none; padding:0; margin:0; }
  .nav-top .song-list li { margin: 0; }
  .nav-top .song-list a { color: #fff !important; font-weight: 600; text-decoration: none; transition: color .2s, text-shadow .2s; }
  .nav-top .song-list a:visited { color: #fff !important; }
  .nav-top .song-list a:hover { color: var(--accent) !important; text-shadow: 0 0 8px var(--accent); text-decoration: underline; }
  .nav-top .song-list a.active { color: var(--accent) !important; font-weight: bold; text-shadow: 0 0 8px var(--accent); }
  .nav-top .song-list li:not(:last-child)::after { content: " | "; color: rgba(255,255,255,0.5); margin: 0 6px; }
  body.light .nav-top { background: rgba(255,255,255,0.85); border-color:rgba(0,0,0,0.15); }
  body.light .nav-top h3 { color: #111; }
  body.light .nav-top .song-list a { color: #111 !important; }
  body.light .nav-top .song-list a:visited { color: #111 !important; }
  body.light .nav-top .song-list li:not(:last-child)::after { color: rgba(0,0,0,0.4); }
  .action-bar { display:flex; gap:10px; margin-top:12px; flex-wrap:wrap; justify-content:center; }
  .action-btn { padding:8px 14px; background:rgba(255,255,255,0.06); border:1px solid var(--panel-border); border-radius:8px; color:var(--text); text-decoration:none; font-size:0.9em; transition:all 0.2s ease; display:inline-flex; align-items:center; gap:6px; }
  .action-btn:hover { background:rgba(255,255,255,0.12); transform:translateY(-1px); color:var(--accent); }
  .action-btn i { font-size:1.1em; }
  body.light .action-btn { background:rgba(0,0,0,0.04); }
  body.light .action-btn:hover { background:rgba(0,0,0,0.08); }
</style>
<main class="avoid-footer">
  <h2 style="text-align:center;">${t.getProperty('menu.lyrics','Texty')}</h2>

  <div class="nav-top">
    <h3>Názvy písní</h3>
    <ul class="song-list">
      <c:forEach items="${songs}" var="s">
        <li>
          <a class="${(lyric != null && lyric.songId == s.id) ? 'active' : ''}"
             href="${pageContext.request.contextPath}/lyrics/${s.firstLyricId}">${s.name}</a>
        </li>
      </c:forEach>
    </ul>
  </div>

  <c:if test="${not empty lyric}">
    <section class="card accent lyric-layout">
      <div>
        <h3>${lyric.songName} <c:if test="${not empty lyric.year}">(${lyric.year})</c:if></h3>
        <c:if test="${not empty lyric.youtubeId}">
          <div style="background:var(--panel); border:1px solid var(--panel-border); border-radius:12px; padding:8px; box-shadow:0 6px 18px rgba(0,0,0,.20); position:relative; margin:10px auto 14px; width:50%; min-width:320px;">
            <div style="position:relative; padding-top:28.125%;">
              <iframe style="position:absolute; inset:0; width:100%; height:100%; border-radius:8px;" src="https://www.youtube.com/embed/${lyric.youtubeId}" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" allowfullscreen></iframe>
            </div>
          </div>
        </c:if>
        <div style="background:var(--panel); border:1px solid var(--panel-border); border-radius:12px; padding:14px; box-shadow:0 6px 18px rgba(0,0,0,.20);">
          <pre style="white-space: pre-wrap; font-family: 'Inter', system-ui, sans-serif; font-size: 1.05em; margin:0; text-align:center;"><c:out value="${lyric.words}"/></pre>
        </div>
        
        <div class="action-bar">
          <button class="action-btn" onclick="navigator.clipboard.writeText(window.location.href); alert('⚡ Odkaz zkopírován!')" title="Sdílet odkaz">
            <i class="fas fa-share-alt"></i> Sdílet
          </button>
          <a class="action-btn" href="https://open.spotify.com/search/${encodeURIComponent(lyric.songName)}" target="_blank" rel="noopener" title="Najít na Spotify">
            <i class="fab fa-spotify" style="color:#1DB954;"></i> Spotify
          </a>
          <c:if test="${not empty lyric.youtubeId}">
            <a class="action-btn" href="https://www.youtube.com/watch?v=${lyric.youtubeId}" target="_blank" rel="noopener" title="Otevřít na YouTube">
              <i class="fab fa-youtube" style="color:#FF0000;"></i> YouTube
            </a>
          </c:if>
        </div>
        
        <div class="views" style="font-size:0.9em; color:#555; margin-top:12px; text-align:center;">Návštěvy: ${lyric.views}</div>
      </div>
      <div class="comments">
        <h4>Komentáře</h4>
        <c:forEach items="${comments}" var="cmt">
          <div class="comment-item" style="display:flex; gap:10px; align-items:flex-start;">
            <img src="${empty cmt.avatarUrl ? '/img/avatar-default.png' : cmt.avatarUrl}" alt="avatar" style="width:36px; height:36px; border-radius:50%; object-fit:cover;"/>
            <div style="flex:1;">
              <strong><c:out value="${cmt.username}"/></strong>
              <span class="meta" style="font-size:0.9em;">(${cmt.createdAt})</span>
              <div><c:out value="${cmt.content}"/></div>
            </div>
          </div>
        </c:forEach>
      </div>
    </section>
  </c:if>
</main>
<%@ include file="/includes/footer.jsp" %>