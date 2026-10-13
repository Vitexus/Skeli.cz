// Karaoke cinema, the room "Prostor": a looping video of a dark space with levitating rocks and golden light
// (made from the design with Seedance, looped and upscaled: prostor/prostor-1440.mp4, -720 for phones). The clip
// is bent onto the tilted black panel in it (a CSS matrix3d from the panel's corners), the words sit on the
// floor under it: the line before grey, the one being sung filling orange word by word, the next one grey.
const D = window.KDATA;
// settings: #sim;auto;t=58 (sim = no YouTube, auto = straight in, t = start time)
const qs = new URLSearchParams((location.search.slice(1) + '&' + location.hash.slice(1)).replace(/;/g, '&'));
const SIM = qs.has('sim') || location.protocol === 'file:';
const LAST_END = D.times[D.times.length - 1][1];
const PHONE = Math.min(innerWidth, innerHeight) < 600;
const $ = (id) => document.getElementById(id);
if (SIM) document.body.classList.add('sim');
document.body.dataset.look = 'p';

$('tagTitle').textContent = D.title;
$('tagArtist').textContent = D.artist + ' · ' + D.year;
$('lobbyTitle').textContent = D.title;
$('lobbyArtist').textContent = D.artist;
$('titleCard').querySelector('b').textContent = D.title;
$('titleCard').querySelector('span').textContent = D.artist;

// ---------------- the space (a video) ----------------
const VID_ASPECT = 16 / 9;
// the black panel in the video: its corners (TL, TR, BR, BL) as a share of the video's width / height
const QUAD = [[.2938, .1889], [.6805, .1597], [.6805, .4694], [.2938, .4792]];
const WIN = { x0: QUAD[0][0], y0: Math.min(QUAD[0][1], QUAD[1][1]), x1: QUAD[1][0], y1: Math.max(QUAD[2][1], QUAD[3][1]) };
const bg = document.createElement('video');
bg.className = 'space';
bg.muted = true; bg.loop = true; bg.playsInline = true; bg.autoplay = true; bg.preload = 'auto';
bg.src = '/kino/prostor/prostor-' + (PHONE || Math.max(innerWidth, innerHeight) * (devicePixelRatio || 1) < 1600 ? '720' : '1440') + '.mp4';
document.body.prepend(bg);
const kick = () => bg.play().catch(() => {});
kick(); addEventListener('pointerdown', kick, { once: true });

// ---------------- the clip, bent onto the panel ----------------
const clipEl = document.createElement('div');
clipEl.className = 'clip';
// the big thumbnail (1280x720) on the large panel; not every clip has one, then the usual one
clipEl.innerHTML = '<img class="poster" alt=""><div class="player"></div><div class="catch" hidden></div><button class="big-play" hidden aria-label="Přehrát"></button><div class="power"></div>';
$('css3d').appendChild(clipEl);
const poster = clipEl.querySelector('.poster'), catcher = clipEl.querySelector('.catch'), bigPlay = clipEl.querySelector('.big-play'), powerEl = clipEl.querySelector('.power');
poster.onerror = () => { poster.onerror = null; poster.src = D.thumb; };
// a golden rim round the clip, like the light lines in the space: its colours flow slowly, a spark runs round
// it and it flares with the song's bass (eq/<id>.json)
const rimEl = document.createElement('div');
rimEl.className = 'clip-rim';
$('css3d').appendChild(rimEl);
const unb64 = (s) => Uint8Array.from(atob(s), (c) => c.charCodeAt(0));
const E = D.eq, energy = unb64(E.energy);
function bassAt(t) {
  const f = Math.floor(t * E.fps), o = f * E.bands;
  if (f < 0 || o + 3 > energy.length) return 0;
  return (energy[o] + energy[o + 1] + energy[o + 2]) / 765;
}
let beat = 0, bassAvg = 0;
poster.src = D.thumb.replace('hqdefault', 'maxresdefault');

