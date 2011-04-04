include <parameters.scad>;
use <library.scad>;

hub_x=-4.5;
drive_offset=[hub_x,-14.6,0];
block_offset=[hub_x,0,0];
lever_offset=[0,0,0];
idler_offset=[5.5,0,0];
clamp_centres=28;
filament_radius=1.75/2;

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
	cylinder(h=200, r=filament_radius, center=true,$fn=10);
}

module tie_rods(radius=3/2)
{
	for(i=[-1/2,1/2])
		translate([i*clamp_centres,0,-30])
			cylinder(h=50, r=radius, center=true,$fn=10);
}

module mendel_mount(radius=4/2)
{
	for(i=[-1/2,1/2])
		translate([0,i*50,0])
			cylinder(h=100, r=radius, center=true,$fn=10);
}



module bearing_hole()
{
	rotate([90,0,0])
	{
		translate([0,0,-15])
		{
			teardrop(h=35,r=screwsize/2, center=false,   teardrop_angle=0,truncateMM=0.5);
			translate([0,0,-26])
				teardrop(h=30,r=screwsize, center=false,   teardrop_angle=0,truncateMM=0.5);
			translate([0,0,35])
				pentanut(height=20, center=true);
		}
		cylinder(h=5.5,r=6,center=true, $fn=20);
		translate([-5,0,0])
			cube([11,12,5.5],center=true);
	}
}

module lever()
{
	difference()
	{
	translate([0,0,12])
		cube([65,15,40], center=true);

	translate([-8,0,13])
	{
		rotate([90, 0, 0])
			cylinder(r=10, h=20 , center=true);
		translate([-25,0,-10])
			cube([50,20,40], center=true);
		translate([-10,0,-25])
			cube([40,20,50], center=true);
	}

	translate([32,0,10])
			cube([30,20,60], center=true);

	translate([32,0,23])
			rotate([0,-45,0])
				cube([30,20,60], center=true);

	translate([-5,0,-10])
			rotate([0,-45,0])
				cube([20,20,20], center=true);

	translate([23,0,-10])
			rotate([0,-45,0])
				cube([20,20,20], center=true);


	translate(idler_offset - lever_offset)
		bearing_hole();

	teardrop(h=200, r=filament_radius*1.5,teardrop_angle=0,truncateMM=0.5);
	translate(drive_offset-lever_offset)
			drive(body=false);

	}
}

module block()
{
	difference()
	{
		union()
		{
			translate([-nema17_screws/2,-0.5,0])
				cube([10, 28, nema17_square], center = true);
			translate([-nema17_screws/2-8,3.5,5])
				cube([10, 20, 10], center = true);
			translate([-8,9.5,0])
				cube([8, 8, 15], center = true);
			translate([-nema17_screws/2+5,-0.5,-nema17_screws/2-0.5])
				cube([10, 28, 10], center = true);

			translate([nema17_screws/2+2.5,-0.5,0])
				cube([15, 28, nema17_square], center = true);
			translate([nema17_screws/2+5,-0.5,-nema17_screws/2-0.5])
				cube([10, 28, 10], center = true);
			translate([0,-0.5,-nema17_screws/2-1.5])
				cube([24, 28, 8], center = true);
	
		}
		translate(-block_offset)
			tie_rods();
		translate([-clamp_centres/2,0,9]-block_offset)
			cylinder(h=40, r=4, center=true,$fn=10);
		translate(drive_offset-block_offset)
			drive(body=false);

		translate([nema17_screws/2,-5.5,10])
			cube([20, 28,nema17_square ], center = true);

	}

}

module sectioncube()
{
	translate([0,-50,0])
		cube([100,100,100], center=true);
}

module idler_bearing()
{
rotate([90,0,0])
cylinder(h=4, r=5, center=true,$fn=20);
}



// PEEK
//translate([0,0,-28])
//cylinder(h=40, r=4, center=true,$fn=20);

//mendel_mount();

intersection()
{
union()
{
// Idler
//translate(idler_offset)
//idler_bearing();

translate(drive_offset)
	drive(body=true);

filament();
//tie_rods();

translate(block_offset)
block();

//translate(lever_offset)
//	lever();
}
//sectioncube();
}
