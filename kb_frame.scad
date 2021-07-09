include<promicro.scad>
include<leg.scad>
include<connector_hole.scad>

$fa = 1;
$fs = 0.2;

_font = "CatV 6x12 9:style=Normal";
_render_grid = true;
_render_base = true;
_slot_framewidth = 21;
_slot_framelength = 23;
_row_curve_r = 85;
_curve_start_offset = 12;
_frame_thickness = 2.5;
_screw_diameter = 5.5;
_screw_radius = _screw_diameter * 0.5 + /* slight gap */ 0.15;
_left = false;

module hex(r) {
    polygon([
        [r * sin(0), r * cos(0)],
        [r * sin(60), r * cos(60)],
        [r * sin(120), r * cos(120)],
        [r * sin(180), r * cos(180)],
        [r * sin(240), r * cos(240)],
        [r * sin(300), r * cos(300)],
    ]);
}

module _switch() { color([0.3, 0.3, 0.3]) union() {
    // cube([15.6, 15.6, 2], center = true); 
    translate([0, 0, -1.25])
    cube([14, 14, 5], center = true);
}}

module _slot_weld() {
    rotate([0, 90, 0])
    cylinder(r = _frame_thickness / 2, h = _slot_framewidth,
        center = true);
}

module slot() { union() {
    color([0.9, 0.6, 0.5]) union() {
        difference() {
            cube([
                _slot_framewidth,
                _slot_framelength,
                _frame_thickness
            ], center = true);
            union() {
                translate([0, 0, -0.5])
                    cube([14, 14, 5], center = true);
                translate([0, -7, -2.75]) rotate([0, 90, 0]) hull() {
                    cylinder(
                        r = _frame_thickness, h = 14, center = true);
                    translate([0, 14, 0])
                    cylinder(
                        r = _frame_thickness, h = 14, center = true);
                }

            }
        }
        translate([0, _slot_framelength / 2, 0]) _slot_weld();
        translate([0, _slot_framelength / -2, 0]) _slot_weld();

    }
    color([0.4, 0.4, 0.4]) translate([0, 9, -2])
    rotate([90, 0, 0]) { difference() {
        union() {
            cube([4.5, 6, 2.7], center = true);
            translate([0, -3, 0])
                cylinder(r = 2.25, h = 2.7, center = true);
        }
        translate([0, -3, 0])
            cylinder(r = 1.25, h = 3, center = true);
    }}
    // _switch();
}}

module bladewheel(r, thickness) {
    rotate_extrude(angle = 360)
        translate([r, 0, 0]) rotate([0, 0, 45])
            square(thickness * sin(45), center = true);
    cylinder(h = thickness, r = r, center = true);
}

module wire_channel() {
    _step_angle = atan(_slot_framelength / _row_curve_r);
    _placement = _row_curve_r;
    _wid = 4;
    color([0.7, 0.7, 0.7])
    translate([0, 0, _placement])
    for (a = [0:1:2]) {
        rotate([_step_angle * a - _step_angle * 0.45, 0, 0])
        translate([(_wid + 2 + _slot_framewidth) * 0.5, 0, -_placement - 2])
        rotate([90, 0, 0]) { difference() {
            hull() {
                cube([_wid, 7.5, 3.5], center = true);
                translate([_wid * 0.5, 0.25, 0])
                cylinder(r = _wid, h = 3.5, center = true);
                translate([_wid * 0.5, -4, 0])
                cylinder(r = _wid, h = 3.5, center = true);
            }
            hull() {
                translate([_wid * 0.5, 0.25, 0])
                cylinder(r = _wid * .7, h = 5, center = true);
                translate([0.15, _wid * 0.5, 0])
                cylinder(r = _wid * 0.25, h = 5, center = true);
                translate([_wid * 0.5, -4, 0])
                cylinder(r = _wid * .7, h = 5, center = true);
            }
        }}
    }
}

