include <parameters.scad>;
use <library.scad>;

motor_angle=-10;
gear_mesh=7;
clamp_centres=19;
plate_thickness=5;
fat_plate_thickness=8;
filament_y_offset=-27;
bearing_gap=44;
idler_z = 31;
fixed_block_width=33;
back_plate_height=41;
motor_plate_extra_x=35;

drive_assembly_position=[-3,filament_y_offset,31];
fixed_block_position=[0,0,10];
idler_position=[0,0,idler_z];
back_plate_position=[0,fixed_block_width/2+fat_plate_thickness/2,5+back_plate_height/2];
motor_plate_position=[0,-fixed_block_width/2-fat_plate_thickness/2,5+back_plate_height/2];
motor_position=[-32*cos(motor_angle), 1, 32*sin(motor_angle)];
base_position=[0,0,0];
accessories_position=[0,0,0];
clamp_position=[-12, -44, -9];

// Module that either gives a cylinder or a teardrop

module maybe_teardrop(h=80, r=screwsize/2, teardrop_angle=-1, faces=15)
{
	if(teardrop_angle < 0)
		cylinder(h=h,r=r,center=true, $fn=faces);
	else
		rotate([0, 0, teardrop_angle])
			translate([0, 0, -h/2])
				teardrop(h=h,r=r,truncateMM=0.5);
}

module nozzle_holes(teardrop_angle=-1)
{
	// M3 holes

	translate([-clamp_centres/2, 0, 0])
		maybe_teardrop(h=80, r=screwsize/2, teardrop_angle=teardrop_angle, faces=15);

	translate([clamp_centres/2, 0, 0])
		maybe_teardrop(h=80, r=screwsize/2, teardrop_angle=teardrop_angle, faces=15);

	// Filament

	maybe_teardrop(h=150, r=1, teardrop_angle=teardrop_angle, faces=15);
}

module accessories(holes=false,  teardrop_angle=270)
{
	if(huxley)
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
								adjustable_bearing(true,  teardrop_angle);
							else
								adjustable_bearing(true,-1);
		
			}

		// 180 bearing
	
			translate([20, x_bar_gap/2, 0])
				rotate([90, 0,90])
					if(holes)
						adjustable_bearing(false,  teardrop_angle);
					else
						adjustable_bearing(false,-1);
		}

	if(holes)
	{
	
		// Nozzle
	
		translate([0, 0, -23+plate_thickness])
		cylinder(h=46,r=4,center=true, $fn=15);
		nozzle_holes();

		if(mendel)
		{
			for(i=[-1,1])
				translate([20, i*25, 0])
					cylinder(h=50,r=2,center=true, $fn=15);
		}
	}

}

module idler_holes(screws=true, bearing_hole=true)
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
					cylinder(h=60,r=0.5+screwsize/2,center=true, $fn=10);
					translate([0,0,-17])
						cylinder(h=20,r=1.3*nutsize,center=true, $fn=6);
				}
		}

		if(bearing_hole)
		{
			rotate([90,0,0])
			{
				translate([0,0,-15])
				{
					teardrop(h=35,r=screwsize/2,truncateMM=0.5);
					translate([0,0,-27])
						teardrop(h=30,r=screwsize,truncateMM=0.5);
					translate([0,0,49])
						pentanut(height=20);
				}
				cylinder(h=5.5,r=6,center=true, $fn=20);
				translate([-5,0,0])
					cube([11,12,5.5],center=true);
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
			translate([2,0,0])
				cube([12,30,22], center = true);

			for(z=[-1,1])
			translate([0,0,z*12])
				cube([20,10,10], center = true);
			translate([-11,0,-11])
				rotate([0,60,0])
					cube([20,40,20], center = true);
			idler_holes();
			translate([-7,0,0])
				cylinder(h=100,r=1,center=true, $fn=15);
		}
	} else
		idler_holes(screws=true, bearing_hole=true);
}

module motor_spacer()
{
	translate([0, 10.75, 0])
		difference()
		{
			cube([nema11_square, 2.5, nema11_square], center = true);
			translate([0, 12,0])
				rotate([-90,0,0])
			 		nema11(body=false, slots = -1, counterbore=-1);
		}
}

module drive_gear()
{
	grub_gear(hub_height = 7, hub_radius = 9.5, shaft_radius = 2.5, height = 8, number_of_teeth = 11, 
		inner_radius = 6.5, outer_radius = 9, angle=25);
}

module drive_gear_and_motor(gear=true, holes=false)
{
	translate(motor_position)
	{
		if(gear)
			rotate([90,gear_mesh,0])
				drive_gear();
		
		translate([0, 12,0])
			rotate([-90,0,0])
		 		nema11(body=!holes, slots = -1, counterbore=8);
		if(!holes)
			motor_spacer();
	}
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

module block_holes(teardrop_angle=-1)
{
	translate([-13, 0, 0])
		rotate([90, 0, 0])
		{
			maybe_teardrop(h=80,r=screwsize/2, teardrop_angle=teardrop_angle, faces=15);
			translate([0, 0, 31])
				rotate([0,0,30])
					cylinder(h = 20, r = screwsize, center=true, $fn=6);
		}

	translate([13, 0, 0])
		rotate([90, 0, 0])
		{
			maybe_teardrop(h=80,r=screwsize/2, teardrop_angle=teardrop_angle, faces=15);
			translate([0, 0, 31])
				rotate([0,0,30])
					cylinder(h = 20, r = screwsize, center=true, $fn=6);
		}

