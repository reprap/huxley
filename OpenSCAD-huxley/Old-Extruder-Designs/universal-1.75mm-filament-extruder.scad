/*

RepRap Universal 1.75mm Filament Extruder

Adrian Bowyer  13 April 2011

Licence: GPL.

*/

include <parameters.scad>;
use <library.scad>;

motor_angle=-10;
gear_mesh=7;
clamp_centres=28;
plate_thickness=5;
fat_plate_thickness=8;
filament_y_offset=-27;
bearing_gap=44;
idler_z = 31;
fixed_block_width=33;
back_plate_height=41;
motor_plate_extra_x=35;
hob_gap=55;
motor_radius=34;

filament_radius=1.75/2;
hub_x=-3-filament_radius;
hub_z=31;

idler_offset=[5.5,0,0];
bearing_offset=[5+filament_radius, 0, 0];
lever_spring_offset=[-39,5,back_plate_height+10];
back_plate_position=[0,fixed_block_width/2+fat_plate_thickness/2,5+back_plate_height/2];
motor_position=[-motor_radius*cos(motor_angle), 1, motor_radius*sin(motor_angle)];



fixed_block_position=[0,0,10];
duct_offset=[-5.5,0,10];
base_position=[0,0,-3.5];
clamp_position=[-12, -44, -9];
drive_assembly_position=[hub_x,filament_y_offset,hub_z];
motor_plate_position=[0,-fixed_block_width/2-fat_plate_thickness/2,5+back_plate_height/2];
motor_plate_clip_position=[24.5,-20.5,15]+fixed_block_position;
spacer_position=drive_assembly_position + motor_position + [0, 10.75, 0];
lever_offset=[0,0,hub_z];
fan_position=[21.5,0,27];
accessories_position=[0,0,0];
motor_add=[0, 0, 0];
gear_add=[0, 0, 0];
bearing_add=[0, 0, 0];


/*
//--- Experimental exploded view
fixed_block_position=[0,0,10];
duct_offset=[-5.5,0,10] + [0, 0, -70];
base_position=[0,0,-3.5] + [0, 0, -20];
clamp_position=[-12, -44, -9] + [0, -40, 0];
drive_assembly_position=[hub_x,filament_y_offset,hub_z] + [0, 0, 0];
motor_plate_position=[0,-fixed_block_width/2-fat_plate_thickness/2,5+back_plate_height/2] + [0, -20, 0];
motor_plate_clip_position=[24.5,-20.5,15]+fixed_block_position + [45, 0, 0];
spacer_position=drive_assembly_position + motor_position + [0, 10.75, 0] + [0, 0, 0];
lever_offset=[0,0,hub_z] + [0, 0, 35];
fan_position=[21.5,0,27] + [30, 0, 0];
accessories_position=[0,0,0] + [0, 0, 0];
motor_add=[0, 0, -20];
gear_add=[0, -40, 0];
bearing_add=[0, 0, 30];
*/





module hob_jig_holes(teardrop_angle=-1)
{

		union()
		{
			rotate([-90,0,0])
			{
				if(teardrop_angle>=0)
					cylinder(h=6,r=7.5,center=true, $fn=20);
				else
					teardrop(h=hob_gap+20,r=7.5,center=true,teardrop_angle=teardrop_angle,truncateMM=0.5);
	
				for(z=[-1,1])
				translate([0,0,z*(hob_gap/2+3)])
					if(teardrop_angle>0)
						cylinder(h=6,r=9.5,center=true, $fn=20);
					else
						teardrop(h=6.2,r=10,center=true,teardrop_angle=teardrop_angle,truncateMM=0.5);
			}

			for(y=[-1,1])
				translate([0, -5+y*12, 0])
					cube([3,15,50], center=true);

		}	

}

module hob_jig()
{
	difference()
	{
		translate([0, 0, -5])
			cube([30, hob_gap+10,20], center=true);
		hob_jig_holes(teardrop_angle=-1);
		translate([0, 0, 10])
			cube([40, hob_gap-10,20], center=true);
	}
}

module hob_jig_handle()
{
	difference()
	{
	union()
	{
		translate([0, -5, -70])
			cube([15, 15, 70], center=true);
		translate([0, -5, -40])
			cube([15, 35, 15], center=true);
	}
	for(y=[-1,1])
		translate([0, -5+y*12, -50])
			teardrop(h=50,r=screwsize/2,center=true,teardrop_angle=180,truncateMM=0.5);
	}
}

