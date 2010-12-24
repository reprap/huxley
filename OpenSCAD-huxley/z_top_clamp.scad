include <parameters.scad>;
use <library.scad>;

module z_top_clamp()
{
	rotate([-90,0,0])
		difference()
		{
		
			cube([vertex_gap+partthick, partthick,partthick],center=true);
		
			translate([vertex_gap/2, 0, -partthick])
				rotate([0,0,90])
					teardrop(radius=rodsize/2 , height=partthick*2,truncateMM=0.5);
			translate([-vertex_gap/2, 0, -partthick])
				rotate([0,0,90])
					teardrop(radius=rodsize/2 , height=partthick*2,truncateMM=0.5);
		
			translate([-(rodsize+screwsize)/2, 0, -partthick])
				rotate([0,0,90])
					teardrop(radius=screwsize/2 , height=partthick*2,truncateMM=-1);
		
			translate([(rodsize+screwsize)/2, 0, -partthick])
				rotate([0,0,90])
					teardrop(radius=screwsize/2 , height=partthick*2,truncateMM=-1);
		
			rotate([90,0,0])
				rod(partthick*2);
			cube([1.8*partthick,2*partthick,partthick*0.1], center=true);
		}
}

z_top_clamp();







