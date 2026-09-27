<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/includes/header.jsp" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<main class="lyric-page">
  <!-- Song switcher -->
  <nav class="lyric-switcher">
    <a class="lyric-back" href="/texty.jsp"><i class="fa-solid fa-arrow-left"></i> <%= t.getProperty("lyrics.back") %></a>
    <ul class="lyric-nav">
      <c:forEach items="${songs}" var="s">
        <li>
          <a href="${pageContext.request.contextPath}/lyrics/${s.firstLyricId}"
             class="${(lyric != null && lyric.songId == s.id) ? 'active' : ''}">
            <c:out value="${s.name}"/>
          </a>
        </li>
      </c:forEach>
    </ul>
  </nav>

  <c:if test="${not empty lyric}">
    <div class="lyric-grid">

      <!-- Song Title -->
      <header class="lyric-head">
        <h1 class="lyric-title"><c:out value="${lyric.songName}"/></h1>
        <c:if test="${not empty lyric.year}"><span class="song-year">${lyric.year}</span></c:if>
      </header>

      <!-- Video + listen links (sticky sidebar on desktop) -->
      <aside class="lyric-side">
        <c:if test="${not empty lyric.youtubeId}">
          <div class="content-box video-box">
            <div class="video-wrapper">
              <iframe src="https://www.youtube.com/embed/<c:out value='${lyric.youtubeId}'/>"
                      frameborder="0"
                      allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share"
                      allowfullscreen></iframe>
            </div>
          </div>
        </c:if>

        <div class="content-box lyric-links">
          <div class="action-buttons">
            <button type="button" class="action-btn" id="shareLyric" data-copied="<%= com.github.skeliit.WebUtils.escapeHtml(t.getProperty("lyric.linkCopied")) %>" title="<%= t.getProperty("lyric.shareLink") %>">
              <i class="fas fa-share-alt"></i> <span><%= t.getProperty("common.share") %></span>
            </button>
            <a class="action-btn" href="https://open.spotify.com/search/<c:out value='${lyric.songName}'/>" target="_blank" rel="noopener" title="<%= t.getProperty("lyric.findSpotify") %>">
              <i class="fab fa-spotify icon-spotify"></i> Spotify
            </a>
            <c:if test="${not empty lyric.youtubeId}">
              <a class="action-btn" href="https://www.youtube.com/watch?v=<c:out value='${lyric.youtubeId}'/>" target="_blank" rel="noopener" title="<%= t.getProperty("lyric.openYoutube") %>">
                <i class="fab fa-youtube icon-youtube"></i> YouTube
              </a>
            </c:if>
            <c:if test="${not empty lyric.appleMusicId}">
              <a class="action-btn" href="https://music.apple.com/song/<c:out value='${lyric.appleMusicId}'/>" target="_blank" rel="noopener" title="<%= t.getProperty("lyric.openApple") %>">
                <i class="fab fa-apple icon-apple"></i> Apple Music
              </a>
            </c:if>
          </div>
          <div class="views-count"><i class="fa-regular fa-eye"></i> <%= t.getProperty("lyric.views") %> ${lyric.views}</div>
        </div>
      </aside>

      <!-- Lyrics Text -->
      <article class="content-box lyric-body">
        <div class="lyrics-text">
          <pre><c:out value="${lyric.words}"/></pre>
        </div>
      </article>

      <!-- Votes & Comments Box -->
      <div class="content-box lyric-comments">
        <!-- Votes -->
        <div class="votes-section">
          <c:choose>
            <c:when test="${not empty sessionScope.username}">
              <form method="post" action="/vote" class="vote-form">
                <input type="hidden" name="lyric_id" value="${lyric.id}">
                <input type="hidden" name="action" value="up">
                <input type="hidden" name="csrf" value="${csrf}">
                <button type="submit" class="vote-btn up" title="<%= t.getProperty("vote.like") %>">👍</button>
              </form>
            </c:when>
            <c:otherwise>
              <a href="/login.jsp" class="vote-btn up" title="<%= t.getProperty("vote.loginToVote") %>">👍</a>
            </c:otherwise>
          </c:choose>
          
          <span class="vote-score">
            <strong class="up">${lyric.votesUp}</strong>
            <span class="sep">/</span>
            <strong class="down">${lyric.votesDown}</strong>
          </span>
          
          <c:choose>
            <c:when test="${not empty sessionScope.username}">
              <form method="post" action="/vote" class="vote-form">
                <input type="hidden" name="lyric_id" value="${lyric.id}">
                <input type="hidden" name="action" value="down">
                <input type="hidden" name="csrf" value="${csrf}">
                <button type="submit" class="vote-btn down" title="<%= t.getProperty("vote.dislike") %>">👎</button>
              </form>
            </c:when>
            <c:otherwise>
              <a href="/login.jsp" class="vote-btn down" title="<%= t.getProperty("vote.loginToVote") %>">👎</a>
            </c:otherwise>
          </c:choose>
        </div>
        
        <hr>
        
        <!-- Comments -->
        <h3 class="comments-title"><%= t.getProperty("comments.title") %></h3>
        
        <c:forEach items="${comments}" var="cmt">
          <div class="comment-item">
            <c:choose>
              <c:when test="${not empty cmt.avatarUrl}">
                <img src="<c:out value='${cmt.avatarUrl}'/>" alt="" class="comment-avatar"/>
              </c:when>
              <c:otherwise>
                <span class="comment-avatar comment-avatar-empty"><i class="fa-solid fa-user"></i></span>
              </c:otherwise>
            </c:choose>
            <div class="comment-content">
              <div class="comment-meta">
                <div>
                  <strong class="comment-username"><c:out value="${cmt.username}"/></strong>
                  <span class="comment-date">${cmt.createdAt}</span>
                </div>
                <c:if test="${not empty sessionScope.userId && (sessionScope.userId == cmt.userId || sessionScope.role == 'ADMIN')}">
                  <form method="post" action="/comment" class="vote-form">
                    <input type="hidden" name="comment_id" value="${cmt.id}">
                    <input type="hidden" name="action" value="delete">
                    <input type="hidden" name="lyric_id" value="${lyric.id}">
                    <input type="hidden" name="csrf" value="${csrf}">
                    <button type="submit" class="comment-delete"
                            onclick="return confirm('<%= com.github.skeliit.WebUtils.escapeJs(t.getProperty("comment.deleteConfirm")) %>')"
                            title="<%= t.getProperty("common.delete") %>" aria-label="<%= t.getProperty("common.delete") %>"><i class="fa-solid fa-trash-can"></i></button>
                  </form>
                </c:if>
              </div>
              <div class="comment-text"><c:out value="${cmt.content}"/></div>
            </div>
          </div>
        </c:forEach>
        
        <c:if test="${not empty sessionScope.username}">
          <form method="post" action="/comment" class="comment-form">
            <input type="hidden" name="lyric_id" value="${lyric.id}">
            <input type="hidden" name="csrf" value="${csrf}">
            <textarea name="content" 
                      placeholder="<%= t.getProperty("comment.placeholder") %>"
                      required ></textarea>
            <button type="submit"><%= t.getProperty("comment.add") %></button>
          </form>
        </c:if>
        <c:if test="${empty sessionScope.username}">
          <p class="comment-login">
            <a href="/login.jsp"><%= t.getProperty("comment.login.link") %></a><%= t.getProperty("comment.login.toComment") %>
          </p>
        </c:if>
      </div>
      
    </div>
  </c:if>
  <script>
    // Song chips row: fade the edges that have hidden songs, let the mouse wheel
    // scroll it sideways, and start with the current song in the middle
    (function () {
      const nav = document.querySelector('.lyric-nav');
      if (!nav) return;
      function updateFades() {
        const max = nav.scrollWidth - nav.clientWidth;
        nav.classList.toggle('fade-left', nav.scrollLeft > 2);
        nav.classList.toggle('fade-right', nav.scrollLeft < max - 2);
      }
      nav.addEventListener('scroll', updateFades, { passive: true });
      // chip widths change once the web font arrives or the window resizes
      if (window.ResizeObserver) new ResizeObserver(updateFades).observe(nav);
      else window.addEventListener('resize', updateFades);
      nav.addEventListener('wheel', function (e) {
        if (Math.abs(e.deltaY) <= Math.abs(e.deltaX)) return;
        const before = nav.scrollLeft;
        nav.scrollLeft += e.deltaY;
        // at either end, let the page scroll normally
        if (nav.scrollLeft !== before) e.preventDefault();
      }, { passive: false });
      function centerActive() {
        const active = nav.querySelector('a.active');
        if (active) {
          const li = active.parentElement;
          nav.scrollLeft = li.offsetLeft - (nav.clientWidth - li.offsetWidth) / 2;
        }
        updateFades();
      }
      centerActive();
      // measure again with the real font (Bruno Ace is wider than the fallback)
      if (document.fonts && document.fonts.ready) document.fonts.ready.then(centerActive);
    })();

    (function () {
      const btn = document.getElementById('shareLyric');
      if (!btn) return;
      btn.addEventListener('click', function () {
        const url = location.href;
        if (navigator.share) { navigator.share({ title: document.title, url }).catch(() => {}); return; }
        navigator.clipboard.writeText(url).then(() => {
          const label = btn.querySelector('span'); const old = label.textContent;
          label.textContent = btn.dataset.copied; setTimeout(() => label.textContent = old, 1500);
        });
      });
    })();
  </script>
</main>
<%@ include file="/includes/footer.jsp" %>