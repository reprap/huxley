include <parameters.scad>;
use <library.scad>;

module idler()
{
	for(i=[-1,1])
	for(j=[-1,1])
	translate([0,i*10,j*7])
		rotate([0,90,0])
			cylinder(h=30,r=screwsize/2,center=true, $fn=10);
	translate([-3,0,0])
		cube([12,25,20], center = true);
	rotate([90,0,0])
	{
		cylinder(h=30,r=screwsize/2,center=true, $fn=10);
		cylinder(h=4,r=5,center=true, $fn=20);
	}
}


module m6_shaft()
{
	rotate([-90,0,0])
	{
		union()
		{
			rod(80);
			translate([0,0,22])
				cylinder(h=6,r=9.5,center=true);
			translate([0,0,-12])
				cylinder(h=6,r=9.5,center=true);
			translate([0,0,-26])
				rotate([180,0,6])
					grub_gear(hub_height = 10, hub_radius = 9.5, shaft_radius = 3, height = 7, number_of_teeth = 31, 
						inner_radius = 22, outer_radius = 25, angle=15);
		}	
	}
}

rotate([0,-60,0])
translate([-32, 25,0])
	m6_shaft();

rotate([90,0,0])
	grub_gear(hub_height = 7, hub_radius = 9.5, shaft_radius = 2.5, height = 8, number_of_teeth = 11, 
		inner_radius = 6.5, outer_radius = 9, angle=25);

translate([0, 11.5,0])
	rotate([-90,0,0])
  		nema11(body=true, slots = 5, counterbore=8);


translate([-40+32*cos(-60),30,32*sin(-60)])
	idler();