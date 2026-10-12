// Karaoke cinema in 3D (preview, round 2): a small, dark, futuristic room. Layers: the room (WebGL with bloom),
// the clip (an <iframe> placed in 3D by CSS3DRenderer, so it sits in the silver frame whatever the camera
// does), the beams and haze in front of it (a second, transparent WebGL canvas) and the words (HTML).
// The room is lit by the clip (the colours of its edges, eq/<id>.json, 4x a second); the lights move to its
// bass (16 bands, 20x a second).
import * as THREE from 'three';
import { CSS3DRenderer, CSS3DObject } from './vendor/jsm/renderers/CSS3DRenderer.js';
import { EffectComposer } from './vendor/jsm/postprocessing/EffectComposer.js';
import { RenderPass } from './vendor/jsm/postprocessing/RenderPass.js';
import { UnrealBloomPass } from './vendor/jsm/postprocessing/UnrealBloomPass.js';
import { OutputPass } from './vendor/jsm/postprocessing/OutputPass.js';
import { RectAreaLightUniformsLib } from './vendor/jsm/lights/RectAreaLightUniformsLib.js';
import { Reflector } from './vendor/jsm/objects/Reflector.js';
import { RoomEnvironment } from './vendor/jsm/environments/RoomEnvironment.js';
import { RoundedBoxGeometry } from './vendor/jsm/geometries/RoundedBoxGeometry.js';
import { buildKevin, ARMS } from '/js/kevin3d.js';

const D = window.KDATA;
// settings: #sim;auto;t=58 (sim = no YouTube, auto = straight in, t = start time, low = phone quality)
const qs = new URLSearchParams((location.search.slice(1) + '&' + location.hash.slice(1)).replace(/;/g, '&'));
const SIM = qs.has('sim') || location.protocol === 'file:';
const LAST_END = D.times[D.times.length - 1][1];
const PHONE = Math.min(innerWidth, innerHeight) < 600;
const LOW = PHONE || qs.has('low');
if (SIM) document.body.classList.add('sim');
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
const seen = {}, keys = D.lines.map((l) => { const k = l.toLowerCase().replace(/[^\p{L}\p{N}]+/gu, ''); seen[k] = (seen[k] || 0) + 1; return k; });
const isChorus = keys.map((k) => seen[k] > 1);   // the chorus: lines that come more than once

// ---------------- renderers ----------------
let renderer;
try {
  renderer = new THREE.WebGLRenderer({ canvas: $('back'), antialias: !LOW, powerPreference: 'high-performance' });
} catch (er) { $('nogl').style.display = 'grid'; throw er; }
const PR = Math.min(devicePixelRatio || 1, LOW ? 1 : 1.5);
renderer.setPixelRatio(PR);
renderer.toneMapping = THREE.ACESFilmicToneMapping;
renderer.toneMappingExposure = .8;
const front = new THREE.WebGLRenderer({ canvas: $('front'), alpha: true, antialias: false, premultipliedAlpha: true });
front.setPixelRatio(PR);
front.setClearColor(0x000000, 0);
const css = new CSS3DRenderer({ element: $('css3d') });

const scene = new THREE.Scene(), frontScene = new THREE.Scene(), cssScene = new THREE.Scene();
scene.background = new THREE.Color(0x010102);
scene.fog = new THREE.FogExp2(0x020204, .03);
const pmrem = new THREE.PMREMGenerator(renderer);
scene.environment = pmrem.fromScene(new RoomEnvironment(), .04).texture;
scene.environmentIntensity = .1;
RectAreaLightUniformsLib.init();

const camera = new THREE.PerspectiveCamera(45, 1, .1, 80);
const composer = new EffectComposer(renderer);
composer.addPass(new RenderPass(scene, camera));
const bloom = new UnrealBloomPass(new THREE.Vector2(256, 256), LOW ? .4 : .5, .55, .82);
composer.addPass(bloom);
composer.addPass(new OutputPass());

// ---------------- the room: small and dark ----------------
const SW = 7.2, SH = SW * 9 / 16, SCY = 3.05, SZ = -6;     // the screen: width, height, centre height, depth (metres)
const BACK = -6.3, FRONT = 6.5, HALF = 6.2, TOP = 6.6;
const GOLD = new THREE.Color(1, .72, .2), COLD = new THREE.Color(.25, .55, 1), WARM = new THREE.Color(1, .45, .12);

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

// back wall: dark panels whose joints glow faintly (sci-fi)
const panelDraw = (seam) => (g, w, h) => {
  g.fillStyle = seam ? '#000' : '#0b0b0e'; g.fillRect(0, 0, w, h);
  for (let y = 0; y < 4; y++) for (let x = 0; x < 6; x++) {
    const v = seam ? 0 : 14 + Math.random() * 5;
    g.fillStyle = seam ? '#000' : `rgb(${v},${v},${v + 3})`;
    g.fillRect(x * w / 6 + 2, y * h / 4 + 2, w / 6 - 4, h / 4 - 4);
  }
  if (seam) { g.strokeStyle = '#fff'; g.lineWidth = 1.2; for (let x = 0; x <= 6; x++) { g.beginPath(); g.moveTo(x * w / 6, 0); g.lineTo(x * w / 6, h); g.stroke(); } for (let y = 0; y <= 4; y++) { g.beginPath(); g.moveTo(0, y * h / 4); g.lineTo(w, y * h / 4); g.stroke(); } }
};
const backWall = new THREE.Mesh(new THREE.PlaneGeometry(HALF * 2, TOP), new THREE.MeshStandardMaterial({
  map: canvasTex(768, 512, panelDraw(false), [2, 1.3]), emissiveMap: canvasTex(768, 512, panelDraw(true), [2, 1.3]),
  emissive: new THREE.Color(.25, .45, .8), emissiveIntensity: .12, roughness: .75
}));
backWall.position.set(0, TOP / 2, BACK);
scene.add(backWall);
// side walls: smooth dark panels
const sideTex = canvasTex(512, 128, (g, w, h) => {
  g.fillStyle = '#09090b'; g.fillRect(0, 0, w, h);
  for (let x = 0; x < w; x += 64) { g.fillStyle = '#0f0f12'; g.fillRect(x + 2, 0, 60, h); }
}, [3, 1]);
for (const s of [-1, 1]) {
  const wall = new THREE.Mesh(new THREE.PlaneGeometry(FRONT - BACK, TOP), new THREE.MeshStandardMaterial({ map: sideTex, roughness: .4, metalness: .3 }));
  wall.position.set(s * HALF, TOP / 2, (FRONT + BACK) / 2);
  wall.rotation.y = -s * Math.PI / 2;
  scene.add(wall);
}
const ceiling = new THREE.Mesh(new THREE.PlaneGeometry(HALF * 2, FRONT - BACK), new THREE.MeshStandardMaterial({ color: 0x050507, roughness: .9 }));
ceiling.position.set(0, TOP, (FRONT + BACK) / 2); ceiling.rotation.x = Math.PI / 2;
scene.add(ceiling);

