include <settings.scad>;

module nema14()
{
	color([1,0.4,0.4,1])
	union()
	{
		translate([0, 0, nema14_shaft_length/2 - nema14_shaft_projection - nema14_hub_depth])
			cylinder(r = nema14_shaft/2, h = nema14_shaft_length, center = true, $fn=20);
		translate([0, 0, -nema14_hub_depth])
			cylinder(r = nema14_hub/2, h = nema14_hub_depth*2, center = true, $fn=20);
		translate([0, 0, nema14_length/2])
			cube([nema14_square,nema14_square,nema14_length], center = true);
		union()
		{
			for ( x = [0:1] ) 
			for ( y = [0:1] )
			{
				translate([(x-0.5)*nema14_screws, (y-0.5)*nema14_screws, 0])
					cylinder(r = screwsize/2, h = 30, center = true, $fn=10);
			}
		}
	}


}

//nema14();