include <settings.scad>;
use <hardware.scad>;
use <carriage.scad>;

module leadscrewnut(variant) {
	for (side = [1, -1]) translate ([0, side * (rodsize + partthick), 0]) rotate([0, 90, 0]) rod(75);
	rod(75, true);
	translate([-partthick - rodsize, 0, 0]) {
		rod(75);
		rotate([0, 0, (variant < 1) ? 180 : 0]) carriage(-bearingsize - partthick, variant);
	}
	rodnut();
	%color(c) difference() {
		union() {
			cylinder(r = rodnutdiameter / 2 + partthick / 4, h = rodnutsize + partthick / 4, center = true, $fn = 6);
			translate([(rodsize * 2 + partthick * 2) / -sqrt(3), 0, 0]) {
				cylinder(r = (rodsize * 2 + partthick * 2) / sqrt(3), h = rodnutsize + partthick / 4, center = true, $fn = 6);
				for (side = [1, -1]) translate ([0, side * (rodsize + partthick), 0]) rotate([0, 90, 0]) difference() {
					cylinder(r = partthick / 2, h = (rodsize * 2 + partthick * 2) / sqrt(3), center = true, $fn = fn);
					*rod((rodsize * 2 + partthick * 2) / sqrt(3) + 0.1);
				}
			}
			*translate([-rodnutdiameter / 4 - partthick / 8 - partthick * 1.5, 0, -partthick / 4]) {
				cube([partthick * 3, rodsize * 2 + partthick * 2, partthick / 2], center = true);
			}
		}
	cylinder(r = rodnutdiameter / 2 + 0.1, h = rodnutsize + 0.1, center = true, $fn = 6);
	translate([rodnutdiameter / 4 + partthick / 8, 0, 0]) cube([rodnutdiameter / 2 + partthick / 4, rodnutdiameter * 3 / 4, rodnutsize + 0.1], center = true);
	cylinder(r = rodsize * 0.6, h  = rodnutsize + partthick / 4 + 0.1, center = true, $fn = fn);
	translate([rodnutdiameter / 4 + partthick / 8, 0, 0]) cube([rodnutdiameter / 2 + partthick / 4, rodsize * 1.2, rodnutsize + partthick / 4 + 0.1], center = true);
	for (side = [1, -1]) translate ([(rodsize * 2 + partthick * 2) / -sqrt(3), side * (rodsize + partthick), 0]) rotate([0, 90, 0]) rod((rodsize * 2 + partthick * 2) / sqrt(3) + rodsize / sqrt(3));

	}
}

leadscrewnut(0);