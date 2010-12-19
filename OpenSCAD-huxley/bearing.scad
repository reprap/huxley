
// Adjustable slide bearings for 6mm diameter rods mounted using M3 cap screws 18 mm apart.

// Adrian Bowyer 18 December 2010

// Set this to 1 for a 360 degree bearing, 0 for a 180 degree one

bearing_360 = 1;

// The location in your file system where the .dxf files are

fileroot="DXF-files/";

//*****************************************************************************************************************

// Make a 7 mm thick extrusion from the appropriate profile

module bearingProfile(b360=true)
{
	if(b360)
		linear_extrude(file = str(fileroot, "bearing360.dxf"), layer = "0", height = 7, 
			center = true, convexity = 10, twist = 0, $fn=40);
	else
		linear_extrude(file = str(fileroot, "bearing180.dxf"), layer = "0", height = 7, 
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

// The distance between the 3mm screw centres is 18 mm

module bearing(b360)
{
	difference()
	{
  		bearingProfile(b360);
		translate([4, -10, 0])rotate(90, [0, 1, 0]) rotate(-90, [1, 0, 0])teardrop(1.5, 50, false);
		translate([22, -10, 0])rotate(90, [0, 1, 0]) rotate(-90, [1, 0, 0])teardrop(1.5, 50, false);
	}
}

bearing(true);
