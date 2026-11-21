// Copyright(c) 2017-2026 R. Mark Sharp
// This file is part of pedkindraw
//
// The recording layer of savePedigreeDiagram() (R/savePedigreeDiagram.R;
// pedkindraw Phase G16a, rulings R142 and R143; docs/planning/
// picture-files-plan.md section 11). It is injected into a headless Chrome
// page BEFORE the saved drawPedigreeDiagram() widget runs, and records every
// call the widget makes on a canvas, so that window.__svg() can write what the
// widget drew as one SVG: the widget's own drawing, with no second version to
// keep alike.
//
// Measured against the live widget (section 11.2): the four-animal drawing
// and legend, and each of 12 typed shapes, 0.0% of their ink differing; an
// 18-animal pedigree with every mark 0.4% (drawing) and 0.2% (legend).
//
// What each part is for:
//  - drawImage() honours the SOURCE rectangle. vis.js keeps each legend icon
//    in a detached mipmap canvas (copies at 25, 12, 6 and 3 px side by side)
//    and draws one region of it; that canvas was itself drawn from the
//    original SVG picture, which is written (as a vector) instead.
//  - A text baseline is written as an alphabetic one, read from the canvas
//    itself (measureText().alphabeticBaseline) and rounded to the nearest
//    pixel as the canvas rounds it: canvas "middle" is not SVG "central".
//  - A canvas is written as the browser paints it: its box at whole device
//    pixels (the legend's left edge, 731.203, is painted at 731) and its
//    pixels unstretched, so scaled by 1 over the device pixel ratio (at a
//    ratio of 2 it has twice the pixels of its box). Measured, the legend's
//    ink differing from the live widget: 1.10% with the unsnapped box, 0.03%
//    with it snapped; scaling by CSS size over pixel size (1.000289 for the
//    drawing, 0.999265 for the legend) stretched what the browser does not.
//  - The legend's title is a page element, not canvas drawing: it is written
//    as text.
//
// The page asks, through Runtime.evaluate: window.__ready(), "<canvases drawn>
// <ms since the last canvas call> <1 when every legend picture has loaded>",
// and window.__svg(widthIn, heightIn), "<x> <y> <width> <height>" of the
// canvases' box in CSS pixels, a newline, then the SVG. A string, not JSON, so
// the R side needs no JSON package.
(function () {
  var proto = CanvasRenderingContext2D.prototype;
  var recs = [];
  var byCanvas = new WeakMap();
  window.__lastOp = performance.now();
  var PROPS = {fillStyle: 'fill', strokeStyle: 'stroke', lineWidth: 'lw',
    font: 'font', textAlign: 'ta', textBaseline: 'tb', globalAlpha: 'ga',
    lineDashOffset: 'doff', lineCap: 'cap', lineJoin: 'join'};
  function fresh() {
    return {m: [1, 0, 0, 1, 0, 0], fill: '#000000', stroke: '#000000', lw: 1,
      font: '10px sans-serif', ta: 'start', tb: 'alphabetic', ga: 1, dash: [],
      doff: 0, cap: 'butt', join: 'miter', clip: null};
  }
  function clone(s) {
    var c = {};
    for (var k in s) { c[k] = s[k]; }
    c.m = s.m.slice();
    c.dash = s.dash.slice();
    return c;
  }
  function R(ctx) {
    var cv = ctx.canvas, r = byCanvas.get(cv);
    if (!r) {
      r = {ctx: ctx, cv: cv, ops: [], defs: [], clipN: 0, stack: [],
        s: fresh(), d: '', has: false, draws: []};
      byCanvas.set(cv, r);
      recs.push(r);
    }
    return r;
  }
  function P(r, x, y) {
    var m = r.s.m;
    return [m[0] * x + m[2] * y + m[4], m[1] * x + m[3] * y + m[5]];
  }
  function sc(r) {
    var m = r.s.m;
    return Math.sqrt(Math.abs(m[0] * m[3] - m[1] * m[2]));
  }
  function n(v) { return Math.round(v * 1000) / 1000; }
  function n6(v) { return Math.round(v * 1000000) / 1000000; }
  function esc(t) {
    return String(t).replace(/&/g, '&amp;').replace(/</g, '&lt;')
      .replace(/>/g, '&gt;');
  }
  function clipAttr(r) {
    return r.s.clip ? ' clip-path="url(#' + r.s.clip + ')"' : '';
  }
  function addPoint(r, cmd, x, y) {
    var p = P(r, x, y);
    r.d += cmd + n(p[0]) + ' ' + n(p[1]) + ' ';
    r.has = true;
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
      r.d += 'Q' + n(c[0]) + ' ' + n(c[1]) + ' ' + n(p[0]) + ' ' + n(p[1]) +
        ' ';
    },
    rect: function (r, x, y, w, h) {
      addPoint(r, 'M', x, y);
      addPoint(r, 'L', x + w, y);
      addPoint(r, 'L', x + w, y + h);
      addPoint(r, 'L', x, y + h);
      r.d += 'Z ';
    },
    arc: function (r, x, y, rad, a0, a1, ccw) {
      var s = sc(r) * rad, TAU = 2 * Math.PI;
      var p0 = P(r, x + rad * Math.cos(a0), y + rad * Math.sin(a0));
      r.d += (r.has ? 'L' : 'M') + n(p0[0]) + ' ' + n(p0[1]) + ' ';
      r.has = true;
      var delta = ccw ? a0 - a1 : a1 - a0;
      if (delta >= TAU - 1e-9) {
        var pm = P(r, x + rad * Math.cos(a0 + Math.PI),
          y + rad * Math.sin(a0 + Math.PI));
        var sw = ccw ? 0 : 1;
        r.d += 'A' + n(s) + ' ' + n(s) + ' 0 1 ' + sw + ' ' + n(pm[0]) + ' ' +
          n(pm[1]) + ' ';
        r.d += 'A' + n(s) + ' ' + n(s) + ' 0 1 ' + sw + ' ' + n(p0[0]) + ' ' +
          n(p0[1]) + ' ';
      } else {
        delta = ((delta % TAU) + TAU) % TAU;
        var p1 = P(r, x + rad * Math.cos(a1), y + rad * Math.sin(a1));
        r.d += 'A' + n(s) + ' ' + n(s) + ' 0 ' + (delta > Math.PI ? 1 : 0) +
          ' ' + (ccw ? 0 : 1) + ' ' + n(p1[0]) + ' ' + n(p1[1]) + ' ';
      }
    },
    fill: function (r) {
      if (!r.d) { return; }
      r.ops.push('<path d="' + r.d + '" fill="' + esc(r.s.fill) +
        '" fill-opacity="' + r.s.ga + '"' + clipAttr(r) + '/>');
    },
    stroke: function (r) {
      if (!r.d) { return; }
      var s = r.s, k = sc(r);
      var dash = s.dash.map(function (v) { return n(v * k); }).join(' ');
      r.ops.push('<path d="' + r.d + '" fill="none" stroke="' + esc(s.stroke) +
        '" stroke-opacity="' + s.ga + '" stroke-width="' + n(s.lw * k) + '"' +
        (dash ? ' stroke-dasharray="' + dash + '" stroke-dashoffset="' +
          n(s.doff * k) + '"' : '') +
        ' stroke-linecap="' + s.cap + '" stroke-linejoin="' + s.join + '"' +
        clipAttr(r) + '/>');
    },
    clip: function (r) {
      var id = 'c' + (r.clipN++) + '_' + recs.indexOf(r);
      r.defs.push('<clipPath id="' + id + '"><path d="' + r.d +
        '"/></clipPath>');
      r.s.clip = id;
    },
    fillRect: function (r, x, y, w, h) {
      var a = P(r, x, y), k = sc(r);
      r.ops.push('<rect x="' + n(a[0]) + '" y="' + n(a[1]) + '" width="' +
        n(w * k) + '" height="' + n(h * k) + '" fill="' + esc(r.s.fill) +
        '" fill-opacity="' + r.s.ga + '"' + clipAttr(r) + '/>');
    },
    clearRect: function (r) { r.ops = []; r.defs = []; r.clipN = 0; },
    setLineDash: function (r, d) { r.s.dash = (d || []).slice(); },
    setTransform: function (r, a, b, c, d, e, f) {
      r.s.m = (arguments.length >= 7) ? [a, b, c, d, e, f] : [1, 0, 0, 1, 0, 0];
    },
    translate: function (r, tx, ty) {
      var m = r.s.m;
      m[4] = m[0] * tx + m[2] * ty + m[4];
      m[5] = m[1] * tx + m[3] * ty + m[5];
    },
    scale: function (r, sx, sy) {
      var m = r.s.m;
      m[0] *= sx; m[1] *= sx; m[2] *= sy; m[3] *= sy;
    },
    fillText: function (r, t, x, y) { text(r, t, x, y, false); },
    strokeText: function (r, t, x, y) { text(r, t, x, y, true); },
    drawImage: function (r, img) {
      var a = arguments, sx, sy, sw, sh, dx, dy, dw, dh;
      var iw = img.naturalWidth || img.width, ih = img.naturalHeight || img.height;
      if (a.length === 4) {
        dx = a[2]; dy = a[3]; dw = iw; dh = ih; sx = 0; sy = 0; sw = iw; sh = ih;
      } else if (a.length === 6) {
        dx = a[2]; dy = a[3]; dw = a[4]; dh = a[5]; sx = 0; sy = 0; sw = iw;
        sh = ih;
      } else {
        sx = a[2]; sy = a[3]; sw = a[4]; sh = a[5];
        dx = a[6]; dy = a[7]; dw = a[8]; dh = a[9];
      }
      var isCanvas = !!img.getContext, srcUrl = isCanvas ? null : img.src;
      r.draws.push({src: srcUrl, dx: dx, dy: dy, dw: dw, dh: dh});
      var p = P(r, dx, dy), k = sc(r), href = null, vector = false;
      // A canvas drawn from an SVG picture: find that picture's draw of the
      // region being copied, and write the picture.
      var rr = isCanvas ? byCanvas.get(img) : null;
      if (rr) {
        for (var i = rr.draws.length - 1; i >= 0; i--) {
          var d = rr.draws[i];
          if (d.src && /^data:image\/svg\+xml/.test(d.src) &&
              Math.abs(d.dx - sx) < 0.5 && Math.abs(d.dy - sy) < 0.5 &&
              Math.abs(d.dw - sw) < 0.5 && Math.abs(d.dh - sh) < 0.5) {
            href = d.src;
            vector = true;
            break;
          }
        }
      }
      if (!href) { href = srcUrl || (img.toDataURL ? img.toDataURL() : ''); }
      // pedkindraw's pictures are width x height with no viewBox: add one,
      // or the picture is clipped, not scaled, to the box it is written in.
      var mm = /^data:image\/svg\+xml;charset=utf-8,(.*)$/.exec(href);
      if (mm) {
        var sv = decodeURIComponent(mm[1]);
        var wh = /<svg [^>]*width='(\d+)' height='(\d+)'/.exec(sv);
        if (wh && !/viewBox/.test(sv)) {
          sv = sv.replace('<svg ', "<svg viewBox='0 0 " + wh[1] + ' ' + wh[2] +
            "' ");
          href = 'data:image/svg+xml;charset=utf-8,' + encodeURIComponent(sv);
        }
      }
      var whole = (sx === 0 && sy === 0 && Math.abs(sw - iw) < 0.5 &&
        Math.abs(sh - ih) < 0.5);
      if (vector || whole) {
        r.ops.push('<image href="' + esc(href) + '" x="' + n(p[0]) + '" y="' +
          n(p[1]) + '" width="' + n(dw * k) + '" height="' + n(dh * k) + '"' +
          (vector ? '' : ' preserveAspectRatio="none"') + clipAttr(r) + '/>');
      } else {
        // The region of a raster: a nested svg crops it to the region.
        r.ops.push('<svg x="' + n(p[0]) + '" y="' + n(p[1]) + '" width="' +
          n(dw * k) + '" height="' + n(dh * k) + '" viewBox="' + n(sx) + ' ' +
          n(sy) + ' ' + n(sw) + ' ' + n(sh) + '" preserveAspectRatio="none"' +
          clipAttr(r) + '><image href="' + esc(href) + '" width="' + n(iw) +
          '" height="' + n(ih) + '"/></svg>');
      }
    }
  };
  function text(r, t, x, y, stroked) {
    var s = r.s, p = P(r, x, y), k = sc(r);
    // Chrome gives the offset from the baseline in use to the alphabetic
    // one, not scaled by the transform and with the opposite sign to the
    // specification's wording.
    p[1] = Math.round(p[1] - r.ctx.measureText(String(t)).alphabeticBaseline * k);
    var f = /^((?:italic |bold |normal )*)\s*([0-9.]+)px\s+(.+)$/.exec(s.font) ||
      [0, '', '10', 'sans-serif'];
    var anchor = {start: 'start', left: 'start', end: 'end', right: 'end',
      center: 'middle'}[s.ta] || 'start';
    var style = (/bold/.test(f[1]) ? ' font-weight="bold"' : '') +
      (/italic/.test(f[1]) ? ' font-style="italic"' : '');
    r.ops.push('<text x="' + n(p[0]) + '" y="' + n(p[1]) + '" font-family="' +
      esc(f[3]) + '" font-size="' + n(parseFloat(f[2]) * k) + '"' + style +
      ' text-anchor="' + anchor + '" dominant-baseline="alphabetic"' +
      (stroked ? ' fill="none" stroke="' + esc(s.stroke) + '" stroke-width="' +
        n(s.lw * k) + '" stroke-linejoin="round"' :
        ' fill="' + esc(s.fill) + '"') +
      ' fill-opacity="' + s.ga + '"' + clipAttr(r) + '>' + esc(t) + '</text>');
  }
  Object.keys(wrap).forEach(function (k) {
    var orig = proto[k];
    Object.defineProperty(proto, k, {configurable: true, writable: true,
      value: function () {
        var r = R(this), a = Array.prototype.slice.call(arguments);
        window.__lastOp = performance.now();
        try { wrap[k].apply(null, [r].concat(a)); } catch (e) {
          window.__recErr = String(e);
        }
        return orig.apply(this, arguments);
      }});
  });
  Object.keys(PROPS).forEach(function (k) {
    var d = Object.getOwnPropertyDescriptor(proto, k);
    Object.defineProperty(proto, k, {configurable: true, get: d.get,
      set: function (v) {
        R(this).s[PROPS[k]] = v;
        return d.set.call(this, v);
      }});
  });
  window.__ready = function () {
    var drawn = recs.filter(function (r) {
      return document.contains(r.cv) && r.ops.length > 0;
    }).length;
    var el = document.querySelector('.visNetwork');
    var w = el && window.HTMLWidgets && HTMLWidgets.find('#' + el.id);
    var pictures = true;
    if (w && w.legend) {
      var L = w.legend;
      pictures = L.body.nodeIndices.every(function (id) {
        var node = L.body.nodes[id];
        return node.options.shape !== 'image' ||
          (!!node.shape.imageObj && node.shape.imageObj.width > 0);
      });
    }
    return drawn + ' ' + (performance.now() - window.__lastOp) + ' ' +
      (pictures ? 1 : 0);
  };
  // Every canvas's last frame, composed into one SVG at the canvases' places.
  // The browser paints a canvas at whole device pixels.
  function snap(v) {
    var ratio = window.devicePixelRatio;
    return Math.round(v * ratio) / ratio;
  }
  window.__svg = function (widthIn, heightIn) {
    var boxes = recs.map(function (r) {
      var b = r.cv.getBoundingClientRect();
      return {r: r, x: b.left, y: b.top, w: b.width, h: b.height};
    }).filter(function (b) { return b.w > 0 && b.h > 0; });
    var x0 = Math.min.apply(null, boxes.map(function (b) { return b.x; }));
    var y0 = Math.min.apply(null, boxes.map(function (b) { return b.y; }));
    var x1 = Math.max.apply(null, boxes.map(function (b) { return b.x + b.w; }));
    var y1 = Math.max.apply(null, boxes.map(function (b) { return b.y + b.h; }));
    var W = x1 - x0, H = y1 - y0;
    var out = ['<svg xmlns="http://www.w3.org/2000/svg" width="' +
      n6(widthIn || W / 96) + 'in" height="' + n6(heightIn || H / 96) +
      'in" viewBox="0 0 ' + n6(W) + ' ' + n6(H) +
      '" preserveAspectRatio="xMidYMid meet">' +
      '<rect width="100%" height="100%" fill="#ffffff"/>'];
    boxes.forEach(function (b, i) {
      out.push('<defs><clipPath id="box' + i + '"><rect width="' +
        n(b.r.cv.width) + '" height="' + n(b.r.cv.height) + '"/></clipPath>' +
        b.r.defs.join('') + '</defs>');
      out.push('<g transform="translate(' + n(snap(b.x) - x0) + ' ' +
        n(snap(b.y) - y0) +
        ') scale(' + n6(1 / window.devicePixelRatio) +
        ')" clip-path="url(#box' + i + ')">' + b.r.ops.join('') + '</g>');
    });
    document.querySelectorAll('[id^="legend_main"] div').forEach(function (e) {
      if (e.children.length > 0 || !e.textContent.trim()) { return; }
      var b = e.getBoundingClientRect(), cs = getComputedStyle(e);
      var al = cs.textAlign;
      var ax = (al === 'center') ? b.left + b.width / 2 :
        (al === 'right' || al === 'end') ? b.right : b.left;
      out.push('<text x="' + n(ax - x0) + '" y="' +
        n(b.top - y0 + b.height / 2) + '" font-family="' +
        esc(cs.fontFamily.replace(/"/g, "'")) + '" font-size="' +
        n(parseFloat(cs.fontSize)) + '"' +
        (parseInt(cs.fontWeight, 10) >= 600 ? ' font-weight="bold"' : '') +
        ' text-anchor="' + ((al === 'center') ? 'middle' :
          (al === 'right' || al === 'end') ? 'end' : 'start') +
        '" dominant-baseline="central" fill="' + esc(cs.color) + '">' +
        esc(e.textContent.trim()) + '</text>');
    });
    out.push('</svg>');
    return n6(x0) + ' ' + n6(y0) + ' ' + n6(W) + ' ' + n6(H) + '\n' +
      out.join('\n');
  };
})();
