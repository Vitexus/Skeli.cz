<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="includes/header.jsp" %>
<main>
  <h2 class="bruno-ace-sc-regular" style="text-align:center; margin-top:0;">Aktuality</h2>
  <section class="card" style="background: var(--panel); border:1px solid var(--panel-border); border-radius:12px; padding:16px; box-shadow: 0 6px 18px rgba(0,0,0,0.20); max-width:1000px; margin:0 auto;">
    <div id="social-feed" style="display:grid; grid-template-columns: repeat(auto-fit,minmax(220px,1fr)); gap:12px;"></div>
    <div style="text-align:center; margin-top:12px;">
      <button id="load-more" style="background:transparent; border:1px solid var(--panel-border); color:var(--text); padding:8px 12px; border-radius:8px; cursor:pointer;">Načíst další</button>
    </div>
  </section>
</main>
<script>
(function(){
  let page=0, loading=false, done=false; const feed=document.getElementById('social-feed');
  function card(p){
    const img = p.image ? `<img src="${p.image}" alt="" style="width:100%;height:180px;object-fit:cover;display:block;">` : '';
    const cap = (p.caption||'').slice(0,160);
    const badge = p.source==='instagram'?'IG':'FB';
    return `<a href="${p.permalink}" target="_blank" rel="noopener" style="text-decoration:none;color:inherit;border:1px solid var(--panel-border);border-radius:10px;overflow:hidden;background:rgba(0,0,0,0.55);display:block;position:relative;">
              ${img}
              <span style="position:absolute;left:8px;top:8px;background:rgba(0,0,0,0.5);padding:2px 6px;border-radius:6px;font-size:.85em;">${badge}</span>
              <div style="padding:8px;font-size:.95em;">${cap}</div>
            </a>`;
  }
  async function load(){ if(loading||done) return; loading=true; const limit=12; const res = await fetch(`/api/social-posts?limit=${limit}`); if(!res.ok){ loading=false; return; } const arr = await res.json(); if(!Array.isArray(arr)||arr.length===0){ done=true; loading=false; return; } feed.innerHTML = arr.map(card).join(''); loading=false; }
  document.getElementById('load-more').addEventListener('click', load);
  load();
})();
</script>
<%@ include file="includes/footer.jsp" %>
