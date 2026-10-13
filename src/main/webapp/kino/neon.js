// Karaoke cinema, the neon hall: a long dark hall, blue neon on the left, orange on the right, a purple line
// along the ceiling, a wet floor that mirrors it all, haze, and the screen at the far end. Layers: the room
// (WebGL with bloom), the clip (an <iframe> placed in 3D by CSS3DRenderer), the haze in front of it (a second,
// transparent WebGL canvas) and the words (HTML). The screen lights the room with the colours of the clip's
// edges (eq/<id>.json, 4x a second); the neon pulses with its bass (16 bands, 20x a second).
// The words: at most three lines; each word is drawn in as it is sung and glows, the line being sung is
// orange, the one before white, the oldest dim, and a line that leaves dissolves in smoke.
import * as THREE from 'three';
import { CSS3DRenderer, CSS3DObject } from './vendor/jsm/renderers/CSS3DRenderer.js';
import { EffectComposer } from './vendor/jsm/postprocessing/EffectComposer.js';
import { RenderPass } from './vendor/jsm/postprocessing/RenderPass.js';
import { UnrealBloomPass } from './vendor/jsm/postprocessing/UnrealBloomPass.js';
import { OutputPass } from './vendor/jsm/postprocessing/OutputPass.js';
import { RectAreaLightUniformsLib } from './vendor/jsm/lights/RectAreaLightUniformsLib.js';
import { Reflector } from './vendor/jsm/objects/Reflector.js';
import { RoomEnvironment } from './vendor/jsm/environments/RoomEnvironment.js';

const D = window.KDATA;
// settings: #sim;auto;t=58 (sim = no YouTube, auto = straight in, t = start time, low = phone quality)
const qs = new URLSearchParams((location.search.slice(1) + '&' + location.hash.slice(1)).replace(/;/g, '&'));
const SIM = qs.has('sim') || location.protocol === 'file:';
const LAST_END = D.times[D.times.length - 1][1];
const PHONE = Math.min(innerWidth, innerHeight) < 600;
const LOW = PHONE || qs.has('low');
if (SIM) document.body.classList.add('sim');
document.body.dataset.look = 'n';
const $ = (id) => document.getElementById(id);
const rnd = (a, b) => a + Math.random() * (b - a);

$('tagTitle').textContent = D.title;
$('tagArtist').textContent = D.artist + ' · ' + D.year;
$('lobbyTitle').textContent = D.title;
$('lobbyArtist').textContent = D.artist;
$('titleCard').querySelector('b').textContent = D.title;
$('titleCard').querySelector('span').textContent = D.artist;

// ---------------- the clip's colours and beat ----------------
const unb64 = (s) => Uint8Array.from(atob(s), (c) => c.charCodeAt(0));
const E = D.eq;
E.l = unb64(E.l); E.r = unb64(E.r); E.b = unb64(E.b); E.energy = unb64(E.energy);
const cur = new Float32Array(16 * 3 * 3), tgt = new Float32Array(16 * 3 * 3);   // rows: left, right, bottom edge
function target(t, out) {
  const f = Math.min(E.cframes - 1, Math.max(0, Math.floor(t * E.cfps)));
  for (let row = 0; row < 3; row++) {
    const src = row === 0 ? E.l : row === 1 ? E.r : E.b, n = row === 2 ? E.cols : E.rows;
    for (let i = 0; i < 16; i++) {
      const k = Math.min(n - 1, Math.round(i * (n - 1) / 15)), o = (f * n + k) * 3;
      for (let c = 0; c < 3; c++) out[(row * 16 + i) * 3 + c] = Math.pow(src[o + c] / 255, .6);   // edges are darker than the middle
    }
  }
}
function bassAt(t) {
  const f = Math.floor(t * E.fps), o = f * E.bands;
  if (f < 0 || o + 3 > E.energy.length) return 0;
  return (E.energy[o] + E.energy[o + 1] + E.energy[o + 2]) / 765;
}

// ---------------- renderers ----------------
let renderer;
try {
  renderer = new THREE.WebGLRenderer({ canvas: $('back'), antialias: !LOW, powerPreference: 'high-performance' });
} catch (er) { $('nogl').style.display = 'grid'; window.kinoLoaded && window.kinoLoaded(); throw er; }
const PR = Math.min(devicePixelRatio || 1, LOW ? 1 : 1.5);
renderer.setPixelRatio(PR);
renderer.toneMapping = THREE.ACESFilmicToneMapping;
renderer.toneMappingExposure = .85;
const front = new THREE.WebGLRenderer({ canvas: $('front'), alpha: true, antialias: false, premultipliedAlpha: true });
front.setPixelRatio(PR);
front.setClearColor(0x000000, 0);
const css = new CSS3DRenderer({ element: $('css3d') });

const scene = new THREE.Scene(), frontScene = new THREE.Scene(), cssScene = new THREE.Scene();
scene.background = new THREE.Color(0x010103);
scene.fog = new THREE.FogExp2(0x020206, .028);
const pmrem = new THREE.PMREMGenerator(renderer);
scene.environment = pmrem.fromScene(new RoomEnvironment(), .04).texture;
scene.environmentIntensity = .06;
RectAreaLightUniformsLib.init();