// the clip is laid out at 1920x1080 and bent onto the panel: YouTube then sends a sharper picture than at 720p
const CW = 1920, CH = 1080;
// the CSS matrix3d that maps a w x h box onto the corners p (TL, TR, BR, BL)
function quadMatrix(w, h, p) {
  const [[x0, y0], [x1, y1], [x2, y2], [x3, y3]] = p;
  const dx1 = x1 - x2, dx2 = x3 - x2, dy1 = y1 - y2, dy2 = y3 - y2, sx = x0 - x1 + x2 - x3, sy = y0 - y1 + y2 - y3, den = dx1 * dy2 - dx2 * dy1;
  const g = (sx * dy2 - dx2 * sy) / den, k = (dx1 * sy - sx * dy1) / den;
  const a = x1 - x0 + g * x1, b = x3 - x0 + k * x3, d = y1 - y0 + g * y1, e = y3 - y0 + k * y3;
  return [a / w, d / w, 0, g / w, b / h, e / h, 0, k / h, 0, 0, 1, 0, x0, y0, 0, 1];
}
// the video covers the screen (a phone upright: the panel nearly as wide as the screen, the sides cut off);
// the clip and the words follow the panel
function fit() {
  const W = innerWidth, H = innerHeight, a = W / H;
  let vw, vh, ox, oy;
  if (H > W * 1.1) {
    vw = W * .96 / (WIN.x1 - WIN.x0); vh = vw / VID_ASPECT;
    ox = W / 2 - (WIN.x0 + WIN.x1) / 2 * vw; oy = H * .18 - WIN.y0 * vh;
  } else {
    if (a > VID_ASPECT) { vw = W; vh = W / VID_ASPECT; } else { vh = H; vw = H * VID_ASPECT; }
    ox = (W - vw) / 2; oy = (H - vh) / 2;
  }
  Object.assign(bg.style, { left: ox + 'px', top: oy + 'px', width: vw + 'px', height: vh + 'px' });
  bg.classList.toggle('upright', H > W * 1.1);
  const p = QUAD.map(([u, v]) => [ox + u * vw, oy + v * vh]);
  clipEl.style.transform = rimEl.style.transform = 'matrix3d(' + quadMatrix(CW, CH, p).join(',') + ')';
  lyricsEl.style.setProperty('--fs', Math.max(16, Math.min(40, vw * .02)) + 'px');
  lyricsEl.style.top = (oy + vh * .58) + 'px';
}

// ---------------- the clock ----------------
let clock = null, simT = qs.has('end') ? LAST_END + 7 : parseFloat(qs.get('t') || '0'), simPlaying = false, simAt = performance.now();
const now = () => clock ? clock.time() : simT + (simPlaying ? (performance.now() - simAt) / 1000 : 0);
const playing = () => clock ? clock.playing() : simPlaying;
const duration = () => clock && clock.duration() ? clock.duration() : Math.max(LAST_END + 8, 30);
function play() { if (clock) clock.play(); else if (!simPlaying) { simAt = performance.now(); simPlaying = true; } }
function pause() { if (clock) clock.pause(); else if (simPlaying) { simT = now(); simPlaying = false; } }
function seek(t) { t = Math.max(0, Math.min(duration() - .5, t)); if (clock) clock.seek(t); else { simT = t; simAt = performance.now(); } shown = -2; }
function startPlayer() {
  if (SIM) { play(); return; }
  const f = document.createElement('iframe');
  f.src = 'https://www.youtube-nocookie.com/embed/' + D.yt + '?enablejsapi=1&autoplay=1&controls=0&cc_load_policy=0&disablekb=1&fs=0&rel=0&playsinline=1&iv_load_policy=3&modestbranding=1&origin=' + encodeURIComponent(location.origin);
  f.allow = 'autoplay; encrypted-media; picture-in-picture';
  f.title = D.title;
  clipEl.querySelector('.player').appendChild(f);
  // YouTube shows its automatic subtitles when the viewer has them on: switch the module off (again later)
  const noCaptions = () => ['captions', 'cc'].forEach((m) => { try { f.contentWindow.postMessage(JSON.stringify({ event: 'command', func: 'unloadModule', args: [m], id: 1, channel: 'widget' }), '*'); } catch (er) { /* gone */ } });
  clock = new window.YtClock(f, noCaptions);
  [800, 2000, 4000, 8000].forEach((ms) => setTimeout(noCaptions, ms));
  catcher.hidden = false;
  catcher.onclick = () => (playing() ? pause() : play());
  setTimeout(() => { if (!playing()) bigPlay.hidden = false; }, 3500);
}
bigPlay.onclick = () => { bigPlay.hidden = true; play(); };