// the floor: a mirror under a dark, partly wet layer
const floorW = HALF * 2, floorD = FRONT - BACK, floorZ = (FRONT + BACK) / 2;
if (!LOW) {
  const mirror = new Reflector(new THREE.PlaneGeometry(floorW, floorD), {
    clipBias: .003, textureWidth: Math.round(innerWidth * PR * .5), textureHeight: Math.round(innerHeight * PR * .5), color: 0x707078
  });
  mirror.rotation.x = -Math.PI / 2; mirror.position.set(0, 0, floorZ);
  scene.add(mirror);
}
const puddles = canvasTex(256, 256, (g, w, h) => {
  g.fillStyle = '#ececec'; g.fillRect(0, 0, w, h);
  for (let i = 0; i < 60; i++) {
    const x = Math.random() * w, y = Math.random() * h, r = rnd(10, 46), gr = g.createRadialGradient(x, y, 0, x, y, r);
    gr.addColorStop(0, 'rgba(80,80,80,.9)'); gr.addColorStop(1, 'rgba(80,80,80,0)'); g.fillStyle = gr; g.fillRect(x - r, y - r, r * 2, r * 2);
  }
}, [3, 3], true);
const floorTop = new THREE.Mesh(new THREE.PlaneGeometry(floorW, floorD), new THREE.MeshStandardMaterial({
  color: 0x040405, roughness: LOW ? .3 : .5, metalness: LOW ? .5 : .1, transparent: !LOW, opacity: LOW ? 1 : .9, alphaMap: LOW ? null : puddles
}));
floorTop.rotation.x = -Math.PI / 2; floorTop.position.set(0, .004, floorZ);
scene.add(floorTop);

// the stage, glossy black with a gold line on its edge
const stage = new THREE.Mesh(new THREE.BoxGeometry(HALF * 2, .4, 1.6), new THREE.MeshStandardMaterial({ color: 0x08080a, roughness: .25, metalness: .6 }));
stage.position.set(0, .2, BACK + .8);
scene.add(stage);
const stageLed = new THREE.Mesh(new THREE.BoxGeometry(HALF * 2, .025, .025), glowMat(GOLD, 1.1));
stageLed.position.set(0, .395, BACK + 1.61);
scene.add(stageLed);

// light lines along the room (sci-fi): the edges of floor and ceiling and lines on the side walls; light pulses
// run along them towards the screen, now and then
const flowMats = [];
function flowLine(a, b, col, k) {
  const len = a.distanceTo(b), geo = new THREE.BoxGeometry(.022, .022, len);
  const m = new THREE.ShaderMaterial({
    uniforms: { uCol: { value: col.clone() }, uK: { value: k }, uTime: { value: 0 }, uOn: { value: 0 }, uBeat: { value: 0 }, uLen: { value: len } },
    vertexShader: 'varying float vZ;void main(){vZ=position.z;gl_Position=projectionMatrix*modelViewMatrix*vec4(position,1.);}',
    fragmentShader: 'uniform vec3 uCol;uniform float uK,uTime,uOn,uBeat,uLen;varying float vZ;void main(){' +
      'float d=fract((vZ+uLen*.5)/uLen*1.5+uTime*.12);float pulse=smoothstep(.0,.06,d)*smoothstep(.16,.06,d);' +
      'gl_FragColor=vec4(uCol*uK*(.35+pulse*(1.4+uBeat))*uOn,1.);}',
    toneMapped: false
  });
  const mesh = new THREE.Mesh(geo, m);
  mesh.position.copy(a).add(b).multiplyScalar(.5); mesh.lookAt(b);
  scene.add(mesh); flowMats.push(m);
}
for (const s of [-1, 1]) {
  const col = s < 0 ? COLD : WARM, x = s * (HALF - .02);
  flowLine(new THREE.Vector3(x, .02, FRONT), new THREE.Vector3(x, .02, BACK), col, 1.2);          // floor edge
  flowLine(new THREE.Vector3(x, TOP - .02, FRONT), new THREE.Vector3(x, TOP - .02, BACK), col, .9); // ceiling edge
  flowLine(new THREE.Vector3(x, 2.4, FRONT), new THREE.Vector3(x, 2.4, BACK), col, .5);            // along the wall
}
// back corners: vertical lines
const cornerLights = [];
for (const s of [-1, 1]) for (const [z, k, wd] of [[BACK + .05, 2.6, .05], [-.6, 1.7, .035]]) {
  const col = s < 0 ? COLD : WARM, m = glowMat(col, k); m.userData.k = k; m.userData.base = col.clone();
  const tb = new THREE.Mesh(new THREE.CylinderGeometry(wd / 2, wd / 2, TOP - .1, 10), m); tb.position.set(s * (HALF - .05), TOP / 2, z);
  scene.add(tb); flowMats.push({ glow: m });
  if (!LOW) {
    const l = new THREE.RectAreaLight(col, 0, .12, TOP - .2);
    l.position.copy(tb.position); l.lookAt(0, TOP / 2, z + (z < -3 ? 4 : 0)); scene.add(l); cornerLights.push(l);
  }
}

// the screen in the room: a soft picture of the clip from its edges (mirrored by the floor, spread by the bloom)
const scrCanvas = document.createElement('canvas'); scrCanvas.width = 32; scrCanvas.height = 18;
const scrCtx = scrCanvas.getContext('2d'), scrImg = scrCtx.createImageData(32, 18);
const scrTex = new THREE.CanvasTexture(scrCanvas); scrTex.colorSpace = THREE.SRGBColorSpace;
const screenMat = new THREE.MeshBasicMaterial({ map: scrTex, toneMapped: false });
const screenMesh = new THREE.Mesh(new THREE.PlaneGeometry(SW, SH), screenMat);
screenMesh.position.set(0, SCY, SZ);
scene.add(screenMesh);
const haloTex = canvasTex(128, 128, (g, w, h) => {
  const gr = g.createRadialGradient(w / 2, h / 2, 0, w / 2, h / 2, w / 2); gr.addColorStop(0, 'rgba(255,255,255,.9)'); gr.addColorStop(.45, 'rgba(255,255,255,.3)'); gr.addColorStop(1, 'rgba(255,255,255,0)');
  g.fillStyle = gr; g.fillRect(0, 0, w, h);
});
const halo = new THREE.Mesh(new THREE.PlaneGeometry(SW * 1.8, SH * 2), new THREE.MeshBasicMaterial({ map: haloTex, transparent: true, blending: THREE.AdditiveBlending, depthWrite: false, toneMapped: false, opacity: 0 }));
halo.position.set(0, SCY, BACK + .02);
scene.add(halo);
const screenLight = new THREE.RectAreaLight(0xffffff, 0, SW, SH);
screenLight.position.set(0, SCY, SZ + .05); screenLight.lookAt(0, SCY, 0);
scene.add(screenLight);
const sideLights = [-1, 1].map((s) => { const l = new THREE.PointLight(0xffffff, 0, 14, 1.8); l.position.set(s * 3, SCY, SZ + .8); scene.add(l); return l; });
scene.add(new THREE.HemisphereLight(0x101826, 0x000000, .06));

