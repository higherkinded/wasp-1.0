$fa = 1;
$fs = 0.1;

module connector_hole() {
    translate([0, 0, -20]) cylinder(h = 40, r = 6.1);
    cylinder(h = 1.8, r = 10);
    translate([0, 0, 5]) cylinder(h = 3.5, r = 7.55);
}