module slot_row(with_channel = false, anchor_hole = false) { union() {
    _step_angle = atan(_slot_framelength / _row_curve_r);
    _prefix = atan(9 / _row_curve_r);
    translate([0, 0, _row_curve_r]) {
        color([0.4, 0.6, 0.8])
            difference() {
                union() {
                    for (d = [-1:2:1]) {
                        rotate([_step_angle * 2.8, 0, 0])
                        translate([d * _slot_framewidth / 2, 0, -_row_curve_r-3.5]) {
                            rotate([0, 90, 0]) {
                                union() {
                                    cube([6, 8, 3], center = true);
                                    for (d = [-1:2:1])
                                        translate([3 * d, 0, 0])
                                        cylinder(r = 4, h = 3, center = true);
                                }
                            }
                        }
                        translate([d * _slot_framewidth / 2, 0, 0])
                        rotate([0, 90, 0]) {
                            rotate([0, 0, -_step_angle - _prefix * 1.5])
                            translate([_row_curve_r + 1.85, 0, 0])
                            bladewheel(3.85, 3);
                            rotate([0, 0, -_step_angle * 1.4 - _prefix * 0.5])
                            rotate_extrude(angle = _step_angle * 4.25 + _prefix / 2) {
                                translate([_row_curve_r + 1.85, 0, 0])
                                square([7.7, 3], center = true);
                                
                                translate([_row_curve_r + 5.7, 0, 0])
                                rotate([0, 0, 45])
                                square(sin(45) * 3, center = true);

                                translate([_row_curve_r - 2, 0, 0])
                                rotate([0, 0, 45])
                                square(sin(45) * 3, center = true);
                            }
                            rotate([0, 0, 41.1])
                            translate([_row_curve_r + 7, 0, 0])
                            // Make a polygon that doesn't intersect with diff
                            linear_extrude(height = 3, center = true) {
                                rotate([0, 0, -41.1]) translate([-1.5, -.9, 0]) polygon([
                                    [5, -12],
                                    [-3, 5],
                                    [6, 11],
                                    [10, 10],
                                    [10, 7],
                                    [6, 5],
                                    [6, 1],
                                    [10, -1],
                                    [11, -20],
                                ]);
                            }
                        }
                    }
                    for (s = [0:1:3]) {
                        for (o = [-1:2:1]) {
                            translate([_slot_framewidth / 2 * o, 0, 0])
                            rotate([
                                s * _step_angle - _step_angle * 0.97,
                                0, 0])
                            translate([0, 0, -_row_curve_r - 5.5])
                            rotate([0, 90, 0]) {
                                cylinder(r = 2, h = 3, center = true);
                                rotate_extrude(angle = 360) {
                                    translate([2, 0, 0]) union() {
                                        rotate([0, 0, 45])
                                            square(sin(45) * 3, center = true);
                                    }
                                }
                            }
                        }
                    }
                }
                union() {
                    for (d = [0:1:3]) {
                        rotate([
                            d * _step_angle - _step_angle * 0.97,
                            0, 0])
                        translate([0, 0, -_row_curve_r - 5.5])
                        rotate([0, 90, 0])
                        cylinder(center = true, h = _slot_framewidth * 2, r = 1.2);
                    }
                    
                    for (o = [-1:2:1]) {
                        if (anchor_hole) {
                            rotate([-_step_angle - _prefix * 1.6, 0, 0])
                            translate([
                                o * _slot_framewidth / 2, 1, -_row_curve_r - 1.75])
                            rotate([0, 90, 0])
                            cylinder(r = _screw_radius + 0.15, h = 10, center = true);
                        }
                        rotate([_step_angle * 2.8, 0, 0])
                        translate([o * _slot_framewidth / 2, 1, -_row_curve_r-3.5])
                        rotate([0, 90, 0])
                        union() {
                            cube([7, 3, 9], center = true);
                            translate([-3.5, 0, 0])
                                cylinder(r = 1.5, h = 4, center = true);
                            hull() {
                                translate([3, -0.95, 0])
                                    cylinder(r = 2.5, h = 4, center = true);
                                translate([0.75, -1, 0])
                                    cylinder(r = 2.5, h = 4, center = true);
                                translate([-2.25, 0, 0])
                                    cylinder(r = 1, h = 4, center = true);
                            }
                        }
                    }
                }
        }
        for (s = [0:1:3]) {
            rotate([
                s * _step_angle - _curve_start_offset,
                0, 0])
            translate([0, 0, -_row_curve_r])
            slot();
        }
        
    }
    if (with_channel) {
        wire_channel();
    }
    
    if (!anchor_hole)
        color([0.8, 0.8, 0.8])
        translate([0, 0, _row_curve_r])
        rotate([-24, 0, 0])
        translate([0, 0, -_row_curve_r - 2])
        rotate([0, 90, 0]) cylinder(r = 2.5, h = _slot_framewidth, center = true);
}}