const camera = new THREE.PerspectiveCamera(45, 1, .1, 90);
const composer = new EffectComposer(renderer);
composer.addPass(new RenderPass(scene, camera));
const bloom = new UnrealBloomPass(new THREE.Vector2(256, 256), LOW ? .5 : .55, .55, .82);
composer.addPass(bloom);
composer.addPass(new OutputPass());

// ---------------- the hall: long, narrow, dark ----------------
const SW = 6.4, SH = SW * 9 / 16, SCY = 2.45, SZ = -7.9;    // the screen: width, height, centre height, depth (metres)
const BACK = -8, FRONT = 15, HALF = 5.6, TOP = 5.4;
const COLD = new THREE.Color(.16, .45, 1), WARM = new THREE.Color(1, .38, .08), VIOLET = new THREE.Color(.55, .25, 1);

function canvasTex(w, h, draw, repeat, linear) {
  const c = document.createElement('canvas'); c.width = w; c.height = h;
  draw(c.getContext('2d'), w, h);
  const t = new THREE.CanvasTexture(c);
  t.colorSpace = linear ? THREE.NoColorSpace : THREE.SRGBColorSpace;
  if (repeat) { t.wrapS = t.wrapT = THREE.RepeatWrapping; t.repeat.set(repeat[0], repeat[1]); }
  t.anisotropy = 4;
  return t;
}
const glowMat = (c, k) => new THREE.MeshBasicMaterial({ color: c.clone().multiplyScalar(k), toneMapped: false });

// side walls: tall dark glass panes with thin seams; they catch the neon
const paneTex = canvasTex(512, 256, (g, w, h) => {
  g.fillStyle = '#020203'; g.fillRect(0, 0, w, h);
  for (let x = 0; x < w; x += 128) {
    const gr = g.createLinearGradient(x, 0, x + 128, 0); gr.addColorStop(0, '#0b0c10'); gr.addColorStop(.5, '#08090c'); gr.addColorStop(1, '#0c0d11');
    g.fillStyle = gr; g.fillRect(x + 3, 0, 122, h);
  }
}, [(FRONT - BACK) / 2.2, 1]);
const paneRough = canvasTex(512, 256, (g, w, h) => {
  g.fillStyle = '#5a5a5a'; g.fillRect(0, 0, w, h);
  for (let x = 0; x < w; x += 128) { g.fillStyle = '#262626'; g.fillRect(x + 3, 0, 122, h); }
  for (let i = 0; i < 900; i++) { g.fillStyle = `rgba(110,110,110,${Math.random() * .25})`; g.fillRect(Math.random() * w, Math.random() * h, 1 + Math.random() * 2, 2 + Math.random() * 10); }
}, [(FRONT - BACK) / 2.2, 1], true);
for (const s of [-1, 1]) {
  const wall = new THREE.Mesh(new THREE.PlaneGeometry(FRONT - BACK, TOP), new THREE.MeshStandardMaterial({ map: paneTex, roughnessMap: paneRough, roughness: 1, metalness: .55, envMapIntensity: .5 }));
  wall.position.set(s * HALF, TOP / 2, (FRONT + BACK) / 2);
  wall.rotation.y = -s * Math.PI / 2;
  scene.add(wall);
}
// the back wall: matte black, so the screen's glow spreads on it
const backWall = new THREE.Mesh(new THREE.PlaneGeometry(HALF * 2, TOP), new THREE.MeshStandardMaterial({ color: 0x050507, roughness: .95 }));
backWall.position.set(0, TOP / 2, BACK);
scene.add(backWall);
const ceiling = new THREE.Mesh(new THREE.PlaneGeometry(HALF * 2, FRONT - BACK), new THREE.MeshStandardMaterial({ color: 0x030304, roughness: .9 }));
ceiling.position.set(0, TOP, (FRONT + BACK) / 2); ceiling.rotation.x = Math.PI / 2;
scene.add(ceiling);

// the floor: a mirror under a dark, wet layer with puddles (where it is wet, the mirror shows through)
const floorW = HALF * 2, floorD = FRONT - BACK, floorZ = (FRONT + BACK) / 2;
if (!LOW) {
  const mirror = new Reflector(new THREE.PlaneGeometry(floorW, floorD), {
    clipBias: .003, textureWidth: Math.round(innerWidth * PR * .5), textureHeight: Math.round(innerHeight * PR * .5), color: 0x6c6c74
  });
  mirror.rotation.x = -Math.PI / 2; mirror.position.set(0, 0, floorZ);
  scene.add(mirror);
}
const puddles = canvasTex(256, 256, (g, w, h) => {
  g.fillStyle = '#e6e6e6'; g.fillRect(0, 0, w, h);
  for (let i = 0; i < 70; i++) {
    const x = Math.random() * w, y = Math.random() * h, r = rnd(10, 50), gr = g.createRadialGradient(x, y, 0, x, y, r);
    gr.addColorStop(0, 'rgba(60,60,60,.95)'); gr.addColorStop(1, 'rgba(60,60,60,0)'); g.fillStyle = gr; g.fillRect(x - r, y - r, r * 2, r * 2);
  }
}, [2, 5], true);
const floorTop = new THREE.Mesh(new THREE.PlaneGeometry(floorW, floorD), new THREE.MeshStandardMaterial({
  color: 0x040406, roughness: LOW ? .25 : .45, metalness: LOW ? .6 : .1, transparent: !LOW, opacity: LOW ? 1 : .86, alphaMap: LOW ? null : puddles
}));
floorTop.rotation.x = -Math.PI / 2; floorTop.position.set(0, .004, floorZ);
scene.add(floorTop);

