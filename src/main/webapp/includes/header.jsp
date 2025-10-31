<!DOCTYPE html>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<html lang="cs-cz">

<head>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, viewport-fit=cover">
    <title>Skeli — oficiální web</title>
    <meta name="description" content="Skeli — hudba, texty, videa a novinky" />
    <meta name="keywords" content="Skeli, hudba, rap, videoklipy, texty" />
    <meta name="author" content="Skeli" />
    <meta property="og:title" content="Skeli — oficiální web" />
    <meta property="og:description" content="Poslouchej hudbu, sleduj klipy a čti texty" />
    <meta property="og:type" content="website" />
    <meta property="og:url" content="/" />
    <link rel="shortcut icon" href="obrazky/skeliico.ico" />
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Alumni+Sans+Pinstripe:ital@0;1&display=swap" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Bruno+Ace+SC&display=swap" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Comforter+Brush&display=swap" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;600&display=swap" rel="stylesheet">
    <!-- Slick Carousel CSS -->
    <link rel="stylesheet" type="text/css" href="https://cdn.jsdelivr.net/npm/slick-carousel@1.8.1/slick/slick.css"/>
    <link rel="stylesheet" type="text/css" href="https://cdn.jsdelivr.net/npm/slick-carousel@1.8.1/slick/slick-theme.css"/>
    <!-- jQuery -->
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <!-- Slick Carousel JS -->
    <script src="https://cdn.jsdelivr.net/npm/slick-carousel@1.8.1/slick/slick.min.js"></script>

