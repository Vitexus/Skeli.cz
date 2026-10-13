<%@ include file="/includes/header.jsp" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%-- "Co říkáš na web?": every rating; a heart puts the message on the home page (web/admin/AdminFeedbackServlet) --%>
<main class="admin-page admin-feedback-page">
  <%@ include file="/includes/admin-nav.jspf" %>
  <h2 class="admin-page-title">Co říkáš na web?</h2>
  <p class="text-dim">Hodnocení webu od přihlášených návštěvníků. Vzkaz se na úvodní stránce ukáže, až mu dáš srdíčko (ukazují se 3 nejnovější se srdíčkem). Když člověk vzkaz změní, srdíčko se mu sebere, ať ho zase vidíš.</p>
  <p class="fb-admin-counts"><span><i class="fa-solid fa-thumbs-up" aria-hidden="true"></i> ${up}</span> <span><i class="fa-solid fa-thumbs-down" aria-hidden="true"></i> ${down}</span></p>

  <c:if test="${empty items}"><p class="text-dim">Zatím nikdo nehodnotil.</p></c:if>
  <c:forEach var="f" items="${items}">
    <section class="admin-card fb-admin-item${f.hearted ? ' is-hearted' : ''}" id="f${f.id}">
      <div class="fb-admin-head">
        <span class="fb-admin-vote ${f.up ? 'up' : 'down'}"><i class="fa-solid ${f.up ? 'fa-thumbs-up' : 'fa-thumbs-down'}" aria-hidden="true"></i></span>
        <strong><c:out value="${f.username}"/></strong>
        <span class="text-dim"><%= com.github.skeliit.WebUtils.formatDateTime(((com.github.skeliit.model.SiteFeedback) pageContext.getAttribute("f")).at, cur) %></span>
        <c:if test="${f.hearted}"><span class="fb-admin-badge"><i class="fa-solid fa-heart" aria-hidden="true"></i> na úvodu</span></c:if>
      </div>
      <c:choose>
        <c:when test="${not empty f.message}"><p class="fb-admin-msg"><c:out value="${f.message}"/></p></c:when>
        <c:otherwise><p class="text-dim">(bez vzkazu)</p></c:otherwise>
      </c:choose>
      <div class="fb-admin-actions">
        <c:if test="${not empty f.message}">
          <form method="post" action="/admin/feedback"><input type="hidden" name="csrf" value="${csrf}"><input type="hidden" name="id" value="${f.id}">
            <input type="hidden" name="action" value="${f.hearted ? 'unheart' : 'heart'}">
            <button type="submit"><i class="fa-${f.hearted ? 'regular' : 'solid'} fa-heart" aria-hidden="true"></i> ${f.hearted ? 'Odebrat z úvodu' : 'Dát srdíčko (na úvod)'}</button></form>
        </c:if>
        <form method="post" action="/admin/feedback" onsubmit="return confirm('Smazat toto hodnocení?')"><input type="hidden" name="csrf" value="${csrf}"><input type="hidden" name="id" value="${f.id}">
          <input type="hidden" name="action" value="delete"><button type="submit" class="btn-delete"><i class="fa-solid fa-trash" aria-hidden="true"></i> Smazat</button></form>
      </div>
    </section>
  </c:forEach>
</main>
<%@ include file="/includes/footer.jsp" %>