// ---------------- the neon ----------------
// long lines: a soft tube with a light pulse running towards the screen now and then (faster on the beat)
const lineMats = [];
function neonLine(a, b, col, k) {
  const len = a.distanceTo(b), geo = new THREE.CylinderGeometry(.014, .014, len, 8, 1, true);
  geo.rotateX(Math.PI / 2);
  const m = new THREE.ShaderMaterial({
    uniforms: { uCol: { value: col.clone() }, uK: { value: k }, uTime: { value: 0 }, uOn: { value: 0 }, uBeat: { value: 0 }, uLen: { value: len } },
    vertexShader: 'varying float vZ;void main(){vZ=position.z;gl_Position=projectionMatrix*modelViewMatrix*vec4(position,1.);}',
    fragmentShader: 'uniform vec3 uCol;uniform float uK,uTime,uOn,uBeat,uLen;varying float vZ;void main(){' +
      'float d=fract((vZ+uLen*.5)/uLen*1.2+uTime*.07);float pulse=smoothstep(.0,.05,d)*smoothstep(.13,.05,d);' +
      'gl_FragColor=vec4(uCol*uK*(.8+pulse*(.9+uBeat*1.5)+uBeat*.25)*uOn,1.);}',
    toneMapped: false
  });
  const mesh = new THREE.Mesh(geo, m);
  mesh.position.copy(a).add(b).multiplyScalar(.5); mesh.lookAt(b);
  scene.add(mesh); lineMats.push(m);
  return mesh;
}
const V3 = (x, y, z) => new THREE.Vector3(x, y, z);
for (const s of [-1, 1]) {
  const col = s < 0 ? COLD : WARM, x = s * (HALF - .03);
  neonLine(V3(x, .03, FRONT), V3(x, .03, BACK), col, 1.3);                          // where the wall meets the floor
  neonLine(V3(x, 1.05, FRONT), V3(x, 1.05, BACK + .4), col, 1.1);                   // low along the wall
  neonLine(V3(x, TOP - .03, FRONT), V3(x, TOP - .03, BACK), s < 0 ? COLD : VIOLET, 1);   // the ceiling edge
  neonLine(V3(s * (HALF - 1.05), .012, FRONT), V3(s * (HALF - 1.05), .012, SZ + 2.2), WARM, 1.25);   // the floor: two orange lines run to the screen
}
// tall tubes on the walls, each with a real light (its colour on the glass and the wet floor)
const tubes = [];
for (const s of [-1, 1]) for (const [z, k, wd] of [[2.5, 1.7, .04], [-2.6, 1.8, .04], [BACK + .12, 2.6, .05]]) {
  const col = s < 0 ? COLD : WARM, m = glowMat(col, k);
  const tb = new THREE.Mesh(new THREE.CylinderGeometry(wd / 2, wd / 2, TOP - .12, 10), m);
  tb.position.set(s * (HALF - .06), TOP / 2, z);
  scene.add(tb);
  let l = null;
  if (!LOW) {
    l = new THREE.RectAreaLight(col, 0, .1, TOP - .2);
    l.position.copy(tb.position); l.position.x -= s * .03; l.lookAt(0, TOP / 2, z + (z < -6 ? 3 : 0)); scene.add(l);
  }
  tubes.push({ m, col, k, l, phase: Math.random() * 6 });
}
// on a phone: one soft light per side instead of the six panel lights
const sideFill = LOW ? [-1, 1].map((s) => { const l = new THREE.PointLight(s < 0 ? COLD : WARM, 0, 12, 1.6); l.position.set(s * (HALF - .6), 1.4, -2); scene.add(l); return l; }) : [];