module tie_rods(radius=3/2,teardrop_angle=-1)
{
	for(i=[-1/2,1/2])
		translate([i*clamp_centres,0,-30])
			if(teardrop_angle<0)
				cylinder(h=100, r=radius, center=true,$fn=10);
			else
				teardrop(h=100,r=radius, center=true,    teardrop_angle=teardrop_angle, truncateMM=0.5);

	translate([-clamp_centres/2,0,10])
	teardrop(h=10,r=3.5, center=true,    teardrop_angle=teardrop_angle, truncateMM=0.5);
}


module nozzle_holes(teardrop_angle=-1)
{
	tie_rods(teardrop_angle=teardrop_angle);

	// Filament

	cylinder(h=150, r=1, center=true,$fn=15);
	translate([0, 0, 15])
		cylinder(h=10, r1=1, r2=2, center=true,$fn=15);

}

module fan_holes()
{
	for(y=[-16,16])
	for(z=[-16,16])
		translate([0,y,z])
			rotate([0,90,0])
				cylinder(h=100, r=1.5, center=true,$fn=15);
}

module fan(holes=false)
{
	if(holes)
		fan_holes();
	else
	difference()
	{
		cube([7,40,40], center=true);
		rotate([0,90,0])
			cylinder(h=10, r=17, center=true,$fn=35);
		fan_holes();
	}
}

module accessories(holes=false,  teardrop_angle=270)
{

	// Fan

	translate(fan_position)
		fan();

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



module motor_spacer()
{
		difference()
		{
			cube([nema11_square, 2.5, nema11_square], center = true);
			translate([0, -2.5/2-1, 33])
				cube([50, 5,50], center = true);
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
		
		translate([0, 12,0]+motor_add)
			rotate([-90,0,0])
		 		nema11(body=!holes, slots = -1, counterbore=8);
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
				number_of_teeth = 31, inner_radius = motor_radius-10, outer_radius = motor_radius-7, angle=15);
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
					teardrop(h=bearing_gap+52,r=big_hole,center=true, teardrop_angle=teardrop_angle,truncateMM=0.5);


			translate([0,0,bearing_gap+22])
				if(body)
					translate(bearing_add)
						cylinder(h=6,r=9.5,center=true);
				else
					teardrop(h=6.2,r=10,center=true,teardrop_angle=teardrop_angle,truncateMM=0.5);

			translate([0,0,22])
				if(body)
					translate(-bearing_add)
						cylinder(h=6,r=9.5,center=true);
				else
					teardrop(h=6.2,r=10,center=true,teardrop_angle=teardrop_angle,truncateMM=0.5);
		}	
	}
}

module drive_assembly()
{
	m6_shaft(body=true, big_hole=7.5, teardrop_angle=-1);
	translate(gear_add)
	{
		driven_gear(wingnut=true);
		drive_gear_and_motor();
	}
	translate(bearing_offset - [-3,filament_y_offset,0])
		rotate([90,0,0])
			cylinder(h=4, r=5, center=true, $fn=20);

}

module block_holes(teardrop_angle=-1, lever = false)
{

	translate([-10, 0, 0])
		rotate([90, 0, 0])
		{
			teardrop(h=80, r=screwsize/2,  center=true,  teardrop_angle=teardrop_angle, faces=15);
			translate([0, 0, 31])
				rotate([0,0,30])
					cylinder(h = 20, r = screwsize, center=true, $fn=6);
		}

	translate([10, 0, 0])
		rotate([90, 0, 0])
		{
			teardrop(h=80,r=screwsize/2,  center=true, teardrop_angle=teardrop_angle, faces=15);
			translate([0, 0, 31])
				rotate([0,0,30])
					cylinder(h = 20, r = screwsize, center=true, $fn=6);
		}

	translate([-10, 0, 32])
		rotate([90, 0, 0])
		{
			teardrop(h=80,r=screwsize/2, center=true, teardrop_angle=teardrop_angle, faces=15);
			translate([0, 0, 31])
				rotate([0,0,30])
					cylinder(h = 20, r = screwsize, center=true, $fn=6);
		}

	translate([6, 0, 30])
		rotate([90, 0, 0])
		{
			if(lever)
				teardrop(h=80,r=2, center=true, teardrop_angle=teardrop_angle, faces=15);
			else
				teardrop(h=80,r=screwsize/2, center=true, teardrop_angle=teardrop_angle, faces=15);
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
					cube([36,fixed_block_width,10], center=true);
					translate([-11.5,0,14 + (back_plate_height - 38)/2])
						cube([13,33,back_plate_height], center=true);
					
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
				
				translate(drive_assembly_position-fixed_block_position)
					m6_shaft(body=false,big_hole=4, teardrop_angle=-1);
				translate([-10,0,19])
					rotate([0,-30,0])
						cube([50,20,13], center=true);
				
			}
			translate(back_plate_position-fixed_block_position)
				difference()
				{
					cube([36,fat_plate_thickness,back_plate_height], center=true);
					translate(drive_assembly_position-back_plate_position)
						m6_shaft(body=false,big_hole=7.5,  teardrop_angle=180);
				}

