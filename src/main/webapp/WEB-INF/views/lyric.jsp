<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/includes/header.jsp" %>
<%@ taglib prefix="c" uri="https://jakarta.ee/jsp/jstl/core" %>
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
          <pre style="white-space: pre-wrap; font-family: 'Inter', system-ui, sans-serif; font-size: 1.05em; margin:0;"><c:out value="${lyric.words}"/></pre>
        </div>
        <div class="views" style="font-size:0.9em; color:#555; margin-top:8px;">Návštěvy: ${lyric.views}</div>
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