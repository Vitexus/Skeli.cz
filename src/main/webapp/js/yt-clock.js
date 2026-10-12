/* The clock of a YouTube clip in an <iframe> (embedded with enablejsapi=1), without loading the IFrame API
   library: the player and the page talk with the same postMessage messages the library uses.

   YtClock(frame, onChange) – after the player answers, it reports its state, time, length, speed and volume
   now and then; between the reports the time is counted on from the last one (at the player's speed), so
   the lyrics never wait for the next message. Pause, seeking back and forth and a slower or faster speed
   stay right, because every report sets the clock again.

   clock.time()                the clip's time in seconds, now
   clock.playing()             is it playing
   clock.duration(), clock.volume(), clock.muted(), clock.ready()
   clock.play(), clock.pause(), clock.seek(s), clock.setVolume(0..100), clock.mute(), clock.unMute()
   clock.stop()                stops listening (the frame was replaced or the page left) */
(function () {
  window.YtClock = function (frame, onChange) {
    var playing = false, base = 0, baseAt = performance.now(), rate = 1;
    var ready = false, dur = 0, vol = 100, muted = false, stopped = false;

    function time() { return base + (playing ? (performance.now() - baseAt) / 1000 * rate : 0); }
    function setBase(t) { base = t; baseAt = performance.now(); }
    function post(msg) { try { frame.contentWindow.postMessage(JSON.stringify(msg), '*'); } catch (e) { /* frame gone */ } }
    function command(func, args) { post({ event: 'command', func: func, args: args || [] }); }

    // "listening": asked 4x a second until the player answers (once a second made the start late)
    function hello() { if (!ready && !stopped) post({ event: 'listening', id: 1, channel: 'widget' }); }
    var tries = 0, asking = setInterval(function () { if (ready || stopped || ++tries > 120) clearInterval(asking); else hello(); }, 250);
    frame.addEventListener('load', hello);
    hello();

    function onMessage(e) {
      if (stopped || e.source !== frame.contentWindow) return;
      var m;
      try { m = typeof e.data === 'string' ? JSON.parse(e.data) : e.data; } catch (er) { return; }
      if (!m || typeof m !== 'object') return;
      if (!ready) { ready = true; clearInterval(asking); }
      var info = m.info;
      if (m.event === 'onStateChange' && typeof info === 'number') {
        setBase(time());               // the time so far, counted with the old state
        playing = info === 1;
      }
      if (info && typeof info === 'object') {
        // the order matters: first freeze the time at the old speed and state, then take the new values
        if (typeof info.playbackRate === 'number' && info.playbackRate !== rate) { setBase(time()); rate = info.playbackRate || 1; }
        if (typeof info.playerState === 'number') { var p = info.playerState === 1; if (p !== playing) { setBase(time()); playing = p; } }
        if (typeof info.currentTime === 'number') setBase(info.currentTime);
        if (typeof info.duration === 'number') dur = info.duration;
        if (typeof info.volume === 'number') vol = info.volume;
        if (typeof info.muted === 'boolean') muted = info.muted;
      }
      if (onChange) onChange(api);
    }
    window.addEventListener('message', onMessage);

    var api = {
      time: time,
      playing: function () { return playing; },
      ready: function () { return ready; },
      duration: function () { return dur; },
      volume: function () { return vol; },
      muted: function () { return muted; },
      play: function () { command('playVideo'); },
      pause: function () { command('pauseVideo'); },
      seek: function (s) { s = Math.max(0, s); command('seekTo', [s, true]); setBase(s); },
      setVolume: function (v) { vol = Math.max(0, Math.min(100, v)); command('setVolume', [vol]); },
      mute: function () { muted = true; command('mute'); },
      unMute: function () { muted = false; command('unMute'); },
      stop: function () { stopped = true; clearInterval(asking); window.removeEventListener('message', onMessage); }
    };
    return api;
  };
})();
