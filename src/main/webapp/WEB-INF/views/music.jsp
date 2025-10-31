<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/includes/header.jsp" %>
<%@ taglib prefix="c" uri="https://jakarta.ee/jsp/jstl/core" %>

<style>
.section { background: var(--panel); border: 1px solid var(--panel-border); border-radius: 12px; padding: 16px 18px; margin-bottom: 18px; box-shadow: 0 6px 18px rgba(0,0,0,0.20); }
.section.spotify { background: linear-gradient(0deg, rgba(204,43,43,0.24), rgba(255,255,255,0.04)); border-color: rgba(204,43,43,0.45); }
.section.youtube { background: linear-gradient(0deg, rgba(255,0,0,0.14), rgba(255,255,255,0.05)); border-color: rgba(255,0,0,0.28); }
.section-title { margin: 0 0 10px; display:flex; align-items:center; gap: 8px; font-weight:700; }
.media-columns { display:block; }
@media (min-width: 1100px){ .media-columns { display:grid; grid-template-columns: 1fr 1fr; gap:16px; align-items:start; } }
.section-title .ico { font-size: 1.2em; }
</style>

<main>
  <h2>Moje Hudba!</h2>

  <div class="media-columns">
    <section class="section youtube">
      <h3 class="section-title"><span class="ico"><i class="fab fa-youtube" style="color:#FF0000"></i></span> ${t.getProperty('section.youtube','YouTube')}</h3>
      <jsp:include page="/elliptic" flush="true" />
    </section>
  </div>
</main>


<%@ include file="/includes/footer.jsp" %>