module anchors() {
    translate([0, 0, _row_curve_r])
    translate([-_slot_framewidth * 0.5 - 1.5, 0, 0])
    color([0.8, 0.8, 0.8])
    for (dx = [-1:2:1]) {
        rotate([dx * 24, 0, 0])
        translate([0, 0, -_row_curve_r - 2])
        rotate([0, -90, 0]) difference() {
            hull() {
                cylinder(r = 2.5);
                translate([0, 0, 3])
                rotate_extrude()
                translate([2.5 - sin(45), 0, 0]) rotate([0, 0, 45])
                    square(1, center = true);
            }
            translate([0, 0, 4]) sphere(r = 1.5);
        }
    }
}

module frame() {
    for (dx = [0:1:5]) {
        translate([dx * _slot_framewidth, 0, 0]) {
            slot_row(with_channel = (dx == 5), anchor_hole = (dx == 5));
        }
    }
    
    anchors();
}

module strut_shape() { color([0.4, 0.4, 0.4]) {
    difference() {
        rotate([0, -90, 0])
        linear_extrude(4, center = true) {
            difference() {
                circle(r = 40);
                circle(r = 37);
                translate([-30, 0])
                square([26, 400], center = true);
                translate([30, 0])
                square([26, 200], center = true);
                translate([0, -20])
                square([70, 50], center = true);
            }
            translate([100, -48]) difference() {
                circle(r = 120);
                circle(r = 117);
                translate([65, 0])
                square([300, 400], center = true);
                translate([-129, 0])
                square([26, 200], center = true);
                translate([-90, -50])
                square([70, 100], center = true);
            }
        }
    }
    translate([0, 40, -13]) rotate([0, -90, 0]) linear_extrude(4, center = true) {
        difference() {
            union() {
                square([8, 8], center = true);
                polygon([
                    [-3.1, -60],
                    [3, -40],
                    [-3.1, -38.5],
                ]);
            }
            translate([3, 6.7]) circle(r = 8);
            translate([0.5, -37.2]) circle(r = 4);
        }
    }
}}

module strut(facing_strut = true) {
    translate([0, 28.5, -7])
    for (dx = [-1:2:1]) translate([dx * 2.5, 0, 0]) rotate([0, 3 * dx, 0])
        strut_shape();
    translate([0, 15, -25]) rotate([0, -90, 0]) hull() for (dx = [-1,1])
        translate([0, dx * 55]) cylinder(r = 2, h = _slot_framewidth, center = true);
    if(facing_strut) color([0.3, 0.3, 0.3])
    translate([0, -35.5, 2]) rotate([0, -90, 0]) difference() {
        hull() {
            cylinder(r = 4, h = 3, center = true);
            translate([-27, 10]) cube([1, 20, 7], center = true);
        }
        translate([3.5, 0, 0])
        cylinder(r = 2.55, h = 10, center = true);
    }
    
    for (dx = [-1, 1])
    translate([7 * dx, 28.5, -7]) difference() {
        rotate([0, -90, 0]) linear_extrude(12, center = true) {
            difference() {
                circle(r = 39);
                circle(r = 37.25);
                translate([-30, 0])
                square([26, 400], center = true);
                translate([30, 0])
                square([26, 200], center = true);
                translate([0, -20])
                square([70, 50], center = true);
            }
        }
        rotate([90, 0, 0]) {
            linear_extrude(100, center = true) {
                for (dy = [-2, -1, 0, 1, 2]) translate([0, dy * 12, 0]) {
                    for (dx = [-1, 0, 1]) translate([dx * 7, 0]) hex(3.1);
                    for (dx = [-1, 1]) translate([dx * 7 * cos(60), 7 * sin(60)])
                        hex(3.1);
                }
            }
        }
    }
}

module side_strut() {
    translate([0, 28.5, -7])
    strut_shape();
    translate([0, 62.5, 7]) rotate([0, -90, 0]) hull() {
        cylinder(r = 5, h = 4.6, center = true);
        translate([0, 0, 1]) cylinder(r = 3, h = 6, center = true);
        translate([-13, -17, 0.29]) cylinder(r = 4, h = 6, center = true);
    }
    translate([0, 62.5, 7]) rotate([0, -90, 0]) hull() {
        cylinder(r = 5, h = 4.6, center = true);
        translate([0, 0, 1]) cylinder(r = 3, h = 6, center = true);
        translate([-10, 3.8, 0]) cylinder(r = 2.5, h = 4.4, center = true);
    }
    
