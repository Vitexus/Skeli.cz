<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/includes/header.jsp" %>
<%@ page import="com.github.skeliit.model.KaraokeSong, com.github.skeliit.WebUtils" %>
<%@ taglib prefix="sk" tagdir="/WEB-INF/tags" %>

<%-- /karaoke-kino: the songs that have karaoke, as the rows on Texty; each opens the karaoke cinema
     (a page of its own, loaded whole – header.jsp keeps /karaoke-kino/ out of the quick page swap) --%>
<main class="texty-page karaoke-list-page">
    <sk:pageHero kicker='<%= t.getProperty("karaoke.list.kicker") %>'
                 title='<%= t.getProperty("menu.karaoke") %>' lead='<%= t.getProperty("karaoke.list.lead") %>'/>
    <div class="song-list">
        <%
            @SuppressWarnings("unchecked")
            java.util.List<KaraokeSong> songs = (java.util.List<KaraokeSong>) request.getAttribute("karaokeSongs");
            if (songs != null) for (KaraokeSong s : songs) {
                String meta = (s.credits == null ? "" : s.credits) + (s.year == null ? "" : ((s.credits == null || s.credits.isBlank()) ? "" : " · ") + s.year);
        %>
            <a class="song-row" href="/karaoke-kino/<%= WebUtils.escapeHtml(s.uuid) %>">
                <span class="song-row-art" aria-hidden="true"><img src="<%= WebUtils.escapeHtml(s.getThumb()) %>" alt="" loading="lazy" data-trim-bars></span>
                <span class="song-row-text">
                    <span class="song-row-title"><%= WebUtils.escapeHtml(s.title) %></span>
                    <% if (!meta.isBlank()) { %><span class="song-row-meta"><%= WebUtils.escapeHtml(meta) %></span><% } %>
                </span>
                <span class="song-go"><i class="fa-solid fa-film"></i></span>
            </a>
        <%
            }
            if (songs == null || songs.isEmpty()) out.println("<p class=\"empty-note\">" + t.getProperty("karaoke.list.none") + "</p>");
        %>
    </div>
    <script src="/js/trim-bars.js?v=<%= assetVersion %>"></script>
</main>
<%@ include file="/includes/footer.jsp" %>
