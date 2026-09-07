# #BaltimoreHero PS4 Controller Stand — OpenSCAD Source

Parametric CAD source file for a custom PS4 DualShock 4 controller stand,
designed for the Creality Ender-3 V2 / Ender-3 Pro (220 x 220 x 250mm build volume).

## Why OpenSCAD instead of a raw STL

OpenSCAD uses real boolean CAD operations (union/difference/intersection) to build
the contoured cradle rails (matching the DualShock 4's ~20mm grip radius) and to
truly engrave "#BaltimoreHero" into the backrest panel as a recessed cut — not an
approximation built from stacked boxes.

## Requirements

- Install OpenSCAD (free): https://openscad.org/downloads.html
- No other dependencies needed.

## How to use

1. Open `baltimorehero_ps4_stand.scad` in OpenSCAD.
2. Press F5 for a fast preview, F6 for a full render (required before export).
3. File > Export > Export as STL.
4. Import the exported STL into Cura for slicing.

## Tuning the fit

All key dimensions are parameters at the top of the file:

- `rail_gap_inside` — distance between the two cradle rails. Start at 128mm.
- `grip_radius` — matches the controller's rounded grip curvature. Start at 20mm.
- `rail_y_pos` — how far forward/back the rails sit on the base.
- `backrest_angle` — how far back the engraved panel leans (default 18 degrees).
- `gamer_tag` — the engraved text (default "#BaltimoreHero").

Edit a value, re-render (F6), re-export, and reslice. No CAD experience required
beyond changing numbers and re-exporting.

## Fit-test procedure

1. Render and export at the default settings first.
2. Print in black PLA: 0.20mm layers, 3 walls, 20-25% infill, no supports.
3. Rest the real DualShock 4 across the rails and check:
   - Rocking side-to-side -> increase `rail_gap_inside` by 3-5mm.
   - Too tight / won't seat -> increase `rail_gap_inside` by 2mm increments.
   - Slides forward -> increase `grip_radius` slightly or adjust `rail_y_pos`.
4. Re-render, re-export, reslice, reprint until the fit feels secure.
5. Only then commit to the final black-PLA gift print.

## Print settings summary

- Material: Black PLA, 1.75mm
- Nozzle: 0.4mm
- Layer height: 0.20mm
- Walls: 3
- Infill: 20-25% gyroid/grid
- Supports: Off (no overhang exceeds 45 degrees by design)
- Orientation: print flat on the base plate, as modeled
