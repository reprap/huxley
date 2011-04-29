include <parameters.scad>;
use <library.scad>;

module cylinder_clamp(hole_offset = 8, c_screw = 3, clamped = 6, thickness = 8, screw_gap = 0)
{
	difference()
	{
		union()
		{
			translate([-(hole_offset+c_screw/2+2)/2,0,0])
				cube([hole_offset+c_screw/2+2, clamped+4, thickness], center=true);
			cylinder(h=thickness, r = clamped/2+2, center=true, $fn=20);
		}
		
		translate([-(hole_offset+c_screw/2+2)/2,0,0])
			cube([(hole_offset+c_screw/2+2)+1, clamped*0.75, thickness+1], center=true);
		cylinder(h=thickness, r = clamped/2, center=true, $fn=20);
		if(screw_gap==0)
		{
			translate([-hole_offset,0,0])
				rotate([90,0,0])
					teardrop(h=2*thickness, r =c_screw/2, center=true, teardrop_angle=270, truncateMM=0.5);
		} else
		{
			for(z=[-1,1])
				translate([-hole_offset,0,z*screw_gap/2])
					rotate([90,0,0])
						teardrop(h=2*thickness, r =c_screw/2, center=true, teardrop_angle=270, truncateMM=0.5);
		}
	}
}


// For Sanguinololu:

//cylinder_clamp(hole_offset = 8, c_screw = 3, clamped = 6, thickness = 8, screw_gap = 0); // 2 off
//cylinder_clamp(hole_offset = 16, c_screw = 3, clamped = 6, thickness = 8, screw_gap = 0); // 1 off

// For X cable holder on the z_top_clamp

cylinder_clamp(hole_offset = 5, c_screw = 3, clamped = 3, thickness = rodsize+3*screwsize, screw_gap = rodsize+screwsize);