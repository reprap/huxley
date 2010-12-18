
// X motor mount

// Adrian Bowyer 18 December 2010

// The location in your file system where the .dxf files are

fileroot="DXF-files/";

motor_center_x = 28;
motor_center_y = 26;
motor_square = 35;

//*****************************************************************************************************************

// Make a 10 mm thick extrusion from the appropriate profile

module x_motor_mount_profile()
{
	linear_extrude(file = str(fileroot, "x-motor-mount.dxf"), layer = "0", height = 10, 
		center = true, convexity = 10, twist = 0, $fn=40);
}


// I stole this function from Erik...

module teardrop(radius,height,truncated)
{
	truncateMM = 1;
	union()
	{
		if(truncated == true)
		{
			intersection()
			{
				translate([0,0,height/2]) scale([1,1,height]) rotate([0,0,180]) cube([radius*2.5,radius*2,1],center=true);
				scale([1,1,height]) rotate([0,0,3*45]) cube([radius,radius,1]);
			}
		}
		if(truncated == false)
		{
			scale([1,1,height]) rotate([0,0,3*45]) cube([radius,radius,1]);
		}
		cylinder(r=radius, h = height, $fn=20);
	}
}

difference()
{
	x_motor_mount_profile();
	difference()
	{
		translate([-20, -20, 0])
			cube([140,140,30]);
		translate([motor_center_x, motor_center_y, 0])
			rotate(a = 45, v = [0, 0, 1])
				translate([ - motor_square*0.5,  - motor_square*0.5, 0])
					cube([motor_square,motor_square,10]);
	}
}

//difference()
//{
//  	bearingProfile();
//	translate([4, -10, 0])rotate(90, [0, 1, 0]) rotate(-90, [1, 0, 0])teardrop(1.5, 50, false);
//	translate([22, -10, 0])rotate(90, [0, 1, 0]) rotate(-90, [1, 0, 0])teardrop(1.5, 50, false);
//}
