
// X idler mount

// Adrian Bowyer 18 December 2010

include <parameters.scad>;
include <nema14_motor.scad>;
use<library.scad>

// Rewrite some values

bearing_y=20;
bearing_plate_overlap=0;

// And define some new ones

bearing_thickness=6;  
bearing_y_offset=6;
screw_hole_r=screwsize/2;


//*****************************************************************************************************************

module base()
{
	x_size = 2*hole_land + 2*bearing_x;
	y_size = bearing_y + hole_land;
	difference()
	{
		translate([-bearing_x - hole_land, 0, -thickness])
			cube([x_size, y_size, thickness]);
		translate([-bar_clamp_x_gap - hole_land, 0, -bearing_x])
			rotate(a = 120, v = [0, 0, 1])
				cube([2*bearing_y ,2*bearing_y , 8*thickness]);
		translate([bar_clamp_x_gap+ hole_land, 0, -4*thickness])
			rotate(a = -30, v = [0, 0, 1])
				cube([2*bearing_y ,2*bearing_y , 8*thickness]);
	}
}

module oriented_teardrop()
{
	translate([0, -2.5*thickness, 0])
		rotate(a = 90, v = [0, 0, 1])
			rotate(a = 90, v = [0, 1, 0])
				teardrop(screw_hole_r, 4*thickness, 0.5);
}

module bearing_plate()
{
	translate([-thickness-bearing_thickness-rodsize/2, -bearing_y_offset, 0])
		rotate(a = 90, v = [0, 0, 1])
			difference()
			{
				translate([-bearing_plate_width/2, bearing_plate_overlap - thickness, -thickness])
				{
					difference()
					{
						cube([bearing_plate_width, thickness + bearing_plate_support, 
							bearing_low_z  + hole_land + thickness]);
						translate([-thickness, thickness, - 5])
							cube([bearing_plate_width, 2*thickness + bearing_plate_support, 
								bearing_low_z + bearing_z_gap + hole_land + thickness + 10]);
						translate([-bearing_plate_width/2, 0, 0])
							cube([bearing_plate_width + 10, bearing_plate_width, 
								bearing_low_z  + hole_land + thickness + 40], center = true);
						translate([0, bearing_plate_width-1.5*thickness, 0])
							cube([2*bearing_plate_width, bearing_plate_width, 
								bearing_low_z  + hole_land + thickness + 40], center = true);
					}
				}
		
				for ( x = [0:1] ) 
				{
					translate([(x-0.5)*bearing_mount_centres, 0, bearing_low_z])
						oriented_teardrop();
				}
			}
}

module cylindrical_z_holes()
{
	union()
	{
		translate([-bar_clamp_x_gap, bar_clamp_y, 0])
			cylinder(r = screw_hole_r, h = 30, center = true, $fn=10);
		translate([0, bar_clamp_y, 0])
			cylinder(r = screw_hole_r, h = 30, center = true, $fn=10);
		translate([bar_clamp_x_gap, bar_clamp_y, 0])
			cylinder(r = screw_hole_r, h = 30, center = true, $fn=10);
		translate([-bearing_x, bearing_y, 0])
			cylinder(r = screw_hole_r, h = 30, center = true, $fn=10);
		translate([bearing_x, bearing_y, 0])
			cylinder(r = screw_hole_r, h = 30, center = true, $fn=10);


	}
}

module x_motor_mount()
{
	union()
	{
		bearing_plate();
		difference()
		{
			base();
			cylindrical_z_holes();
		}
	}
}


x_motor_mount();

//translate([0, motor_center_y, thickness])
//	rotate(a = 45, v = [0, 0, 1])
//		nema14();
