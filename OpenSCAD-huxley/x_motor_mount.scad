
// X motor mount

// Adrian Bowyer 18 December 2010

include <settings.scad>;
include <teardrop.scad>;
include <nema14_motor.scad>;

motor_center_y = 26;
screw_hole_r=screwsize/2;
bar_clamp_x=5;
bar_clamp_y=8;
bar_clamp_x_gap=24;
bearing_y=50;
bearing_x=bar_clamp_x_gap + 10;
hole_land=4;
thickness=5;
bearing_low_z = 5;
bearing_z_gap = 30;
bearing_plate_width = bearing_mount_centres+2*hole_land + 10;
bearing_plate_overlap=0.5;
bearing_plate_support=10;

//*****************************************************************************************************************

module base()
{
	x_size = 2*hole_land + 2*bearing_x;
	y_size = bearing_y + hole_land;
	difference()
	{
		difference()
		{
			translate([-bearing_x - hole_land, 0, -thickness])
				cube([x_size, y_size, 2*thickness]);
			translate([-bar_clamp_x_gap - hole_land, 0, -bearing_x])
				rotate(a = 105, v = [0, 0, 1])
					cube([2*bearing_y ,2*bearing_y , 8*thickness]);
			translate([bar_clamp_x_gap+ hole_land, 0, -4*thickness])
				rotate(a = -15, v = [0, 0, 1])
					cube([2*bearing_y ,2*bearing_y , 8*thickness]);
		}
		difference()
		{
			translate([-x_size-1, -1, 0])
				cube([2+ 2*x_size, y_size+2, 6*thickness]);
			translate([0, motor_center_y, 0])
				rotate(a = 45, v = [0, 0, 1])
					translate([ - nema14_square*0.5,  - nema14_square*0.5, 0])
						cube([nema14_square, nema14_square, 2*thickness]);
		}
	}
}

module oriented_teardrop()
{
	translate([0, -2.5*thickness, 0])
		rotate(a = 90, v = [0, 0, 1])
			rotate(a = 90, v = [0, 1, 0])
				teardrop(screw_hole_r, 4*thickness, true);
}

module bearing_plate()
{
	difference()
	{

		translate([-bearing_plate_width/2, bearing_plate_overlap - thickness, -thickness])
		{
			difference()
			{
				cube([bearing_plate_width, thickness + bearing_plate_support, 
					bearing_low_z + bearing_z_gap + hole_land + thickness]);
				translate([thickness, thickness, 0])
					cube([bearing_plate_width - 2*thickness, 2*thickness + bearing_plate_support, 
						bearing_low_z + bearing_z_gap + hole_land + thickness]);
			}
		}

		for ( y = [0:1] )
		for ( x = [0:1] ) 
		{
			translate([(x-0.5)*bearing_mount_centres, 0, bearing_low_z + y*bearing_z_gap])
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
		translate([bar_clamp_x_gap, bar_clamp_y, 0])
			cylinder(r = screw_hole_r, h = 30, center = true, $fn=10);
		translate([-bearing_x, bearing_y, 0])
			cylinder(r = screw_hole_r, h = 30, center = true, $fn=10);
		translate([bearing_x, bearing_y, 0])
			cylinder(r = screw_hole_r, h = 30, center = true, $fn=10);
		translate([0, motor_center_y, 0])
		union()
		{
	
			cylinder(r = 1+nema14_hub/2, h = 30, center = true, $fn=20);
			rotate(a = 45, v = [0, 0, 1])
				union()
				{
					for ( x = [0:1] ) 
					for ( y = [0:1] )
					{
						translate([(x-0.5)*nema14_screws, (y-0.5)*nema14_screws, 0])
							cylinder(r = screw_hole_r, h = 30, center = true, $fn=10);
					}
				}
		}
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