// ---------------- the words: three lines ----------------
// The line being sung in the middle (its words turn orange as they are sung), the one before above it and the
// next one below it, both grey. A new line slides the three up. In a long pause the middle stays empty.
const AHEAD = .35, PAUSE = 4, lyricsEl = $('lyrics'), titleCard = $('titleCard'), dotsEl = $('dots');
const firstWord = (k) => (D.words[k] && D.words[k][0] ? D.words[k][0][0] : D.times[k][0]);
function lineAt(t) { let i = -1; for (let k = 0; k < D.times.length; k++) { if (firstWord(k) - AHEAD <= t) i = k; else break; } return i; }
const rows = document.createElement('div'); rows.className = 'rows'; lyricsEl.appendChild(rows);
if (!qs.has('auto')) lyricsEl.style.visibility = 'hidden';   // not under the lobby
function lineEl(k, cls) {
  const d = document.createElement('div'); d.className = 'ln ' + cls;
  if (k >= 0 && k < D.lines.length) {
    const times = D.words[k] || [];
    d._w = D.lines[k].split(/\s+/).map((tok, n) => { const s = document.createElement('span'); s.className = 'w'; s.textContent = tok; d.appendChild(s); d.appendChild(document.createTextNode(' ')); return { el: s, t: times[n] || D.times[k] }; });
  } else d._w = [];
  return d;
}
let shown = -2, rowCur = null;
function words(t) {
  let i = lineAt(t);
  const resting = i >= 0 && t > D.times[i][1] + PAUSE && !(D.times[i + 1] && firstWord(i + 1) - t < 1.5);
  const key = resting ? -1 - i - 1000 : i;   // a pause between verses: the middle empties, the next line waits below
  if (key !== shown) {
    const step = key > shown && shown > -2 && key - shown === 1;
    shown = key;
    const cur = resting ? -1 : i, before = resting ? i : i - 1, next = (resting ? i : i) + 1;
    rows.innerHTML = '';
    rows.appendChild(lineEl(before, 'before'));
    rowCur = lineEl(cur, 'cur'); rows.appendChild(rowCur);
    rows.appendChild(lineEl(next, 'next'));
    if (step) { rows.classList.remove('slide'); void rows.offsetWidth; rows.classList.add('slide'); }
  }
  if (rowCur) for (const w of rowCur._w) { const s = t >= w.t[0] - .05; if (s !== w.s) { w.el.classList.toggle('sung', s); w.s = s; } }
  titleCard.classList.toggle('gone', t > D.times[0][0] - 1.2);
  rows.classList.toggle('waiting', t < D.times[0][0] - 1.2);
  let sung = -1; for (let s = 0; s < D.times.length && D.times[s][0] <= t; s++) sung = s;
  const nx = D.times[sung + 1], prevEnd = sung >= 0 ? D.times[sung][1] : 0;
  const wait = nx ? nx[0] - .5 - t : 99, gap = nx ? nx[0] - prevEnd : 0;
  const showDots = nx && sung >= 0 && gap > 5 && wait > 0 && wait < 3.2;
  dotsEl.classList.toggle('show', !!showDots);
  if (showDots) [...dotsEl.children].forEach((d, n) => d.classList.toggle('out', wait < 3 - n));
}

// ---------------- controls ----------------
const fmt = (s) => { s = Math.max(0, Math.floor(s)); return Math.floor(s / 60) + ':' + ('0' + s % 60).slice(-2); };
const bar = $('bar');
D.times.forEach((tt) => { const i = document.createElement('i'); i.className = 'tick'; i.style.left = (tt[0] / duration() * 100) + '%'; bar.appendChild(i); });
bar.onclick = (ev) => { const r = bar.getBoundingClientRect(); seek((ev.clientX - r.left) / r.width * duration()); };
$('pp').onclick = () => (playing() ? pause() : play());
$('back5').onclick = () => seek(now() - 5);
$('fwd5').onclick = () => seek(now() + 5);
$('vol').oninput = (ev) => { if (clock) clock.setVolume(+ev.target.value); };
$('fs').onclick = () => (document.fullscreenElement ? document.exitFullscreen() : document.documentElement.requestFullscreen().catch(() => {}));
$('exit').onclick = leave;
let entered = false, idleTimer = 0;
addEventListener('keydown', (ev) => {
  if (!entered) return;
  if (ev.key === ' ') { ev.preventDefault(); playing() ? pause() : play(); }
  else if (ev.key === 'ArrowLeft') seek(now() - 5);
  else if (ev.key === 'ArrowRight') seek(now() + 5);
  else if (ev.key === 'Escape' && !document.fullscreenElement) leave();
  else if (ev.key === 'f' || ev.key === 'F') $('fs').click();
  wake();
});
function wake() { document.body.classList.remove('idle'); clearTimeout(idleTimer); idleTimer = setTimeout(() => { if (playing()) document.body.classList.add('idle'); }, 2800); }
addEventListener('pointermove', wake); addEventListener('pointerdown', wake);
let turnDismissed = false;   // a phone held upright: ask to turn it (once dismissed, not again)
function askToTurn() { $('rotate').hidden = !(PHONE && entered && !turnDismissed && innerHeight > innerWidth); }
$('rotateAnyway').onclick = () => { turnDismissed = true; askToTurn(); };
addEventListener('resize', () => { fit(); askToTurn(); });

