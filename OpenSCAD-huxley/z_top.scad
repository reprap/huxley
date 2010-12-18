include <settings.scad>;
use <hardware.scad>;

module z_top() color(c) difference() {
	union() {
		translate([-partthick / 4, 0, 0]) cube([(vertexoffset / 2 + rodsize * sqrt(3) / 2) * 2 + partthick / 2, partthick, partthick], center = true);
		rotate([90, 0, 0]) translate([vertexoffset / 2 + rodsize * sqrt(3) / 2, 0, 0]) cylinder(r = partthick / 2, h = partthick, center = true);
	}
	translate([((vertexoffset / 2 + rodsize * sqrt(3) / 2) + partthick / 2) / 2, 0, 0]) cube([(vertexoffset / 2 + rodsize * sqrt(3) / 2) + partthick / 2 + 0.1, rodsize * sin(45), partthick + 0.1], center = true);
	rotate([90, 0, 0]) for(side = [1, -1]) {
		translate([-side * (vertexoffset / 2 + rodsize * sqrt(3) / 2), 0, 0]) rod(partthick * 2);
	}
	rod(partthick + 0.1);
}

z_top();