    translate([0, 15, -25]) rotate([0, -90, 0]) hull() for (dx = [-1,1])
        translate([0, dx * 55]) cylinder(r = 2, h = 9, center = true);
}

module bottom() { difference() { union() {
    color([0.3, 0.2, 0.2])
    difference() {
        translate([-_slot_framewidth * 0.5 - 4.5, 0, -7]) hull() {
            translate([-1.5, 10, -13]) cube([5, 100, 10], center = true);
            for (oy = [-1:2:1]) translate([0, 35.5 * oy, 12.5]) rotate([0, 90, 0])
                cylinder(h = 6, r = 6, center = true); 
        }
        translate([-15, 0, 50])
        rotate([0, 90, 0]) cylinder(h = 100, r = 50, center = true);
        for (oy = [-1:2:1]) translate([0, 35.5 * oy, 5.5]) rotate([0, 90, 0])
            cylinder(h = 100, r = 2.55, center = true);
    }

    translate([_slot_framewidth * 2.5, 62.6, 9])
    rotate([0, 90, 0])
    linear_extrude(_slot_framewidth * 6 + 5 * 2, center = true) {
        polygon([
            [-2, -1.9], [-2, 1.9],
            [2, 3.8],
            [6, 1], [6, -1],
            [2, -3.8]
        ]);
    }
    
    for (sdx = [0:1:5]) translate([_slot_framewidth * sdx, 0]) strut(sdx != 5);
    translate([-_slot_framewidth * 0.5 - 4, 0]) side_strut();
    translate([_slot_framewidth * 5.5 + 4, 0]) scale([-1, 1]) side_strut();
    translate([_slot_framewidth * 5.5, -35.5, 6]) for (ssdx = [-1, 1])
        scale([ssdx, 1])
        translate([2.7, 0]) rotate([0, -90, 0]) difference() {
            hull() {
                cylinder(r = 4.5, h = 2, center = true);
                translate([0, 0, -1]) cylinder(r = 3.5, h = 3, center = true);
                translate([-28.6, 5.5, -3]) cube([1, 20, 5.6], center = true);
            }
            cylinder(r = _screw_radius, h = 10, center = true);
            hull() {
                translate([0, 0, -7]) cylinder(r = 8, h = 1, center = true);
                translate([0, 0, -4.5]) cylinder(r = 6 - ssdx / 2, h = 5, center = true);
            }
        }
    translate([-1, -7.7, -20]) rotate([0, 0, 90]) promicro_hold();
    }
    translate([-1, -7.7, -20]) rotate([0, 0, 90]) promicro_cutout();
    translate([52.5, 15, -28]) {
        for (lhdx = [-1:2:1]) for (lhdy = [-1:2:1])
            translate([lhdx * 55, lhdy * 40]) leg_hole();
    }
    translate([-12, 12, -14]) rotate([0, -90, 0]) connector_hole();
    }
}
    

module title() {
    rotate([90, 0, -90])
    linear_extrude(height = 2, center = true)
    scale(0.24)
    text("Wasp v1.0", font = _font, halign = "center");
}

module logo() {
    rotate([88, 0, -90])
    linear_extrude(height = 2, center = true) scale(3)
        text("hk", font = _font, halign = "center");
}

module triangle(r) {
    polygon([
        [r * cos(-30), r * sin(-30)],
        [r * cos( 90), r * sin( 90)],
        [r * cos(210), r * sin(210)]
    ]);
}

module side_marker() {
    rotate([90, 0, -90]) {
        linear_extrude(height = 2, center = true) {
            difference() { triangle(5); triangle(4.2); }
            translate([-1, -1.5]) scale(0.4)
                text(_left ? "L" : "R", font = _font);
        }
    }
}

module logo_and_title(mirror = false) {
    __ltm_scale = [1, mirror ? -1 : 1, 1];
    translate([-19, 40, -5]) scale(__ltm_scale) {
        translate([0, 0, -10]) logo();
        translate([-.5, 3, -13.6]) title();
        translate([-.5, mirror ? -15 : 15, -14]) side_marker();
    }
}

scale([_left ? -1 : 1, 1, 1]) {
    if (_render_grid) frame();
    if (_render_base) difference() {
        bottom();
        logo_and_title(mirror = _left);
    }
}