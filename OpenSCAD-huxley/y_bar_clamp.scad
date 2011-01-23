

include <parameters.scad>;
use <library.scad>;



module y_bar_clamp()
{
	difference()
	{
		cube([partthick*1.7,partthick,partthick], center=true);
		translate([partthick*0.75, 0, 0])
			cube([partthick*1.5,0.2*partthick,partthick*2], center=true);
		rod(rodsize*5);
		translate([rodsize, 2*rodsize, 0])
		rotate([90, 0, 0])
			rotate([0, 0, -90])
				teardrop(r = screwsize/2, h = rodsize * 5, truncateMM = 0.5);
		translate([-rodsize, 2*rodsize, 0])
		rotate([90, 0, 0])
			rotate([0, 0, -90])
				teardrop(r = screwsize/2, h = rodsize * 5, truncateMM = 0.5);
	}
}

y_bar_clamp();


