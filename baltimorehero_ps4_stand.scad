// #BaltimoreHero PS4 DualShock 4 Controller Stand — v3
// Parametric OpenSCAD source. Cradle rails use intersection(tube, wedge-box),
// a standard robust pattern for open troughs (avoids non-manifold half-space cuts).
// Target printer: Creality Ender-3 V2 / Ender-3 Pro (220 x 220 x 250mm build volume)
// Material: Black PLA, single 0.4mm nozzle, no supports needed if printed as designed.

$fn = 64;

// ============ PARAMETERS (safe to edit and re-render) ============
gamer_tag        = "#BaltimoreHero";

base_w           = 180;
base_d           = 100;
base_h           = 6;

grip_radius      = 20;   // matches DualShock 4 grip curvature
rail_wall        = 5;
rail_length      = 26;
rail_gap_inside  = 128;
rail_open_width  = 34;   // width of the open top slot the controller drops into
rail_y_pos       = 30;

backrest_w       = 150;
backrest_h       = 70;
backrest_thick   = 8;
backrest_angle   = 18;
backrest_y_pos   = 84;

text_size        = 14;
text_depth       = 1.0;
text_font        = "Liberation Sans:style=Bold";
relief_depth     = 1.2;

// ============ MODULES ============

module base_plate() {
    translate([0, 0, base_h/2])
        cube([base_w, base_d, base_h], center = true);
}

// Robust open-top curved trough: full tube (annulus extruded along X)
// intersected with a tall box that only spans the desired open-slot width.
// This keeps the mesh manifold because intersection() of two closed solids
// is always closed, unlike subtracting an unbounded half-space.
module cradle_rail() {
    intersection() {
        rotate([0, 90, 0])
            linear_extrude(height = rail_length, center = true)
                difference() {
                    circle(r = grip_radius + rail_wall);
                    circle(r = grip_radius);
                }
        translate([0, 0, (grip_radius + rail_wall)])
            cube([rail_length + 2, rail_open_width, (grip_radius + rail_wall) * 2 + 2], center = true);
    }
    translate([0, 0, -(grip_radius/2)])
        cube([rail_length, rail_open_width, grip_radius], center = true);
}

module cradle_pair() {
    z_center = base_h + grip_radius * 0.35;
    translate([-(rail_gap_inside/2 + rail_length/2), rail_y_pos, z_center])
        cradle_rail();
    translate([ (rail_gap_inside/2 + rail_length/2), rail_y_pos, z_center])
        cradle_rail();
}

module backrest_panel() {
    difference() {
        translate([0, backrest_y_pos, base_h])
            rotate([-backrest_angle, 0, 0])
                translate([0, -backrest_thick/2, 0])
                    cube([backrest_w, backrest_thick, backrest_h]);
        translate([0, backrest_y_pos, base_h])
            rotate([-backrest_angle, 0, 0])
                translate([0, -backrest_thick/2 - 0.5, backrest_h*0.35])
                    rotate([90, 0, 0])
                        linear_extrude(height = text_depth + 1)
                            text(gamer_tag, size = text_size, halign = "center", valign = "center", font = text_font);
        for (side = [-1, 1])
            translate([side * (backrest_w/2 - 22), backrest_y_pos, base_h])
                rotate([-backrest_angle, 0, 0])
                    translate([0, -backrest_thick/2 - 0.5, backrest_h*0.65])
                        rotate([90, 0, 0])
                            linear_extrude(height = relief_depth + 1)
                                polygon(points = [
                                    [-4, 10], [3, 10], [-2, 0], [4, 0],
                                    [-3, -10], [-4, -10], [1, -1], [-4, -1]
                                ]);
    }
}

module gusset() {
    hull() {
        translate([0, backrest_y_pos - 8, base_h/2])
            cube([backrest_w * 0.6, 4, base_h], center = true);
        translate([0, backrest_y_pos - 8, base_h + 12])
            cube([backrest_w * 0.4, 2, 2], center = true);
    }
}

module ps4_stand() {
    union() {
        base_plate();
        cradle_pair();
        backrest_panel();
        gusset();
    }
}

ps4_stand();

// ============ FIT-TEST NOTES ============
// 1. In OpenSCAD: press F6 (full render, not just F5 preview), confirm NO errors
//    appear in the Console/Error-Log panels before exporting.
// 2. File > Export > Export as STL.
// 3. Print at 0.20mm layers, 3 walls, 20-25% infill, no supports.
// 4. Rest the real DualShock 4 across the two rails.
//    - Rocks side-to-side -> increase rail_gap_inside by 3-5mm, re-render, re-export.
//    - Too tight -> increase rail_gap_inside by 2mm at a time.
//    - Slides forward/back -> adjust rail_y_pos.
//    - Grip sits too high/low -> adjust grip_radius by 1-2mm.
