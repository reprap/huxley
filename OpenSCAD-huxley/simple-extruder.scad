include <parameters.scad>;
use <library.scad>;

hub_x=-4.5;
drive_offset=[hub_x,-14.5,0];
block_offset=[0,0,0];
clamp_centres=28;

module end_bearing(body=true)
{
	union()
	{
		rotate([90,0,0])
			translate([0,0,-22])
			{
				cylinder(h=4, r=13/2, center=true,$fn=20);
				if(!body)
					cylinder(h=20, r=6/2, center=true,$fn=20);
			}
	}
}


module drive(body=true)
{
	union()
	{
			rotate([90,0,0])
			{
				nema17(body = body, slots = -1, counterbore = -1, hubdepth = 7);
				if(body)
				{
					translate([0,0,-15])
						cylinder(h=10, r=4, center=true,$fn=20);
					translate([0,0,-7.5])
						cylinder(h=5, r=12.5/2, center=true,$fn=20);
					rotate([-90,0,0])
						end_bearing(body);
				}
			}
	}
}

module filament()
{
	cylinder(h=200, r=1.75/2, center=true,$fn=10);
}

module tie_rods()
{
	for(i=[-1/2,1/2])
		translate([i*clamp_centres,0,-30])
			cylinder(h=200, r=3/2, center=true,$fn=10);
}

module block()
{
	difference()
	{
		translate([hub_x+2,-0.5,0])
			cube([nema17_square+1, 28, nema17_square], center = true);
		translate(drive_offset)
			drive(body=false);
		translate([10,0,10])
			cube([40,17,40], center=true);
		tie_rods();
		filament();
		translate(drive_offset)
			end_bearing(body=false);
	}
}



// PEEK
//translate([0,0,-28])
//cylinder(h=40, r=4, center=true,$fn=20);

// Idler
translate([5.5,0,0])
rotate([90,0,0])
cylinder(h=4, r=5, center=true,$fn=20);

translate(drive_offset)
drive(body=true);

 filament();

translate(block_offset)
	block();