// ---------------- the screen ----------------
// a soft picture of the clip from its edges (mirrored by the floor, spread by the bloom), a glow behind it
const scrCanvas = document.createElement('canvas'); scrCanvas.width = 32; scrCanvas.height = 18;
const scrCtx = scrCanvas.getContext('2d'), scrImg = scrCtx.createImageData(32, 18);
const scrTex = new THREE.CanvasTexture(scrCanvas); scrTex.colorSpace = THREE.SRGBColorSpace;
const screenMat = new THREE.MeshBasicMaterial({ map: scrTex, toneMapped: false });
const screenMesh = new THREE.Mesh(new THREE.PlaneGeometry(SW, SH), screenMat);
screenMesh.position.set(0, SCY, SZ);
scene.add(screenMesh);
const haloTex = canvasTex(128, 128, (g, w, h) => {
  const gr = g.createRadialGradient(w / 2, h / 2, 0, w / 2, h / 2, w / 2); gr.addColorStop(0, 'rgba(255,255,255,.9)'); gr.addColorStop(.45, 'rgba(255,255,255,.28)'); gr.addColorStop(1, 'rgba(255,255,255,0)');
  g.fillStyle = gr; g.fillRect(0, 0, w, h);
});
const halo = new THREE.Mesh(new THREE.PlaneGeometry(SW * 2, SH * 2.3), new THREE.MeshBasicMaterial({ map: haloTex, transparent: true, blending: THREE.AdditiveBlending, depthWrite: false, toneMapped: false, opacity: 0 }));
halo.position.set(0, SCY, BACK + .02);
scene.add(halo);
// a thin edge round the screen, lit by the picture
const edgeMat = glowMat(new THREE.Color(1, 1, 1), .2);
for (const [w, h, x, y] of [[SW + .06, .02, 0, SCY + SH / 2 + .02], [SW + .06, .02, 0, SCY - SH / 2 - .02], [.02, SH + .06, -SW / 2 - .02, SCY], [.02, SH + .06, SW / 2 + .02, SCY]]) {
  const e = new THREE.Mesh(new THREE.PlaneGeometry(w, h), edgeMat); e.position.set(x, y, SZ - .005); scene.add(e);
}
const screenLight = new THREE.RectAreaLight(0xffffff, 0, SW, SH);
screenLight.position.set(0, SCY, SZ + .05); screenLight.lookAt(0, SCY, 0);
scene.add(screenLight);
const sideLights = [-1, 1].map((s) => { const l = new THREE.PointLight(0xffffff, 0, 12, 1.8); l.position.set(s * 2.6, SCY, SZ + .9); scene.add(l); return l; });
scene.add(new THREE.HemisphereLight(0x0d1428, 0x000000, .05));

// ---------------- haze ----------------
// soft wisps by the sides of the screen and low over the floor, tinted by the neon on their side (blue left,
// orange right) and by the clip in the middle; never over the middle of the clip
const smokeTex = (() => {
  const n = 128, c = document.createElement('canvas'); c.width = c.height = n;
  const g = c.getContext('2d'), img = g.createImageData(n, n);
  const hsh = (x, y) => { const s = Math.sin(x * 127.1 + y * 311.7) * 43758.5453; return s - Math.floor(s); };
  const vn = (x, y) => { const ix = Math.floor(x), iy = Math.floor(y); let fx = x - ix, fy = y - iy; fx = fx * fx * (3 - 2 * fx); fy = fy * fy * (3 - 2 * fy);
    return (hsh(ix, iy) * (1 - fx) + hsh(ix + 1, iy) * fx) * (1 - fy) + (hsh(ix, iy + 1) * (1 - fx) + hsh(ix + 1, iy + 1) * fx) * fy; };
  for (let y = 0; y < n; y++) for (let x = 0; x < n; x++) {
    const dx = x / n - .5, dy = y / n - .5, r = Math.sqrt(dx * dx + dy * dy) * 2;
    const no = vn(x / 22, y / 22) * .6 + vn(x / 10, y / 10) * .28 + vn(x / 5, y / 5) * .12;
    const a = Math.max(0, 1 - r) ** 2 * Math.max(0, no * 1.8 - .3), o = (y * n + x) * 4;
    img.data[o] = img.data[o + 1] = img.data[o + 2] = 255; img.data[o + 3] = Math.min(255, a * 255);
  }
  g.putImageData(img, 0, 0);
  const t = new THREE.CanvasTexture(c); t.colorSpace = THREE.SRGBColorSpace; return t;
})();
const wisps = [];
for (let i = 0; i < (LOW ? 14 : 34); i++) {
  const m = new THREE.SpriteMaterial({ map: smokeTex, transparent: true, depthWrite: false, opacity: 0, rotation: Math.random() * 6.28,
    blending: THREE.CustomBlending, blendEquation: THREE.AddEquation, blendSrc: THREE.SrcAlphaFactor, blendDst: THREE.OneFactor, blendSrcAlpha: THREE.ZeroFactor, blendDstAlpha: THREE.OneFactor });
  const s = new THREE.Sprite(m); frontScene.add(s);
  wisps.push({ sp: s, m });
}
function respawn(w) {
  const low = Math.random() < .45, side = Math.random() < .5 ? -1 : 1;
  w.sp.position.set(low ? rnd(-HALF + .4, HALF - .4) : side * rnd(SW / 2 + .2, HALF - .2), low ? rnd(.15, .7) : rnd(.4, 4.3), low ? rnd(-7.4, 1) : rnd(-7.6, -3));
  w.v = new THREE.Vector3(rnd(-.06, .06) + (low ? 0 : side * .03), rnd(.01, .05), rnd(-.02, .05));
  w.size = low ? rnd(2.2, 3.8) : rnd(1.8, 3.4); w.age = 0; w.life = 11 + Math.random() * 7; w.spin = rnd(-.05, .05);
}
wisps.forEach((w) => { respawn(w); w.age = Math.random() * w.life; });

// ---------------- the clip in 3D ----------------
const clipEl = document.createElement('div');
clipEl.className = 'clip';
clipEl.innerHTML = '<img class="poster" src="' + D.thumb + '" alt=""><div class="player"></div><div class="catch" hidden></div><button class="big-play" hidden aria-label="Přehrát"></button><div class="power"></div>';
const clipObj = new CSS3DObject(clipEl);
clipObj.position.set(0, SCY, SZ + .005);
clipObj.scale.setScalar(SW / 1280);
cssScene.add(clipObj);
const poster = clipEl.querySelector('.poster'), catcher = clipEl.querySelector('.catch'), bigPlay = clipEl.querySelector('.big-play'), powerEl = clipEl.querySelector('.power');

