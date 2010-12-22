include <settings.scad>;
use <hardware.scad>;

module z_base() {
	width = partthick * 2 + rodsize;
	color(c) difference() {
		union() {
			translate([0, -(partthick / 2 + rodsize), 0]) rotate([0, 90, 0]) cylinder(h = width, r = partthick / 2, center = true, $fn = fn);
			translate([0, 0, -rodsize]) cube([width, (partthick + rodsize) * 2, partthick], center = true);
			//for (side = [1, -1]) 
			translate([0, partthick + rodsize, -rodsize]) rotate([0, 90, 0]) cylinder(h = width, r = partthick / 2, center = true, $fn = fn);
			translate([(width - partthick) / 2, 0, -rodsize]) cube([partthick, (partthick + rodsize) * 2, partthick], center = true);
			translate([(width - partthick) / 2, partthick + rodsize, -(partthick / 2 + rodsize) / 2]) cube([partthick, partthick, partthick / 2 + rodsize], center = true);
		}
		translate([0, -(partthick / 2 + rodsize), 0]) rotate([0, 90, 0]) rod(width + 0.1);
		translate([(width - partthick) / 2, partthick / 4, -rodsize]) rotate([90, 0, 0]) rod((partthick + rodsize) * 2 + partthick / 2 + 0.1);
		translate([0, 0, -rodsize]) rod(partthick + 0.1);
		translate([0, partthick + rodsize, -rodsize]) rod(partthick + 0.1);
		translate([width / 4, partthick + rodsize, -rodsize]) cube([(width) / 2 + 0.1, rodsize * sin(45), partthick + 0.1], center = true);
	}
}

z_base();