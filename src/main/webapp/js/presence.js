// "Online now" in the footer + visit counting (PresenceServlet / VisitStats).
// One request when a page is shown (also after PJAX navigation), then one a minute while the tab is visible.
// No cookies of its own, nothing stored in the browser.
(function () {
  const box = document.getElementById('onlineNow');
  function ping(newPage) {
    let url = '/api/presence';
    if (newPage) {
      const main = document.querySelector('main[data-lyric-id]');
      url += '?view=1' + (main ? '&lyric=' + encodeURIComponent(main.dataset.lyricId) : '');
    }
    fetch(url, { credentials: 'same-origin', cache: 'no-store' })
      .then(r => (r.ok ? r.json() : null))
      .then(j => {
        if (!j || !box || typeof j.online !== 'number') return;
        box.querySelector('b').textContent = Math.max(1, j.online); // you are here, at least
        box.hidden = false;
      })
      .catch(() => {});
  }
  ping(true);
  document.addEventListener('pjax:done', () => ping(true));
  // A clip started anywhere on the site, counted for the admin's "what is played most" (the server counts
  // each clip once a day per visitor; here once per page): the event 'skeli:play' {yt} from our own play
  // buttons, or a YouTube player on the page reporting "playing" (players with enablejsapi=1).
  const counted = new Set();
  function countClip(yt) {
    if (!yt || counted.has(yt) || !/^[\w-]{6,20}$/.test(yt)) return;
    counted.add(yt);
    fetch('/api/presence?play=clip&id=' + encodeURIComponent(yt), { credentials: 'same-origin', cache: 'no-store' }).catch(() => {});
  }
  window.addEventListener('skeli:play', e => countClip(e.detail && e.detail.yt));
  window.addEventListener('message', e => {
    if (!/^https:\/\/www\.youtube(-nocookie)?\.com$/.test(e.origin)) return;
    let m;
    try { m = typeof e.data === 'string' ? JSON.parse(e.data) : e.data; } catch (x) { return; }
    const info = m && m.info;
    const state = m && m.event === 'onStateChange' ? info : info && info.playerState;
    if (state !== 1) return;
    const frame = Array.from(document.querySelectorAll('iframe')).find(f => f.contentWindow === e.source);
    countClip(frame && (frame.src.match(/\/embed\/([\w-]{6,20})/) || [])[1]);
  });
  setInterval(() => { if (!document.hidden) ping(false); }, 60000);
  document.addEventListener('visibilitychange', () => { if (!document.hidden) ping(false); });
})();
