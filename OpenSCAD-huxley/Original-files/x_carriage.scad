//%translate([0, -20, 0]) import_stl("x-carriage-upper_1off.stl", convexity = 5);
translate([0, 30, 0]) translate([-0.1, -50, -3]) rotate([0, 0, -90]) import_stl("x-blunt-plate_1off.stl", convexity = 5);
translate([0, 50, 24]) rotate([0, 180,  -45]) import_stl("x-motor-end-clamp_1off.stl", convexity = 5);
//rotate([0, 0, 90]) import_stl("x-axis-sandwich-clamp_1off.stl", convexity = 5);
//%rotate([0, 180, 0]) import_stl("extruder-bracket-bowden_1off.stl", convexity = 5);


carriagewidth = 40;
rodsize = 6;
rodheight = 15;
rodspacing = 30;
screwsize = 3;
washersize = 0.5;
bearingsize = 10;
bearingwidth = 4;


module bearingneg(round = false, captivenut = true) translate([5 + rodsize / 2, 0, -bearingwidth / 2 - washersize]) union() {
	cylinder(r = (screwsize + 0.5) / 2, h = 40, center = true);
	if (captivenut) {
		translate([0, 0, -8]) cylinder(r1 = screwsize + 0.55, r2 = screwsize, h = 10, center = true, $fn = 6);
		*translate([0, 0, -18]) cylinder(r = screwsize + 0.25, h = 20.01, center = true, $fn = 6);
		}
	if (round) {
		translate([0, 0, 2.5]) cylinder(r = bearingsize / 2 + 1, h = 5, center = true);
		difference() {
			translate([0, 0, 5]) sphere(r = bearingsize / 2 + 1, center = true);
			translate([0, 0, 3 - bearingsize / 2]) cube(bearingsize + 2, center = true); 
		}
	}
	else translate([0, 0, 5]) cube([bearingsize + 5, carriagewidth, 10], center = true);
}


%for (side = [1, -1]) translate([side * rodspacing / 2, 0, rodheight]) rotate([90, 0, 0]) cylinder(r = rodsize / 2, h = 100, center = true);

module belt() union() {
	translate([1.25 / 2, 0, 0]) square([1.25, 30], center = true);
	for(i = [-3:3]) translate([1.25, 5 * i, 0]) rotate([0, 0, 90]) scale([0.75, 1, 1]) circle(r = 1.5,center = true, $fn = 6);
}

for (side = [0, 1]) rotate([0, 0, side * 180]) %translate([57 / 2, 0, rodheight]) linear_extrude(height = 5, center = true, convexity = 5) belt();




!difference() {union() {
	//translate([(rodspacing + bearingwidth + washersize * 4 + rodheight) / 2, 0, rodheight - 5]) 
	translate([-5, 10, 7.5]) rotate([90, 0, 0])
		difference() {
			translate([0, 0, 10]) rotate([0, 90, 0]) linear_extrude(height = 10, convexity = 5) difference() {
				square([20, 15], center = true);
				translate([-5, 0, 0]) circle(r = (screwsize + 0.5) / 2, center = true);
			}
			translate([3, 0, 2.5]) linear_extrude(height = 20, convexity = 5) belt();
		}
	
	
	difference() {
		union() {
			difference() {
				linear_extrude(height = rodheight - rodsize / 2, center = false, convexity = 5) difference() {
					square([rodspacing + bearingwidth + washersize * 4 + 15, carriagewidth], center = true);
					square([rodspacing - 15, carriagewidth - 20], center = true);
					circle(r = 13, center = true);
					//for(side = [1, -1]) translate([0, side * (carriagewidth / 2 - 5), 0]) circle(r = (screwsize + 0.5) / 2, center = true);
				}
				for (side = [1, -1]) {
					translate([rodspacing / 2, side * (carriagewidth / 2 - 5), rodheight]) rotate([0, 30, 180]) bearingneg();
					translate([rodspacing / 2, side * (carriagewidth / 2 - 5), rodheight]) rotate([0, 30, 0]) bearingneg();
				
					translate([-rodspacing / 2, side * (carriagewidth / 2 - 5), rodheight]) rotate([0, 90, 0]) bearingneg(true, false);
					translate([-5, 0, 15]) cube([15, carriagewidth + 0.1, 20], center = true);
					translate([-rodspacing / 2 + 5, 0, rodheight]) cube([10, carriagewidth + 0.1, rodsize * 2], center = true);
				}
			}
			for (side = [1, -1]) {
				translate([side * (rodspacing / 2 + bearingwidth / 2 + washersize * 2), 0, 0]) rotate([90, 0, side * 90]) linear_extrude(height = 7.5, center = false, convexity = 5) difference() {
					union() {
						translate([0, (rodheight + rodsize + 5) / 2, 0]) square([15, rodheight + rodsize + 5], center = true);
						translate([0, rodheight + rodsize + 5, 0]) circle(r = 7.5, center = true);
					}
					translate([0, rodheight + rodsize / 2 + 5, 0]) square([screwsize + 0.5, rodsize], center = true);
					translate([0, rodheight + 5, 0]) circle(r = (screwsize + 0.5) / 2, center = true);
					translate([0, rodheight + rodsize + 5, 0]) circle(r = (screwsize + 0.5) / 2, center = true);
				}
			}
			for (side = [1, -1]) difference() {
				linear_extrude(height = 5, convexity = 5) difference() {
					union() {
						translate([side * ((72 - 15 - rodspacing) / 4 + rodspacing / 2), 0, 0]) square([(72 - 15 - rodspacing) / 2, 15], center = true);
						translate([side * (72 / 2 - 7.5), 0, 0]) circle(r = 7.5, center = true);
					}
					translate([side * 30, 0, 0]) circle(r = (screwsize + 0.5) / 2, center = true);
				}
				translate([side * 30, 0, 3]) linear_extrude(height = 10, convexity = 5) circle(r = screwsize + 0.25, center = true, $fn = 6);
			}
		}
		for (side = [1, -1]) translate([side * rodspacing / 2, 0, rodheight]) rotate([90, 0, 0]) cylinder(r = rodsize * 1, h = 100, center = true);
	}
}
//translate([0, 0, 8.1]) linear_extrude(height = 30, convexity = 5) square([200, 200], center = true);
}