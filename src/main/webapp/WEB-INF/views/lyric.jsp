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
  .card { background: linear-gradient(180deg, rgba(255,255,255,0.50), rgba(255,255,255,0.40)); border: 1px solid rgba(0,0,0,0.08); border-radius: 12px; box-shadow: 0 10px 30px rgba(0,0,0,0.12); padding: 16px 20px; backdrop-filter: blur(4px); }
  .card h3 { margin-top: 0; padding-bottom: 8px; border-bottom: 1px solid rgba(0,0,0,0.06); }
  .card pre { background: transparent; margin: 0 auto; max-width: 60ch; white-space: pre-wrap; overflow-wrap: anywhere; word-break: break-word; text-align:center; font-weight: var(--fw); }
  @media (min-width: 1100px){ .lyric-layout { display:grid; grid-template-columns: 1fr 1fr; gap:24px; align-items:start; } }
  .accent { border-left: 4px solid #ffd700; padding-left: 16px; }
  .comments { margin-top:14px; background: rgba(0,0,0,0.70); color: var(--text); border: 1px solid var(--panel-border); border-radius: 12px; padding: 14px 16px; box-shadow: 0 8px 24px rgba(0,0,0,.35); }
  .comments h4 { margin: 0 0 10px; color: #fff; }
  .comments .comment-item { background: rgba(255,255,255,0.06); border:1px solid rgba(255,255,255,0.12); border-radius:10px; padding:10px; margin:8px 0; }
  .comments .comment-item strong { color:#fff; }
  .comments .comment-item .meta { color: rgba(255,255,255,0.75); }
  body.light .comments { background: #ffffff; color:#111; border-color: rgba(0,0,0,0.12); }
  body.light .comments h4 { color:#111; }
  body.light .comments .comment-item { background: rgba(0,0,0,0.03); border-color: rgba(0,0,0,0.12); }
  .votes { display:flex; align-items:center; gap:10px; margin-top:12px; }
  .btn-vote { width:40px; height:40px; border-radius:9999px; border:1px solid var(--panel-border); display:inline-flex; align-items:center; justify-content:center; cursor:pointer; font-size:16px; backdrop-filter: blur(2px); transition: transform .12s ease, background-color .2s ease, box-shadow .2s ease; background: rgba(255,255,255,0.06); color:#fff; box-shadow: 0 6px 18px rgba(0,0,0,.25); }
  .btn-vote:hover { background: rgba(255,255,255,0.12); transform: translateY(-1px); }
  .btn-vote.up { border-color: rgba(0,255,170,0.35); }
  .btn-vote.down { border-color: rgba(255,80,80,0.35); }
  .btn-vote.up:hover { box-shadow: 0 8px 22px rgba(0,255,170,.25); }
  .btn-vote.down:hover { box-shadow: 0 8px 22px rgba(255,80,80,.25); }
  body.light .btn-vote { background: rgba(0,0,0,0.06); color:#111; box-shadow: 0 6px 18px rgba(0,0,0,.12); }
  body.light .btn-vote:hover { background: rgba(0,0,0,0.12); }
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
          <a class="action-btn" href="https://open.spotify.com/search/<c:out value='${lyric.songName}'/>" target="_blank" rel="noopener" title="Najít na Spotify">
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
      
      <div>
        <div class="votes">
          <form method="post" action="/vote" style="display:inline;">
            <input type="hidden" name="lyric_id" value="${lyric.id}">
            <input type="hidden" name="action" value="up">
            <button type="submit" class="btn-vote up" title="Líbí se mi">
              <i class="fa-solid fa-thumbs-up"></i>
            </button>
          </form>
          <form method="post" action="/vote" style="display:inline;">
            <input type="hidden" name="lyric_id" value="${lyric.id}">
            <input type="hidden" name="action" value="down">
            <button type="submit" class="btn-vote down" title="Nelíbí se mi">
              <i class="fa-solid fa-thumbs-down"></i>
            </button>
          </form>
          <span style="margin-left:6px; white-space:nowrap;">
            <strong>${lyric.votesUp}</strong> / <strong>${lyric.votesDown}</strong>
          </span>
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
          
          <c:if test="${not empty sessionScope.username}">
            <form method="post" action="/comment" style="margin-top:14px;">
              <input type="hidden" name="lyric_id" value="${lyric.id}">
              <input type="hidden" name="csrf" value="${csrf}">
              <textarea name="content" placeholder="Napiš komentář..." required style="width:100%; min-height:80px; box-sizing:border-box; margin-bottom:8px;"></textarea>
              <button type="submit" style="background:var(--accent); color:#000; border:none; padding:8px 16px; border-radius:8px; cursor:pointer; font-weight:600;">Přidat komentář</button>
            </form>
          </c:if>
          <c:if test="${empty sessionScope.username}">
            <p style="margin-top:14px; text-align:center; opacity:0.7;"><a href="/login.jsp" style="color:var(--accent);">Přihlaš se</a> pro přidání komentáře</p>
          </c:if>
        </div>
      </div>
    </section>
  </c:if>
</main>
<%@ include file="/includes/footer.jsp" %>