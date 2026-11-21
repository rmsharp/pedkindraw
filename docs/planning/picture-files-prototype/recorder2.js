// pedkindraw S69 (2026-11-21), Phase G16a's pre-RED measures: PROTOTYPE 2, NOT PACKAGE CODE.
// recorder.js's (S68) successor, written to measure what its faults cost and what fixes them
// (docs/planning/picture-files-plan.md, section 11). Not tested, not linted, not installed
// (docs/ is in .Rbuildignore). G16a writes the real recording layer, inst/js/, test first; this
// file is its measured starting point, not its source.
//
// What changed from recorder.js, each measured (section 11.2):
//  - drawImage() honours the SOURCE rectangle. vis.js keeps each icon in a mipmap canvas (25, 12,
//    6 and 3 px copies side by side, 36 x 25) and draws one region of it; recorder.js squeezed the
//    whole pyramid into each icon. MODE.legend: 'vector' finds the original SVG picture the region
//    was cut from and writes that (the chosen way, R143); 'crop' writes the region of the raster.
//  - the legend's title (a page div, not canvas drawing) is written as <text> (MODE.title).
//  - text baselines: MODE.base 'metrics' reads measureText().alphabeticBaseline (Chrome gives it
//    the opposite sign to the spec's wording and unscaled by the transform) and writes every label
//    with an alphabetic baseline; MODE.snap 'up' rounds that y to the nearest pixel, as canvas does.
//  - window.__lastOp / window.__nOps: the time of the last canvas call, for a quiet-time wait.
//  - NOT handled here (G16a's tests and GREEN): a device scale factor other than 1 (canvas width / CSS
//    width: the scratch reference scaled each canvas's group by it, with 6 decimals; 3 decimals turned
//    0.4996 into 0.5, 0.2 px across the legend).
//  - FIXED after the measures (S69, validating RED): with MODE.base 'metrics' the text elements carried
//    dominant-baseline="[object Object]" (the metrics map was the whole ternary's result: an
//    operator-precedence slip). Chrome ignores an invalid value and takes the alphabetic default, which
//    is what every measure in the plan's section 11 therefore measured; the line now writes 'alphabetic'.
//
// How it was used: window.__MODE = {...} set first, then this file, injected with Page$enable()
// FIRST and Page$addScriptToEvaluateOnNewDocument(); window.__svg() returns one SVG of every
// canvas's last frame.
(function () {
  var MODE = window.__MODE || {legend: 'vector', base: 'metrics', snap: 'up', title: true, tbase: 'central'};
  var proto = CanvasRenderingContext2D.prototype;
  var recs = []; window.__lastOp = performance.now(); window.__nOps = 0;
  window.__recs = recs;
  var byCanvas = new WeakMap();
  var PROPS = {fillStyle: 'fill', strokeStyle: 'stroke', lineWidth: 'lw', font: 'font',
    textAlign: 'ta', textBaseline: 'tb', globalAlpha: 'ga', lineDashOffset: 'doff',
    lineCap: 'cap', lineJoin: 'join'};
  function fresh() {
    return {m: [1, 0, 0, 1, 0, 0], fill: '#000000', stroke: '#000000', lw: 1,
      font: '10px sans-serif', ta: 'start', tb: 'alphabetic', ga: 1, dash: [], doff: 0,
      cap: 'butt', join: 'miter', clip: null};
  }
  function clone(s) {
    var c = {}; for (var k in s) { c[k] = s[k]; }
    c.m = s.m.slice(); c.dash = s.dash.slice(); return c;
  }
  function R(ctx) {
    var cv = ctx.canvas, r = byCanvas.get(cv);
    if (!r) {
      r = {ctx: ctx, cv: cv, ops: [], defs: [], clipN: 0, stack: [], s: fresh(), d: '', has: false, draws: []};
      byCanvas.set(cv, r); recs.push(r);
    }
    return r;
  }
  function P(r, x, y) {
    var m = r.s.m; return [m[0] * x + m[2] * y + m[4], m[1] * x + m[3] * y + m[5]];
  }
  function sc(r) { var m = r.s.m; return Math.sqrt(Math.abs(m[0] * m[3] - m[1] * m[2])); }
  function n(v) { return Math.round(v * 1000) / 1000; }
  function esc(t) {
    return String(t).replace(/&/g, '&amp;').replace(/</g, '&lt;').replace(/>/g, '&gt;');
  }
  function clipAttr(r) { return r.s.clip ? ' clip-path="url(#' + r.s.clip + ')"' : ''; }
  function addPoint(r, cmd, x, y) {
    var p = P(r, x, y); r.d += cmd + n(p[0]) + ' ' + n(p[1]) + ' '; r.has = true;
  }
  var wrap = {
    save: function (r) { r.stack.push(clone(r.s)); },
    restore: function (r) { if (r.stack.length) { r.s = r.stack.pop(); } },
    beginPath: function (r) { r.d = ''; r.has = false; },
    closePath: function (r) { r.d += 'Z '; },
    moveTo: function (r, x, y) { addPoint(r, 'M', x, y); },
    lineTo: function (r, x, y) { addPoint(r, r.has ? 'L' : 'M', x, y); },
    quadraticCurveTo: function (r, cx, cy, x, y) {
      var c = P(r, cx, cy), p = P(r, x, y);
      r.d += 'Q' + n(c[0]) + ' ' + n(c[1]) + ' ' + n(p[0]) + ' ' + n(p[1]) + ' ';
    },
    rect: function (r, x, y, w, h) {
      addPoint(r, 'M', x, y); addPoint(r, 'L', x + w, y); addPoint(r, 'L', x + w, y + h);
      addPoint(r, 'L', x, y + h); r.d += 'Z ';
    },
    arc: function (r, x, y, rad, a0, a1, ccw) {
      var s = sc(r) * rad, TAU = 2 * Math.PI;
      var p0 = P(r, x + rad * Math.cos(a0), y + rad * Math.sin(a0));
      r.d += (r.has ? 'L' : 'M') + n(p0[0]) + ' ' + n(p0[1]) + ' '; r.has = true;
      var delta = ccw ? a0 - a1 : a1 - a0;
      if (delta >= TAU - 1e-9) {
        var pm = P(r, x + rad * Math.cos(a0 + Math.PI), y + rad * Math.sin(a0 + Math.PI));
        var sw = ccw ? 0 : 1;
        r.d += 'A' + n(s) + ' ' + n(s) + ' 0 1 ' + sw + ' ' + n(pm[0]) + ' ' + n(pm[1]) + ' ';
        r.d += 'A' + n(s) + ' ' + n(s) + ' 0 1 ' + sw + ' ' + n(p0[0]) + ' ' + n(p0[1]) + ' ';
      } else {
        delta = ((delta % TAU) + TAU) % TAU;
        var p1 = P(r, x + rad * Math.cos(a1), y + rad * Math.sin(a1));
        r.d += 'A' + n(s) + ' ' + n(s) + ' 0 ' + (delta > Math.PI ? 1 : 0) + ' ' +
          (ccw ? 0 : 1) + ' ' + n(p1[0]) + ' ' + n(p1[1]) + ' ';
      }
    },
    fill: function (r) {
      if (!r.d) { return; }
      r.ops.push('<path d="' + r.d + '" fill="' + esc(r.s.fill) + '" fill-opacity="' + r.s.ga +
        '"' + clipAttr(r) + '/>');
    },
    stroke: function (r) {
      if (!r.d) { return; }
      var s = r.s, k = sc(r), dash = s.dash.map(function (v) { return n(v * k); }).join(' ');
      r.ops.push('<path d="' + r.d + '" fill="none" stroke="' + esc(s.stroke) +
        '" stroke-opacity="' + s.ga + '" stroke-width="' + n(s.lw * k) + '"' +
        (dash ? ' stroke-dasharray="' + dash + '" stroke-dashoffset="' + n(s.doff * k) + '"' : '') +
        ' stroke-linecap="' + s.cap + '" stroke-linejoin="' + s.join + '"' + clipAttr(r) + '/>');
    },
    clip: function (r) {
      var id = 'c' + (r.clipN++) + '_' + recs.indexOf(r);
      r.defs.push('<clipPath id="' + id + '"><path d="' + r.d + '"/></clipPath>');
      r.s.clip = id;
    },
    fillRect: function (r, x, y, w, h) {
      var a = P(r, x, y), k = sc(r);
      r.ops.push('<rect x="' + n(a[0]) + '" y="' + n(a[1]) + '" width="' + n(w * k) +
        '" height="' + n(h * k) + '" fill="' + esc(r.s.fill) + '" fill-opacity="' + r.s.ga +
        '"' + clipAttr(r) + '/>');
    },
    clearRect: function (r) { r.ops = []; r.defs = []; r.clipN = 0; },
    setLineDash: function (r, d) { r.s.dash = (d || []).slice(); },
    setTransform: function (r, a, b, c, d, e, f) {
      r.s.m = (arguments.length >= 7) ? [a, b, c, d, e, f] : [1, 0, 0, 1, 0, 0];
    },
    translate: function (r, tx, ty) {
      var m = r.s.m; m[4] = m[0] * tx + m[2] * ty + m[4]; m[5] = m[1] * tx + m[3] * ty + m[5];
    },
    scale: function (r, sx, sy) {
      var m = r.s.m; m[0] *= sx; m[1] *= sx; m[2] *= sy; m[3] *= sy;
    },
    fillText: function (r, t, x, y) { text(r, t, x, y, false); },
    strokeText: function (r, t, x, y) { text(r, t, x, y, true); },
    drawImage: function (r, img) {
      var a = arguments, sx, sy, sw, sh, dx, dy, dw, dh;
      var iw = img.naturalWidth || img.width, ih = img.naturalHeight || img.height;
      if (a.length === 4) { dx = a[2]; dy = a[3]; dw = iw; dh = ih; sx = 0; sy = 0; sw = iw; sh = ih; }
      else if (a.length === 6) { dx = a[2]; dy = a[3]; dw = a[4]; dh = a[5]; sx = 0; sy = 0; sw = iw; sh = ih; }
      else { sx = a[2]; sy = a[3]; sw = a[4]; sh = a[5]; dx = a[6]; dy = a[7]; dw = a[8]; dh = a[9]; }
      var isCanvas = !!img.getContext, srcUrl = isCanvas ? null : img.src;
      r.draws.push({src: srcUrl, dx: dx, dy: dy, dw: dw, dh: dh});
      var p = P(r, dx, dy), k = sc(r), href = null, vector = false;
      if (MODE.legend === 'vector' && isCanvas) {
        var rr = byCanvas.get(img);
        if (rr) {
          for (var i = rr.draws.length - 1; i >= 0; i--) {
            var d = rr.draws[i];
            if (d.src && /^data:image\/svg\+xml/.test(d.src) && Math.abs(d.dx - sx) < 0.5 &&
                Math.abs(d.dy - sy) < 0.5 && Math.abs(d.dw - sw) < 0.5 && Math.abs(d.dh - sh) < 0.5) {
              href = d.src; vector = true; break;
            }
          }
        }
      }
      if (!href) { href = srcUrl || (img.toDataURL ? img.toDataURL() : ''); }
      var mm = /^data:image\/svg\+xml;charset=utf-8,(.*)$/.exec(href);
      if (mm) {
        var sv = decodeURIComponent(mm[1]), wh = /<svg [^>]*width='(\d+)' height='(\d+)'/.exec(sv);
        if (wh && !/viewBox/.test(sv)) {
          sv = sv.replace('<svg ', "<svg viewBox='0 0 " + wh[1] + ' ' + wh[2] + "' ");
          href = 'data:image/svg+xml;charset=utf-8,' + encodeURIComponent(sv);
        }
      }
      var whole = (sx === 0 && sy === 0 && Math.abs(sw - iw) < 0.5 && Math.abs(sh - ih) < 0.5);
      if (MODE.legend === 'raw' || vector || whole) {
        // raw = the prototype's behaviour (whole image squeezed into the destination)
        r.ops.push('<image href="' + esc(href) + '" x="' + n(p[0]) + '" y="' + n(p[1]) +
          '" width="' + n(dw * k) + '" height="' + n(dh * k) + '"' + (vector ? '' : ' preserveAspectRatio="none"') + clipAttr(r) + '/>');
      } else {
        // crop the source rectangle (a mipmap level) out of the raster
        r.ops.push('<svg x="' + n(p[0]) + '" y="' + n(p[1]) + '" width="' + n(dw * k) + '" height="' +
          n(dh * k) + '" viewBox="' + n(sx) + ' ' + n(sy) + ' ' + n(sw) + ' ' + n(sh) +
          '" preserveAspectRatio="none"' + clipAttr(r) + '><image href="' + esc(href) +
          '" width="' + n(iw) + '" height="' + n(ih) + '"/></svg>');
      }
    }
  };
  function text(r, t, x, y, stroked) {
    var s = r.s, p = P(r, x, y), k = sc(r);
    var dyMetrics = false;
    if (MODE.base === 'metrics') {
      try { p[1] -= r.ctx.measureText(String(t)).alphabeticBaseline * k; dyMetrics = true; } catch (e) { window.__recErr = String(e); }
    }
    if (MODE.snap === 'down') { p[1] = Math.ceil(p[1] - 0.5); }
    if (MODE.snap === 'up') { p[1] = Math.round(p[1]); }
    if (MODE.snap === 'floor') { p[1] = Math.floor(p[1]); }
    var f = /^((?:italic |bold |normal )*)\s*([0-9.]+)px\s+(.+)$/.exec(s.font) || [0, '', '10', 'sans-serif'];
    var anchor = {start: 'start', left: 'start', end: 'end', right: 'end', center: 'middle'}[s.ta] || 'start';
    var base = dyMetrics ? 'alphabetic' : ({alphabetic: 'alphabetic', middle: MODE.base, top: 'text-before-edge',
      bottom: 'text-after-edge', hanging: 'hanging', ideographic: 'ideographic'}[s.tb] || 'alphabetic');
    var style = (/bold/.test(f[1]) ? ' font-weight="bold"' : '') + (/italic/.test(f[1]) ? ' font-style="italic"' : '');
    r.ops.push('<text x="' + n(p[0]) + '" y="' + n(p[1]) + '" font-family="' + esc(f[3]) +
      '" font-size="' + n(parseFloat(f[2]) * k) + '"' + style + ' text-anchor="' + anchor +
      '" dominant-baseline="' + base + '"' +
      (stroked ? ' fill="none" stroke="' + esc(s.stroke) + '" stroke-width="' + n(s.lw * k) +
        '" stroke-linejoin="round"' : ' fill="' + esc(s.fill) + '"') +
      ' fill-opacity="' + s.ga + '"' + clipAttr(r) + '>' + esc(t) + '</text>');
  }
  Object.keys(wrap).forEach(function (k) {
    var orig = proto[k];
    Object.defineProperty(proto, k, {configurable: true, writable: true, value: function () {
      var r = R(this), a = Array.prototype.slice.call(arguments);
      window.__lastOp = performance.now(); window.__nOps++;
      try { wrap[k].apply(null, [r].concat(a)); } catch (e) { window.__recErr = String(e); }
      return orig.apply(this, arguments);
    }});
  });
  Object.keys(PROPS).forEach(function (k) {
    var d = Object.getOwnPropertyDescriptor(proto, k);
    Object.defineProperty(proto, k, {configurable: true, get: d.get, set: function (v) {
      R(this).s[PROPS[k]] = v; return d.set.call(this, v);
    }});
  });
  // Compose every canvas's last frame into one SVG at the canvases' positions.
  window.__svg = function (opts) {
    opts = opts || {};
    var boxes = recs.map(function (r) {
      var b = r.cv.getBoundingClientRect(); return {r: r, x: b.left, y: b.top, w: b.width, h: b.height};
    }).filter(function (b) { return b.w > 0 && b.h > 0; });
    var x0 = Math.min.apply(null, boxes.map(function (b) { return b.x; }));
    var y0 = Math.min.apply(null, boxes.map(function (b) { return b.y; }));
    var x1 = Math.max.apply(null, boxes.map(function (b) { return b.x + b.w; }));
    var y1 = Math.max.apply(null, boxes.map(function (b) { return b.y + b.h; }));
    var out = ['<svg xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" ' +
      'width="' + n(x1 - x0) + '" height="' + n(y1 - y0) + '" viewBox="0 0 ' + n(x1 - x0) + ' ' +
      n(y1 - y0) + '"><rect width="100%" height="100%" fill="#ffffff"/>'];
    boxes.forEach(function (b, i) {
      out.push('<defs><clipPath id="box' + i + '"><rect width="' + n(b.w) + '" height="' +
        n(b.h) + '"/></clipPath>' + b.r.defs.join('') + '</defs>');
      out.push('<g transform="translate(' + n(b.x - x0) + ' ' + n(b.y - y0) + ')" clip-path="url(#box' +
        i + ')">' + b.r.ops.join('') + '</g>');
    });
    if (MODE.title) {
      document.querySelectorAll('[id^="legend_main"] div').forEach(function (e) {
        if (e.children.length > 0 || !e.textContent.trim()) { return; }
        var b = e.getBoundingClientRect(), cs = getComputedStyle(e);
        var al = cs.textAlign, ax = (al === 'center') ? b.left + b.width / 2 : (al === 'right' || al === 'end') ? b.right : b.left;
        out.push('<text x="' + n(ax - x0) + '" y="' + n(b.top - y0 + b.height / 2) + '" font-family="' +
          esc(cs.fontFamily.replace(/"/g, "'")) + '" font-size="' + n(parseFloat(cs.fontSize)) + '"' +
          (parseInt(cs.fontWeight, 10) >= 600 ? ' font-weight="bold"' : '') + ' text-anchor="' +
          ((al === 'center') ? 'middle' : (al === 'right' || al === 'end') ? 'end' : 'start') +
          '" dominant-baseline="' + (MODE.tbase || MODE.base) + '" fill="' + esc(cs.color) + '">' + esc(e.textContent.trim()) + '</text>');
      });
    }
    out.push('</svg>');
    return JSON.stringify({svg: out.join('\n'), x: x0, y: y0, w: x1 - x0, h: y1 - y0,
      xs: boxes.map(function (b) { return b.x - x0; }),
      canvases: boxes.length, ops: boxes.map(function (b) { return b.r.ops.length; })});
  };
})();
