include <parameters.scad>;
use <library.scad>;


module m6_shaft()
{
	rotate([-90,0,0])
	{
		union()
		{
			rod(80);
			for(i=[-1,1])
				translate([0,0,10*i])
					cylinder(h=6,r=9.5,center=true);
			translate([0,0,-36])
			union()
			{
				difference()
				{
					cylinder(h=11,r=43,center=true);
					translate([0,0,-3])
						gear(height = 20, number_of_teeth = 57, inner_radius = 
							38, outer_radius = 41, angle=10);
				}

				cylinder(h=11,r=15,center=true);
			}

		}	
	}
}

translate([-32, 25,0])
	m6_shaft();

rotate([90,0,0])
	grub_gear(base_height = 7, height = 8, number_of_teeth = 11, inner_radius = 6.5, outer_radius = 9, angle=25);

translate([0, 11.5,0])
	rotate([-90,0,0])
  		nema11();