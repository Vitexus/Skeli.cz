// Furniture and decoration for the rooms B–E of the home cinema (room A is built in domov.js).
// buildDecor(ctx) -> { b, c, d, e: THREE.Group, update(dt, sec, beat, lights) }
import * as THREE from 'three';
import { RoundedBoxGeometry } from './vendor/jsm/geometries/RoundedBoxGeometry.js';

export function buildDecor({ HALF, TOP, BACK, glowMat, canvasTex, rnd, SW, SH, SCY, SZ, ring }) {
  const groups = { b: new THREE.Group(), c: new THREE.Group(), d: new THREE.Group(), e: new THREE.Group() };
  const anim = [];
  const box = (g, mat, w, h, d, x, y, z, r = .04) => { const m = new THREE.Mesh(r ? new RoundedBoxGeometry(w, h, d, 3, r) : new THREE.BoxGeometry(w, h, d), mat); m.position.set(x, y, z); g.add(m); return m; };
  const cyl = (g, mat, rt, rb, h, x, y, z, seg = 24) => { const m = new THREE.Mesh(new THREE.CylinderGeometry(rt, rb, h, seg), mat); m.position.set(x, y, z); g.add(m); return m; };
  const WARM = new THREE.Color(1, .55, .2), GOLDC = new THREE.Color(1, .72, .2), CYAN = new THREE.Color(.25, .8, 1);
  // a frame round the screen in a room's own style
  const frame = (g, mat, ft, depth, r) => { const m = new THREE.Mesh(new THREE.ExtrudeGeometry(ring(SW + ft * 2, SH + ft * 2, ft, r), { depth, bevelEnabled: true, bevelThickness: .015, bevelSize: .012, bevelSegments: 4, curveSegments: 12 }), mat); m.position.set(0, SCY, SZ - depth - .01); g.add(m); return m; };

  // ---------- B: warm wood – a chesterfield, a wooden table, a fireplace, a bookcase ----------
  {
    const g = groups.b;
    const cognac = new THREE.MeshPhysicalMaterial({ color: 0x5a2a12, roughness: .45, clearcoat: .4, clearcoatRoughness: .4 });
    const wood = new THREE.MeshStandardMaterial({ color: 0x4a2c16, roughness: .5 });
    const S = new THREE.Group(); g.add(S);
    box(S, cognac, 2.8, .32, .95, 0, .24, 0, .05);
    for (let i = 0; i < 3; i++) box(S, cognac, .9, .16, .8, -.92 + i * .92, .46, .02, .07);
    const back = box(S, cognac, 2.8, .5, .22, 0, .66, .38, .08);
    for (let i = 0; i < 18; i++) {   // the buttons of the tufted back
      const b = new THREE.Mesh(new THREE.SphereGeometry(.018, 8, 6), cognac); b.position.set(-1.25 + (i % 9) * .31, .58 + Math.floor(i / 9) * .16, .26); S.add(b);
    }
    for (const s of [-1, 1]) {   // rolled arms
      box(S, cognac, .24, .42, .95, s * 1.42, .42, 0, .06);
      const roll = cyl(S, cognac, .14, .14, .98, s * 1.44, .66, 0); roll.rotation.x = Math.PI / 2;
    }
    S.position.set(.3, 0, 1.9);
    box(g, wood, 1.3, .06, .7, .3, .42, .55, .02);                                 // coffee table
    for (const [x, z] of [[-.55, -.28], [.55, -.28], [-.55, .28], [.55, .28]]) cyl(g, wood, .025, .02, .4, .3 + x, .2, .55 + z, 10);
    const mug = cyl(g, new THREE.MeshStandardMaterial({ color: 0xe8e0d4, roughness: .4 }), .04, .035, .09, .55, .495, .45, 16); mug.rotation.y = 1;
    // fireplace in the left wall: a dark stone surround, the fire flickers and lights the room
    const stone = new THREE.MeshStandardMaterial({ color: 0x2a2826, roughness: .9 });
    const F = new THREE.Group(); F.position.set(-HALF + .2, 0, -1.7); F.rotation.y = Math.PI / 2; g.add(F);
    box(F, stone, 1.5, 1.05, .4, 0, .52, 0, .02);
    box(F, new THREE.MeshStandardMaterial({ color: 0x050403, roughness: 1 }), 1, .6, .1, 0, .42, .16, 0);
    box(F, wood, 1.7, .08, .48, 0, 1.08, .02, .01);
    const fireMat = (seed, k) => new THREE.ShaderMaterial({
      uniforms: { uTime: { value: 0 }, uSeed: { value: seed }, uK: { value: k } },
      vertexShader: 'varying vec2 vUv;void main(){vUv=uv;gl_Position=projectionMatrix*modelViewMatrix*vec4(position,1.);}',
      fragmentShader: 'uniform float uTime,uSeed,uK;varying vec2 vUv;' +
        'float h(vec2 p){p=fract(p*vec2(123.34,456.21)+uSeed);p+=dot(p,p+45.32);return fract(p.x*p.y);}' +
        'float n(vec2 p){vec2 i=floor(p),f=fract(p);vec2 u=f*f*(3.-2.*f);return mix(mix(h(i),h(i+vec2(1,0)),u.x),mix(h(i+vec2(0,1)),h(i+vec2(1,1)),u.x),u.y);}' +
        'float fbm(vec2 p){float v=0.,a=.5;for(int i=0;i<5;i++){v+=a*n(p);p*=2.1;a*=.5;}return v;}' +
        'void main(){vec2 uv=vUv;float t=uTime;' +
        // rising, licking noise; several tongues across the width; thinner and gone towards the top
        ' vec2 q=vec2(uv.x*4.,uv.y*2.2-t*1.9);float f=fbm(q+vec2(fbm(q*1.7+t*.4)*.8,0.));' +
        ' float tongues=.55+.45*sin(uv.x*18.+fbm(vec2(uv.x*3.,t*.7))*6.);' +
        ' float body=smoothstep(.0,.15,uv.x)*smoothstep(1.,.85,uv.x)*(1.-uv.y);' +
        ' float fire=smoothstep(.25,.75,f*body*1.9*tongues+ (1.-uv.y)*.25-uv.y*.55);' +
        ' vec3 c=mix(vec3(.5,.05,0.),vec3(1.,.42,.05),smoothstep(.05,.45,fire));c=mix(c,vec3(1.,.85,.45),smoothstep(.5,.95,fire));' +
        ' gl_FragColor=vec4(c*fire*uK,fire);}',
      transparent: true, depthWrite: false, blending: THREE.AdditiveBlending, toneMapped: false, side: THREE.DoubleSide
    });
    const flames = [];
    for (const [z, seed, k, w] of [[.12, .17, .75, .92], [.2, .61, 1, .82], [.26, .93, .65, .7]]) {
      const fm = fireMat(seed, k), fl = new THREE.Mesh(new THREE.PlaneGeometry(w, .5), fm); fl.position.set(0, .4, z); F.add(fl); flames.push(fm);
    }
    const coals = new THREE.Mesh(new THREE.BoxGeometry(.75, .04, .18), glowMat(new THREE.Color(1, .3, .05), 1.4)); coals.position.set(0, .13, .2); F.add(coals);
    const logs = cyl(F, wood, .045, .045, .8, 0, .16, .2, 10); logs.rotation.z = Math.PI / 2;
    const fire = new THREE.PointLight(WARM, 0, 5, 1.5); fire.position.set(0, .45, .55); F.add(fire);
    anim.push((dt, sec, beat, lights) => {
      flames.forEach((fm) => { fm.uniforms.uTime.value = sec; });
      coals.material.color.setRGB(1, .3, .05).multiplyScalar(1.1 + .4 * Math.sin(sec * 2.3) * Math.sin(sec * 5.1));
      fire.intensity = (1.6 + Math.sin(sec * 9) * .25 + Math.sin(sec * 23) * .15) * Math.max(.4, lights);
    });
    frame(g, wood, .14, .06, .03);
    const fabric = new THREE.MeshStandardMaterial({ color: 0x2a2622, roughness: 1 });
    for (const s of [-1, 1]) { box(g, wood, .34, 1.05, .32, s * 2.3, .53, BACK + .45, .02); box(g, fabric, .28, .95, .02, s * 2.3, .55, BACK + .62, 0); }
    box(g, wood, 2.6, .5, .42, 0, .3, BACK + .25, .02);
    for (let i = 0; i < 3; i++) box(g, new THREE.MeshStandardMaterial({ color: 0x2e1b0d, roughness: .6 }), .8, .012, .01, -.86 + i * .86, .4, BACK + .47, 0);
    for (const z of [-2.6, -.6, 1.4]) box(g, new THREE.MeshStandardMaterial({ color: 0x2b1a0c, roughness: .7 }), HALF * 2, .18, .2, 0, TOP - .09, z, 0);
    // a bookcase in the back right corner
    const shelf = new THREE.Group(); shelf.position.set(2.85, 0, -3.5); g.add(shelf);
    const inner = new THREE.MeshStandardMaterial({ color: 0x1a110a, roughness: .9 });
    box(shelf, wood, .04, 2.1, .32, -.405, 1.05, 0, 0); box(shelf, wood, .04, 2.1, .32, .405, 1.05, 0, 0);   // sides
    box(shelf, wood, .85, .04, .32, 0, 2.08, 0, 0); box(shelf, wood, .85, .08, .32, 0, .04, 0, 0);             // top, plinth
    box(shelf, inner, .77, 2.04, .015, 0, 1.05, -.15, 0);                                                         // back
    const spines = [[.42, .12, .1], [.07, .3, .22], [.6, .25, .2], [.1, .2, .35], [.02, .45, .3], [.33, .3, .18], [.0, .0, .12]];
    for (let r = 0; r < 5; r++) {
      const y0 = .08 + r * .4;
      box(shelf, wood, .77, .025, .3, 0, y0, 0, 0);
      let x = -.37;
      const stopAt = r === 2 ? .05 : .36;
      while (x < stopAt) {
        const w = rnd(.022, .05), hh = rnd(.22, .33), sp = spines[Math.floor(Math.random() * spines.length)];
        const c = new THREE.Color().setHSL(sp[0] + rnd(-.03, .03), sp[1], sp[2] + rnd(-.05, .05));
        const b = box(shelf, new THREE.MeshStandardMaterial({ color: c, roughness: .75 }), w, hh, rnd(.17, .22), x + w / 2, y0 + .013 + hh / 2, .02, 0);
        if (Math.random() < .08) { b.rotation.z = -.25; b.position.x += .03; x += .03; }
        x += w + .003;
      }
      if (r === 2) {   // a small vase and a framed photo between the books
        cyl(shelf, new THREE.MeshPhysicalMaterial({ color: 0x2a4a3a, roughness: .2, clearcoat: 1 }), .05, .04, .2, .2, y0 + .11, 0, 20);
        const ph = box(shelf, new THREE.MeshStandardMaterial({ color: 0x111111, roughness: .5 }), .14, .18, .015, .32, y0 + .1, -.05, 0); ph.rotation.x = -.15;
      }
    }
  }

  // ---------- C: loft – a low modular sofa, industrial pendant lights, a shelf of records ----------
  {
    const g = groups.c;
    const fabric = new THREE.MeshStandardMaterial({ color: 0x3a3b3f, roughness: .95 });
    const metal = new THREE.MeshStandardMaterial({ color: 0x18181a, roughness: .35, metalness: .8 });
    const S = new THREE.Group(); S.position.set(.3, 0, 1.9); g.add(S);
    for (let i = 0; i < 3; i++) { box(S, fabric, .98, .26, 1, -1 + i, .13, 0, .06); box(S, fabric, .98, .32, .25, -1 + i, .42, .4, .1); box(S, fabric, .5, .14, .12, -1 + i + rnd(-.2, .2), .33, .25, .06); }
    box(S, fabric, .98, .26, 1.4, 1, .13, -1.1, .06);
    box(g, metal, 1.1, .05, .6, .3, .38, .55, .01);                                  // steel coffee table
    for (const [x, z] of [[-.5, -.25], [.5, -.25], [-.5, .25], [.5, .25]]) box(g, metal, .03, .36, .03, .3 + x, .18, .55 + z, 0);
    // pendant lights: a cord, a black cone and a glowing filament bulb
    for (const [x, z] of [[-2.25, .9], [2.45, .9], [2.45, -.9]]) {
      cyl(g, metal, .004, .004, .62, x, TOP - .31, z, 6);
      const shade = new THREE.Mesh(new THREE.ConeGeometry(.16, .18, 24, 1, true), new THREE.MeshStandardMaterial({ color: 0x111112, roughness: .4, metalness: .7, side: THREE.DoubleSide }));
      shade.position.set(x, TOP - .7, z); g.add(shade);
      const bulb = new THREE.Mesh(new THREE.SphereGeometry(.045, 16, 12), glowMat(new THREE.Color(1, .6, .25), 3)); bulb.position.set(x, TOP - .8, z); g.add(bulb);
      const l = new THREE.PointLight(new THREE.Color(1, .62, .3), 1.1, 4, 1.6); l.position.set(x, TOP - .85, z); g.add(l);
    }
    frame(g, new THREE.MeshStandardMaterial({ color: 0x0a0a0a, roughness: .6 }), .03, .02, .005);
    box(g, metal, .42, .16, .36, 0, TOP - .3, 1.2, .03); cyl(g, metal, .01, .01, .2, 0, TOP - .12, 1.2, 6);
    const lens = new THREE.Mesh(new THREE.CircleGeometry(.05, 20), glowMat(new THREE.Color(.8, .9, 1), 2)); lens.position.set(0, TOP - .3, 1.01); lens.rotation.y = Math.PI; g.add(lens);
    for (const x of [-1.3, 1.6]) { const d = cyl(g, new THREE.MeshStandardMaterial({ color: 0x8a8c90, roughness: .4, metalness: .9 }), .14, .14, 7.4, x, TOP - .17, -.2, 20); d.rotation.x = Math.PI / 2; }
    for (const s of [-1, 1]) { cyl(g, metal, .015, .015, .8, s * 2.35, .4, BACK + .7, 8); cyl(g, metal, .14, .14, .02, s * 2.35, .01, BACK + .7, 20); box(g, new THREE.MeshStandardMaterial({ color: 0x1c1c1e, roughness: .5 }), .24, .36, .26, s * 2.35, .98, BACK + .7, .02); const c = cyl(g, new THREE.MeshStandardMaterial({ color: 0x0a0a0a, roughness: .5 }), .07, .07, .01, s * 2.35, .93, BACK + .84, 20); c.rotation.x = Math.PI / 2; }
    // a low shelf of records with a turntable on the right wall
    const R = new THREE.Group(); R.position.set(HALF - .25, 0, -1.2); R.rotation.y = -Math.PI / 2; g.add(R);
    box(R, metal, 1.6, .55, .38, 0, .28, 0, .01);
    for (let i = 0; i < 26; i++) {
      const c = new THREE.Color().setHSL(rnd(0, 1), rnd(.3, .7), rnd(.2, .5));
      box(R, new THREE.MeshStandardMaterial({ color: c, roughness: .7 }), .012, .31, .31, -.72 + i * .056, .3, .02, 0);
    }
    box(R, new THREE.MeshStandardMaterial({ color: 0x0c0c0c, roughness: .3 }), .45, .08, .36, .45, .6, 0, .02);
    const platter = cyl(R, new THREE.MeshStandardMaterial({ color: 0x050505, roughness: .2, metalness: .3 }), .15, .15, .012, .42, .65, 0, 40);
    anim.push((dt) => { platter.rotation.y += dt * 3.5; });
  }

  // ---------- D: velvet and gold – a curved velvet sofa, gold globe lamps, brass tables, a palm ----------
  {
    const g = groups.d;
    const velvet = new THREE.MeshPhysicalMaterial({ color: 0x123326, roughness: .85, sheen: 1, sheenColor: new THREE.Color(.25, .6, .4), sheenRoughness: .4 });
    const brass = new THREE.MeshStandardMaterial({ color: 0xc9a14a, roughness: .25, metalness: 1 });
    const arc = (r0, r1, a0, a1) => { const s = new THREE.Shape(); s.absarc(0, 0, r1, a0, a1, false); s.absarc(0, 0, r0, a1, a0, true); return s; };
    const seat = new THREE.Mesh(new THREE.ExtrudeGeometry(arc(1.35, 2.25, Math.PI * 1.22, Math.PI * 1.78), { depth: .4, bevelEnabled: true, bevelThickness: .06, bevelSize: .06, bevelSegments: 4, curveSegments: 40 }), velvet);
    seat.rotation.x = -Math.PI / 2; seat.position.set(.3, .02, -.35); g.add(seat);
    const backr = new THREE.Mesh(new THREE.ExtrudeGeometry(arc(2.05, 2.3, Math.PI * 1.22, Math.PI * 1.78), { depth: .78, bevelEnabled: true, bevelThickness: .08, bevelSize: .06, bevelSegments: 4, curveSegments: 40 }), velvet);
    backr.rotation.x = -Math.PI / 2; backr.position.set(.3, .02, -.35); g.add(backr);
    for (const [x, z] of [[-1.6, 1.4], [2.2, 1.4]]) {   // brass side tables with a globe lamp
      cyl(g, brass, .22, .22, .03, x, .55, z, 32); cyl(g, brass, .02, .02, .55, x, .28, z, 10); cyl(g, brass, .16, .16, .02, x, .01, z, 32);
      const globe = new THREE.Mesh(new THREE.SphereGeometry(.13, 24, 16), glowMat(new THREE.Color(1, .75, .4), 1.6)); globe.position.set(x, .72, z); g.add(globe);
      const l = new THREE.PointLight(new THREE.Color(1, .72, .4), 1, 3.5, 1.6); l.position.set(x, .75, z); g.add(l);
    }
    frame(g, brass, .1, .05, .05);
    box(g, new THREE.MeshPhysicalMaterial({ color: 0x0c2a1e, roughness: .2, clearcoat: 1 }), 2.4, .42, .42, 0, .4, BACK + .26, .03);
    for (const x of [-1.1, 1.1]) for (const z of [BACK + .1, BACK + .42]) cyl(g, brass, .015, .01, .2, x, .1, z, 8);
    for (const s of [-1, 1]) { cyl(g, brass, .05, .05, .03, s * 2.4, 1.9, BACK + .02, 16).rotation.x = Math.PI / 2; box(g, brass, .02, .02, .2, s * 2.4, 1.9, BACK + .12, 0); const gl = new THREE.Mesh(new THREE.SphereGeometry(.09, 20, 14), glowMat(new THREE.Color(1, .75, .4), 1.6)); gl.position.set(s * 2.4, 1.97, BACK + .24); g.add(gl); const l = new THREE.PointLight(new THREE.Color(1, .72, .4), .8, 3, 1.6); l.position.copy(gl.position); g.add(l); }
    // a palm in a gold pot (back right)
    cyl(g, brass, .22, .17, .5, 2.85, .25, -3.35, 32);
    const frond = new THREE.MeshStandardMaterial({ color: 0x1f4a26, roughness: .5, side: THREE.DoubleSide });
    for (let i = 0; i < 11; i++) {
      const a = i / 11 * Math.PI * 2, L = rnd(.7, 1.05), geo = new THREE.PlaneGeometry(.34, L, 6, 10), p = geo.attributes.position;
      for (let k = 0; k < p.count; k++) { const y = p.getY(k) / L + .5, x = p.getX(k); p.setX(k, x * Math.sin(y * Math.PI) * 1.1); p.setY(k, y * L); p.setZ(k, -Math.pow(y, 1.8) * .45 + Math.abs(Math.sin(x * 60)) * .02); }
      geo.computeVertexNormals();
      const f = new THREE.Mesh(geo, frond); f.position.set(2.85, 1.05, -3.35); f.rotation.set(0, a, 0); f.rotateX(-.55); g.add(f);
      cyl(g, new THREE.MeshStandardMaterial({ color: 0x3a2a14, roughness: .9 }), .025, .03, .6, 2.85, .75, -3.35, 8);
    }
  }

  // ---------- E: graphite sci-fi – two white egg chairs, light lines in the floor, a ring of light under the ceiling ----------
  {
    const g = groups.e;
    const white = new THREE.MeshPhysicalMaterial({ color: 0xe6e6ea, roughness: .25, clearcoat: .8, clearcoatRoughness: .2 });
    const cushion = new THREE.MeshStandardMaterial({ color: 0x1a2a3a, roughness: .8 });
    for (const [x, ry] of [[-2.3, .5], [2.5, -.5]]) {
      const egg = new THREE.Mesh(new THREE.SphereGeometry(.55, 40, 24, Math.PI * .5, Math.PI, 0, Math.PI * .78), white);
      egg.material.side = THREE.DoubleSide; egg.position.set(x, .74, .9); egg.rotation.y = -Math.PI / 2 + ry; egg.scale.set(1, 1.15, 1); g.add(egg);
      const cu = box(g, cushion, .6, .1, .48, x, .42, .85, .05); cu.rotation.y = ry;
      cyl(g, white, .05, .2, .28, x, .14, .9, 24);
    }
    const edge = new THREE.Mesh(new THREE.ShapeGeometry(ring(SW + .05, SH + .05, .012, .04), 12), glowMat(CYAN, 2.2)); edge.position.set(0, SCY, SZ - .02); g.add(edge);
    for (const s of [-1, 1]) { box(g, white, .14, 1.7, .14, s * 2.35, .85, BACK + .45, .05); const st = new THREE.Mesh(new THREE.BoxGeometry(.03, 1.5, .02), glowMat(CYAN, 2)); st.position.set(s * 2.35, .85, BACK + .53); g.add(st); }
    box(g, white, 2.6, .07, .45, 0, .45, BACK + .3, .03);
    const under = new THREE.Mesh(new THREE.BoxGeometry(2.4, .005, .01), glowMat(CYAN, 2)); under.position.set(0, .41, BACK + .5); g.add(under);
    const lineM = glowMat(CYAN, 1.4);
    for (const [w, d, x, z] of [[3.8, .015, .2, -.95], [3.8, .015, .2, 2.75], [.015, 3.7, -1.7, .9], [.015, 3.7, 2.1, .9]]) {
      const m = new THREE.Mesh(new THREE.BoxGeometry(w, .004, d), lineM); m.position.set(x, .006, z); g.add(m);
    }
    const holo = new THREE.Mesh(new THREE.TorusGeometry(.9, .018, 10, 90), glowMat(CYAN, 1.8)); holo.position.set(.2, TOP - .35, .6); holo.rotation.x = Math.PI / 2; g.add(holo);
    const ring2 = new THREE.Mesh(new THREE.TorusGeometry(.62, .01, 8, 80), glowMat(CYAN, 1.2)); ring2.position.copy(holo.position); ring2.rotation.x = Math.PI / 2; g.add(ring2);
    const ringLight = new THREE.PointLight(CYAN, 1.2, 4.5, 1.6); ringLight.position.set(.2, TOP - .5, .6); g.add(ringLight);
    anim.push((dt, sec, beat) => {
      holo.rotation.z += dt * .25; ring2.rotation.z -= dt * .4;
      holo.position.y = TOP - .35 + Math.sin(sec * .8) * .03;
      holo.rotation.x = Math.PI / 2 + Math.sin(sec * .5) * .08; ring2.rotation.y = Math.sin(sec * .6) * .12;
      holo.material.color.copy(CYAN).multiplyScalar(1.6 + beat * 1.4); ringLight.intensity = 1 + beat;
    });
  }

  return {
    ...groups,
    update(dt, sec, beat, lights) { for (const f of anim) f(dt, sec, beat, lights); }
  };
}
