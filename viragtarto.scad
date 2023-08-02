include <minta.scad>;

echo(polys[0][0]);
echo(polys[0][1]);

module lab() {
    difference() {
        linear_extrude(height = 10)
        polygon([
            [0, 0],
            [5, 0],
            [15, -20],
            [11, -20],
            [0, -8]
        ]);
        a = atan2(10, 20);
        s = 1.2;
        translate([5, 0, 10])
        rotate([a, -90, 0])
        for (i = [0:18])
            translate([s / 4, i * -s - s, 0])
            cylinder(d = s, h = 10, $fn = 60);
    }
}

module tarto() {
    difference() {
        linear_extrude(height = 8)
        polygon([
            [0, -2],
            [35, -2],
            [35, -10],
            [0, -15]
        ]);

        translate([0, -16, 7.5])
        cube([35, 12, 1]);

        translate([34.5, -16, 0])
        cube([1, 12, 8]);
    }
}

module ur() {
    linear_extrude(height = 6)
    polygon([
        [0, 1],
        [33, 1],
        [33, -8],
        [0, -12]
    ]);
}

module minta() {
  for (p = polys) {
    polyhedron(p[0], p[1]);
  }
}

module minta2() {
  for (p = polys2) {
    polyhedron(p[0], p[1]);
  }
}

module viragtarto() {
    module negyed() {
        difference() {
            union() {
                rotate([90, 0, 0])
                lab();
                difference() {
                    rotate([90, 0, 0])
                    tarto();
                }
            }
            rotate([90, 0, 0])
            ur();
        }
    }

    module fel() {
        mirror([1, 0, 0])
        negyed();
        negyed();
    }
    
    mirror([0, 1, 0])
    fel();
    fel();

    translate([-35, -7.5, -15])
    rotate([90, 0, 0])
    minta();

    mirror([0, 1, 0])
    translate([-35, -7.5, -15])
    rotate([90, 0, 0])
    minta();

    translate([34.5, -7.5, -15])
    rotate([90, 0, 90])
    minta2();

    mirror([1, 0, 0])
    translate([34.5, -7.5, -15])
    rotate([90, 0, 90])
    minta2();
}

module darab_a() {
    rotate([90, 0, 0])
    intersection() {
        viragtarto();
        translate([0, -6, -25])
        cube([40, 12, 50]);
    }
}

module darab_b() {
    mirror([1,0,0])
    darab_a();
}

module darab_c() {
    rotate([90, 0, 0])
    intersection() {
        viragtarto();
        translate([0, 6, -25])
        cube([40, 12, 50]);
    }
}

module darab_d() {
    mirror([1,0,0])
    darab_c();
}

viragtarto();
