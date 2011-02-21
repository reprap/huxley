include <parameters.scad>;
use <library.scad>;

module accessories(holes=false, angle=270)
{
	for(i=[-1,1])
	{

		// X axis rods

		if(!holes)
		translate([0, i*x_bar_gap/2 , 0])
			rotate([0,90,0])
				rod(100);
		// Belts

		if(!holes)
		translate([0, i*40 , 0])
			cube([100,2,6], center=true);

		//360 bearings

		translate([i*20, -x_bar_gap/2, 0])
			rotate([90,0,-90])
				if(holes)
					adjustable_bearing(true,angle);
				else
					adjustable_bearing(true,-1);

	}

	// 180 bearing

	translate([20, x_bar_gap/2, 0])
		rotate([90, 0,90])
			if(holes)
				adjustable_bearing(false,360-angle);
			else
				adjustable_bearing(false,-1);
	// Filament

	cylinder(h=150,r=1,center=true, $fn=15);

	// Nozzle

	translate([0, 0, -23])
	cylinder(h=46,r=4,center=true, $fn=15);

}

module driven_gear(wingnut=false)
{
	translate([0,-7,0])
	rotate([-90,0,0])
	difference()
	{
		union()
		{
			grub_gear(hub_height = 10, hub_radius = 10, shaft_radius = 3, height = 7, 
				number_of_teeth = 31, inner_radius = 22, outer_radius = 25, angle=15);
			if(wingnut)
				difference()
				{
					strut(p1=[0,-7,-5], p2=[0,7,-5], wide = 10, deep = 15, round=2);
					cylinder(h=50,r=9, center=true,$fn=20);
				}
		}
		if(wingnut)
		{
			intersection()
			{
				translate([0,16,-14])
					rotate([-30,0,0])
						cube([4, 26, 20], center=true);
				cylinder(h=50,r=13, center=true,$fn=20);
			}
			intersection()
			{
				translate([0,-16,-14])
					rotate([30,0,0])
						cube([4, 26, 20], center=true);
				cylinder(h=50,r=13, center=true,$fn=20);
			}
		}
	}
}

module m6_shaft(body=true, bearing_gap=28)
{
	translate([0,-17,0])
	rotate([-90,0,0])
	{
		union()
		{
			translate([0,0,(bearing_gap+27)/2])
				if(body)
					rod(bearing_gap+27);
				else
					cylinder(h=bearing_gap+52,r=7.5,center=true);

			translate([0,0,bearing_gap+22])
				if(body)
					cylinder(h=6,r=9.5,center=true);
				else
					cylinder(h=6.2,r=10,center=true);

			translate([0,0,22])
				if(body)
					cylinder(h=6,r=9.5,center=true);
				else
					cylinder(h=6.2,r=10,center=true);
		}	
	}
}


translate([3,-20,35])
{
	m6_shaft(body=true, bearing_gap=28);
	driven_gear(wingnut=true);
}
accessories();