// ---------------- camera: from the far end of the hall, a slow glide in ----------------
const CAM = new THREE.Vector3(0, 1.6, 7), look = new THREE.Vector3();
const camFrom = new THREE.Vector3(0, 2.3, 16.5);
let camAt = 0, camMs = 1, portrait = false;
const mouse = { x: 0, y: 0 }, par = { x: 0, y: 0 };
function fit() {
  const w = innerWidth, h = innerHeight, aspect = w / h;
  portrait = h > w;
  const share = PHONE ? (portrait ? .8 : .36) : .46;        // how much of the width the screen takes
  const dist = CAM.z - SZ, tanH = (SW / 2 / share) / dist;
  camera.fov = Math.min(90, 2 * Math.atan(tanH / aspect) * 180 / Math.PI);
  camera.aspect = aspect; camera.updateProjectionMatrix();
  // aim so the middle of the screen sits at a set height (room for the words under it)
  look.set(0, SCY, SZ); camera.position.copy(CAM);
  const want = portrait ? .32 : PHONE ? .3 : .38;
  for (let n = 0; n < 6; n++) {
    camera.lookAt(look); camera.updateMatrixWorld();
    const c = new THREE.Vector3(0, SCY, SZ).project(camera);
    look.y += (want - (1 - c.y) / 2) * 7;
  }
  renderer.setSize(w, h, false); front.setSize(w, h, false); css.setSize(w, h); composer.setSize(w, h);
  fx.width = Math.round(w * PR); fx.height = Math.round(h * PR);
  placeWords();
}
addEventListener('pointermove', (ev) => { mouse.x = ev.clientX / innerWidth * 2 - 1; mouse.y = ev.clientY / innerHeight * 2 - 1; });

// ---------------- the clock ----------------
let clock = null, simT = qs.has('end') ? LAST_END + 7 : parseFloat(qs.get('t') || '0'), simPlaying = false, simAt = performance.now();
const now = () => clock ? clock.time() : simT + (simPlaying ? (performance.now() - simAt) / 1000 : 0);
const playing = () => clock ? clock.playing() : simPlaying;
const duration = () => clock && clock.duration() ? clock.duration() : E.cframes / E.cfps;
function play() { if (clock) clock.play(); else if (!simPlaying) { simAt = performance.now(); simPlaying = true; } }
function pause() { if (clock) clock.pause(); else if (simPlaying) { simT = now(); simPlaying = false; } }
function seek(t) { t = Math.max(0, Math.min(duration() - .5, t)); if (clock) clock.seek(t); else { simT = t; simAt = performance.now(); } rebuild(t); }
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

// ---------------- smoke for the words (2D, over everything but the words) ----------------
const fx = $('fx'), fg = fx.getContext('2d');
let smoke = [];
const smokeSprites = (() => {   // soft wisps of turbulent noise (as on the home page quote)
  const hash = (x, y, sd) => { const v = Math.sin(x * 127.1 + y * 311.7 + sd * 74.7) * 43758.5453; return v - Math.floor(v); };
  const noise = (x, y, sd) => { const ix = Math.floor(x), iy = Math.floor(y), fx2 = x - ix, fy = y - iy, ux = fx2 * fx2 * (3 - 2 * fx2), uy = fy * fy * (3 - 2 * fy);
    const a = hash(ix, iy, sd), b = hash(ix + 1, iy, sd), c = hash(ix, iy + 1, sd), d = hash(ix + 1, iy + 1, sd); return a + (b - a) * ux + (c - a) * uy + (a - b - c + d) * ux * uy; };
  const fbm = (x, y, sd) => { let v = 0, amp = .5; for (let o = 0; o < 5; o++) { v += amp * noise(x, y, sd); x *= 2.03; y *= 2.03; amp *= .5; } return v; };
  const S = 96, out = [];
  for (let k = 0; k < 3; k++) {
    const sd = k * 13.7 + 1, c = document.createElement('canvas'); c.width = c.height = S;
    const x = c.getContext('2d'), img = x.createImageData(S, S), o = img.data;
    for (let py = 0; py < S; py++) for (let px = 0; px < S; px++) {
      const u = px / S, v = py / S, dx = u - .5, dy = v - .5, r = Math.sqrt(dx * dx + dy * dy) * 2;
      const tt = fbm(u * 4 + fbm(u * 3 + 5, v * 3, sd) * 1.6, v * 4 + fbm(u * 3, v * 3 + 9, sd) * 1.6, sd);
      let al = Math.min(1, Math.max(0, (tt - .38) / .45)); al = al * al * (3 - 2 * al);
      const i = (py * S + px) * 4; o[i] = 200; o[i + 1] = 205; o[i + 2] = 220; o[i + 3] = Math.round(255 * al * Math.pow(Math.max(0, 1 - r), 1.6));
    }
    x.putImageData(img, 0, 0); out.push(c);
  }
  return out;
})();
const puff = (x, y, size, grow, life, alpha) => smoke.push({ x, y, age: 0, life, size, grow, rot: Math.random() * 6.28, vr: (Math.random() - .5) * .9, seed: Math.random() * 9, a: alpha, sp: smokeSprites[Math.floor(Math.random() * 3)] });
function drawFx(dt) {
  const W = innerWidth, H = innerHeight;
  fg.setTransform(PR, 0, 0, PR, 0, 0); fg.clearRect(0, 0, W, H);
  smoke = smoke.filter((m) => {
    m.age += dt; if (m.age > m.life) return false;
    const a = m.age / m.life, size = m.size + m.grow * m.age;
    m.y -= (26 - 10 * a) * dt; m.x += Math.sin(m.age * 1.6 + m.seed) * 12 * dt; m.rot += m.vr * dt;
    fg.globalAlpha = Math.min(1, m.age * 3) * Math.pow(1 - a, 1.4) * m.a;
    fg.save(); fg.translate(m.x, m.y); fg.rotate(m.rot); fg.drawImage(m.sp, -size / 2, -size / 2, size, size); fg.restore();
    return true;
  });
  fg.globalAlpha = 1;
}

