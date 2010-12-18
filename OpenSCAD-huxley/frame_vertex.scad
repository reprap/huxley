// TODO: add foot

include <settings.scad>;
use <hardware.scad>;

module frame_vertex(round = false, foot = false) color(c) difference() {
	union() {
		for(side = [1, -1]) {
			rotate([0, 0, side * 30]) translate([0, vertexoffset, 0]) {
				if (round) {
					translate([-side * partthick / 4, 0, 0]) cube([partthick  / 2, partthick, partthick], center = true);
					rotate([0, 90, 0]) cylinder(h = partthick, r = partthick / 2, center = true, $fn = fn);
					rotate([90, 0, 0]) cylinder(h = partthick, r = partthick / 2, center = true, $fn = fn);
				} else cube([partthick, partthick, partthick], center = true);
				translate([side * -rodsize, 0, 0]) cylinder(h = partthick, r = partthick / 2, center = true, $fn = fn);
			}
		}
		translate([0, partthick, 0]) difference() {
			rotate_extrude(convexity = 10, $fn = fn) translate([vertexoffset - partthick * sqrt(3) / 2, 0, 0]) {
				if (round) circle(r = partthick / 2, center = true, $fn = fn);
				else square(size = partthick, center = true);
			}
			for (side = [1, -1]) rotate([0, 0, side * 30]) translate([-side * vertexoffset, 0, 0]) cube(vertexoffset * 2, center = true);
		}
	}
	for(side = [1, -1]) {
		rotate([90, 0, side * 30]) rod(rodsize * 15);
		rotate([0, 0, side * 30]) {
			translate([-side * rodsize, vertexoffset, 0]) rod(partthick * 2);
		}
	}
}

frame_vertex();