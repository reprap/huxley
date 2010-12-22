include <settings.scad>;
use <hardware.scad>;

module y_bar_clamp() color(c) difference() {
	union() {
		translate([0, 0, -rodsize / 2]) cube([partthick, partthick, rodsize], center = true);
		translate([0, -partthick / 4, partthick / 4]) cube([partthick, partthick / 2, partthick / 2], center = true);
		rotate([0, 90, 0]) cylinder(h = partthick, r = partthick / 2, center = true, $fn = fn);
		translate([0, 0, -rodsize]) rotate([90, 0, 0]) cylinder(h = partthick, r = partthick / 2, center = true, $fn = fn);
	}
	translate([0, 0, partthick - rodsize]) cube([rodsize * sin(45), partthick * 2, partthick * 2], center = true);
	rotate([0, 90, 0]) rod(partthick + 1);
	translate([0, 0, -rodsize]) rotate([90, 0, 0]) rod(partthick + 1);
}

for(x = [1, -1]) for(y = [1, -1]) translate([x * 8, y * 8, partthick / 2]) rotate([90, 0, -x * 90]) y_bar_clamp();