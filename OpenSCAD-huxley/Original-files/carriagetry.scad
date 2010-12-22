include <settings.scad>;
use <hardware.scad>;

module carriage(position, side) {
	rodoffset = (rodsize + bearingsize) / 2;
	rodclearance = rodoffset - screwsize;
	translate([0, 0, position]) if (side > 0) {
		rotate([0, 0, -90]) {
			translate([0, rodoffset, 0]) rotate([0, 90, 0]) translate([0, 0, bearingwidth / 2]) screw(25, bearingwidth, 1, 0);
		for (end = [1, -1]) for (side = [1, -1]) scale([side, 1, 1]) rotate([0, 0, 120]) translate([0, rodoffset, end * bearingsize]) rotate([0, -90, 0]) translate([0, 0, bearingwidth / 2]) screw(25, rodclearance + partthick, 1, 0);
		}
		color(c) difference() {
			translate([0, 0, 0]) union() {
				rotate_extrude(convexity = 10, $fn = fn) translate([rodoffset + partthick / 4 - screwsize, 0, 0]) square(size = [partthick / 2, partthick + bearingsize * 2], center = true);
				for (side = [1, -1]) scale([1, side, 1]) rotate([0, 0, 30]) translate([(rodclearance + partthick / 2) / 2, (rodclearance + partthick) / 2, 0]) cube([rodclearance + partthick / 2, rodclearance + partthick, partthick + bearingsize * 2], center = true);
			}
			cylinder(h = partthick * 10, r = rodoffset  - screwsize, center = true, $fn = fn);
			cube([(rodclearance + partthick) * 2, bearingwidth + washersize * 4, bearingsize], center = true);
			for (end = [1, -1]) translate([0, 0, end * bearingsize / 2]) rotate([0, 90, 0]) cylinder(r = bearingwidth / 2 + washersize * 2, h = (rodclearance + partthick) * 2, center = true, $fn = fn);
			for (side = [1, -1]) scale([1, side, 1]) rotate([0, 0, 30]) translate([-(rodsize / 2 + bearingsize / 2 - screwsize / 2 + partthick) + bearingwidth / 2 + washersize, rodsize / 2 + bearingsize / 2 - screwsize / 2 + partthick, 0]) cube([rodsize / 2 + bearingsize / 2 - screwsize / 2 + partthick, rodsize / 2 + bearingsize / 2 - screwsize / 2 + partthick, partthick + bearingsize + 0.1] * 2, center = true);
		}
	} else {
		translate([0, rodoffset, 0]) rotate([0, 90, 0]) translate([0, 0, bearingwidth / 2]) screw(25, bearingwidth, 1, 0);
		translate([0, -rodoffset, 0]) rotate([0, 90, 0]) translate([0, 0, bearingwidth / 2]) screw(25, bearingwidth, 1, 0);
	}
}

rod(rodsize * 10);
carriage(0, 1);