// the frame: polished silver
const frameMat = new THREE.MeshStandardMaterial({ color: 0xc9ccd2, metalness: 1, roughness: .1, envMapIntensity: 1.6 });
const FT = .13;
function roundRect(w, hh, r, hole) {
  const p = hole ? new THREE.Path() : new THREE.Shape(), x = -w / 2, y = -hh / 2;
  p.moveTo(x + r, y); p.lineTo(x + w - r, y); p.quadraticCurveTo(x + w, y, x + w, y + r); p.lineTo(x + w, y + hh - r);
  p.quadraticCurveTo(x + w, y + hh, x + w - r, y + hh); p.lineTo(x + r, y + hh); p.quadraticCurveTo(x, y + hh, x, y + hh - r);
  p.lineTo(x, y + r); p.quadraticCurveTo(x, y, x + r, y);
  return p;
}
function ring(w, hh, t, r) { const sh = roundRect(w, hh, r); sh.holes.push(roundRect(w - t * 2, hh - t * 2, Math.max(.001, r - t), true)); return sh; }
const frameGeo = new THREE.ExtrudeGeometry(ring(SW + FT * 2, SH + FT * 2, FT, .12), { depth: .04, bevelEnabled: true, bevelThickness: .035, bevelSize: .03, bevelSegments: 6, curveSegments: 16 });
const frame3 = new THREE.Mesh(frameGeo, frameMat); frame3.position.set(0, SCY, SZ - .04); scene.add(frame3);
const goldLine = new THREE.Mesh(new THREE.ShapeGeometry(ring(SW + FT * 2 + .14, SH + FT * 2 + .14, .022, .19), 16), glowMat(GOLD, 1.3));
goldLine.position.set(0, SCY, SZ - .07); scene.add(goldLine);

// the SKELO SQUAD neon above the frame
const signMat = new THREE.MeshBasicMaterial({ transparent: true, depthWrite: false, toneMapped: false, color: new THREE.Color(1.7, 1.2, .35), opacity: 0 });
const sign = new THREE.Mesh(new THREE.PlaneGeometry(3.4, 3.4 * 182 / 720), signMat);
sign.position.set(0, SCY + SH / 2 + .72, BACK + .05);
scene.add(sign);
const logo = new Image();
logo.onload = () => {
  signMat.map = canvasTex(720, 182, (g, w, h) => { g.drawImage(logo, 0, 0, w, h); g.globalCompositeOperation = 'source-in'; g.fillStyle = '#fff'; g.fillRect(0, 0, w, h); });
  signMat.needsUpdate = true;
};
logo.src = '/img/squad-logo.webp';

// speakers on the stage: the cones move with the bass, a small LED
const speakers = [];
const rubber = new THREE.MeshStandardMaterial({ color: 0x0e0e10, roughness: .55 });
const coneMat = new THREE.MeshStandardMaterial({ color: 0x15151a, roughness: .4, metalness: .25, side: THREE.DoubleSide });
for (const s of [-1, 1]) {
  const g = new THREE.Group();
  const box = new THREE.Mesh(new RoundedBoxGeometry(.95, 3.1, .8, 4, .06), new THREE.MeshStandardMaterial({ color: 0x0a0a0c, roughness: .3, metalness: .5 }));
  box.position.y = 1.55; g.add(box);
  const cones = [];
  for (const [yy, r] of [[.62, .32], [1.48, .32], [2.32, .24]]) {
    const c = new THREE.Group();
    c.add(new THREE.Mesh(new THREE.TorusGeometry(r + .035, .025, 10, 40), frameMat));
    c.add(new THREE.Mesh(new THREE.TorusGeometry(r, .03, 10, 40), rubber));
    const cone = new THREE.Mesh(new THREE.CylinderGeometry(r, r * .25, .14, 40, 1, true), coneMat);
    cone.rotation.x = Math.PI / 2; cone.position.z = -.07; c.add(cone);
    const cap = new THREE.Mesh(new THREE.SphereGeometry(r * .24, 20, 10, 0, Math.PI * 2, 0, Math.PI / 2), rubber);
    cap.rotation.x = Math.PI / 2; cap.position.z = -.1; c.add(cap);
    c.position.set(0, yy, .41);
    g.add(c); cones.push(c);
  }
  // a thin light line down the front edge (sci-fi)
  const stripM = glowMat(s < 0 ? COLD : WARM, 1); const strip = new THREE.Mesh(new THREE.BoxGeometry(.018, 2.9, .018), stripM);
  strip.position.set(-s * .44, 1.55, .41); g.add(strip);
  const ledM = glowMat(s < 0 ? COLD : WARM, 3);
  const led = new THREE.Mesh(new THREE.SphereGeometry(.025, 10, 8), ledM);
  led.position.set(0, 2.92, .42); g.add(led);
  g.position.set(s * 4.55, .4, BACK + .7);
  scene.add(g);
  speakers.push({ cones, ledM, stripM, col: s < 0 ? COLD : WARM });
}

// two short rows of velvet seats (an empty one in the front row: Kevin's)
const seatBackGeo = new RoundedBoxGeometry(.56, .78, .12, 2, .05), seatGeo = new RoundedBoxGeometry(.52, .13, .5, 2, .05), armGeo = new THREE.BoxGeometry(.07, .2, .5);
const velvet = new THREE.MeshPhysicalMaterial({ color: 0x1c080b, roughness: .9, sheen: 1, sheenColor: new THREE.Color(.4, .12, .15), sheenRoughness: .45 });
const armMat = new THREE.MeshStandardMaterial({ color: 0x0a0a0c, roughness: .3, metalness: .4 });
const ROWS = [1.2, 2.5], PER = 7, GAP = .66;
const KEVIN_SEAT = { row: 0, i: 4 };
const nSeats = ROWS.length * PER - 1;
const backs = new THREE.InstancedMesh(seatBackGeo, velvet, nSeats), cushions = new THREE.InstancedMesh(seatGeo, velvet, nSeats), arms = new THREE.InstancedMesh(armGeo, armMat, ROWS.length * (PER + 1));
const m4 = new THREE.Matrix4(), q = new THREE.Quaternion().setFromEuler(new THREE.Euler(-.13, 0, 0)), one = new THREE.Vector3(1, 1, 1);
let si = 0, ai = 0;
ROWS.forEach((z, r) => {
  for (let i = 0; i < PER; i++) {
    const x = (i - (PER - 1) / 2) * GAP;
    if (r === KEVIN_SEAT.row && i === KEVIN_SEAT.i) continue;
    backs.setMatrixAt(si, m4.compose(new THREE.Vector3(x, .84, z + .24), q, one));
    cushions.setMatrixAt(si, m4.compose(new THREE.Vector3(x, .47, z), new THREE.Quaternion(), one));
    si++;
  }
  for (let i = 0; i <= PER; i++) arms.setMatrixAt(ai++, m4.makeTranslation((i - PER / 2) * GAP, .62, z + .02));
});
scene.add(backs, cushions, arms);