<style>
:root { --bg:#0b0c0d; --text:#e7e9ea; --panel:rgba(0,0,0,0.60); --panel-strong:rgba(0,0,0,0.75); --panel-border:rgba(255,255,255,0.18); --accent:#00d1ff; --spotify:#CC2B2B; --youtube:#FF0000; --fw:400; }
body.light { --bg:#f6f6f6; --text:#111; --panel:#ffffff; --panel-strong:#ffffff; --panel-border:rgba(0,0,0,0.18); --accent:#007acc; }
body.dark { --bg:#0b0c0d; --text:#e7e9ea; --panel:rgba(0,0,0,0.60); --panel-strong:rgba(0,0,0,0.75); --panel-border:rgba(255,255,255,0.18); --accent:#00d1ff; }
.comforter-brush-regular {
  font-family: "Comforter Brush", cursive;
  font-weight: 800;
  font-style: normal;
}

.bruno-ace-sc-regular {
  font-family: "Bruno Ace SC", sans-serif;
  font-weight: 400;
  font-style: normal;
}

.carousel iframe {
    display: block;
    margin: 0 auto;
}

.cpy {
    font-family: 'Alumni Sans Pinstripe', Arial, sans-serif;
    font-size: 1em;
    color: gold;
    font-weight: bold;
}
p {
    font-family: 'Inter', 'Alumni Sans Pinstripe', Arial, sans-serif;
    font-size: 1.05em;
    color: var(--text);
    font-weight: var(--fw);
    line-height: 1.6;
}

html, body {
    height: 100%;
}
body {
    font-family: 'Inter', 'Segoe UI', Arial, sans-serif;
    background: var(--bg) url('img/IMG_0090.JPG') center center/cover no-repeat fixed;
    color: var(--text);
    margin: 0;
    padding: 0;
    display: flex;
    flex-direction: column;
    min-height: 100vh;
}

header {
    width: 100%;
    color: gold;
    padding: 120px 0 40px 0px;
    text-align: center;
    border-radius: 0;
    margin: 0;
    position: relative;
    /* průhlednost směrem dolů */
    background: linear-gradient(
        to bottom,
        rgba(34,34,34,0.9) 0%,   /* nahoře jen lehce průhledné */
        rgba(255,255,255,0) 100%    /* dole úplně průhledné */
    );
}

nav a {
    color: white;
    text-decoration: none;
    margin: 0 10px;
    font-weight: bold;
}
h3 { font-family: "Bruno Ace SC", sans-serif; letter-spacing: 0.5px; }
.top-controls { font-family: "Bruno Ace SC", sans-serif; }
.top-controls a, .top-controls button { font-family: inherit; }
.lang-switch { position: relative; }
.lang-switch .menu { display:none; position:absolute; right:0; top:100%; background: var(--panel-strong); border:1px solid var(--panel-border); border-radius:8px; padding:6px; min-width:140px; z-index:1000; }
.lang-switch.open .menu { display:block; }
.lang-switch .menu a { display:block; padding:6px 8px; color:#fff; text-decoration:none; }
body.light .lang-switch .menu a { color:#111; }
.lang-switch .menu a:hover { background: rgba(0,0,0,0.25); }
/* Light mode fixes */
body.light .user-dropdown { background: #fff; border:1px solid var(--panel-border); }
.user-dropdown a { color:#fff; }
.user-dropdown a:hover { background: rgba(255,255,255,0.08); }
body.light .user-dropdown a { color:#111; }
body.light .user-dropdown a:hover { background: rgba(0,0,0,0.06); }
body.light .top-controls { color:#111; }
body.light .top-controls a { color:#111; }
body.light .top-controls button { color:#111; border-color: rgba(0,0,0,0.35); }

nav a:hover {
    text-decoration: underline;
}

main {
    flex: 1 0 auto;
    width: calc(100vw - 60px);
    max-width: none;
    margin: 30px auto;
    background: var(--panel);
    padding: 30px;
    border-radius: 10px;
    box-shadow: 0 12px 36px rgba(0,0,0,0.35);
    border: 1px solid var(--panel-border);
}

footer {
    background: linear-gradient(
        to top,
        rgba(34,34,34,0.9) 0%,
        rgba(255,255,255,0) 100%
    );
    color: white;
    text-align: center;
    padding: 80px 0;
    position: static;
    width: 100%;
    border-radius: 3px 3px 0px 0px;
    margin-top: auto; /* push to bottom when content short */
}

body {
    margin:0;
    padding:0;
    background-color:#333;
    font-family:verdana;
}

.smoke {
    position:absolute;
    top:50%;
    left:50%;
    transform:translate(-50%,-50%);
}

.smoke ul {
    margin:0;
    padding:0;
    display:flex;

}

.smoke ul li {
    list-style:none;
    font-weight:bold;
    letter-spacing:10px;
    filter:blur(1px);
    color:#fff;
    font-size:6em;
    display: inline-block;
    animation: smoke 2s linear infinite;
}

@keyframes smoke {
    0% {
        transform: rotate(0deg) translateY(0px);
        opacity: 1;
        filter:blur(1px);
    }
    100% {
      transform: rotate(45deg) translateY(-200px);
        opacity: 0;
        filter:blur(20px);
    }
}

.smoke ul li:nth-child(1){
    animation-delay:0s
}
.smoke ul li:nth-child(2){
    animation-delay:.4s
}
.smoke ul li:nth-child(3){
    animation-delay:.8s
}
.smoke ul li:nth-child(4){
    animation-delay:1.2s
}
.smoke ul li:nth-child(5){
    animation-delay:1.6s
}
ul li a {
    font-family: "Bruno Ace SC", sans-serif;
    font-weight: bold;
    color: #222;
    text-decoration: none;
    transition: color 0.2s, text-shadow 0.2s;
}

ul li a:hover {
    color: var(--accent);
    text-shadow: 0 0 8px var(--accent);
    text-decoration: underline;
}



</style>
<style>
  /* Global inputs styling */
  input[type=text], input[type=password], input[type=email], input[type=number], select, textarea {
    font-family: 'Inter', system-ui, sans-serif; font-size: 1.02em; color: var(--text);
    background: rgba(0,0,0,0.18); border:1px solid var(--panel-border); border-radius:8px; padding:8px 10px;
  }
  body.light input[type=text], body.light input[type=password], body.light input[type=email], body.light input[type=number], body.light select, body.light textarea {
    background: rgba(0,0,0,0.06); color:#111;
  }
</style>
<style>
  /* Dropdown admin highlight */
  .user-dropdown a.admin { color:#ffd700; }
  body.light .user-dropdown a.admin { color:#a37b00; }

  /* Persistent bottom Spotify bar */
  .sp-bar { position:fixed; left:0; right:0; bottom:0; z-index:9999; background: rgba(0,0,0,0.85); border-top:1px solid var(--panel-border); box-shadow: 0 -12px 30px rgba(0,0,0,.45); display:none; }
  .sp-inner { display:flex; align-items:center; gap:10px; padding:8px 10px; position:relative; }
  .sp-iframe { width:100%; height:152px; border:0; border-radius:12px 12px 0 0; }
  .sp-hide { position:absolute; right:10px; top:-32px; border-radius:999px; border:1px solid var(--panel-border); background: rgba(0,0,0,0.65); color:#fff; padding:4px 10px; cursor:pointer; box-shadow:0 8px 22px rgba(0,0,0,.35); }
  .sp-hide:hover { background: rgba(0,0,0,0.8); }
  .sp-minbar { position:fixed; left:50%; transform:translateX(-50%); bottom:10px; z-index:9998; display:none; background: rgba(0,0,0,0.65); color:#fff; border:1px solid var(--panel-border); border-radius:999px; padding:6px 10px; cursor:pointer; box-shadow:0 8px 22px rgba(0,0,0,.35); }
  .sp-minbar:hover { background: rgba(0,0,0,0.8); }
  body.light .sp-bar { background:#ffffff; box-shadow: 0 -12px 30px rgba(0,0,0,.20); }
  body.light .sp-hide { background: rgba(255,255,255,0.9); color:#111; border-color: rgba(0,0,0,0.15); }
  body.light .sp-hide:hover { background: rgba(255,255,255,1); }
  body.light .sp-minbar { background: rgba(255,255,255,0.9); color:#111; border-color: rgba(0,0,0,0.15); }
</style>
<%@ include file="/WEB-INF/i18n/i18n.jspf" %>
<header>


   <h1 class="comforter-brush-regular">SKELOSQUAD</h1>
   <nav class="bruno-ace-sc-regular">
        <a href="index.jsp"><%= ((java.util.Properties)request.getAttribute("t")).getProperty("menu.home","Home") %></a> |
        <a href="bio.jsp"><%= ((java.util.Properties)request.getAttribute("t")).getProperty("menu.about","About") %></a> |
        <a href="music.jsp"><%= ((java.util.Properties)request.getAttribute("t")).getProperty("menu.music","Music") %></a> |
        <a href="texty.jsp"><%= ((java.util.Properties)request.getAttribute("t")).getProperty("menu.lyrics","Lyrics") %></a>
    </nav>
    <div class="top-controls" style="position:absolute; top:10px; right:14px; font-size:0.95em; display:flex; gap:10px; align-items:center;">
        <% String currentUser = (String) session.getAttribute("username"); String currentRole = (String) session.getAttribute("role"); %>
        <a href="donate.jsp" style="color:var(--accent); font-weight:700;">❤ <%= ((java.util.Properties)request.getAttribute("t")).getProperty("btn.donate","Donate") %></a>
        <button id="fontToggle" title="Toggle font weight" style="background:transparent;border:1px solid rgba(255,255,255,0.5);color:white;padding:4px 8px;border-radius:6px;cursor:pointer;">Aa</button>
        <button id="themeToggle" title="Přepnout vzhled" style="background:transparent;border:1px solid rgba(255,255,255,0.5);color:white;padding:4px 8px;border-radius:6px;cursor:pointer;">🌓</button>
        <div class="lang-switch">
          <button class="lang-btn" title="Jazyk" style="background:transparent;border:1px solid rgba(255,255,255,0.5);color:white;padding:4px 8px;border-radius:6px;cursor:pointer;">🌐</button>
          <ul class="menu">
            <li><a href="?lang=cs">Čeština 🇨🇿</a></li>
            <li><a href="?lang=en">English 🇬🇧</a></li>
            <li><a href="?lang=de">Deutsch 🇩🇪</a></li>
            <li><a href="?lang=sk">Slovensky 🇸🇰</a></li>
            <li><a href="?lang=uk">Українська 🇺🇦</a></li>
          </ul>
        </div>
        <% if (currentUser == null) { %>
            <a href="login.jsp" style="color:white;">Přihlásit</a> |
            <a href="register.jsp" style="color:white;">Registrovat</a>
        <% } else { %>
            <div class="user-menu" style="position:relative; display:inline-block;">
              <span style="color:white; cursor:pointer;">👤 <%= currentUser %><% if ("ADMIN".equals(currentRole)) { %> (admin)<% } %></span>
              <div class="user-dropdown" style="display:none; position:absolute; right:0; top:100%; background:var(--panel-strong); border:1px solid var(--panel-border); border-radius:8px; padding:6px; min-width:140px; z-index:1000;">
                <a href="/profile.jsp" style="display:block; padding:6px 8px; text-decoration:none;">Profil</a>
                <a href="/uzivatel.jsp" style="display:block; padding:6px 8px; text-decoration:none;">Nastavení</a>
                <% if ("ADMIN".equals(currentRole)) { %><a href="/admin.jsp" class="admin" style="display:block; padding:6px 8px; text-decoration:none;">Admin</a><% } %>
                <a href="/logout" style="display:block; padding:6px 8px; text-decoration:none;">Odhlásit</a>
              </div>
            </div>
        <% } %>
    </div>
</header>
<script>
  (function(){
    const fwKey='fontWeight';
    const body=document.body; const curFw=localStorage.getItem(fwKey)||'400';
    document.documentElement.style.setProperty('--fw', curFw);
    document.getElementById('fontToggle').addEventListener('click',()=>{
      const newFw=(getComputedStyle(document.documentElement).getPropertyValue('--fw').trim()==='400')?'600':'400';
      document.documentElement.style.setProperty('--fw', newFw);
      localStorage.setItem(fwKey,newFw);
    });
    const k='theme';
    const cur=localStorage.getItem(k)||'dark';
    body.classList.add(cur);
    document.getElementById('themeToggle').addEventListener('click',()=>{
      body.classList.toggle('light'); body.classList.toggle('dark');
      const v=body.classList.contains('light')?'light':'dark'; localStorage.setItem(k,v);
    });

    // Language menu toggle by click
    const langSwitch=document.querySelector('.lang-switch');
    const langBtn=document.querySelector('.lang-switch .lang-btn');
    if (langBtn && langSwitch) {
      langBtn.addEventListener('click', (e)=>{ e.stopPropagation(); langSwitch.classList.toggle('open'); });
      document.addEventListener('click', ()=>{ langSwitch.classList.remove('open'); });
      langSwitch.querySelectorAll('.menu a').forEach(a=>a.addEventListener('click', ()=>{ langSwitch.classList.remove('open'); }));
    }
    // User menu dropdown on hover
    const userMenu=document.querySelector('.user-menu');
    const userDropdown=document.querySelector('.user-dropdown');
    if (userMenu && userDropdown) {
      userMenu.addEventListener('mouseenter', ()=>{ userDropdown.style.display='block'; });
      userMenu.addEventListener('mouseleave', ()=>{ userDropdown.style.display='none'; });
    }

    // Persistent Spotify bottom bar
    function ensureSpBar(){
      if(document.getElementById('sp-bar')) return document.getElementById('sp-bar');
      const bar=document.createElement('div'); bar.id='sp-bar'; bar.className='sp-bar';
      bar.innerHTML = "<div class='sp-inner'><button id='sp-hide' class='sp-hide' title='Skrýt přehrávač'>▼</button><iframe id='sp-iframe' class='sp-iframe' allow='autoplay; clipboard-write; encrypted-media; fullscreen; picture-in-picture' loading='lazy'></iframe></div>";
      document.body.appendChild(bar);
      const min=document.createElement('div'); min.id='sp-min'; min.className='sp-minbar'; min.textContent='▲ Otevřít přehrávač';
      document.body.appendChild(min);
      document.getElementById('sp-hide').addEventListener('click', ()=>closeBar());
      min.addEventListener('click', ()=>openBar());
      return bar;
    }
    function normalizeSrc(input){
      if(!input) return null;
      if(/^https?:\/\//.test(input)) return input;
      // short forms: track:ID, playlist:ID, album:ID, artist:ID
      const [type,id] = input.split(':');
      if(id){ return `https://open.spotify.com/embed/${type}/${id}?utm_source=generator`; }
      return `https://open.spotify.com/embed/track/${input}?utm_source=generator`;
    }
    const SP_DEFAULT = 'https://open.spotify.com/embed/artist/5IouXw8U9uKCTwmncG5bUl?utm_source=generator';
    function openBar(){ const bar=ensureSpBar(); const f=document.getElementById('sp-iframe'); if(!f.src){ const saved=localStorage.getItem('sp_src'); f.src=saved||SP_DEFAULT; } bar.style.display='block'; document.getElementById('sp-min').style.display='none'; localStorage.setItem('sp_min','0'); }
    function closeBar(){ const bar=ensureSpBar(); bar.style.display='none'; const m=document.getElementById('sp-min'); m.style.display='block'; m.textContent='▲ Otevřít přehrávač'; localStorage.setItem('sp_min','1'); }
    window.toggleSpotifyBar=function(){ if(ensureSpBar().style.display==='none'){ openBar(); } else { closeBar(); } }
    window.playSpotify=function(src){ const bar=ensureSpBar(); const url=normalizeSrc(src); const f=document.getElementById('sp-iframe'); if(f.src!==url) f.src=url; openBar(); localStorage.setItem('sp_src', url); localStorage.setItem('sp_play','true'); };

    // Restore state on every page
    (function(){ const bar=ensureSpBar(); const wasMin=localStorage.getItem('sp_min')==='1'; const saved=localStorage.getItem('sp_src'); const f=document.getElementById('sp-iframe'); if(saved){ f.src=saved; }
      if((saved||SP_DEFAULT) && !wasMin){ f.src=f.src||SP_DEFAULT; bar.style.display='block'; document.getElementById('sp-min').style.display='none'; }
      else { bar.style.display='none'; document.getElementById('sp-min').style.display='block'; }
    })();

    // Autowire any element with data-spotify-src
    document.addEventListener('click', function(e){ const t=e.target.closest('[data-spotify-src]'); if(t){ e.preventDefault(); window.playSpotify(t.getAttribute('data-spotify-src')); }});

    // Lightweight PJAX navigation to preserve global UI (Spotify bar)
    (function(){
      const ORIGIN = location.origin;
      function isInternal(a){ try{ const u=new URL(a.href, ORIGIN); return u.origin===ORIGIN && !a.hasAttribute('download') && (!a.target || a.target==='_self'); }catch{return false;} }
      function extractMain(html){
        const doc = new DOMParser().parseFromString(html, 'text/html');
        const main = doc.querySelector('main');
        return main ? main : doc.body;
      }
      async function navigate(url, push){
        try{
          document.body.style.cursor='progress';
          const res = await fetch(url, {headers:{'X-Requested-With':'fetch'}});
          const text = await res.text();
          const newMain = extractMain(text);
          if(!newMain) return location.assign(url);
          const curMain = document.querySelector('main');
          if(curMain){ curMain.replaceWith(newMain); } else { document.body.appendChild(newMain); }
          const titleMatch = text.match(/<title>([\s\S]*?)<\/title>/i); if(titleMatch) document.title = titleMatch[1];
          // re-execute inline scripts in main
          newMain.querySelectorAll('script').forEach(old => { const s=document.createElement('script'); if(old.src){ s.src=old.src; } else { s.textContent=old.textContent; } (old.type && (s.type=old.type)); old.replaceWith(s); });
          if(push) history.pushState({url}, '', url);
          window.scrollTo({top:0, behavior:'smooth'});
        }catch(e){ location.assign(url); }
        finally{ document.body.style.cursor=''; }
      }
      document.addEventListener('click', function(e){
        const a = e.target.closest('a');
        if(!a) return;
        if(!isInternal(a)) return;
        const href = a.getAttribute('href');
        if(!href || href.startsWith('#')) return;
        // allow full reload for language switch to refresh header/nav strings
        if(href.includes('lang=')) return;
        e.preventDefault();
        navigate(href, true);
      });
      window.addEventListener('popstate', (e)=>{ const url = (e.state && e.state.url) || location.href; navigate(url, false); });
    })();
  })();
</script>