// ---------------- in and out ----------------
let on = 0, onTo = 0;
$('enter').onclick = () => {
  entered = true;
  lyricsEl.style.visibility = '';
  $('lobby').classList.add('gone');
  setTimeout(() => { onTo = 1; }, 500);
  setTimeout(startPlayer, 900);
  askToTurn();
  wake();
};
function leave() {   // like the end of a film: the picture fades to black, back to the karaoke list
  if (leave.done) return; leave.done = true;
  entered = false; pause(); onTo = 0;
  setTimeout(() => document.body.classList.add('fading'), 500);
  setTimeout(() => { try { sessionStorage.setItem('kinoOut', '1'); } catch (er) { /* no storage */ } location.href = '/karaoke-kino'; }, 1900);
}
if (qs.has('auto')) { entered = true; $('lobby').classList.add('gone'); on = onTo = 1; play(); }

let credited = false;
function credits() {
  return '<span class="ct">' + D.title + '</span><span class="cv">' + D.artist + ' · ' + D.year + '</span>' +
    '<span class="cl">Rap a text</span><span class="cv">' + D.artist + '</span>' +
    '<span class="cl">Karaoke</span><span class="cv">SKELO SQUAD</span>' +
    '<span class="cl">A hlavně</span><span class="cv">ty – díky, že sis zazpíval/a</span><span class="cs"></span>';
}

// ---------------- every frame ----------------
let last = performance.now(), wasPlaying = null, started = false;
fit();
function frame(ts) {
  requestAnimationFrame(frame);
  const dt = Math.min(.1, (ts - last) / 1000); last = ts;
  const t = now(), pl = playing();
  on += (onTo - on) * (1 - Math.exp(-dt * 2.5));
  if (pl) { const b = bassAt(t); bassAvg += (b - bassAvg) * (1 - Math.exp(-dt / .7)); beat = Math.max(beat * Math.exp(-dt / .2), Math.min(1, Math.max(0, b - bassAvg * 1.08) * 4.5)); }
  else beat *= Math.exp(-dt / .3);
  rimEl.style.setProperty('--k', (beat * on).toFixed(3)); rimEl.style.opacity = (.35 + .65 * on).toFixed(3);
  powerEl.style.opacity = (1 - on).toFixed(3);
  const ended = entered && started && t > Math.min(duration() - 1.5, LAST_END + 6);
  if (ended && !credited) { credited = true; onTo = .15; $('roll').innerHTML = credits(); $('credits').hidden = false; $('credits').classList.add('run'); }
  if (!ended && credited) { credited = false; onTo = 1; $('credits').hidden = true; $('credits').classList.remove('run'); }
  if (entered) words(t);
  if (pl && !started && (!clock || clock.time() > .3)) { started = true; if (clock) poster.style.display = 'none'; }
  if (clock && clock.time() > .3) catcher.classList.toggle('paused', !pl);
  $('fill').style.width = (t / duration() * 100) + '%';
  $('time').textContent = fmt(t) + ' / ' + fmt(duration());
  if (pl !== wasPlaying) { wasPlaying = pl; $('ppIcon').innerHTML = pl ? '<path d="M6 5h4v14H6zm8 0h4v14h-4z"/>' : '<path d="M8 5v14l11-7z"/>'; }
}
requestAnimationFrame(frame);

// the loading screen stays up until the space video can play (at most 12 s)
let ready = false;
const done = () => { if (ready) return; ready = true; if (window.kinoLoaded) window.kinoLoaded(); };
bg.addEventListener('canplaythrough', done, { once: true });
bg.addEventListener('loadeddata', () => setTimeout(done, 400), { once: true });
setTimeout(done, 12000);
if (window.kinoProgress) bg.addEventListener('progress', () => { try { const b = bg.buffered; if (b.length && bg.duration) window.kinoProgress(b.end(b.length - 1) / bg.duration); } catch (er) { /* not yet */ } });