// stars in the ceiling
const N_STARS = LOW ? 120 : 260, sp = new Float32Array(N_STARS * 3), sf = new Float32Array(N_STARS), starGeo = new THREE.BufferGeometry();
for (let i = 0; i < N_STARS; i++) { sp[i * 3] = rnd(-HALF + .3, HALF - .3); sp[i * 3 + 1] = TOP - .02; sp[i * 3 + 2] = rnd(BACK + .3, FRONT - .3); sf[i] = Math.random() * 6.28; }
starGeo.setAttribute('position', new THREE.BufferAttribute(sp, 3)); starGeo.setAttribute('phase', new THREE.BufferAttribute(sf, 1));
const starMat = new THREE.ShaderMaterial({
  uniforms: { uTime: { value: 0 }, uOn: { value: 0 }, uPix: { value: PR } },
  vertexShader: 'attribute float phase;uniform float uTime,uPix;varying float vA;void main(){vec4 mv=modelViewMatrix*vec4(position,1.);gl_Position=projectionMatrix*mv;' +
    'vA=.3+.7*pow(.5+.5*sin(uTime*(.6+fract(phase*7.)*1.7)+phase*9.),3.);gl_PointSize=uPix*(1.6+fract(phase*13.)*2.)*(12./-mv.z);}',
  fragmentShader: 'uniform float uOn;varying float vA;void main(){float d=length(gl_PointCoord-.5);float a=smoothstep(.5,0.,d);gl_FragColor=vec4(vec3(1.3,1.2,1.)*a*vA*uOn,1.);}',
  transparent: true, blending: THREE.AdditiveBlending, depthWrite: false, toneMapped: false
});
scene.add(new THREE.Points(starGeo, starMat));

// sci-fi light pylons by the side walls: glossy black, glowing rings, a round light head on top whose beam
// crosses the room (beams are drawn in front of everything)
const heads = [];
const pylonMat = new THREE.MeshStandardMaterial({ color: 0x08080a, roughness: .15, metalness: .9 });
const beamGeo = new THREE.CylinderGeometry(.05, 1, 1, 40, 1, true); beamGeo.translate(0, -.5, 0);
const beamMat = (col) => new THREE.ShaderMaterial({
  uniforms: { uColor: { value: col.clone() }, uInt: { value: 0 }, uTime: { value: 0 } },
  vertexShader: 'varying float vL;varying vec3 vN,vV,vW;void main(){vL=-position.y;vec4 w=modelMatrix*vec4(position,1.);vW=w.xyz;vec4 mv=viewMatrix*w;vV=-mv.xyz;' +
    'vN=normalize(normalMatrix*normal);gl_Position=projectionMatrix*mv;}',
  fragmentShader: 'uniform vec3 uColor;uniform float uInt,uTime;varying float vL;varying vec3 vN,vV,vW;' +
    'void main(){float f=abs(dot(normalize(vN),normalize(vV)));float edge=pow(f,2.4);float along=pow(1.-vL,1.8)*smoothstep(0.,.04,vL);' +
    'float dust=.75+.25*sin(vW.y*3.1+uTime*.7+vW.x*2.)*sin(vW.z*2.3-uTime*.5);gl_FragColor=vec4(uColor*edge*along*dust*uInt,0.);}',
  transparent: true, depthWrite: false, side: THREE.DoubleSide,
  blending: THREE.CustomBlending, blendEquation: THREE.AddEquation,
  blendSrc: THREE.OneFactor, blendDst: THREE.OneFactor, blendSrcAlpha: THREE.ZeroFactor, blendDstAlpha: THREE.OneFactor
});
const ringMats = [];
for (const s of [-1, 1]) {
  const col = s < 0 ? COLD : WARM, x = s * (HALF - .55), z = -3.2;
  const pylon = new THREE.Mesh(new RoundedBoxGeometry(.26, 4.6, .26, 3, .06), pylonMat);
  pylon.position.set(x, 2.3, z); scene.add(pylon);
  for (const y of [.8, 1.7, 2.6, 3.5]) {   // glowing rings round the pylon
    const rm = glowMat(col, .8); ringMats.push({ m: rm, col, y });
    const ring = new THREE.Mesh(new THREE.TorusGeometry(.2, .012, 8, 40), rm); ring.rotation.x = Math.PI / 2; ring.position.set(x, y, z); scene.add(ring);
  }
  for (let k = 0; k < (LOW ? 1 : 2); k++) {
    const y = 4.75 + k * .02, hx = x - s * k * .0;
    const head = new THREE.Mesh(new THREE.SphereGeometry(.2, 24, 16), pylonMat); head.position.set(hx, y, z + (k ? .45 : -.45)); scene.add(head);
    const lensM = glowMat(k ? GOLD : col, 1.4);
    const lens = new THREE.Mesh(new THREE.TorusGeometry(.12, .025, 8, 32), lensM); lens.position.copy(head.position); lens.lookAt(0, 1, 2); lens.translateZ(.17); scene.add(lens);
    const beam = new THREE.Mesh(beamGeo, beamMat(k ? GOLD : col)); frontScene.add(beam);
    const spot = new THREE.SpotLight(k ? GOLD : col, 0, 22, .14, .7, 1.4); spot.position.copy(lens.position);
    scene.add(spot, spot.target);
    heads.push({ s, k, origin: lens.position.clone(), beam, spot, lensM, col: k ? GOLD : col, phase: Math.random() * 6 });
  }
}

// haze in front: soft wisps at the sides of the screen and low over the stage, never over the middle of the clip
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
for (let i = 0; i < (LOW ? 10 : 24); i++) {
  const m = new THREE.SpriteMaterial({ map: smokeTex, transparent: true, depthWrite: false, opacity: 0, rotation: Math.random() * 6.28,
    blending: THREE.CustomBlending, blendEquation: THREE.AddEquation, blendSrc: THREE.SrcAlphaFactor, blendDst: THREE.OneFactor, blendSrcAlpha: THREE.ZeroFactor, blendDstAlpha: THREE.OneFactor });
  const s = new THREE.Sprite(m); frontScene.add(s);
  wisps.push({ sp: s, m });
}
function respawn(w) {
  const low = Math.random() < .5, side = Math.random() < .5 ? -1 : 1;
  w.sp.position.set(low ? rnd(-5, 5) : side * rnd(3.9, 5.8), low ? rnd(.25, .9) : rnd(.8, 4.6), rnd(-5.6, -2));
  w.v = new THREE.Vector3(rnd(-.06, .06) + (low ? 0 : side * .04), rnd(.01, .05), rnd(-.02, .04));
  w.size = rnd(1.6, 3.2); w.age = 0; w.life = 10 + Math.random() * 6; w.spin = rnd(-.05, .05);
}
wisps.forEach((w) => { respawn(w); w.age = Math.random() * w.life; });