			translate([24.5,20.5,15])
				difference()
				{
					translate([-2,0,0])
						cube([9,8,20], center = true);
					translate([-8,-4,0])
						cube([16,8,30], center = true);
					translate([0,-4/sin(45),0])
						rotate([0,0,45])
							cube([8,8,30], center = true);
				}

			translate([-2,0,back_plate_height-8])
				cube([8,8,6], center = true);
			translate([-2,0,back_plate_height-6])
				cube([7,33,2], center = true);
			translate([-14.5,5,back_plate_height])
				cube([7,10,10], center = true);
				
		}
		nozzle_holes(teardrop_angle=180);
		if(mendel)
		translate([0,26,0])
			rotate([-10,0,0])
				cylinder(h=100,r=4, center=true,$fn=15);
		block_holes(teardrop_angle=180);
		translate(lever_spring_offset-fixed_block_position)
			lever_spring();
	}
}

module duct_split()
{
	translate([-40.11,0,0])
	union()
	{
		cube([45,40,60],center=true);
		translate([21,0,-20])
			rotate([0,0,45])
				cube([5,5,70],center=true);
		translate([21,0,-10])
			rotate([0,45,0])
				cube([5,70,5],center=true);
	}
}

module duct_i()
{	
	difference()
	{
		cube([45,20,50],center=true);
		cube([41,16,46],center=true);
		translate(fixed_block_position-duct_offset)
			nozzle_holes(teardrop_angle=180);
		translate([10,0,9])
			cube([45,40,50],center=true);
		translate([39,0,0])
			cube([45,40,60],center=true);
		translate(drive_assembly_position-duct_offset+[0,-5,0])
			drive_gear_and_motor(gear=false, holes=false);
		translate(fixed_block_position-duct_offset)
			teardrop(h=100, r=5, center=true,teardrop_angle=180, truncateMM=0.5);
	}
}

module duct(split=0)
{
	if(split==1)
		difference()
		{
			duct_i();
			duct_split();
		}
	else if(split==2)
		intersection()
		{
			duct_i();
			duct_split();
		}
	else
		duct_i();
}

module bracket_holes(teardrop_angle=-1)
{
	for(x=[-1,1])
	for(z=[0,1])
	{
		translate([x*12, -30, -4-10*z])
			rotate([90,0,0])
			{
				teardrop(h=40, r=screwsize/2, center=true,teardrop_angle=teardrop_angle, truncateMM=0.5);
				if(teardrop_angle>=0)
					translate([0,0,-6])
						rotate([0, 0, teardrop_angle])
							pentanut(height=20,center=true);
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
	if(huxley)
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
	
			translate(bracket_position-base_position)
				bracket_holes(teardrop_angle=90);
		}
	} else
	{
		union()
		{
			difference()
			{
				union()
				{
					difference()
					{
						cube([36,54,5],center=true);
						translate([0,-20,6])
							rotate([3,0,0])
								cube([40,30,7],center=true);
					}
					translate([0,0,4])
						cube([36,28,9],center=true);
				}
				translate([0,0,10])
				tie_rods();
				cylinder(h=100, r=4, center=true,$fn=30);
				for(i=[-1/2,1/2])
				{
					translate([0,i*46,0])
						cylinder(h=100, r=2, center=true,$fn=10);
					translate([0,i*56,0])
						cube([4,10,100],center=true);
				}
			}
			translate([24.5,0,10])
				difference()
				{
					translate([-2,0,-4])
						cube([9,20,17], center = true);
					translate([-8,0,4])
						cube([16,30,8], center = true);
					translate([-10,0,1.5])
						cube([16,30,18], center = true);
					translate([0,0,4/sin(45)])
						rotate([0,45,0])
							cube([8,30,8], center = true);
				}
		}
	}
}

module bearing_hole()
{

	rotate([90,0,0])
		teardrop(h=100,r=screwsize/2, center=true,   teardrop_angle=180,truncateMM=0.5);
	translate([0,43,0])
		rotate([90,0,0])
			teardrop(h=30,r=screwsize, center=false,   teardrop_angle=180,truncateMM=0.5);
	translate([0,-23,0])
		rotate([90,180,0])
			pentanut(height=20, center=true);	
}