	translate([-13, 0, 32])
		rotate([90, 0, 0])
		{
			maybe_teardrop(h=80,r=screwsize/2, teardrop_angle=teardrop_angle, faces=15);
			translate([0, 0, 31])
				rotate([0,0,30])
					cylinder(h = 20, r = screwsize, center=true, $fn=6);
		}
}


module fixed_block()
{
	difference()
	{
		union()
		{
			difference()
			{
				union()
				{
					cube([32,fixed_block_width,10], center=true);
					translate([-9.5,0,14 + (back_plate_height - 38)/2])
						cube([13,33,back_plate_height], center=true);
					translate([0,0,back_plate_height-8])
						cube([8,8,6], center = true);
					difference()
					{
						translate([0,0,12])
							cube([10,8,24], center=true);
						translate([11,0,20])
							rotate([0,60,0])
								cube([20,40,20], center = true);
						translate([0,0,27])
								cube([20,40,20], center = true);
					}
				}
				nozzle_holes(teardrop_angle=180);
				translate(idler_position-fixed_block_position)
					idler_holes(screws=true, bearing_hole=false);
				translate(drive_assembly_position-fixed_block_position)
					m6_shaft(body=false,big_hole=4, teardrop_angle=-1);
			}
			translate(back_plate_position-fixed_block_position)
				difference()
				{
					cube([32,fat_plate_thickness,back_plate_height], center=true);
					translate(drive_assembly_position-back_plate_position)
						m6_shaft(body=false,big_hole=7.5,  teardrop_angle=180);
				}
				
		}
		block_holes(teardrop_angle=180);
	}
}

module m6_shaft(body=true,big_hole=7.5, teardrop_angle=-1)
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
					maybe_teardrop(h=bearing_gap+52,r=big_hole,teardrop_angle=teardrop_angle,truncateMM=0.5);


			translate([0,0,bearing_gap+22])
				if(body)
					cylinder(h=6,r=9.5,center=true);
				else
					maybe_teardrop(h=6.2,r=10,teardrop_angle=teardrop_angle,truncateMM=0.5);

			translate([0,0,22])
				if(body)
					cylinder(h=6,r=9.5,center=true);
				else
					maybe_teardrop(h=6.2,r=10,teardrop_angle=teardrop_angle,truncateMM=0.5);
		}	
	}
}

module drive_assembly()
{
	m6_shaft(body=true, big_hole=7.5, teardrop_angle=-1);
	driven_gear(wingnut=true);
	drive_gear_and_motor();
	translate([5+4, -filament_y_offset, 0])
		rotate([90,0,0])
			cylinder(h=4, r=5, center=true, $fn=20);

}

module bracket_holes(teardrop_angle=-1)
{
	for(x=[-1,1])
	for(z=[0,1])
	{
		translate([x*12, -30, -4-10*z])
			rotate([90,0,0])
			{
				maybe_teardrop(h=40, r=screwsize/2, teardrop_angle=teardrop_angle, faces=15);
				if(teardrop_angle>=0)
					translate([0,0,-7])
						rotate([0, 0, teardrop_angle])
							pentanut(height=20);
			}
	}
}


module belt_clamp()
{
	difference()
	{
		translate([0, 0, 0])
			cube([8,5,18], center=true);
		translate(base_position-clamp_position)
			bracket_holes(teardrop_angle=-1);
	}
}

module base_plate()
{
	difference()
	{
		union()
		{
			translate([0, 0, plate_thickness/2])
				cube([50,60,plate_thickness], center=true);
			if(huxley)
				translate([0, -29,-8.5+plate_thickness/2])
					difference()
					{
						cube([32, 20, 22], center=true);
						translate([0, 8, -4])
							cube([40, 20, 20], center=true);
					}
		}
		accessories(holes=true, angle=361);
		if(huxley)
			translate(bracket_position-base_position)
				bracket_holes(teardrop_angle=90);
	}
}



module motor_plate()
{
	difference()
	{
		translate([-motor_plate_extra_x/2, 0, 0])
			cube([32+motor_plate_extra_x,fat_plate_thickness,back_plate_height], center=true);
		translate([-motor_plate_extra_x/2-17,0,-26])
			cube([36,20,20], center=true);
		translate([-motor_plate_extra_x/2-17,0,26])
			cube([36,20,20], center=true);
		translate(drive_assembly_position-motor_plate_position)
			m6_shaft(body=false,big_hole=7.5, teardrop_angle=-1);
		translate(drive_assembly_position-motor_plate_position)
			drive_gear_and_motor(gear=false, holes=true);
		translate(fixed_block_position-motor_plate_position)
			block_holes(teardrop_angle=-1);
	}
}



/*
//------------------------------------------------------------------

// Uncomment to check hole interference

translate(fixed_block_position)
	block_holes();

translate(idler_position)
	idler_holes();

translate(base_position)
	nozzle_holes();

//--------------------------------------------------------------------
*/




//--------------------------------------------------------------------

// Uncomment to get entire assembly

translate(fixed_block_position)
	fixed_block();

translate(idler_position)
	idler();

translate(base_position)
	base_plate();

translate(clamp_position)
	belt_clamp();


translate(motor_plate_position)
	motor_plate();

translate(drive_assembly_position)
	drive_assembly();

translate(accessories_position)
	accessories();
//-----------------------------------------------------------------



// Individual built items

//fixed_block();

//idler();

//base_plate();

//belt_clamp(); // 2 off

//motor_plate();

//motor_spacer();

//drive_gear();

//driven_gear(wingnut=true);

//adjustable_bearing(true,-1); // 2 off

//adjustable_bearing(false,-1);