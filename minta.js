import * as d3 from 'd3';
import PoissonDiskSampling from 'poisson-disk-sampling';

// https://observablehq.com/@d3/polygonclip
function polygonClip(clip, subject) {
  const closed = polygonClosed(subject);
  const n = clip.length - polygonClosed(clip);
  subject = subject.slice(); // copy before mutate
  for (let i = 0, a = clip[n - 1], b, c, d; i < n; ++i) {
    const input = subject.slice();
    const m = input.length - closed;
    subject.length = 0;
    b = clip[i];
    c = input[m - 1];
    for (let j = 0; j < m; ++j) {
      d = input[j];
      if (lineOrient(d, a, b)) {
        if (!lineOrient(c, a, b)) {
          subject.push(lineIntersect(c, d, a, b));
        }
        subject.push(d);
      } else if (lineOrient(c, a, b)) {
        subject.push(lineIntersect(c, d, a, b));
      }
      c = d;
    }
    if (closed) subject.push(subject[0]);
    a = b;
  }
  return subject.length ? subject : null;
}

function lineOrient([px, py], [ax, ay], [bx, by]) {
  return (bx - ax) * (py - ay) < (by - ay) * (px - ax);
}

function lineIntersect([ax, ay], [bx, by], [cx, cy], [dx, dy]) {
  const bax = bx - ax, bay = by - ay, dcx = dx - cx, dcy = dy - cy;
  const k = (bax * (cy - ay) - bay * (cx - ax)) / (bay * dcx - bax * dcy);
  return [cx + k * dcx, cy + k * dcy];
}

function polygonClosed(points) {
  const [ax, ay] = points[0], [bx, by] = points[points.length - 1];
  return ax === bx && ay === by;
}

var poly = [
  [ 0, 11 ],
  [ 70, 11 ],
  [ 70, 5 ],
  [ 35, 0 ],
  [ 0, 5 ],
];

var p = new PoissonDiskSampling({
    shape: [70, 11],
    minDistance: 1,
    maxDistance: 200,
    tries: 20,
    distanceFunction: p => d3.polygonContains(poly, p) ? 0 : 1,
});
var points = p.fill();

const delaunay = d3.Delaunay.from(points);
const voronoi = delaunay.voronoi([0, 0, 70, 11]);

const h = 0.5;
var polys = [];

for (let i = 0; i < points.length; i++) {
  let g = voronoi.cellPolygon(i);
  g = polygonClip(poly, g);
  g.pop();
  g = g.map(p => [ p[0], p[1], 0 ]);
  g.push([ points[i][0], points[i][1], h ]);

  let faces = [];

  for (let j = 0; j < g.length - 1; j++) {
    faces.push([ j, (j + 1) % (g.length - 1), g.length - 1 ]);
  }

  faces.push(Array(g.length - 1).fill(0).map((e,i)=>g.length - i - 2));

  polys.push([g, faces]);
}

console.log("polys =");
console.log(JSON.stringify(polys));