// ---------------- the words ----------------
// At most three lines, the newest at the bottom. Its words are laid out in advance (so the line builds up
// centred) and each one is drawn in, left to right, as it is sung (CSS --p over the word's length), with a
// short glow. When the next line comes, the others move one step up: the one before turns white, the
// oldest dim; a fourth dissolves in smoke. After a pause in the singing all of them go up in smoke.
const AHEAD = .12, KEEP = 3, PAUSE = 3.5, lyricsEl = $('lyrics'), titleCard = $('titleCard'), dotsEl = $('dots');
let stack = [], shownIdx = -1;
function placeWords() {
  const h = innerHeight;
  const bottom = new THREE.Vector3(0, SCY - SH / 2, SZ).project(camera);
  const sy = (1 - bottom.y) / 2 * h, lh = lyricsEl.offsetHeight;
  lyricsEl.style.top = Math.max(sy + 6, Math.min(h - lh - 78, sy + (h - sy - 78 - lh) * .38)) + 'px';
}
const firstWord = (k) => (D.words[k] && D.words[k][0] ? D.words[k][0][0] : D.times[k][0]);
function makeLine(i) {
  const el = document.createElement('div'); el.className = 'line';
  const toks = D.lines[i].split(/\s+/), times = D.words[i] || [];
  el._w = toks.map((tok, k) => {
    const s = document.createElement('span'); s.className = 'w'; s.textContent = tok;
    const t = times[k] || D.times[i];
    s.style.setProperty('--dur', Math.min(.9, Math.max(.2, t[1] - t[0])).toFixed(2) + 's');
    el.appendChild(s); el.appendChild(document.createTextNode(' '));
    return { el: s, t };
  });
  el._i = i;
  lyricsEl.appendChild(el);
  return el;
}
function slots() { stack.forEach((l, k) => { l.dataset.slot = stack.length - 1 - k; }); }
function dissolve(l) {
  l.classList.add('gone');
  l.querySelectorAll('.w.in').forEach((w) => { const r = w.getBoundingClientRect(); puff(r.left + r.width / 2, r.top + r.height * .5, r.height * 1.1, r.height * 1.6, 1.8, .38); });
  setTimeout(() => l.remove(), 1500);
}
function push(i) {
  const el = makeLine(i); stack.push(el);
  while (stack.length > KEEP) dissolve(stack.shift());
  slots();
  return el;
}
function clearAll(instant) { stack.forEach((l) => (instant ? l.remove() : dissolve(l))); stack = []; }
function lineAt(t) { let i = -1; for (let k = 0; k < D.times.length; k++) { if (firstWord(k) - AHEAD - .3 <= t) i = k; else break; } return i; }
function rebuild(t) {   // after a jump: the line being sung and up to two before it (if they belong to the same verse)
  clearAll(true);
  const i = lineAt(t); shownIdx = i;
  if (i < 0 || t > D.times[i][1] + PAUSE) return;
  let from = i;
  while (from > 0 && i - from < KEEP - 1 && firstWord(from) - D.times[from - 1][1] < PAUSE) from--;
  for (let k = from; k <= i; k++) {
    const el = push(k); el.classList.add('instant');
    if (k < i) el._w.forEach((w) => { w.el.classList.add('in'); w.on = true; });
  }
  requestAnimationFrame(() => stack.forEach((l) => l.classList.remove('instant')));
}
function words(t) {
  const i = lineAt(t);
  if (i < shownIdx) { rebuild(t); return; }
  if (i > shownIdx) {
    if (stack.length && firstWord(i) - D.times[stack[stack.length - 1]._i][1] > PAUSE) clearAll(false);   // a new verse: start clean
    for (let k = shownIdx + 1; k <= i; k++) push(k);
    shownIdx = i;
  }
  const top = stack[stack.length - 1];
  if (top && t > D.times[top._i][1] + PAUSE && !(D.times[top._i + 1] && firstWord(top._i + 1) - t < 1)) clearAll(false);
  for (const l of stack) for (const w of l._w) {
    const shown = t >= w.t[0] - AHEAD, nw = shown && t < Math.max(w.t[1], w.t[0] + .3);
    if (shown !== w.on) { w.el.classList.toggle('in', shown); w.on = shown; }
    if (nw !== w.now) { w.el.classList.toggle('now', nw); w.now = nw; }
  }
  titleCard.classList.toggle('gone', t > D.times[0][0] - 1);
  let sung = -1; for (let s = 0; s < D.times.length && D.times[s][0] <= t; s++) sung = s;
  const next = D.times[sung + 1], prevEnd = sung >= 0 ? D.times[sung][1] : 0;
  const wait = next ? next[0] - .5 - t : 99, gap = next ? next[0] - prevEnd : 0;
  const showDots = next && sung >= 0 && gap > 5 && wait > 0 && wait < 3.2;
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
// a phone held upright: ask to turn it on its side (once dismissed, not again)
let turnDismissed = false;
function askToTurn() { $('rotate').hidden = !(PHONE && entered && !turnDismissed && innerHeight > innerWidth); }
$('rotateAnyway').onclick = () => { turnDismissed = true; askToTurn(); };
addEventListener('resize', () => { fit(); askToTurn(); });

// ---------------- in and out: the camera glides in, the neon flickers on, then the projector ----------------
let on = 0, onFrom = 0, onTo = 0, onAt = 0, onMs = 1, neon = .12, neonTo = .12;
const flicker = (p) => (p < .18 ? p / .18 * .55 : p < .26 ? .12 : p < .4 ? .7 : p < .46 ? .3 : Math.min(1, .3 + (p - .46) / .54 * .7));
function power(to, ms) { onFrom = on; onTo = to; onAt = performance.now(); onMs = ms; }
camera.position.copy(camFrom);
$('enter').onclick = () => {
  entered = true;
  $('lobby').classList.add('gone');
  camAt = performance.now(); camMs = 5200;
  setTimeout(() => { neonTo = 1; }, 500);
  setTimeout(() => power(1, 1600), 3200);
  setTimeout(startPlayer, 3800);
  askToTurn();
  wake();
};
function leave() {   // like the end of a film: the projector and the neon go down, fade to black, back to the karaoke list
  if (leave.done) return; leave.done = true;
  entered = false; pause(); power(0, 1200); neonTo = .05;
  clearAll(false);
  setTimeout(() => document.body.classList.add('fading'), 900);
  setTimeout(() => { try { sessionStorage.setItem('kinoOut', '1'); } catch (er) { /* no storage */ } location.href = '/karaoke-kino'; }, 2300);
}
if (qs.has('auto')) { entered = true; $('lobby').classList.add('gone'); on = onTo = 1; neon = neonTo = 1; camAt = -1e9; play(); }

// ---------------- every frame ----------------
const glide = (p) => 1 - Math.pow(1 - p, 3);   // the glide in: quick start, a long soft stop
let credited = false;
function credits() {
  return '<span class="ct">' + D.title + '</span><span class="cv">' + D.artist + ' · ' + D.year + '</span>' +
    '<span class="cl">Rap a text</span><span class="cv">' + D.artist + '</span>' +
    '<span class="cl">Karaoke</span><span class="cv">SKELO SQUAD</span>' +
    '<span class="cl">A hlavně</span><span class="cv">ty – díky, že sis zazpíval/a</span><span class="cs"></span>';
}
let last = performance.now(), beat = 0, bassAvg = 0, wasPlaying = null, started = false;
const avg = new THREE.Color(), tmp = new THREE.Color(), tmp2 = new THREE.Color();
target(Math.max(20, simT), cur);
fit();
if (qs.has('auto')) rebuild(now());
const edgeCol = (row, i, out) => { const o = (row * 16 + i) * 3; return out.setRGB(cur[o], cur[o + 1], cur[o + 2]); };

function frame(ts) {
  const dt = Math.min(.1, (ts - last) / 1000); last = ts;
  const t = now(), pl = playing(), sec = ts / 1000;

  if (onAt) { const p = Math.min(1, (ts - onAt) / onMs); on = onTo > onFrom ? onFrom + (onTo - onFrom) * flicker(p) : onFrom + (onTo - onFrom) * p; if (p >= 1) onAt = 0; }
  neon += (neonTo - neon) * (1 - Math.exp(-dt * 2.2));
  powerEl.style.opacity = (1 - on).toFixed(3);
  const k = camAt < 0 ? 1 : glide(Math.min(1, (ts - camAt) / camMs));
  par.x += (mouse.x - par.x) * (1 - Math.exp(-dt * 2)); par.y += (mouse.y - par.y) * (1 - Math.exp(-dt * 2));
  camera.position.lerpVectors(camFrom, CAM, k);
  camera.position.x += par.x * .3; camera.position.y -= par.y * .1;
  camera.lookAt(look);

  // the clip's colours
  if (entered && (pl || onAt)) target(t, tgt); else target(Math.max(t, 20), tgt);
  const kk = 1 - Math.exp(-dt * 5);
  let sr = 0, sg = 0, sb = 0;
  for (let i = 0; i < cur.length; i++) cur[i] += (tgt[i] - cur[i]) * kk;
  for (let j = 0; j < 48; j++) { sr += cur[j * 3]; sg += cur[j * 3 + 1]; sb += cur[j * 3 + 2]; }
  avg.setRGB(sr / 48, sg / 48, sb / 48);
  const lum = avg.r * .3 + avg.g * .59 + avg.b * .11;
  for (let y = 0; y < 18; y++) for (let x = 0; x < 32; x++) {
    const u = x / 31, v = y / 17, li = Math.round(v * 15), bi = Math.round(u * 15), wb = Math.max(0, Math.min(1, (v - .35) / .65)) * .65;
    edgeCol(0, li, tmp); edgeCol(1, li, tmp2); tmp.lerp(tmp2, u * u * (3 - 2 * u)); edgeCol(2, bi, tmp2); tmp.lerp(tmp2, wb);
    const o = (y * 32 + x) * 4; scrImg.data[o] = tmp.r * 255; scrImg.data[o + 1] = tmp.g * 255; scrImg.data[o + 2] = tmp.b * 255; scrImg.data[o + 3] = 255;
  }
  scrCtx.putImageData(scrImg, 0, 0); scrTex.needsUpdate = true;
  screenMat.color.setScalar(1.2 * on);
  screenLight.color.copy(avg); screenLight.intensity = (.4 + lum * 3.5) * on;
  halo.material.color.copy(avg); halo.material.opacity = .14 * on;
  edgeMat.color.copy(avg).multiplyScalar(.15 + .5 * on);
  for (const [i, l] of sideLights.entries()) {   // a grey clip lights the sides cold left / warm right like a film
    edgeCol(i, 7, tmp); const g = tmp.r * .3 + tmp.g * .59 + tmp.b * .11, sat = Math.max(tmp.r, tmp.g, tmp.b) - Math.min(tmp.r, tmp.g, tmp.b);
    tmp2.copy(i === 0 ? COLD : WARM).multiplyScalar(g * 1.6);
    l.color.copy(tmp2.lerp(tmp, Math.min(1, sat * 4))); l.intensity = 2.4 * on;
  }

  // the beat
  if (pl) { const b = bassAt(t); bassAvg += (b - bassAvg) * (1 - Math.exp(-dt / .7)); beat = Math.max(beat * Math.exp(-dt / .17), Math.min(1, Math.max(0, b - bassAvg * 1.08) * 4.5)); }
  else beat *= Math.exp(-dt / .3);

  // the neon: lines with running pulses, tubes breathing a little and catching the beat
  for (const m of lineMats) { m.uniforms.uTime.value = sec; m.uniforms.uOn.value = neon; m.uniforms.uBeat.value = beat; }
  for (const tb of tubes) {
    const br = (.88 + .12 * Math.sin(sec * .8 + tb.phase) + beat * .35) * neon;
    tb.m.color.copy(tb.col).multiplyScalar(tb.k * br);
    if (tb.l) tb.l.intensity = 1.3 * br;
  }
  for (const l of sideFill) l.intensity = 2.5 * neon * (1 + beat * .4);

  for (const w of wisps) {
    w.age += dt; if (w.age > w.life) respawn(w);
    w.sp.position.addScaledVector(w.v, dt);
    const f = w.age / w.life, s = w.size * (1 + f * .6), x = w.sp.position.x / HALF;
    w.sp.scale.set(s, s, 1); w.m.rotation += w.spin * dt;
    tmp.copy(x < 0 ? COLD : WARM); w.m.color.copy(avg).lerp(tmp, Math.min(1, Math.abs(x) * 1.4)).multiplyScalar(.75);
    w.m.opacity = (f < .2 ? f / .2 : 1 - (f - .2) / .8) * .2 * (.35 + .4 * neon + .25 * on);
  }

  // the end: the projector goes down, the titles roll
  const ended = entered && started && t > Math.min(duration() - 1.5, LAST_END + 6);
  if (ended && !credited) { credited = true; power(0, 2500); $('roll').innerHTML = credits(); $('credits').hidden = false; $('credits').classList.add('run'); }
  if (!ended && credited) { credited = false; power(1, 800); $('credits').hidden = true; $('credits').classList.remove('run'); }

  if (entered) words(t);
  drawFx(dt);
  if (pl && !started && (!clock || clock.time() > .3)) { started = true; if (clock) poster.style.display = 'none'; }
  if (clock && clock.time() > .3) catcher.classList.toggle('paused', !pl);
  $('fill').style.width = (t / duration() * 100) + '%';
  $('time').textContent = fmt(t) + ' / ' + fmt(duration());
  if (pl !== wasPlaying) { wasPlaying = pl; $('ppIcon').innerHTML = pl ? '<path d="M6 5h4v14H6zm8 0h4v14h-4z"/>' : '<path d="M8 5v14l11-7z"/>'; }

  composer.render(dt);
  css.render(cssScene, camera);
  front.render(frontScene, camera);
  requestAnimationFrame(frame);
}

// the loading screen stays up until every shader is built and a few frames are drawn, so going in does not jerk
(async () => {
  try { await Promise.all([renderer.compileAsync(scene, camera), front.compileAsync(frontScene, camera)]); } catch (er) { /* older browsers: compiled on the first frame */ }
  requestAnimationFrame(frame);
  let n = 0;
  const settle = () => { if (++n < 4) requestAnimationFrame(settle); else if (window.kinoLoaded) window.kinoLoaded(); };
  requestAnimationFrame(settle);
})();
