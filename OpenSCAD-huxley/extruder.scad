include <parameters.scad>;
use <library.scad>;

module idler_holes(screws=true, bearing=true, filament=true)
{
	translate([1,0,0])
	union()
	{
		if(screws)
		{
			for(i=[-1,1])
			for(j=[-1,1])
			translate([0,i*4,j*5])
				rotate([0,90,0])
				{
					cylinder(h=60,r=screwsize/2,center=true, $fn=10);
					translate([0,0,30])
						cylinder(h=20,r=nutsize,center=true, $fn=6);
				}
		}

		if(bearing)
		{
			rotate([90,0,0])
			{
				cylinder(h=30,r=screwsize/2,center=true, $fn=10);
				cylinder(h=4.2,r=5,center=true, $fn=20);
				translate([5,0,0])
					cube([10,11,4.2],center=true);
			}
		}


		if(filament)
		{
			translate([6,0,0])
			{
				cylinder(h=100,r=1,center=true, $fn=15);
				translate([0,0,-33])
				cylinder(h=30,r=4.2,center=true, $fn=25);
			for(i=[-1,1])
			rotate([0,0,90])
			translate([0,i*19/2,-35])
				cylinder(h=50,r=screwsize/2,center=true, $fn=15);

			}
		}
	}
}


module idler(body=true)
{
	if(body)
	{
		difference()
		{
			translate([-2,0,0])
				cube([12,15,16], center = true);
			idler_holes();
		}
	} else
		idler_holes();
}

module l_block(body=true)
{
	if(body)
	{
		difference()
		{
			union()
			{
				translate([19,0,0])
					cube([10,16,18], center = true);
				translate([7,0,-20])
					cube([29,16,10], center = true);
			}
			idler_holes(screws=true, bearing=false,filament=true);
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
				translate([0,0,-17])
					rod(55);
			else
				cylinder(h=80,r=7.5,center=true);

			translate([0,0,5])
				if(body)
					cylinder(h=6,r=9.5,center=true);
				else
					cylinder(h=6.2,r=10,center=true);

			translate([0,0,-23])
				if(body)
					cylinder(h=6,r=9.5,center=true);
				else
					cylinder(h=6.2,r=10,center=true);

			if(body)
				translate([0,0,-33])
					rotate([0,0,2])
						grub_gear(hub_height = 10, hub_radius = 9.5, shaft_radius = 3, height = 7, 
							number_of_teeth = 31, inner_radius = 22, outer_radius = 25, angle=15);
		}	
	}
}

difference()
{

union()
{
translate([nema11_square/2+2, 0,nema11_square/2+2])
	mirror([1,0,1])
		cube([69, 8, 50]);

translate([nema11_square/2+2-18, 24,-nema11_square/2-2])
	mirror([1,0,1])
		cube([53-nema11_square/2-2, 8, 50-18]);
}


rotate([0,-60,0])
	translate([-32, 25,0])
		m6_shaft(body=false);

translate([-42+32*cos(-60),16,32*sin(-60)])
	idler(body=false);

translate([0, 11.5,0])
	rotate([-90,0,0])
  		nema11(body=false, slots = 5, counterbore=8);


}

rotate([0,-60,0])
	translate([-32, 25,0])
		m6_shaft(body=true);

translate([-42+32*cos(-60),16,32*sin(-60)])
	idler(body=true);

translate([-42+32*cos(-60),16,32*sin(-60)])
	l_block(body=true);

rotate([90,0,0])
	grub_gear(hub_height = 7, hub_radius = 9.5, shaft_radius = 2.5, height = 8, number_of_teeth = 11, 
		inner_radius = 6.5, outer_radius = 9, angle=25);

translate([0, 8,0])
	rotate([-90,0,0])
  		nema11(body=true, slots = 5, counterbore=8);


