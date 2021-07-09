$fa = 1;
$fs = 0.05;

module __screw_shape(radius, height, flaps, flap_radius) {
    difference() {
        circle(r = radius);
        union() {
            _flap_step = 360 / flaps;
            for (n = [1:1:flaps]) {
                rotate([0, 0, _flap_step * n])
                translate([radius + flap_radius / 3, 0, 0])
                circle(r = flap_radius);
            }
        }
    }
}

module screw(radius, height, flaps = 3) {
    _flap_radius = radius * tan(360 / flaps / 3.2);
    color([0.7, 0.7, 0.7])
    linear_extrude(height, twist = -150 / radius * height)
        __screw_shape(radius, height, flaps, _flap_radius);
    color([0.3, 0.6, 0.8])
    translate([0, 0, height]) difference() {
        hull() {
            rotate_extrude() {
                translate([radius * 1.2, 0, 0]) {
                    rotate([0, 0, 45])
                    square(radius * 0.5 * sin(45));
                }
            }
            rotate_extrude() {
                translate([radius * 1.2, radius * 1.2, 0]) {
                    rotate([0, 0, 45])
                    square(radius * 0.5 * sin(45));
                }
            }
        }
        translate([0, 0, radius * 1.5]) cube(
            [radius * 2, radius * 0.5, radius * 2],
            center = true);
    }
}

module gaige(radius, height, flaps = 3, capped = false) {
    _flap_radius = radius * tan(360 / flaps / 3.5);
    color([0.5, 0.7, 0.5]) {
    linear_extrude(height, twist = -150 / radius * height) difference () {
        circle(r = radius * (1.2 + .4 * sin(45)));
        __screw_shape(radius * 1.05, height, flaps, _flap_radius);
    }
    hull() rotate_extrude() {
        translate([radius * 1.2, 0, 0])
        rotate([0, 0, 45])
        difference() {
            square(radius * 0.55 * sin(45), center = true);
            translate([-2, radius * 0.2 * -sin(45), 0]) square(4, 4);
        }
    }}
}

screw(2, 12);
//translate([10, 0, 0]) gaige(2, 12);