module lever_spring()
{
	rotate([0,90,0])
	union()
	{
		cylinder(h=200, r=2,$fn=10);
		translate([0,0,31])
			cylinder(r=3.5,h=10, center=true, $fn=6);
		translate([0,0,40])
			cylinder(r=4,h=14, center=true, $fn=15);
		translate([0,0,48.5])
			cylinder(r1=4,r2=2,h=3, center=true, $fn=15);
	}
}

module bevel_cube(box)
{
	difference()
	{
		cube(box, center=true);

		translate([0,(box.y-box.x)/2,0])
			rotate([0,0,45])
				translate([0, box.y/2,0])
					cube([2*box.x, box.y, 2*box.z], center=true);

		translate([0,-(box.y-box.x)/2,0])
			rotate([0,0,-45])
				translate([0, -box.y/2,0])
					cube([2*box.x, box.y, 2*box.z], center=true);

		translate([0,0,(box.z-box.x)/2])
			rotate([0,-45,0])
				translate([0, 0, box.z/2])
					cube([2*box.x, 2*box.y, box.z], center=true);
	}
}

module lever()
{



	difference()
	{
	translate([8.5,0,15])
		cube([12,32,40], center=true);

	translate([8.5,-10,36])
		rotate([20,0,0])
			cube([20,32,30], center=true);

	translate([8.5,19,36])
		rotate([60,0,0])
			cube([20,32,30], center=true);


	translate([10,0,-3])
	{
		cube([30,18,20], center=true);
		translate([-3,0,0])
			bevel_cube(box=[15,28,30]);
	}

	translate(fixed_block_position-lever_offset)
		block_holes(teardrop_angle=180, lever=true);

	translate(bearing_offset)
		bearing_hole();

	translate(lever_spring_offset-lever_offset)
		lever_spring();
	}

}

module motor_plate()
{
		difference()
		{
			translate([-motor_plate_extra_x/2, 0, 0])
				cube([36+motor_plate_extra_x,fat_plate_thickness,back_plate_height], center=true);
			translate([-motor_plate_extra_x/2-23,0,-26])
				cube([36,20,20], center=true);
			translate([-motor_plate_extra_x/2-18.5,0,26])
				cube([36,20,20], center=true);
			translate(drive_assembly_position-motor_plate_position)
				m6_shaft(body=false,big_hole=7.5, teardrop_angle=-1);
			translate(drive_assembly_position-motor_plate_position)
				drive_gear_and_motor(gear=false, holes=true);
			translate(fixed_block_position-motor_plate_position)
				block_holes(teardrop_angle=-1);
			translate([0,-26,0]+fixed_block_position-motor_plate_position)
				rotate([10,0,0])
					cylinder(h=100,r=4, center=true,$fn=15);
			translate(motor_plate_clip_position-motor_plate_position)
				motor_plate_clip();
		}

}

module motor_plate_clip()
{
	difference()
	{
		translate([-2,0,0])
		{
			cube([9,8,20], center = true);
			translate([-4,0,0])
				rotate([0,45,0])
					cube([8,8,8], center = true);
		}
		translate([-8,4,0])
			cube([16,8,30], center = true);
		translate([0,4/sin(45),0])
			rotate([0,0,45])
				cube([8,8,30], center = true);
	}
}

//------------------------------------------------------------------

// Uncomment to check hole interference
/*
translate(fixed_block_position)
	block_holes();

translate(idler_position)
	idler_holes();

translate(base_position)
	nozzle_holes();

translate(clamp_position)
	bracket_holes();
*/
//--------------------------------------------------------------------





//--------------------------------------------------------------------

// Uncomment to get entire assembly

translate(fixed_block_position)
	fixed_block();

translate(duct_offset)
	duct();

translate(base_position)
	base_plate();

if(huxley)
	translate(clamp_position)
		belt_clamp();

translate(motor_plate_position)
	motor_plate();

translate(motor_plate_clip_position)
	motor_plate_clip();

translate(spacer_position)
	motor_spacer();

translate(lever_offset)
	lever();

translate(drive_assembly_position)
	drive_assembly();

translate(fan_position)
	fan();

translate(accessories_position)
	accessories();
//-----------------------------------------------------------------




// Individual built items

// For Huxley
//----
//adjustable_bearing(true,-1); // 2 off
//adjustable_bearing(false,-1);
//belt_clamp(); // 2 off
//----

// For all

//hob_jig();
//hob_jig_handle();
//duct(1);
//duct(2);
//fixed_block();
//lever();
//base_plate();
//motor_plate();
//motor_plate_clip();
//motor_spacer();
//drive_gear();
//driven_gear(wingnut=true);
