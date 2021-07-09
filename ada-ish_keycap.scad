$fa = 1;
$fs = 0.1;

module cherry_mx_stem() {
    difference() {
        translate([0, 0, -0.5]) cylinder(r = 2.9, h = 8);
        for (a = [0:1:1]) rotate([0, 0, 90 * a]) cube([1.05, 4.8, 10], center = true);
    }
}

module keycap_form(
    width_u = 1,
    length_u = 1,
    bump = 0,
    bottom_rounding = 2,
    top_rounding = 6.6
) {
    bottom_x_d = width_u * 9 - bottom_rounding;
    bottom_y_d = length_u * 9 - bottom_rounding;
    top_x_d = width_u * 8.8 - top_rounding;
    top_y_d = length_u * 8.8 - top_rounding;

    difference() {
        hull() {
            difference() {
                hull() for (ox = [-1:2:1]) for (oy = [-1:2:1])
                    translate([ox * bottom_x_d, oy * bottom_y_d, 0])
                        sphere(r = bottom_rounding);
            }
            
            translate([0, 0, 5]) hull()
                for (ox = [-1:2:1]) for (oy = [-1:2:1])
                    translate([ox * top_x_d, oy * top_y_d, 0])
                        sphere(r = top_rounding);
        }
        union() {
            translate([0, 0, -3.5])
                cube([width_u * 100, length_u * 100, 6], center = true);
            translate([0, 0, 38.5])
                sphere(r = 30);
        }
    }
}

module bump() {
    hull() for (ox = [-1:2:1])
        translate([1 * ox, -4, 8.5]) sphere(r = 1);
}

module keycap(
    width_u = 1,
    length_u = 1,
    bump = 0,
    bottom_rounding = 4.5,
    top_rounding = 6.6
) {
    difference() {
        keycap_form(width_u, length_u, bump, bottom_rounding, top_rounding);
        translate([0, 0, -1]) scale([0.86, 0.86, 0.7]) difference() {
            keycap_form(width_u, length_u, bump, 1, top_rounding);
            /*translate([0, 0, 8]) for(a = [0:1:1]) rotate([0, 0, 90 * a])
                cube([1, 30, 2.5], center = true);
            /*
            translate([0, 0, 40]) difference() {
                sphere(r = 35);
                sphere(r = 34.4);
                translate([0, 0, -40])
                cylinder(r = 4, h = 90);
            }
            */
        }
        for (a = [0:1:1]) rotate([0, 0, 90 * a])
            for (dx = [0:1:3]) translate([(dx - 1.5) * 2.2, 0, 3.6])
                rotate([90, 0, 0]) cylinder(h = 100, r = 0.65, center = true);
        for (a = [0:1:1]) rotate([0, 0, 90 * a])
            for (dx = [-2:1:2]) translate([dx * 2.2, 0, 1.5])
                rotate([90, 0, 0]) cylinder(h = 100, r = 0.65, center = true);
        if (bump < 0) bump();
    }
    
    if (bump > 0) bump();
    
    cherry_mx_stem();
}

keycap(bump = -1);