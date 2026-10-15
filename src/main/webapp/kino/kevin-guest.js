// Karaoke cinema, room "Prostor": MC Kevin floats in the space left of the panel (js/kevin-model.js, the same cat
// as on the site). In the verses he swims slowly through the space, in the chorus he dances, in a long instrumental
// gap he looks round or gets bored, while paused he faces you, and when the song is over he claps and cheers.
// He never covers the clip or the words: a small canvas left of the panel, drifting gently as if weightless.
// Not on a phone held upright (no room) and not with reduced motion.
// ver = the page's ?v=, so the model's script is never an old cached one
export async function kevinGuest(ver) {
  const { createKevin } = await import('/js/kevin-model.js' + (ver || ''));
  const phoneUpright = () => Math.min(innerWidth, innerHeight) < 600 && innerHeight > innerWidth;
  if (matchMedia('(prefers-reduced-motion: reduce)').matches) return { place() {}, update() {} };
  const box = document.createElement('div');
  box.className = 'kino-kevin';
  box.setAttribute('aria-hidden', 'true');
  const canvas = document.createElement('canvas');
  box.appendChild(canvas);
  document.body.appendChild(box);
  let k = null, ready = false;
  try {
    k = createKevin(canvas, {
      view: { y: 1.0, z: 5.6, look: 0.95 },   // wider: swimming he is long, not tall
      alwaysRender: true,
      onReady() { ready = true; box.classList.add('in'); }
    });
  } catch (e) { box.remove(); return { place() {}, update() {} }; }

  let mode = '', dances = ['dance', 'dance2', 'dance3', 'silly', 'robot'], danceN = 0, t0 = performance.now();
  // what he does now: verse | chorus | gap | paused | ended
  function set(next) {
    if (next === mode) return;
    mode = next;
    if (next === 'verse') { k.turn(Math.PI / 2.4); k.hold('swim'); }
    if (next === 'chorus') { k.turn(0); k.hold(dances[danceN++ % dances.length]); }
    if (next === 'gap') { k.turn(0); k.hold(Math.random() < 0.5 ? 'lookAround' : 'bored'); }
    if (next === 'paused') { k.turn(0); k.hold('idle'); }
    if (next === 'ended') { k.turn(0); k.hold('cheer'); k.once('clap'); }
  }
  return {
    // where he floats: a free spot left of the panel (prostor.js works it out from the video, see fit())
    place(x, y, size) { Object.assign(box.style, { left: x + 'px', top: y + 'px', width: size + 'px', height: size + 'px' }); },
    // info: { playing, chorus, gap, ended, entered }
    update(info) {
      if (!k || !ready) return;
      box.hidden = phoneUpright() || !info.entered;
      set(info.ended ? 'ended' : !info.playing ? 'paused' : info.chorus ? 'chorus' : info.gap ? 'gap' : 'verse');
      // weightless: a slow drift up and down and a little sway (stronger while swimming)
      const s = (performance.now() - t0) / 1000, sw = mode === 'verse' ? 1 : 0.4;
      box.style.transform = 'translate(' + (Math.sin(s * 0.23) * 1.2 * sw).toFixed(2) + 'vw,' + (Math.sin(s * 0.41) * 2.2).toFixed(2) + 'vh) rotate(' + (Math.sin(s * 0.3) * 4 * sw).toFixed(2) + 'deg)';
    }
  };
}
