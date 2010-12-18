include <hardware.scad>;

module y_bar_clamp() color(c) difference() {
	union() {
		translate([0, 0, -(partthick / 2 + rodsize) /2]) cube([partthick, partthick, partthick / 2 + rodsize], center = true);
		rotate([0, 90, 0]) cylinder(h = partthick, r = partthick / 2, center = true, $fn = fn);
	}
	translate([0, 0, partthick - rodsize]) cube([rodsize * sin(45), partthick * 2, partthick * 2], center = true);
	rotate([0, 90, 0]) rod(partthick + 1);
	translate([0, 0, -rodsize]) rotate([90, 0, 0]) rod(partthick + 1);
}

y_bar_clamp();