// lasers from the front corners of the stage, only in the chorus: fans of thin gold lines over the room
const lasers = [];
const laserMat = (col, k) => new THREE.ShaderMaterial({
  uniforms: { uColor: { value: col.clone().multiplyScalar(k) }, uInt: { value: 0 } },
  vertexShader: 'varying float vL;void main(){vL=position.y;gl_Position=projectionMatrix*modelViewMatrix*vec4(position,1.);}',
  fragmentShader: 'uniform vec3 uColor;uniform float uInt;varying float vL;void main(){gl_FragColor=vec4(uColor*uInt*pow(1.-vL,.8),0.);}',
  transparent: true, depthWrite: false, blending: THREE.CustomBlending, blendEquation: THREE.AddEquation,
  blendSrc: THREE.OneFactor, blendDst: THREE.OneFactor, blendSrcAlpha: THREE.ZeroFactor, blendDstAlpha: THREE.OneFactor
});
const coreGeo = new THREE.CylinderGeometry(.01, .01, 1, 6, 1, true); coreGeo.translate(0, .5, 0);
const glowGeo = new THREE.CylinderGeometry(.06, .06, 1, 8, 1, true); glowGeo.translate(0, .5, 0);
for (const s of [-1, 1]) for (let j = 0; j < (LOW ? 4 : 7); j++) {
  const col = j % 3 === 1 ? (s < 0 ? COLD : WARM) : GOLD;
  const core = new THREE.Mesh(coreGeo, laserMat(col, 3)), glow = new THREE.Mesh(glowGeo, laserMat(col, .35));
  const origin = new THREE.Vector3(s * (HALF - 1.1), .45, BACK + 1.62);
  core.position.copy(origin); glow.position.copy(origin); frontScene.add(core, glow);
  lasers.push({ s, j, core, glow });
}
// a rain of gold glitter (chorus starts, the end of the song); never over the clip
const N_RAIN = LOW ? 250 : 600, rainPos = new Float32Array(N_RAIN * 3), rainLife = new Float32Array(N_RAIN), rainSeed = new Float32Array(N_RAIN), rainVel = new Float32Array(N_RAIN);
for (let i = 0; i < N_RAIN; i++) { rainSeed[i] = Math.random(); rainPos[i * 3 + 1] = -10; }
const rainGeo = new THREE.BufferGeometry();
rainGeo.setAttribute('position', new THREE.BufferAttribute(rainPos, 3)); rainGeo.setAttribute('aLife', new THREE.BufferAttribute(rainLife, 1)); rainGeo.setAttribute('aSeed', new THREE.BufferAttribute(rainSeed, 1));
const rainMat = new THREE.ShaderMaterial({
  uniforms: { uScr: { value: new THREE.Vector4() }, uPix: { value: PR }, uTime: { value: 0 } },
  vertexShader: 'attribute float aLife,aSeed;uniform vec4 uScr;uniform float uPix,uTime;varying float vA;void main(){vec4 mv=modelViewMatrix*vec4(position,1.);gl_Position=projectionMatrix*mv;' +
    'vec2 n=gl_Position.xy/gl_Position.w;float inside=step(uScr.x,n.x)*step(n.x,uScr.z)*step(uScr.y,n.y)*step(n.y,uScr.w);' +
    'vA=aLife*(1.-inside*.95)*(.35+.65*pow(.5+.5*sin(uTime*(6.+aSeed*9.)+aSeed*40.),2.));gl_PointSize=uPix*(2.+aSeed*3.)*(9./-mv.z);}',
  fragmentShader: 'varying float vA;void main(){float d=length(gl_PointCoord-.5);float a=smoothstep(.5,0.,d);gl_FragColor=vec4(vec3(1.,.78,.3)*1.6*a*vA,0.);}',
  transparent: true, depthWrite: false, blending: THREE.CustomBlending, blendEquation: THREE.AddEquation,
  blendSrc: THREE.OneFactor, blendDst: THREE.OneFactor, blendSrcAlpha: THREE.ZeroFactor, blendDstAlpha: THREE.OneFactor
});
const rain = new THREE.Points(rainGeo, rainMat); rain.frustumCulled = false; frontScene.add(rain);
function spawnRain(n) {
  for (let i = 0; i < N_RAIN && n > 0; i++) {
    if (rainLife[i] > 0) continue;
    rainPos[i * 3] = rnd(-HALF + .5, HALF - .5); rainPos[i * 3 + 1] = rnd(TOP - .2, TOP + 2.5); rainPos[i * 3 + 2] = rnd(-4.5, 3.5);
    rainVel[i] = rnd(.45, 1.1); rainLife[i] = 1; n--;
  }
}
// the curtain: red velvet in front of the screen (drawn in front of the clip), opens when the projector is on,
// closes at the end for the titles
frontScene.add(new THREE.HemisphereLight(0x664444, 0x000000, .5));
const curtainKey = new THREE.PointLight(0xffd9a8, 0, 12, 1.5); curtainKey.position.set(0, SCY + 2.2, SZ + 3); frontScene.add(curtainKey);
const curtainMat = new THREE.MeshPhysicalMaterial({ color: 0x4a0b12, roughness: .8, sheen: 1, sheenColor: new THREE.Color(.9, .25, .3), sheenRoughness: .35 });
const CW = SW / 2 + .9, CH = SH + 1.3;
const curtains = [-1, 1].map((s) => {
  const g = new THREE.PlaneGeometry(CW, CH, 90, 1), p = g.attributes.position;
  for (let i = 0; i < p.count; i++) { const x = p.getX(i); p.setZ(i, Math.sin(x * 10) * .07 + Math.sin(x * 27 + 1) * .015); }
  g.computeVertexNormals(); g.translate(-s * CW / 2, 0, 0);   // pivot on its outer edge
  const m = new THREE.Mesh(g, curtainMat);
  m.position.set(s * (SW / 2 + .8), SCY + .25, SZ + .4);
  frontScene.add(m);
  return m;
});
const valance = new THREE.Mesh(new THREE.BoxGeometry(SW + 1.9, .32, .2), curtainMat); valance.position.set(0, SCY + SH / 2 + .78, SZ + .4); frontScene.add(valance);
let curtainOpen = 0, curtainTo = 0;
// Kevin in the front row (his seat was left empty): watching the screen; in the chorus he gets up, turns round,
// raps with the song (a bubble with the bit being sung) and dances
const kev = buildKevin('/img/');
kev.scale.setScalar(.17);
const KX = (KEVIN_SEAT.i - (PER - 1) / 2) * GAP, KZ = ROWS[KEVIN_SEAT.row];
kev.position.set(KX, .46, KZ); kev.rotation.y = Math.PI;
scene.add(kev);
const ku = kev.userData;
const kevSpot = new THREE.SpotLight(0xffe2b8, 0, 9, .32, .7, 1.2); kevSpot.position.set(KX, 4.4, KZ + 1.8); kevSpot.target.position.set(KX, .9, KZ); scene.add(kevSpot, kevSpot.target);
let kStand = 0;

// ---------------- the clip in 3D ----------------
const clipEl = document.createElement('div');
clipEl.className = 'clip';
clipEl.innerHTML = '<img class="poster" src="' + D.thumb + '" alt=""><div class="player"></div><div class="catch" hidden></div><button class="big-play" hidden aria-label="Přehrát"></button><div class="power"></div>';
const clipObj = new CSS3DObject(clipEl);
clipObj.position.set(0, SCY, SZ + .005);
clipObj.scale.setScalar(SW / 1280);
cssScene.add(clipObj);
const poster = clipEl.querySelector('.poster'), catcher = clipEl.querySelector('.catch'), bigPlay = clipEl.querySelector('.big-play'), powerEl = clipEl.querySelector('.power');

