#!/usr/bin/env python3
# A measuring prototype, not package code (pedkindraw S70, G16b's pre-RED measures,
# docs/planning/picture-files-plan.md section 12): write each dash of a dashed
# path as its own short stroked segment, so Chrome's PDF writer does not turn
# every dash into an outline. Reads the SVG savePedigreeDiagram() writes; only
# the paths with stroke-dasharray="0.319 ..." (the 375 animals' repeat-animal
# edges) are rewritten, and only M, L and Q path commands are read, which is all
# those paths hold.
#   python3 expandDashes.py in.svg out.svg
import re, math, sys
src = open(sys.argv[1]).read()
def quad(p0,p1,p2,t):
    u=1-t
    return (u*u*p0[0]+2*u*t*p1[0]+t*t*p2[0], u*u*p0[1]+2*u*t*p1[1]+t*t*p2[1])
def flatten(d):
    toks=re.findall(r'[MLQ]|-?\d+\.?\d*',d)
    pts=[];i=0;cur=None
    while i<len(toks):
        c=toks[i];i+=1
        if c=='M': cur=(float(toks[i]),float(toks[i+1]));i+=2;pts.append(cur)
        elif c=='L': cur=(float(toks[i]),float(toks[i+1]));i+=2;pts.append(cur)
        elif c=='Q':
            c1=(float(toks[i]),float(toks[i+1]));e=(float(toks[i+2]),float(toks[i+3]));i+=4
            for k in range(1,301): pts.append(quad(cur,c1,e,k/300))
            cur=e
    return pts
def dashes(pts,a,b,off=0.0):
    out=[];pos=-off;period=a+b
    # cumulative lengths
    segs=[];L=0
    for p,q in zip(pts,pts[1:]):
        l=math.hypot(q[0]-p[0],q[1]-p[1]);segs.append((p,q,l,L));L+=l
    def at(s):
        # point at arc length s
        lo=0
        for p,q,l,c in segs:
            if s<=c+l or (p,q,l,c)==segs[-1]:
                t=0 if l==0 else (s-c)/l
                t=min(max(t,0),1)
                return (p[0]+(q[0]-p[0])*t,p[1]+(q[1]-p[1])*t)
    s=0.0
    while s<L:
        e=min(s+a,L)
        out.append((at(s),at(e)))
        s+=period
    return out
def f(m):
    p=m.group(0)
    da=re.search(r'stroke-dasharray="([^"]*)"',p).group(1).replace(',',' ').split()
    a=float(da[0]);b=float(da[1]) if len(da)>1 else a
    d=re.search(r'd="([^"]*)"',p).group(1)
    ds=dashes(flatten(d),a,b)
    nd=' '.join('M%.3f %.3f L%.3f %.3f'%(s[0],s[1],e[0],e[1]) for s,e in ds)
    q=re.sub(r' d="[^"]*"',' d="%s"'%nd,p,1)
    q=re.sub(r' stroke-dasharray="[^"]*"','',q); q=re.sub(r' stroke-dashoffset="[^"]*"','',q)
    return q
out = re.sub(r'<path [^>]*stroke-dasharray="0\.319[^>]*/>', f, src)
open(sys.argv[2], 'w').write(out)
print(len(out))
