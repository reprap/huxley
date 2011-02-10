include <parameters.scad>;
use <library.scad>;

module idler_holes()
{
	union()
	{
		for(i=[-1,1])
		for(j=[-1,1])
		translate([0,i*5,j*7])
			rotate([0,90,0])
			{
				cylinder(h=60,r=screwsize/2,center=true, $fn=10);
				translate([0,0,30])
					cylinder(h=20,r=nutsize,center=true, $fn=6);
			}
		rotate([90,0,0])
		{
			cylinder(h=30,r=screwsize/2,center=true, $fn=10);
			cylinder(h=4.2,r=5.5,center=true, $fn=20);
			translate([5.5,0,0])
				cube([11,11,4.2],center=true);
		}

		// Filament

		translate([6,0,0])
			cylinder(h=100,r=1,center=true, $fn=15);
	}
}

module idler(body=true)
{
	if(body)
	{
		difference()
		{
			translate([-3,0,0])
				cube([12,15,20], center = true);
			idler_holes();
		}
	} else
		idler_holes();
}


module m6_shaft(body=true)
{
	rotate([-90,0,0])
	{
		union()
		{
			if(body)
				rod(80);
			else
				cylinder(h=80,r=7.5,center=true);

			translate([0,0,17])
				if(body)
					cylinder(h=6,r=9.5,center=true);
				else
					cylinder(h=6.2,r=10,center=true);

			translate([0,0,-7])
				if(body)
					cylinder(h=6,r=9.5,center=true);
				else
					cylinder(h=6.2,r=10,center=true);

			if(body)
				translate([0,0,-26])
					rotate([180,0,6])
						grub_gear(hub_height = 10, hub_radius = 9.5, shaft_radius = 3, height = 7, 
							number_of_teeth = 31, inner_radius = 22, outer_radius = 25, angle=15);
		}	
	}
}

difference()
{

translate([nema11_square/2, 0,nema11_square/2])
	mirror([1,0,1])
		cube([50, 60, 60]);


translate([0, 15+40,nema11_square*0.1])
	cube([nema11_square*1.2, 80, nema11_square*1.2], center=true);

translate([-30, 30,-15])
	cube([30, 80, 30], center=true);


rotate([0,-60,0])
	translate([-32, 25,0])
		m6_shaft(body=false);

translate([-42+32*cos(-60),30,32*sin(-60)])
	idler(body=false);

translate([0, 11.5,0])
	rotate([-90,0,0])
  		nema11(body=false, slots = 5, counterbore=8);


}

rotate([0,-60,0])
	translate([-32, 25,0])
		m6_shaft(body=true);

translate([-42+32*cos(-60),30,32*sin(-60)])
	idler(body=true);

rotate([90,0,0])
	grub_gear(hub_height = 7, hub_radius = 9.5, shaft_radius = 2.5, height = 8, number_of_teeth = 11, 
		inner_radius = 6.5, outer_radius = 9, angle=25);

translate([0, 11.5,0])
	rotate([-90,0,0])
  		nema11(body=true, slots = 5, counterbore=8);


