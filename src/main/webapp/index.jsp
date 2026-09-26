<%@ page import="java.sql.*" %>
<%@ page import="com.github.skeliit.Db" %>
<%@ include file="includes/header.jsp" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<main>
  <section class="hero-section">
    <h2 class="comforter-brush-regular">SKELOSQUAD</h2>
    <p><%= t.getProperty("index.hero","Official website – music, lyrics, news.") %></p>
  </section>

  <section class="tiles-grid">
    <a class="section" href="/music.jsp">
      <h3><i class="fas fa-music"></i> <%= t.getProperty("tile.music.title","Music") %></h3>
      <p><%= t.getProperty("tile.music.desc","YouTube videos and Spotify playlist.") %></p>
    </a>
    <a class="section" href="/texty.jsp">
      <h3><i class="fas fa-align-left"></i> <%= t.getProperty("tile.lyrics.title","Lyrics") %></h3>
      <p><%= t.getProperty("tile.lyrics.desc","Browse lyrics, vote and comment.") %></p>
    </a>
    <a class="section" href="/about.jsp">
      <h3><i class="fas fa-user"></i> <%= t.getProperty("tile.about.title","About") %></h3>
      <p><%= t.getProperty("tile.about.desc","Who I am and how I create.") %></p>
    </a>
  </section>

  <!-- 2-column layout: News + Social/Concerts -->
  <section class="home-grid">
    <div class="card">
      <h3 class="bruno-ace-sc-regular">🗞️ <%= t.getProperty("home.news","Novinky") %></h3>
      <div class="videos">
        <%
          String sql = "SELECT youtube_id, COALESCE(title, youtube_id) AS title, published_at FROM videos ORDER BY published_at DESC, id DESC LIMIT 3";
          try (Connection conn = Db.get()){
            if (conn != null){
              try (PreparedStatement ps = conn.prepareStatement(sql); ResultSet rs = ps.executeQuery()){
                while (rs.next()){
                  String vid = rs.getString(1);
                  String title = rs.getString(2);
                  java.sql.Timestamp ts = rs.getTimestamp(3);
                  String dateStr = ts == null ? "" : new java.text.SimpleDateFormat("yyyy-MM-dd").format(ts);
        %>
                  <a class="video" href="https://www.youtube.com/watch?v=<%= vid %>" target="_blank" rel="noopener">
                    <img src="https://img.youtube.com/vi/<%= vid %>/hqdefault.jpg" alt="<%= com.github.skeliit.WebUtils.escapeHtml(title) %>">
                    <div class="meta">
                      <div><%= com.github.skeliit.WebUtils.escapeHtml(title) %></div>
                      <div><%= dateStr %></div>
                    </div>
                    <button type="button" class="share-btn" data-url="https://www.youtube.com/watch?v=<%= vid %>" title="<%= t.getProperty("common.share") %>"><%= t.getProperty("common.share") %></button>
                  </a>
        <%
                }
              }
            } else {
        %>
              <div><%= t.getProperty("home.news.none","Žádná videa k zobrazení.") %></div>
        <%
            }
          } catch (SQLException ex) {
        %>
            <div><%= t.getProperty("home.news.error") %></div>
        <%
          }
        %>
      </div>
    </div>

    <div class="card">
      <h3 class="bruno-ace-sc-regular">🎤 <%= t.getProperty("home.concerts","Koncerty") %></h3>
      <ul class="concerts-list">
        <li><%= t.getProperty("home.concerts.none","Zatím nejsou naplánovány žádné koncerty.") %></li>
      </ul>
      <hr style="border-color:var(--panel-border); opacity:.5; margin:12px 0;">
      
      <h4 class="bruno-ace-sc-regular" style="margin-top:16px;">📣 <%= t.getProperty("home.social") %></h4>
      <div id="home-social" class="home-social-grid"></div>
      <div class="all-news-link" style="margin-top:8px;"><a href="/aktuality.jsp"><%= t.getProperty("home.allNews") %></a></div>
      
      <hr style="border-color:var(--panel-border); opacity:.5; margin:12px 0;">
      <div class="newsletter">
        <h4>📧 <%= t.getProperty("home.newsletter.title","Novinky e-mailem") %></h4>
        <form method="post" action="/newsletter/subscribe">
          <input type="hidden" name="csrf" value="<%= request.getAttribute("csrf") %>">
          <input type="email" name="email" placeholder="<%= t.getProperty("home.newsletter.placeholder","Tvůj e-mail") %>" required>
          <button type="submit"><%= t.getProperty("home.newsletter.submit","Odebírat") %></button>
        </form>
    </div>
  </section>

<script>
  // Load social posts for home page
  (async function(){
    try{
      const res = await fetch('/api/social-posts?onePerSource=true'); 
      if(!res.ok) return;
      const posts = await res.json(); 
      if(!Array.isArray(posts)||!posts.length) return;
      const el = document.getElementById('home-social'); 
      if(!el) return;
      const esc = v => String(v==null?'':v).replace(/&/g,'&amp;').replace(/</g,'&lt;').replace(/>/g,'&gt;').replace(/"/g,'&quot;').replace(/'/g,'&#39;');
      const safeUrl = u => /^https?:\/\//i.test(u||'') ? esc(u) : '#';
      el.innerHTML = posts.map(p=>{
        const img = p.image?`<img src="\${safeUrl(p.image)}" class="home-social-img">`:'';
        const cap = esc((p.caption||'').slice(0,120));
        const badge = p.source==='instagram'?'<i class="fab fa-instagram"></i>':(p.source==='facebook'?'<i class="fab fa-facebook"></i>':'📰');
        return `<a href="\${safeUrl(p.permalink)}" target="_blank" rel="noopener" class="home-social-link">\${img}<span class="home-social-badge">\${badge}</span><div class="home-social-caption">\${cap}</div></a>`;
      }).join('');
    }catch(e){}
  })();

  // Share button handler
  document.addEventListener('click', function(e){
    const btn = e.target.closest('.share-btn');
    if(!btn) return;
    e.preventDefault(); e.stopPropagation();
    const url = btn.getAttribute('data-url');
    if (navigator.share) {
      navigator.share({ title: document.title, url }).catch(()=>{});
    } else {
      navigator.clipboard.writeText(url).then(()=>{ btn.textContent='<%= com.github.skeliit.WebUtils.escapeJs(t.getProperty("common.copied")) %>'; setTimeout(()=>btn.textContent='<%= com.github.skeliit.WebUtils.escapeJs(t.getProperty("common.share")) %>',1200); });
    }
    }
  });
</script>
</main>

<%@ include file="includes/footer.jsp" %>
