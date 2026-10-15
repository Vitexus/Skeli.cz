// Karaoke cinema, room "Prostor": MC Kevin (js/kevin-model.js, the same cat as on the site) drops by now and then –
// never for the whole song. At a random moment he jumps up onto the top edge of the panel's golden frame (left part)
// and stays a while: in a verse he sits on the edge with his legs over it, in the chorus he stands up on it and
// dances, in a long gap he looks round; then he jumps off again. The next visit comes 40–90 s later; at the end of
// the song he always comes to clap. He stands and sits on the frame, tilted with it, or – when there is no room above
// the frame (a low window) or just for a change – on the floor left of the panel; never floating in the air.
// Not on a phone held upright (no room) and not with reduced motion.
// ver = the page's ?v=, so the model's script is never an old cached one
export async function kevinGuest(ver, soon) {   // soon (#kevinnow): he comes at once (tests)
  const { createKevin } = await import('/js/kevin-model.js' + (ver || ''));
  const none = { place() {}, update() {} };
  if (matchMedia('(prefers-reduced-motion: reduce)').matches) return none;
  const phoneUpright = () => Math.min(innerWidth, innerHeight) < 600 && innerHeight > innerWidth;
  const box = document.createElement('div');   // on the frame's edge, tilted with it (its bottom middle = where he is)
  box.className = 'kino-kevin';
  box.setAttribute('aria-hidden', 'true');
  box.hidden = true;
  const lift = document.createElement('div');  // the jumps up and down
  lift.className = 'kino-kevin-lift';
  const canvas = document.createElement('canvas');
  lift.appendChild(canvas);
  box.appendChild(lift);
  document.body.appendChild(box);
  // the shot (view below): where his feet and, sitting, his seat are in the picture, as a share of its height
  const VIEW = { y: 1.0, z: 5.6, look: 0.95 }, TAN = Math.tan(15 * Math.PI / 180);
  const at = (h) => (1 - (h - VIEW.look) / (VIEW.z * TAN)) / 2;
  const FEET = at(0), SEAT = at(0.5), HEAD = at(2.05);
  let k = null, ready = false;
  try {
    k = createKevin(canvas, { view: VIEW, alwaysRender: true, onReady() { ready = true; } });
  } catch (e) { box.remove(); return none; }

  let size = 0, spots = null, kind = '', mode = '', dances = ['dance', 'dance2', 'dance3', 'silly', 'robot'], danceN = 0;
  let here = false, leaving = false, nextAt = soon ? 0 : 20 + Math.random() * 25, until = 0, lastT = 0;
  function seat(sitting) { canvas.style.top = (size * (1 - (sitting ? SEAT : FEET))) + 'px'; }
  // what he does on the edge: sit (verse, paused) | chorus | gap | ended
  function set(next) {
    if (next === mode) return;
    mode = next;
    seat(next === 'sit');
    if (next === 'sit') k.hold('sit');
    if (next === 'chorus') k.hold(dances[danceN++ % dances.length]);
    if (next === 'gap') k.hold(Math.random() < 0.5 ? 'lookAround' : 'bored');
    if (next === 'ended') { k.hold('cheer'); k.once('clap'); }
  }
  function jump(from, to, ms) {
    return lift.animate([{ transform: 'translateY(' + from + 'px)', opacity: from > 0 ? 0 : 1 }, { transform: 'translateY(' + (-size * .35) + 'px)', opacity: 1, offset: .5 }, { transform: 'translateY(' + to + 'px)', opacity: to > 0 ? 0 : 1 }],
      { duration: ms, easing: 'ease-in-out', fill: 'forwards' });
  }
  // where to stand this time: the frame's edge when there is room above it for him (65 % of visits), else the floor
  function pick(keep) {
    const roomOnEdge = spots.edge.y - (FEET - HEAD) * size > 8;
    if (!keep || (kind === 'edge' && !roomOnEdge)) kind = roomOnEdge && Math.random() < .65 ? 'edge' : 'floor';
    const spot = spots[kind];
    Object.assign(box.style, { left: (spot.x - size / 2) + 'px', top: (spot.y - size) + 'px', width: size + 'px', height: size + 'px', transform: 'rotate(' + (spot.angle || 0) + 'rad)' });
  }
  function arrive(t, len) {
    here = true; leaving = false; until = t + len; mode = '';
    pick();
    box.hidden = false;
    k.setPaused(false);
    seat(false);
    k.once('jump');
    jump(size * .6, 0, 900);
  }
  function leave(t) {
    leaving = true;
    seat(false);
    k.hold(null);
    k.once('jump');
    jump(0, size * .6, 900).onfinish = () => { box.hidden = true; here = false; leaving = false; k.setPaused(true); };
    nextAt = t + 40 + Math.random() * 50;
  }
  return {
    // where he can be: { edge: {x, y, angle} on the frame's top edge, floor: {x, y} left of the panel }, panelH = the panel's height
    place(where, panelH) {
      spots = where;
      size = Math.max(60, panelH * .62);
      if (here) pick(true);   // the window changed size: the same place, unless the edge has no room now
      seat(mode === 'sit');
    },
    // info: { t, playing, chorus, gap, ended, entered }
    update(info) {
      if (!k || !ready || !size) return;
      const t = info.t;
      if (t < lastT - 3 && !here) nextAt = t + 15 + Math.random() * 20;   // a jump back in the song: a fresh wait
      lastT = t;
      if (phoneUpright() || !info.entered) { if (here && !leaving) { box.hidden = true; here = false; } return; }
      if (!here) {
        if (info.ended) arrive(t, 1e9);
        else if (info.playing && t >= nextAt) arrive(t, 14 + Math.random() * 16 + (info.chorus ? 8 : 0));
        return;
      }
      if (leaving) return;
      if (!info.ended && t >= until && !info.chorus) return leave(t);   // a dance is finished first
      set(info.ended ? 'ended' : info.chorus ? 'chorus' : info.gap ? 'gap' : 'sit');
    }
  };
}
