/* Karaoke on the song page, the light version: while the clip plays, the line being sung fills with gold
   from left to right, the lines already sung stay gold; the lyrics scroll in a window under the clip. (A full karaoke
   with its own place in the menu comes later.)

   Timings: /api/karaoke?yt=<clip> = [start, end] for every non-empty line of the lyrics (made by
   tools/karaoke-align.py, corrected in the admin). They count lines of the Czech text; a translation
   with the same lines uses them too, otherwise karaoke stays off. Time: the YouTube player reports it
   by postMessage (the same messages the IFrame API uses). The microphone button or the K key turns it off. */
(function () {
  var pre = document.querySelector('.lyric-page .lyrics-text pre');
  var player = document.getElementById('ytFacade');
  var button = document.getElementById('karaokeToggle');
  if (!pre || !player || !button || pre.dataset.karaoke) return;
  pre.dataset.karaoke = '1';
  var reduce = matchMedia('(prefers-reduced-motion: reduce)').matches;
  var original = pre.textContent;
  var lines = [];            // the spans of the non-empty lines, in order
  var data = null, clipId = null, on = true, cur = -1;
  try { on = localStorage.getItem('karaoke') !== 'off'; } catch (e) {}

  // ---------- the lyrics as one span per line ----------
  function split() {
    pre.textContent = '';
    lines = [];
    original.split('\n').forEach(function (line, i, all) {
      if (line.trim()) {
        var s = document.createElement('span');
        s.className = 'k-line';
        s.textContent = line;
        pre.appendChild(s);
        lines.push(s);
      } else if (line) {
        pre.appendChild(document.createTextNode(line));
      }
      if (i < all.length - 1) pre.appendChild(document.createTextNode('\n'));
    });
  }
  function unsplit() { pre.textContent = original; lines = []; }

  // ---------- timings of the clip that shows ----------
  function load(id) {
    if (!/^[A-Za-z0-9_-]{6,20}$/.test(id || '') || id === clipId) return;
    clipId = id; data = null; stop();
    button.hidden = true;
    fetch('/api/karaoke?yt=' + encodeURIComponent(id)).then(function (r) { return r.ok ? r.json() : null; }).then(function (d) {
      if (!d || clipId !== id || !d.times) return;
      var count = original.split('\n').filter(function (l) { return l.trim(); }).length;
      if (count !== d.lines || d.times.length !== d.lines) return;   // another text than the timings were made for
      data = d;
      button.hidden = false;
      paintButton();
      if (playing && on) start();
    }).catch(function () {});
  }

  function paintButton() {
    button.setAttribute('aria-pressed', String(on));
    button.classList.toggle('on', on);
  }
  button.addEventListener('click', function () {
    on = !on;
    try { localStorage.setItem('karaoke', on ? 'on' : 'off'); } catch (e) {}
    paintButton();
    if (!on) stop();
  });

  // ---------- where the player is ----------
  var playing = false, base = 0, baseAt = 0, frame = null, hello = null;
  function watchFrame() {
    var f = player.querySelector('iframe[src]');
    if (f === frame) return;
    frame = f; playing = false; base = 0; baseAt = performance.now();
    clearInterval(hello);
    if (!frame) { stop(); return; }
    var say = function () { try { frame.contentWindow.postMessage(JSON.stringify({ event: 'listening', id: 2, channel: 'widget' }), '*'); } catch (e) {} };
    frame.addEventListener('load', say);
    hello = setInterval(say, 1000); say();
  }
  new MutationObserver(function () { watchFrame(); load(player.getAttribute('data-yt')); })
    .observe(player, { childList: true, subtree: true, attributes: true, attributeFilter: ['data-yt'] });
  window.addEventListener('message', function (e) {
    if (!frame || e.source !== frame.contentWindow) return;
    var m; try { m = typeof e.data === 'string' ? JSON.parse(e.data) : e.data; } catch (er) { return; }
    if (!m) return;
    clearInterval(hello);
    var info = m.info;
    if (m.event === 'onStateChange' && typeof info === 'number') { base = now(); baseAt = performance.now(); playing = info === 1; }
    if (info && typeof info === 'object') {
      if (typeof info.playerState === 'number') playing = info.playerState === 1;
      if (typeof info.currentTime === 'number') { base = info.currentTime; baseAt = performance.now(); }
    }
    if (playing && on && data) start();
  });
  function now() { return base + (playing ? (performance.now() - baseAt) / 1000 : 0); }

  // ---------- the karaoke window: the clip stays big where it is, the lyrics scroll inside a box under it ----------
  // On start the page lines up once (the clip just under the header bar) and then keeps still; the box
  // fills the rest of the screen. The sung line sits in its upper third, the sung ones slide up and fade.
  // Scrolling the box yourself stops the following and shows "Back to the song" (it comes back by itself
  // after a few seconds). A tap on a line plays the clip from that line.
  var box = pre.closest('.lyric-body') || pre.parentNode;
  var grid = pre.closest('.lyric-grid');
  var backBtn = null, running = false, userAt = 0, ourAt = 0;
  var RESUME_MS = 6000;

  function sizeBox() {
    var top = box.getBoundingClientRect().top;
    box.style.setProperty('--k-win', Math.max(220, Math.round(innerHeight - Math.max(top, 0) - 14)) + 'px');
  }
  function lineUp() {
    // wide screens: the title, the heart and Share stay in sight just under the bar; phones: the clip itself
    var actions = innerWidth >= 1100 && document.querySelector('.lyric-head');
    var stage = actions || player.closest('.lyric-stage') || player;
    var head = parseFloat(getComputedStyle(document.documentElement).getPropertyValue('--header-h')) || 68;
    var y = stage.getBoundingClientRect().top - head - 8;
    if (Math.abs(y) > 4) scrollBy({ top: y, behavior: 'auto' });
  }
  function start() {
    if (running) return;
    running = true;
    if (!lines.length) split();
    lines.forEach(function (l, n) { l.dataset.i = n; });
    pre.classList.add('karaoke');
    if (grid) grid.classList.add('k-mode');   // wide screens: clip and lyrics side by side (pages.css)
    lineUp();
    box.classList.add('k-window');
    sizeBox();
    if (!backBtn) {
      backBtn = document.createElement('button');
      backBtn.type = 'button';
      backBtn.className = 'k-back';
      backBtn.hidden = true;
      backBtn.innerHTML = '<i class="fa-solid fa-arrow-down" aria-hidden="true"></i> ';
      backBtn.appendChild(document.createTextNode(button.dataset.back || '↓'));
      backBtn.addEventListener('click', function () { userAt = 0; backBtn.hidden = true; follow(true); });
    }
    var tools = document.querySelector('.lyric-tools');
    if (tools) tools.insertBefore(backBtn, tools.firstChild); else box.appendChild(backBtn);
    requestAnimationFrame(tick);
  }
  function stop() {
    running = false; cur = -1;
    pre.classList.remove('karaoke');
    box.classList.remove('k-window');
    if (grid) grid.classList.remove('k-mode');
    box.style.removeProperty('--k-win');
    if (backBtn) { backBtn.hidden = true; backBtn.remove(); }
    if (lines.length) unsplit();
  }
  addEventListener('resize', function () { if (running) sizeBox(); });

  // the visitor's own scrolling inside the box (ours is told apart by the time it was started)
  function userScroll() {
    if (!running || performance.now() < ourAt) return;
    userAt = performance.now();
    if (backBtn) backBtn.hidden = false;
  }
  box.addEventListener('wheel', userScroll, { passive: true });
  box.addEventListener('touchmove', userScroll, { passive: true });
  box.addEventListener('scroll', function () { if (performance.now() >= ourAt) userScroll(); }, { passive: true });

  function follow(force) {
    var el = lines[cur];
    if (!el || !running) return;
    if (!force && userAt && performance.now() - userAt < RESUME_MS) return;
    if (userAt && backBtn) backBtn.hidden = true;
    userAt = 0;
    var target = el.offsetTop - box.clientHeight * 0.33;
    if (Math.abs(box.scrollTop - target) < 4) return;
    ourAt = performance.now() + 700;
    box.scrollTo({ top: target, behavior: reduce ? 'auto' : 'smooth' });
  }

  // a tap on a line: the clip jumps to it (the IFrame API's seekTo, by postMessage)
  pre.addEventListener('click', function (e) {
    if (!running || !data || !frame) return;
    var l = e.target.closest && e.target.closest('.k-line');
    if (!l || l.dataset.i == null) return;
    var t = data.times[+l.dataset.i][0];
    try { frame.contentWindow.postMessage(JSON.stringify({ event: 'command', func: 'seekTo', args: [t, true] }), '*'); } catch (er) { return; }
    base = t; baseAt = performance.now(); userAt = 0;
    if (backBtn) backBtn.hidden = true;
  });

  function tick() {
    if (!running) return;
    if (!document.body.contains(pre)) { stop(); return; }    // the page was left (PJAX)
    if (!on || !data || !frame) { stop(); return; }
    var time = now(), times = data.times;

    // which line is sung now: the last one that has started
    var i = -1;
    for (var k = 0; k < times.length; k++) { if (times[k][0] <= time) i = k; else break; }
    if (i !== cur) {
      if (lines[cur]) lines[cur].classList.remove('k-now');
      cur = i;
      lines.forEach(function (l, n) { l.classList.toggle('k-past', n < i); });
      if (lines[i]) lines[i].classList.add('k-now');
      follow(false);
    } else if (userAt && performance.now() - userAt >= RESUME_MS) {
      follow(false);   // a while after the visitor's own scrolling: back to the song
    }
    // how far into the line the singing is: one CSS variable, the gradient does the rest
    if (lines[cur]) {
      var s = times[cur][0], e = times[cur][1];
      var p = Math.max(0, Math.min(1, (time - s) / Math.max(0.3, e - s)));
      lines[cur].style.setProperty('--k', (p * 100).toFixed(1) + '%');
    }
    requestAnimationFrame(tick);
  }

  // K turns it on and off (not while typing)
  document.addEventListener('keydown', function (e) {
    if (e.key !== 'k' && e.key !== 'K') return;
    if (e.ctrlKey || e.metaKey || e.altKey || button.hidden || !document.body.contains(pre)) return;
    if (e.target.closest && e.target.closest('input, textarea, select, [contenteditable]')) return;
    button.click();
  });

  paintButton();
  watchFrame();
  load(player.getAttribute('data-yt'));
})();
