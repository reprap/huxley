include <parameters.scad>;
use <library.scad>;

motor_angle=-21.5;
gear_mesh=7;
clamp_centres=19;
plate_thickness=5;
filament_y_offset=-27;
bearing_gap=43;

module accessories(holes=false, angle=270)
{
	translate([0,0,-bearing_depth/2])
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
					adjustable_bearing(true, angle);
				else
					adjustable_bearing(true,-1);

	}

	// 180 bearing

	translate([20, x_bar_gap/2, 0])
		rotate([90, 0,90])
			if(holes)
				adjustable_bearing(false, angle);
			else
				adjustable_bearing(false,-1);
	}

	if(holes)
	{
		// Filament
	
		cylinder(h=150,r=1,center=true, $fn=15);
	
		// Nozzle
	
		translate([0, 0, -23+plate_thickness])
		cylinder(h=46,r=4,center=true, $fn=15);
		translate([-clamp_centres/2, 0, 0])
		cylinder(h=40,r=screwsize/2,center=true, $fn=15);
		translate([clamp_centres/2, 0, 0])
		cylinder(h=40,r=screwsize/2,center=true, $fn=15);
	}

}

module idler_holes(screws=true, bearing=true)
{
	translate([-1,0,0])
	union()
	{
		if(screws)
		{
			for(i=[-1,1])
			for(j=[-1,1])
			translate([0,i*11,j*7])
				rotate([0,90,0])
				{
					cylinder(h=60,r=screwsize/2,center=true, $fn=10);
					translate([0,0,28])
						cylinder(h=20,r=nutsize,center=true, $fn=6);
				}
		}

		if(bearing)
		{
			rotate([90,0,0])
			{
				translate([0,0,-15])
				{
					teardrop(h=30,r=screwsize/2,truncateMM=0.5);
					translate([0,0,-27])
						teardrop(h=30,r=screwsize,truncateMM=0.5);
					translate([0,0,50])
						pentanut(height=20);
				}
				cylinder(h=5,r=7,center=true, $fn=20);
				translate([-5,0,0])
					cube([10,14,5],center=true);
			}
		}



	}
}


module idler(body=true)
{
	translate([7,0,0])
	if(body)
	{
		difference()
		{
			union()
			{
				translate([2,0,0])
					cube([12,30,22], center = true);
				translate([-1,0,12])
					cube([18,12,5], center = true);
			}
			translate([-11,0,-11])
				rotate([0,60,0])
					cube([20,40,20], center = true);
			idler_holes();
			translate([-7,0,0])
				cylinder(h=100,r=1,center=true, $fn=15);
		}
	} else
		idler_holes(screws=true, bearing=false, filament=true);
}

module drive_gear_and_motor(gear=true, holes=false)
{
	if(gear)
		rotate([90,gear_mesh,0])
			grub_gear(hub_height = 7, hub_radius = 9.5, shaft_radius = 2.5, height = 8, number_of_teeth = 11, 
				inner_radius = 6.5, outer_radius = 9, angle=25);
	
	translate([0, 12,0])
		rotate([-90,0,0])
	 		nema11(body=!holes, slots = -1, counterbore=8);
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

module m6_shaft(body=true)
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

module drive_assembly()
{
	m6_shaft(body=true);
	driven_gear(wingnut=true);
	translate([-32*cos(motor_angle), 1, 32*sin(motor_angle)])
		drive_gear_and_motor();
	translate([5+4, -filament_y_offset, 0])
		rotate([90,0,0])
			cylinder(h=4, r=5, center=true, $fn=20);

}

module base_plate()
{
	difference()
	{
		translate([0, 0, plate_thickness/2])
			cube([50,60,plate_thickness], center=true);
		accessories(holes=true, angle=361);
	}
}



translate([-3,filament_y_offset,31])
	drive_assembly();

translate([0,0,31])
	idler();


base_plate();

accessories();
