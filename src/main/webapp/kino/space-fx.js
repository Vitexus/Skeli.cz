// Karaoke cinema, room "Prostor": more life in the space, on one canvas behind the clip and the words.
//  - nebulae left and right of the panel in the clip's own colours (its edge colours from eq/<id>.json), slowly
//    following the picture and breathing with the song's loudness – never pulsing on the beat (the user didn't like that)
//  - now and then a comet across the upper sky, more often in the chorus
//  - in the chorus the stars stretch into lines towards us: hyperspace
//  - gold dust rising from a line that has just been sung, fireworks of embers when the song is over
// spaceFx(anchor, view, colours) – anchor: the element the canvas goes after; view: where the depth is ({x, y, s},
// kept up to date by prostor.js); colours(t) → {l: [r,g,b], r: [r,g,b]} for the clip at time t.
export function spaceFx(anchor, view, colours) {
  const quiet = matchMedia('(prefers-reduced-motion: reduce)').matches;
  const PHONE = Math.min(innerWidth, innerHeight) < 600;
  const cv = document.createElement('canvas');
  cv.className = 'space-fx';
  cv.setAttribute('aria-hidden', 'true');
  anchor.after(cv);
  const g = cv.getContext('2d'), dpr = Math.min(PHONE ? 1.5 : 2, devicePixelRatio || 1);
  let W = 0, H = 0;
  const neb = { l: [90, 70, 40], r: [60, 80, 120], k: 0 };
  const comets = [], dust = [], stars = [], bursts = [];
  let nextComet = 3 + Math.random() * 5, warp = 0, t0 = performance.now();
  for (let i = 0, n = PHONE ? 60 : 140; i < n; i++) stars.push({ a: Math.random() * 6.283, r: Math.random(), tw: Math.random() * 6.283 });

  // a soft round glow, drawn once per colour change would be costly: a radial gradient each frame is cheap enough
  function nebula(x, y, rad, c, a) {
    const gr = g.createRadialGradient(x, y, 0, x, y, rad);
    gr.addColorStop(0, 'rgba(' + c[0] + ',' + c[1] + ',' + c[2] + ',' + a + ')');
    gr.addColorStop(.45, 'rgba(' + c[0] + ',' + c[1] + ',' + c[2] + ',' + (a * .35) + ')');
    gr.addColorStop(1, 'rgba(0,0,0,0)');
    g.fillStyle = gr;
    g.fillRect(x - rad, y - rad, rad * 2, rad * 2);
  }
  // brighten a dim clip colour so the glow reads as light, not as mud
  const lift = (c) => { const m = Math.max(1, ...c); const k = Math.min(2.4, 210 / m); return c.map((v) => Math.round(Math.min(255, v * k * .9 + 20))); };

  return {
    // info: { t, playing, energy (0–1, smoothed loudness), chorus }
    frame(dt, info) {
      if (cv.width !== Math.round(innerWidth * dpr) || cv.height !== Math.round(innerHeight * dpr)) {
        W = innerWidth; H = innerHeight; cv.width = Math.round(W * dpr); cv.height = Math.round(H * dpr);
      }
      g.setTransform(dpr, 0, 0, dpr, 0, 0);
      g.clearRect(0, 0, W, H);
      g.globalCompositeOperation = 'lighter';
      const s = (performance.now() - t0) / 1000;

      // nebulae: the colours glide towards the clip's (about a second), the strength follows the loudness slowly
      const c = colours(info.t), ease = 1 - Math.exp(-dt * 1.2);
      for (const side of ['l', 'r']) { const to = lift(c[side]); for (let i = 0; i < 3; i++) neb[side][i] += (to[i] - neb[side][i]) * ease; }
      neb.k += ((info.playing ? .1 + info.energy * .22 : .06) - neb.k) * (1 - Math.exp(-dt * .8));
      const breathe = .85 + .15 * Math.sin(s * .5);
      const R = Math.max(W, H) * .42;
      nebula(view.x - W * .33 + Math.sin(s * .07) * 30, view.y + H * .08, R, neb.l.map(Math.round), (neb.k * breathe).toFixed(3));
      nebula(view.x + W * .33 + Math.cos(s * .06) * 30, view.y - H * .02, R * .9, neb.r.map(Math.round), (neb.k * breathe * .9).toFixed(3));

      if (!quiet) {
        // hyperspace in the chorus: faint streaks from the depth, longer as the warp builds up
        warp += ((info.playing && info.chorus ? 1 : 0) - warp) * (1 - Math.exp(-dt * (info.chorus ? 1.5 : .8)));
        if (warp > .02) {
          g.lineCap = 'round';
          for (const st of stars) {
            st.r += dt * (.12 + st.r * .9) * (.4 + warp * 1.6);
            if (st.r > 1.3) { st.r = .02 + Math.random() * .1; st.a = Math.random() * 6.283; }
            const d = st.r * Math.max(W, H) * .7, len = d * .18 * warp;
            const x = view.x + Math.cos(st.a) * d, y = view.y + Math.sin(st.a) * d * .7;
            g.globalAlpha = Math.min(1, st.r * 1.6) * warp * .55;
            g.strokeStyle = st.tw > 4.5 ? 'rgba(150,200,255,1)' : 'rgba(255,214,150,1)';
            g.lineWidth = .6 + st.r * 1.4;
            g.beginPath(); g.moveTo(x - Math.cos(st.a) * len, y - Math.sin(st.a) * len * .7); g.lineTo(x, y); g.stroke();
          }
          g.globalAlpha = 1;
        }

        // comets: a bright head and a fading tail, across the upper part of the sky
        nextComet -= dt * (info.chorus ? 2.2 : 1);
        if (nextComet <= 0 && info.playing) {
          nextComet = 6 + Math.random() * 9;
          const fromLeft = Math.random() < .5, cold = Math.random() < .4;
          comets.push({ x: fromLeft ? -40 : W + 40, y: H * (.05 + Math.random() * .3), vx: (fromLeft ? 1 : -1) * W * (.35 + Math.random() * .25), vy: H * (.04 + Math.random() * .08), age: 0, life: 3.2, cold });
        }
        for (let i = comets.length - 1; i >= 0; i--) {
          const m = comets[i];
          m.age += dt; m.x += m.vx * dt; m.y += m.vy * dt;
          if (m.age > m.life) { comets.splice(i, 1); continue; }
          const f = Math.min(1, m.age / .3) * Math.min(1, (m.life - m.age) / .6), len = Math.hypot(m.vx, m.vy) * .35;
          const tx = m.x - m.vx / Math.hypot(m.vx, m.vy) * len, ty = m.y - m.vy / Math.hypot(m.vx, m.vy) * len;
          const gr = g.createLinearGradient(tx, ty, m.x, m.y);
          gr.addColorStop(0, 'rgba(0,0,0,0)');
          gr.addColorStop(1, m.cold ? 'rgba(170,215,255,' + (.75 * f) + ')' : 'rgba(255,215,140,' + (.8 * f) + ')');
          g.strokeStyle = gr; g.lineWidth = 2.2; g.lineCap = 'round';
          g.beginPath(); g.moveTo(tx, ty); g.lineTo(m.x, m.y); g.stroke();
          nebula(m.x, m.y, 14, m.cold ? [200, 230, 255] : [255, 230, 170], (.9 * f).toFixed(3));
        }
      }

      // gold dust and fireworks: small sparks that rise or fly out, twinkle and fade
      for (const list of [dust, bursts]) for (let i = list.length - 1; i >= 0; i--) {
        const p = list[i];
        p.age += dt;
        if (p.age > p.life) { list.splice(i, 1); continue; }
        p.vy += (p.g || 0) * dt; p.x += p.vx * dt; p.y += p.vy * dt; p.vx *= Math.exp(-dt * (p.drag || .8)); p.vy *= Math.exp(-dt * (p.drag || .8));
        const f = 1 - p.age / p.life, tw = .6 + .4 * Math.sin(p.age * 18 + p.ph);
        g.globalAlpha = Math.max(0, f * tw);
        g.fillStyle = p.c;
        g.beginPath(); g.arc(p.x, p.y, p.r * (.5 + f * .5), 0, 6.283); g.fill();
      }
      g.globalAlpha = 1;
      g.globalCompositeOperation = 'source-over';
    },
    // a line has been sung: dust rises from its words (rect = the line's box on screen)
    dust(rect) {
      if (quiet || !rect || !rect.width) return;
      for (let i = 0, n = Math.min(40, Math.round(rect.width / 14)); i < n; i++) {
        dust.push({ x: rect.left + Math.random() * rect.width, y: rect.top + rect.height * (.3 + Math.random() * .5), vx: (Math.random() - .5) * 20,
          vy: -25 - Math.random() * 45, r: .8 + Math.random() * 1.6, life: 1.2 + Math.random() * 1.2, age: 0, ph: Math.random() * 6, drag: .5,
          c: Math.random() < .8 ? '#ffd27a' : '#fff4d6' });
      }
    },
    // the song is over: a few bursts of embers round the panel
    finale(points) {
      if (quiet) return;
      points.forEach(([x, y], k) => setTimeout(() => {
        for (let i = 0; i < 70; i++) {
          const a = Math.random() * 6.283, v = 80 + Math.random() * 220;
          bursts.push({ x, y, vx: Math.cos(a) * v, vy: Math.sin(a) * v - 40, g: 90, drag: 1.4, r: 1 + Math.random() * 1.8, life: 1.4 + Math.random() * 1.2, age: 0,
            ph: Math.random() * 6, c: ['#ffd23f', '#ff9a2e', '#fff1c2', '#9cc8ff'][Math.floor(Math.random() * 4)] });
        }
      }, k * 450));
    }
  };
}
