// #BaltimoreHero PS4 DualShock 4 Controller Stand
// Parametric OpenSCAD source — real boolean CAD, not stacked primitives.
// Target printer: Creality Ender-3 V2 / Ender-3 Pro (220 x 220 x 250mm build volume)
// Material: Black PLA, single 0.4mm nozzle, no supports needed if printed as designed.

// ============ PARAMETERS (edit these to fine-tune fit) ============
gamer_tag        = "#BaltimoreHero";

// Base plate
base_w           = 180;   // X width
base_d           = 100;   // Y depth
base_h           = 6;     // thickness

// Cradle rails (contoured to DualShock 4 grip curvature)
grip_radius      = 20;    // matches DS4 rounded grip radius (~40mm diameter grips)
rail_wall        = 4;     // shell thickness of each curved rail
rail_length      = 26;    // how long each rail is along X (contact length under the grip)
rail_gap_inside  = 128;   // inside-to-inside spacing between the two rails (fit-test value)
rail_arc_start   = 200;   // degrees, arc sweep start (bottom-outer)
rail_arc_end     = 340;   // degrees, arc sweep end (top-inner) — controller drops in from top
rail_y_pos       = 30;    // Y position of rail centerline from front edge

// Backrest panel (solid, angled, holds the engraved gamer tag)
backrest_w       = 150;
backrest_h       = 70;    // height of panel along its own slope
backrest_thick   = 8;
backrest_angle   = 18;    // degrees back from vertical
backrest_y_pos   = 84;    // Y position of backrest base, near rear of base plate

// Text engraving
text_size        = 14;
text_depth       = 1.0;   // how deep the text is recessed into the backrest
text_font        = "Liberation Sans:style=Bold";

// Decorative relief (kept simple + printable, low profile, no overhangs beyond 45deg)
bolt_width       = 10;
bolt_height      = 45;
relief_depth     = 1.2;

// ============ MODULES ============

module base_plate() {
    linear_extrude(height = base_h)
        square([base_w, base_d], center = true);
}

module cradle_rail() {
    difference() {
        translate([-rail_length/2, 0, base_h])
            rotate([0,90,0])
                linear_extrude(height = rail_length)
                    difference() {
                        circle(r = grip_radius + rail_wall, $fn = 96);
                        circle(r = grip_radius, $fn = 96);
                    }
        translate([-rail_length/2 - 1, 0, base_h])
            rotate([0,90,0])
                linear_extrude(height = rail_length + 2)
                    difference() {
                        square([ (grip_radius+rail_wall)*2.2, (grip_radius+rail_wall)*2.2 ], center = true);
                        rotate([0,0,rail_arc_start])
                            square([ (grip_radius+rail_wall)*3, (grip_radius+rail_wall)*3 ]);
                        rotate([0,0,rail_arc_end])
                            translate([-(grip_radius+rail_wall)*3,0,0])
                                square([ (grip_radius+rail_wall)*3, (grip_radius+rail_wall)*3 ]);
                    }
    }
}

module cradle_pair() {
    translate([-(rail_gap_inside/2 + rail_length/2), rail_y_pos, 0]) cradle_rail();
    translate([ (rail_gap_inside/2 + rail_length/2), rail_y_pos, 0]) cradle_rail();
}

module backrest_panel() {
    difference() {
        union() {
            translate([0, backrest_y_pos, base_h])
                rotate([-backrest_angle, 0, 0])
                    translate([0, 0, 0])
                        linear_extrude(height = backrest_h)
                            square([backrest_w, backrest_thick], center = true);
        }
        translate([0, backrest_y_pos, base_h])
            rotate([-backrest_angle, 0, 0])
                translate([0, -backrest_thick/2 - 0.01, backrest_h*0.35])
                    rotate([90,0,0])
                        linear_extrude(height = text_depth + 0.5)
                            text(gamer_tag, size = text_size, halign = "center", valign = "center", font = text_font);
        for (side = [-1, 1])
            translate([side * (backrest_w/2 - 22), backrest_y_pos, base_h])
                rotate([-backrest_angle, 0, 0])
                    translate([0, -backrest_thick/2 - 0.01, backrest_h*0.65])
                        rotate([90,0,0])
                            linear_extrude(height = relief_depth + 0.5)
                                polygon(points = [
                                    [-4, 10], [3, 10], [-2, 0], [4, 0],
                                    [-3, -10], [-4, -10], [1, -1], [-4, -1]
                                ]);
    }
}

module gusset() {
    hull() {
        translate([0, backrest_y_pos - 6, base_h]) cube([backrest_w*0.6, 1, 1], center = true);
        translate([0, backrest_y_pos - 6, base_h + 14]) cube([backrest_w*0.4, 1, 1], center = true);
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
// 1. Render this file in OpenSCAD (F6), then export as STL (File > Export > Export as STL).
// 2. Print at 0.20mm layers, 3 walls, 20-25% infill, no supports.
// 3. Rest the real DualShock 4 across the two rails.
//    - Rocks side-to-side -> increase rail_gap_inside by 3-5mm, re-render, re-export.
//    - Too tight / won't seat -> increase rail_gap_inside by 2mm at a time.
//    - Slides forward -> increase grip_radius slightly or raise rail_y_pos.
// 4. Once fit is correct, re-export the final STL for the finished print.
