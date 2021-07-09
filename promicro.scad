$fa = 1;
$fs = 0.1;

module receptacle() {
    color([0.8, 0.8, 0.85]) {
    rotate([-90, 0, 0]) rotate([0, 0, -90]) translate([0, 0, -0.2])
    linear_extrude(0.25) difference() {
        polygon([
            [0, 2.70],
            [1.175, 3.45],
            [2.35, 3.45],
            [2.35, -3.45],
            [1.175, -3.45],
            [0, -2.70],
        ]);
    }
    rotate([-90, 0, 0]) rotate([0, 0, -90]) linear_extrude(4.3) difference() {
        polygon([
            [0, 2.70],
            [1.175, 3.45],
            [2.35, 3.45],
            [2.35, -3.45],
            [1.175, -3.45],
            [0, -2.70],
        ]);
        polygon([
            [0.25, 2.55],
            [1.25, 3.2],
            [2.15, 3.2],
            [2.15, -3.2],
            [1.25, -3.2],
            [0.25, -2.55],
        ]);
    }}
}

module promicro_body() {
    difference() {
        union() {
            color([0.2, 0.3, 0.6]) cube([18, 33, 1.5], center = true);
            color([0.8, 0.8, 0.85]) for (dx = [-1, 1]) for (dy = [-6:1:5])
                translate([dx * 7.8, dy * 33 / 13, 0])
                    cylinder(r = 1.1, h = 1.52, center = true);
        }
        for (dx = [-1, 1]) for (dy = [-6:1:5]) translate([dx * 7.8, dy * 33 / 13, 0])
            cylinder(r = 0.65, h = 2.2, center = true);
    }
}

module promicro() {
    translate([0, 13.75, 0.75]) receptacle();
    promicro_body();
}

module promicro_hold() { color([.7, .2, .2]) {
    translate([0, 0, -.5]) linear_extrude(3, center = true) difference() {
        square([22, 16], center = true);
        square([18.5, 33.5], center = true);
    }
    translate([0, -3, -1.85]) rotate([90, 0, 0]) linear_extrude(34, center = true) {
        polygon([
            [5, 1],
            [-5, 1],
            [-7, -1],
            [7, -1],
        ]);
    }
    translate([0, -3, -3]) linear_extrude(2, center = true) {
        square([22, 34], center = true);
    }
    translate([0, -16.65, 0])
    rotate([90, 0, 0])
    rotate([0, 90, 0])
    linear_extrude(7, center = true)
    polygon([
        [0, -1],
        [0, .7],
        [.25, .8],
        [.5, 1],
        [.75, 1.4],
        [.775, 2],
        [.6, 2.25],
        [-1, 2.25],
        [-2, 1],
        [-3, -1],
    ]);
}}

module promicro_cutout() {
    translate([0, 14.75, .2]) rotate([0, -90, 0]) {
        linear_extrude(19, center = true) polygon([
            [-1, -4.5], [-1, 2], [1, 2], [1, 1], [2, -2], [2, -4.5]
        ]);
        translate([2.2, 0, 0]) linear_extrude(8, center = true) polygon([
            [-2.2, -4.5], [-2.2, 4.5], [1, 4.5], [1, 1], [2, -2], [2, -4.5]
        ]);
    }
}

// promicro();
// promicro_hold();
// promicro_cutout();