// ---------------- camera ----------------
const CAM = new THREE.Vector3(0, 1.85, 4.6), look = new THREE.Vector3();
let camFrom = new THREE.Vector3(0, 2.6, 9.5), camAt = 0, camMs = 1, portrait = false;
const mouse = { x: 0, y: 0 }, par = { x: 0, y: 0 };
function fit() {
  const w = innerWidth, h = innerHeight, aspect = w / h;
  portrait = h > w;
  const share = PHONE ? (portrait ? .78 : .44) : .5;        // how much of the width the screen takes
  const dist = CAM.z - SZ, tanH = (SW / 2 / share) / dist;
  camera.fov = Math.min(90, 2 * Math.atan(tanH / aspect) * 180 / Math.PI);
  camera.aspect = aspect; camera.updateProjectionMatrix();
  // aim so the middle of the screen sits at a set height (room for the words under it)
  look.set(0, SCY, SZ); camera.position.copy(CAM);
  const want = portrait ? .32 : PHONE ? .42 : .4;
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

// ---------------- sparks for the words (2D, over everything but the words) ----------------
const fx = $('fx'), fxc = fx.getContext('2d');
let sparks = [];
function sparkIn(el) {
  const r = el.getBoundingClientRect(), n = Math.min(30, 10 + Math.round(r.width / 6));
  for (let k = 0; k < n; k++) {
    const tx = r.left + Math.random() * r.width, ty = r.top + r.height * rnd(.25, .8), a = Math.random() * 6.28, d = rnd(50, 160);
    sparks.push({ m: 0, sx: tx + Math.cos(a) * d, sy: ty + Math.sin(a) * d * .6 - 30, tx, ty, x: 0, y: 0, px: 0, py: 0, age: -Math.random() * .08, dur: rnd(.3, .48) });
  }
}
function sparkUp(el) {
  const r = el.getBoundingClientRect();
  for (let k = 0; k < 7; k++) sparks.push({ m: 1, x: r.left + Math.random() * r.width, y: r.top + r.height * .45, vx: rnd(-40, 40), vy: rnd(-110, -50), age: 0, life: rnd(.5, .9) });
}
function drawSparks(dt) {
  fxc.setTransform(1, 0, 0, 1, 0, 0); fxc.clearRect(0, 0, fx.width, fx.height);
  if (!sparks.length) return;
  fxc.setTransform(PR, 0, 0, PR, 0, 0); fxc.globalCompositeOperation = 'lighter'; fxc.lineCap = 'round';
  sparks = sparks.filter((p) => {
    p.age += dt; if (p.age < 0) return true;
    let a;
    if (p.m === 0) {
      const f = Math.min(1, p.age / p.dur), e = 1 - Math.pow(1 - f, 3);
      p.px = p.x || p.sx; p.py = p.y || p.sy;
      p.x = p.sx + (p.tx - p.sx) * e; p.y = p.sy + (p.ty - p.sy) * e - Math.sin(f * Math.PI) * 18;
      a = f < 1 ? .9 : Math.max(0, 1 - (p.age - p.dur) / .18);
      if (f >= 1 && a <= 0) return false;
    } else {
      p.px = p.x; p.py = p.y; p.x += p.vx * dt; p.y += p.vy * dt; p.vy += 90 * dt;
      a = 1 - p.age / p.life; if (a <= 0) return false;
    }
    fxc.strokeStyle = 'rgba(255,205,90,' + (a * .55).toFixed(3) + ')'; fxc.lineWidth = 2.2;
    fxc.beginPath(); fxc.moveTo(p.px, p.py); fxc.lineTo(p.x, p.y); fxc.stroke();
    fxc.fillStyle = 'rgba(255,240,200,' + a.toFixed(3) + ')'; fxc.beginPath(); fxc.arc(p.x, p.y, 1.3, 0, 6.29); fxc.fill();
    return true;
  });
}

// ---------------- the words ----------------
// Word by word: each one flies in out of the depth just before it is sung and takes its place in the line
// (the line is laid out in advance, so it builds up centred); gold while sung, then white. When the next
// line starts (or a while after the line ends), the full line moves one step up and fades away.
const AHEAD = .5, lyricsEl = $('lyrics'), titleCard = $('titleCard'), dotsEl = $('dots');
let line = null, shownIdx = -1;
function placeWords() {
  const h = innerHeight;
  const bottom = new THREE.Vector3(0, SCY - SH / 2 - FT, SZ).project(camera);
  const sy = (1 - bottom.y) / 2 * h, lh = lyricsEl.offsetHeight;
  lyricsEl.style.top = Math.max(sy + 8, Math.min(h - lh - 78, sy + (h - sy - 78 - lh) * .45)) + 'px';
}
function makeLine(i) {
  const el = document.createElement('div'); el.className = 'line';
  const toks = D.lines[i].split(/\s+/), times = D.words[i] || [];
  el._w = toks.map((tok, k) => {
    const s = document.createElement('span'); s.className = 'w'; s.textContent = tok;
    s.style.setProperty('--fx', rnd(-1.2, 1.2).toFixed(2) + 'em');
    el.appendChild(s); el.appendChild(document.createTextNode(' '));
    return { el: s, t: times[k] || D.times[i] };
  });
  el._i = i;
  lyricsEl.appendChild(el);
  return el;
}
function leaveLine() {
  if (!line) return;
  const l = line; line = null;
  l.classList.add('gone');
  setTimeout(() => l.remove(), 1000);
}
function lineAt(t) { let i = -1; for (let k = 0; k < D.times.length; k++) { const first = (D.words[k] && D.words[k][0]) ? D.words[k][0][0] : D.times[k][0]; if (first - AHEAD <= t) i = k; else break; } return i; }
function rebuild(t) {
  lyricsEl.querySelectorAll('.line').forEach((l) => l.remove()); line = null;
  const i = lineAt(t); shownIdx = i;
  if (i >= 0 && t < D.times[i][1] + 1.2) { line = makeLine(i); line.classList.add('instant'); requestAnimationFrame(() => line && line.classList.remove('instant')); }
}
function words(t) {
  const i = lineAt(t);
  if (i < shownIdx) { rebuild(t); return; }
  if (i > shownIdx) { leaveLine(); shownIdx = i; line = makeLine(i); }
  if (line && t > D.times[line._i][1] + 1.2) leaveLine();
  if (line) for (const w of line._w) {
    const on = t >= w.t[0] - AHEAD, lit = t >= w.t[0] - .06, nw = lit && t < Math.max(w.t[1], w.t[0] + .25);
    if (on !== w.on) { w.el.classList.toggle('on', on); w.on = on; if (on && t - w.t[0] < .1) sparkIn(w.el); }
    if (lit !== w.lit) { w.el.classList.toggle('lit', lit); w.lit = lit; }
    if (nw !== w.now) { w.el.classList.toggle('now', nw); w.now = nw; if (nw) sparkUp(w.el); }
  }
  titleCard.classList.toggle('gone', t > D.times[0][0] - 1);
  let sung = -1; for (let s = 0; s < D.times.length && D.times[s][0] <= t; s++) sung = s;
  const next = D.times[sung + 1], prevEnd = sung >= 0 ? D.times[sung][1] : 0;
  const wait = next ? next[0] - AHEAD - t : 99, gap = next ? next[0] - prevEnd : 0;
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

// ---------------- in and out: the camera walks in, the lines light up, then the projector ----------------
let on = 0, onFrom = 0, onTo = 0, onAt = 0, onMs = 1, neon = .1, neonTo = .1;
const flicker = (p) => (p < .18 ? p / .18 * .55 : p < .26 ? .12 : p < .4 ? .7 : p < .46 ? .3 : Math.min(1, .3 + (p - .46) / .54 * .7));
function power(to, ms) { onFrom = on; onTo = to; onAt = performance.now(); onMs = ms; }
camera.position.copy(camFrom);
$('enter').onclick = () => {
  entered = true;
  $('lobby').classList.add('gone');
  camAt = performance.now(); camMs = 3400;
  setTimeout(() => { neonTo = 1; }, 600);
  setTimeout(() => power(1, 1500), 1900);
  setTimeout(startPlayer, 2500);
  askToTurn();
  wake();
};
function leave() {   // like the end of a film: lights down, fade to black, back to the karaoke list
  if (leave.done) return; leave.done = true;
  entered = false; pause(); power(0, 1200); neonTo = .1;
  setTimeout(() => document.body.classList.add('fading'), 900);
  setTimeout(() => { try { sessionStorage.setItem('kinoOut', '1'); } catch (er) { /* no storage */ } location.href = '/karaoke-kino'; }, 2300);
}
if (qs.has('auto')) { entered = true; $('lobby').classList.add('gone'); on = onTo = 1; neon = neonTo = 1; camAt = -1e9; play(); }
if (qs.has('auto') && !qs.has('end')) curtainOpen = 1;

// ---------------- every frame ----------------
const ease = (p) => (p < .5 ? 4 * p * p * p : 1 - Math.pow(-2 * p + 2, 3) / 2);
let wasChorus = false, credited = false;
function credits() {
  return '<span class="ct">' + D.title + '</span><span class="cv">' + D.artist + ' · ' + D.year + '</span>' +
    '<span class="cl">Rap a text</span><span class="cv">' + D.artist + '</span>' +
    '<span class="cl">Karaoke</span><span class="cv">SKELO SQUAD</span>' +
    '<span class="cl">V první řadě</span><span class="cv">MC Kevin</span>' +
    '<span class="cl">A hlavně</span><span class="cv">ty – díky, že sis zazpíval/a</span><span class="cs"></span>';
}
let last = performance.now(), beat = 0, bassAvg = 0, chorus = 0, wasPlaying = null, started = false;
const avg = new THREE.Color(), tmp = new THREE.Color(), tmp2 = new THREE.Color(), DOWN = new THREE.Vector3(0, -1, 0), tv = new THREE.Vector3();
target(Math.max(20, simT), cur);
fit();
if (qs.has('auto')) rebuild(now());
const edgeCol = (row, i, out) => { const o = (row * 16 + i) * 3; return out.setRGB(cur[o], cur[o + 1], cur[o + 2]); };

function frame(ts) {
  const dt = Math.min(.1, (ts - last) / 1000); last = ts;
  const t = now(), pl = playing(), sec = ts / 1000;

  if (onAt) { const p = Math.min(1, (ts - onAt) / onMs); on = onTo > onFrom ? onFrom + (onTo - onFrom) * flicker(p) : onFrom + (onTo - onFrom) * p; if (p >= 1) onAt = 0; }
  neon += (neonTo - neon) * (1 - Math.exp(-dt * 2.5));
  powerEl.style.opacity = (1 - on).toFixed(3);
  const k = camAt < 0 ? 1 : ease(Math.min(1, (ts - camAt) / camMs));
  par.x += (mouse.x - par.x) * (1 - Math.exp(-dt * 2)); par.y += (mouse.y - par.y) * (1 - Math.exp(-dt * 2));
  camera.position.lerpVectors(camFrom, CAM, k);
  camera.position.x += par.x * .35; camera.position.y -= par.y * .12;
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
  screenLight.color.copy(avg); screenLight.intensity = (.5 + lum * 4) * on;
  halo.material.color.copy(avg); halo.material.opacity = .1 * on;
  for (const [i, l] of sideLights.entries()) {   // a grey clip lights the sides cold left / warm right like a film
    edgeCol(i, 7, tmp); const g = tmp.r * .3 + tmp.g * .59 + tmp.b * .11, sat = Math.max(tmp.r, tmp.g, tmp.b) - Math.min(tmp.r, tmp.g, tmp.b);
    tmp2.copy(i === 0 ? COLD : WARM).multiplyScalar(g * 1.6);
    l.color.copy(tmp2.lerp(tmp, Math.min(1, sat * 4))); l.intensity = 3 * on;
  }

  // the beat and the chorus
  if (pl) { const b = bassAt(t); bassAvg += (b - bassAvg) * (1 - Math.exp(-dt / .7)); beat = Math.max(beat * Math.exp(-dt / .17), Math.min(1, Math.max(0, b - bassAvg * 1.08) * 4.5)); }
  else beat *= Math.exp(-dt / .3);
  let sg2 = -1; for (let c = 0; c < D.times.length && D.times[c][0] <= t; c++) sg2 = c;
  chorus += ((sg2 >= 0 && isChorus[sg2] && t < D.times[sg2][1] + 1.5 ? 1 : 0) - chorus) * (1 - Math.exp(-dt / .9));

  // light lines, sign, stars, pylon rings
  for (const l of cornerLights) l.intensity = 2.5 * neon;
  for (const m of flowMats) {
    if (m.glow) { m.glow.color.copy(m.glow.userData.base).multiplyScalar(m.glow.userData.k * neon); continue; }
    m.uniforms.uTime.value = sec; m.uniforms.uOn.value = neon; m.uniforms.uBeat.value = beat;
  }
  const buzz = (ts % 9000) < 160 ? (Math.sin(ts * .09) > 0 ? .5 : 1) : 1;
  signMat.opacity = Math.min(1, neon) * buzz;
  starMat.uniforms.uTime.value = sec; starMat.uniforms.uOn.value = .2 + .6 * neon;
  for (const r of ringMats) r.m.color.copy(r.col).multiplyScalar((.25 + .55 * (.5 + .5 * Math.sin(sec * 2 - r.y * 1.6)) + beat * .6) * neon);

  for (const s of speakers) {
    s.cones.forEach((c, i) => { c.position.z = .41 + (i < 2 ? beat * .04 : beat * .012); });
    s.ledM.color.copy(s.col).multiplyScalar(1 + beat * 3);
    s.stripM.color.copy(s.col).multiplyScalar(.6 * neon);
  }

  // light heads: slow sweeps over the room (never across the screen); a kick lights them, a chorus swings them wider
  for (const h of heads) {
    const sw = .5 + .5 * Math.sin(sec * (.17 + h.k * .05) + h.phase), up = .5 + .5 * Math.sin(sec * (.12 + h.k * .03) + h.phase * 2);
    const tx = h.s * (1.4 + 3.6 * sw) * (1 - chorus * .7) - h.s * chorus * 2.2 * sw;
    const ty = chorus > .5 ? 1.5 + 4 * up : .1 + 1.2 * up;
    const tz = -2 + 6.5 * (.5 + .5 * Math.sin(sec * .1 + h.phase));
    tv.set(tx, ty, tz);
    const dir = tv.clone().sub(h.origin), len = dir.length(); dir.normalize();
    h.beam.position.copy(h.origin);
    h.beam.quaternion.setFromUnitVectors(DOWN, dir);
    const r = len * .1; h.beam.scale.set(r, len, r);
    const inten = (.06 + beat * .55 + chorus * .14) * neon * on;
    h.beam.material.uniforms.uInt.value = inten * 1.3; h.beam.material.uniforms.uTime.value = sec;
    h.spot.target.position.copy(tv); h.spot.intensity = inten * 18;
    h.lensM.color.copy(h.col).multiplyScalar(.8 + inten * 4);
  }

  for (const w of wisps) {
    w.age += dt; if (w.age > w.life) respawn(w);
    w.sp.position.addScaledVector(w.v, dt);
    const f = w.age / w.life, s = w.size * (1 + f * .6);
    w.sp.scale.set(s, s, 1); w.m.rotation += w.spin * dt;
    w.m.color.copy(avg).lerp(GOLD, .15).multiplyScalar(.6);
    w.m.opacity = (f < .2 ? f / .2 : 1 - (f - .2) / .8) * .15 * (.4 + .6 * on);
  }

  // lasers (only in the chorus)
  for (const L of lasers) {
    const n = LOW ? 4 : 7, yaw = L.s * (.12 + .55 * L.j / (n - 1)) + Math.sin(sec * .9 + L.j * .5) * .1 * L.s;
    const pitch = .05 + .3 * (.5 + .5 * Math.sin(sec * 1.4 + L.j * .9 + L.s));
    const dv = new THREE.Vector3(Math.sin(yaw) * Math.cos(pitch), Math.sin(pitch), Math.cos(yaw) * Math.cos(pitch));
    const qq = new THREE.Quaternion().setFromUnitVectors(new THREE.Vector3(0, 1, 0), dv);
    for (const m of [L.core, L.glow]) { m.quaternion.copy(qq); m.scale.set(1, 18, 1); }
    const li = Math.max(0, chorus - .15) * (.55 + beat * 1.1) * on;
    L.core.material.uniforms.uInt.value = li; L.glow.material.uniforms.uInt.value = li;
    L.core.visible = L.glow.visible = li > .002;
  }
  // a rain of gold when a chorus starts
  if (chorus > .5 && !wasChorus && pl) spawnRain(LOW ? 90 : 200);
  wasChorus = chorus > .5;
  {
    const a = new THREE.Vector3(-SW / 2, SCY - SH / 2, SZ).project(camera), b = new THREE.Vector3(SW / 2, SCY + SH / 2, SZ).project(camera);
    rainMat.uniforms.uScr.value.set(a.x, a.y, b.x, b.y); rainMat.uniforms.uTime.value = sec;
    for (let i = 0; i < N_RAIN; i++) {
      if (rainLife[i] <= 0) continue;
      rainPos[i * 3 + 1] -= rainVel[i] * dt; rainPos[i * 3] += Math.sin(sec * 2 + rainSeed[i] * 30) * .12 * dt;
      if (rainPos[i * 3 + 1] < 0) rainLife[i] = 0;
    }
    rainGeo.attributes.position.needsUpdate = true; rainGeo.attributes.aLife.needsUpdate = true;
  }
  // the curtain opens once the projector is on, closes after the last line for the end titles
  const ended = entered && started && t > Math.min(duration() - 1.5, LAST_END + 6);
  curtainTo = ended ? 0 : on > .95 && (started || SIM) ? 1 : 0;
  if (ended && !credited) { credited = true; $('roll').innerHTML = credits(); $('credits').hidden = false; $('credits').classList.add('run'); spawnRain(N_RAIN); }
  if (!ended && credited) { credited = false; $('credits').hidden = true; $('credits').classList.remove('run'); }
  curtainOpen += (curtainTo - curtainOpen) * (1 - Math.exp(-dt * (curtainTo ? .9 : 1.3)));
  const co = curtainOpen * curtainOpen * (3 - 2 * curtainOpen);
  curtains.forEach((c) => { c.scale.x = 1 - co * .86; c.visible = co < .985; });
  valance.visible = co < .985;
  curtainKey.intensity = 7 * Math.max(neon, .3) * (1 - co);
  // Kevin: up for the chorus, rapping the words being sung
  kStand += ((chorus > .5 && pl ? 1 : 0) - kStand) * (1 - Math.exp(-dt * 2.2));
  const hop = Math.abs(Math.sin(t * Math.PI * 1.5)) * .05 * kStand;
  kev.position.y = .46 + kStand * .3 + hop;
  kev.rotation.y = Math.PI * (1 - kStand) + Math.sin(sec * 2.2) * .18 * kStand;
  const pose = kStand > .5 ? (Math.floor(sec / 2.5) % 2 ? 'beatbox' : 'rap') : 'idle', arm = ARMS[pose];
  const ke = 1 - Math.exp(-dt * 8);
  ku.armR.rotation.x += (arm[0] - ku.armR.rotation.x) * ke; ku.armR.rotation.z += (arm[1] - ku.armR.rotation.z) * ke;
  ku.armL.rotation.x += (arm[2] + (pose === 'rap' ? Math.sin(sec * 9) * .2 : 0) - ku.armL.rotation.x) * ke; ku.armL.rotation.z += (arm[3] - ku.armL.rotation.z) * ke;
  const rapping = kStand > .6 && line && line._w.some((w) => w.now);
  ku.mouth.scale.y += ((rapping ? .35 + Math.abs(Math.sin(sec * 15)) * .6 : .05) - ku.mouth.scale.y) * .3;
  ku.head.rotation.z = Math.sin(t * Math.PI * .75) * .07 * (.3 + kStand);
  ku.body.position.y = beat * .04;
  ku.eyes.forEach((ey) => { ey.scale.y += (((sec % 4.2) < .12 ? .1 : 1) - ey.scale.y) * .5; });
  ku.tail.rotation.y = Math.sin(sec * (1.3 + kStand * 4)) * (.12 + kStand * .25);
  kevSpot.intensity = kStand * 22;
  const bub = $('kbubble');
  if (kStand > .7 && line) {
    const said = line._w.filter((w) => w.lit), tail = said.slice(-5);
    if (tail.length) {
      bub.innerHTML = tail.map((w) => (w.now ? '<b>' + w.el.textContent + '</b>' : w.el.textContent)).join(' ');
      const hp = new THREE.Vector3(0, 3.6, 0); kev.localToWorld(hp); hp.project(camera);
      bub.style.left = ((hp.x + 1) / 2 * innerWidth) + 'px'; bub.style.top = ((1 - hp.y) / 2 * innerHeight - 6) + 'px';
      bub.hidden = false;
    } else bub.hidden = true;
  } else bub.hidden = true;

  if (entered) words(t);
  drawSparks(dt);
  if (pl && !started && (!clock || clock.time() > .3)) { started = true; if (clock) poster.style.display = 'none'; }
  if (clock && clock.time() > .3) catcher.classList.toggle('paused', !pl);
  $('fill').style.width = (t / duration() * 100) + '%';
  $('time').textContent = fmt(t) + ' / ' + fmt(duration());
  if (pl !== wasPlaying) { wasPlaying = pl; $('ppIcon').innerHTML = pl ? '<path d="M6 5h4v14H6zm8 0h4v14h-4z"/>' : '<path d="M8 5v14l11-7z"/>'; }
  const hb = .85 / Math.max(avg.r, avg.g, avg.b, .08);
  document.documentElement.style.setProperty('--hot', `rgb(${Math.round(Math.min(255, avg.r * hb * 128 + 115))},${Math.round(Math.min(255, avg.g * hb * 128 + 92))},${Math.round(Math.min(255, avg.b * hb * 128 + 24))})`);

  composer.render(dt);
  css.render(cssScene, camera);
  front.render(frontScene, camera);
  requestAnimationFrame(frame);
}
requestAnimationFrame(frame);
