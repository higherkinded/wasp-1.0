# Wasp 1.0 box

A set of OpenSCAD files concerning my handwired keeb project.

## How do I?

Render and export to STL then slice with Cura or whatever you like the most.
Keeb itself is in `kb_frame.scad`. To prevent it from rendering grid/base just
switch `_render_grid` or `_render_base` off, respectively. To make a left half,
toggle `_left` flag. Keycaps are basically what I'm printing but you can do your
own if you want.
