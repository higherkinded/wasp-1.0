$fa = 1;
$fs = 0.1;

module leg() {
    intersection() {
        translate([0, 0, 2.5]) sphere(r = 10.1);
        cylinder(h = 3, r = 10, center = true);
    }
    for (i = [0:12]) {
        rotate([0, 0, i * 30]) translate([6, 0, -1.5])
            rotate([45, 0, 0])
            cube([5.5, 1.2, 1.2], center = true);
    }
}

module leg_hole() {
    cylinder(h = 2, r = 10.15);
}