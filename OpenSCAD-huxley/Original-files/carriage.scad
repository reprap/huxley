include <settings.scad>;
use <hardware.scad>;

module carriage(position, side) {
	rodoffset = (rodsize + bearingsize) / 2;
	rodclearance = rodoffset - screwsize;
	bracketthick = screwsize * 1.5;
	bracketsize = bearingsize + rodsize / 2;
	bearingoffset = bearingwidth / 2 + washersize * 2;
	translate([0, 0, position]) if (side > 0) {
		rotate([0, 0, -90]) {
			translate([0, rodoffset, 0]) rotate([0, 90, 0]) translate([0, 0, bearingoffset + bracketthick]) screw(20, bracketthick * 2 + bearingoffset * 2, 1, bracketthick + bearingoffset - bearingwidth / 2);
		for (end = [1, -1]) for (side = [1, -1]) scale([side, 1, 1]) rotate([0, 0, 120]) translate([0, rodoffset, end * bearingsize]) rotate([0, -90, 0]) translate([0, 0, bearingwidth / 2]) screw(20, bearingwidth / 2 + bearingoffset + bracketthick, 1, 0);
		}
		color(c) difference() {
			union() {
				for (side = [0, 1]) rotate([side * 180, 0, 0]) for (end = [0, 1]) rotate([0, end * 180, end * -60]) translate([bracketsize / 2 + bearingoffset / sqrt(3), bearingoffset + bracketthick / 2, 0]) cube([bracketsize, bracketthick, bearingsize * 2 + partthick], center = true);
			}
			cylinder(h = bearingsize * 2 + partthick + 0.1, r = rodclearance, center = true);
		}
	} else {
		for (side = [1, -1]) for (end = [1, -1])
		translate([0, side * rodoffset, end * bearingsize]) rotate([0, 90, 0]) translate([0, 0, bearingwidth / 2]) screw(20, bearingwidth + washersize * 2 + bracketthick, 1, 0);
		color(c) difference() {
			union() {	
				for (end = [0, 1]) rotate([end * 180, 180, 0]) translate([bearingoffset + bracketthick / 2, bracketsize / 2 + bearingoffset / sqrt(3), 0]) cube([bracketthick, bracketsize, bearingsize * 2 + partthick], center = true);
				difference() {
					cylinder(h = bearingsize * 2 + partthick, r = rodclearance + bracketthick, center = true);
					translate([rodclearance + bracketthick - bearingoffset, 0, 0]) cube([(rodclearance + bracketthick) * 2, (rodclearance + bracketthick) * 2, bearingsize * 2 + partthick + 0.1], center = true);
				}
			}
			cylinder(h = bearingsize * 2 + partthick + 0.1, r = rodclearance, center = true);
		}
	}
}

for (side = [1, -1]) translate([side * 15, 0, 0]) {
	rod(rodsize * 10);
	carriage(0, side);
}