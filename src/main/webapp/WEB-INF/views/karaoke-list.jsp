<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/includes/header.jsp" %>
<%@ page import="com.github.skeliit.model.KaraokeSong, com.github.skeliit.WebUtils" %>

<%-- /karaoke-kino: the cinema's lobby. A marquee with bulbs, the newest song as the premiere, the others as
     film posters with a ticket stub. Each opens the karaoke cinema (a page of its own, loaded whole –
     header.jsp keeps /karaoke-kino/ out of the quick page swap). Styles: .k-lobby in css/pages.css --%>
<%
    @SuppressWarnings("unchecked")
    java.util.List<KaraokeSong> songs = (java.util.List<KaraokeSong>) request.getAttribute("karaokeSongs");
    if (songs == null) songs = java.util.List.of();
%>
<%-- coming back from the cinema: the page rises out of the black the cinema faded to --%>
<main class="k-lobby">
<div class="k-from-black" id="kFromBlack" hidden aria-hidden="true"></div>
<script>try { if (sessionStorage.getItem("kinoOut")) { sessionStorage.removeItem("kinoOut"); document.getElementById("kFromBlack").hidden = false; } } catch (e) {}</script>
    <header class="k-marquee">
        <span class="k-bulbs" aria-hidden="true"></span>
        <p class="k-marquee-kicker"><%= t.getProperty("karaoke.list.marquee") %></p>
        <h1 class="k-marquee-title"><%= t.getProperty("menu.karaoke") %></h1>
        <p class="k-marquee-lead"><%= t.getProperty("karaoke.list.lead") %></p>
    </header>

    <% if (songs.isEmpty()) { %>
        <p class="empty-note"><%= t.getProperty("karaoke.list.none") %></p>
    <% } else {
        KaraokeSong top = songs.get(0);
        String topMeta = (top.credits == null || top.credits.isBlank() ? "Skeli" : top.credits) + (top.year == null ? "" : " · " + top.year);
    %>
    <%-- the premiere: the newest song, big --%>
    <a class="k-feature" href="/karaoke-kino/<%= WebUtils.escapeHtml(top.uuid) %>">
        <span class="k-feature-bg" aria-hidden="true" style="--bg: url('/yt-thumb/<%= WebUtils.escapeHtml(top.youtubeId) %>/hqdefault.jpg')"></span>
        <span class="k-feature-poster" aria-hidden="true"><img src="/yt-thumb/<%= WebUtils.escapeHtml(top.youtubeId) %>/hqdefault.jpg" alt=""></span>
        <span class="k-feature-text">
            <span class="k-badge"><%= t.getProperty("karaoke.list.newest") %></span>
            <span class="k-feature-title"><%= WebUtils.escapeHtml(top.title) %></span>
            <span class="k-feature-meta"><%= WebUtils.escapeHtml(topMeta) %></span>
            <span class="k-enter"><i class="fa-solid fa-play" aria-hidden="true"></i> <%= t.getProperty("karaoke.list.enter") %></span>
        </span>
    </a>

    <%-- the rest: posters --%>
    <div class="k-posters">
        <% for (int i = 1; i < songs.size(); i++) {
            KaraokeSong s = songs.get(i);
            String meta = (s.credits == null || s.credits.isBlank() ? "" : s.credits + " · ") + (s.year == null ? "" : String.valueOf(s.year));
        %>
        <a class="k-poster" href="/karaoke-kino/<%= WebUtils.escapeHtml(s.uuid) %>">
            <span class="k-poster-img" aria-hidden="true"><img src="/yt-thumb/<%= WebUtils.escapeHtml(s.youtubeId) %>/hqdefault.jpg" alt="" loading="lazy"></span>
            <span class="k-poster-no" aria-hidden="true"><%= String.format("%02d", i + 1) %></span>
            <span class="k-poster-text">
                <span class="k-poster-title"><%= WebUtils.escapeHtml(s.title) %></span>
                <% if (!meta.isBlank()) { %><span class="k-poster-meta"><%= WebUtils.escapeHtml(meta) %></span><% } %>
            </span>
            <span class="k-ticket"><i class="fa-solid fa-ticket" aria-hidden="true"></i> <span class="k-ticket-txt"><%= t.getProperty("karaoke.list.enter") %></span><i class="fa-solid fa-play k-ticket-go" aria-hidden="true"></i></span>
        </a>
        <% } %>
    </div>
    <% } %>
</main>
<%@ include file="/includes/footer.jsp" %>
