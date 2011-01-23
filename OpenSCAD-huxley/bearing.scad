
// Adjustable slide bearings for 6mm diameter rods mounted using M3 cap screws 18 mm apart.

// The profile for these should be CSG from the parameters, but at the moment it's a dxf.

// Adrian Bowyer 18 December 2010

include <parameters.scad>;
use <library.scad>;


//*****************************************************************************************************************

// Make an extrusion from the appropriate profile

module bearingProfile(b360=true)
{
	if(b360)
		linear_extrude(file = str(fileroot, "bearing360.dxf"), layer = "0", height = bearing_width, 
			center = true, convexity = 10, twist = 0, $fn=40);
	else
		linear_extrude(file = str(fileroot, "bearing180.dxf"), layer = "0", height = bearing_width, 
			center = true, convexity = 10, twist = 0, $fn=40);
}

// The distance between the 3mm screw centres is 18 mm

module bearing(b360)
{
	difference()
	{
  		bearingProfile(b360);
		translate([4, -10, 0])rotate(90, [0, 1, 0])
			rotate(-90, [1, 0, 0])
				teardrop(r=1.5, h=50, truncateMM=-1);
		translate([22, -10, 0])rotate(90, [0, 1, 0])
			rotate(-90, [1, 0, 0])
				teardrop(r=1.5, h=50, truncateMM=-1);
	}
}

// true for a 360 degree bearing, false for a 180 one.

//bearing(true);
