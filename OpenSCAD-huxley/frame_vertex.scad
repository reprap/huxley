

include <parameters.scad>;
use <library.scad>;

module basic_vertex(round = false) 
{
	difference() 
	{
		union() 
		{
			for(side = [1, -1]) 
			{
				rotate([0, 0, side * 30]) translate([0, vertexoffset, 0]) 
				{
					if (round) 
					{
						translate([-side * partthick / 4, 0, 0]) cube([partthick  / 2, partthick, partthick], center = true);
						rotate([0, 90, 0]) cylinder(h = partthick, r = partthick / 2, center = true, $fn = fn);
						rotate([90, 0, 0]) cylinder(h = partthick, r = partthick / 2, center = true, $fn = fn);
					} else 
						cube([partthick, partthick, partthick], center = true);
					translate([side * -rodsize, 0, 0]) 
						cylinder(h = partthick, r = partthick / 2, center = true, $fn = fn);
				}
			}
			translate([0, partthick, 0]) 
				difference() 
				{
					rotate_extrude(convexity = 10, $fn = fn) 
						translate([vertexoffset - partthick * sqrt(3) / 2, 0, 0]) 
						{
							if (round) 
								circle(r = partthick / 2, center = true, $fn = fn);
							else 
								square(size = partthick, center = true);
						}
					for (side = [1, -1]) 
						rotate([0, 0, side * 30])
							 translate([-side * vertexoffset, 0, 0]) 
								cube(vertexoffset * 2, center = true);
				}
		}
		for(side = [1, -1]) 
		{
			rotate([90, 0, side * 30])
				translate([0, 0, -rodsize * 7.5]) 
					rotate([0, 0, -90])
						teardrop(radius = rodsize/2, height = rodsize * 15, truncateMM = 1);//rod(rodsize * 15);
			rotate([0, 0, side * 30]) 
			{
				translate([-side * rodsize, vertexoffset, 0]) 
					rod(partthick * 2);
			}
		}
	}
}

module with_foot_and_shelf(round)
{
	union()
	{
		basic_vertex(round);
		translate([-partthick*2.3, 0.2*partthick, 0.5*(partthick+bearing_mount_centres)]) 
			rotate([0, 0, 60])
			{
				difference()
				{
					translate([0.5*partthick,0,0])
						cube([partthick,partthick/3,2*partthick+bearing_mount_centres], center=true);
					translate([0.5*partthick,0,0.5*partthick])
						hat_cube([screwsize,partthick,2*partthick], center=true);
					//translate([-0.5*partthick,0,0.5*partthick])
						//hat_cube([screwsize,partthick,2*partthick], center=true);
				}
				translate([0.8*partthick,0,-0.5*partthick-bearing_mount_centres/2])
				{
					difference()
					{
						cube([partthick,partthick/1.5,partthick], center=true);
						translate([0, partthick/1.5, 0])
							rotate([0, 0, 10])
								cube([3*partthick,partthick/1.5,partthick], center=true);
						translate([0, -partthick/1.5, 0])
							rotate([0, 0, -10])
								cube([3*partthick,partthick/1.5,partthick], center=true);
					}
				}
			}
		translate([partthick*2.2, 0, 0]) 
			rotate([0, 0, 60])
				cube([partthick,partthick/3,partthick], center=true);
		translate([partthick*1.9, partthick*0.6, 0]) 
			rotate([0, 0, -60])
				cube([1.4*partthick,partthick/3,partthick], center=true);
	}
}

module frame_vertex(round = false, foot = false, left = false) 
{
	color(c)
	if(!foot)
		basic_vertex(round);
	else
	{
		if(left)
			with_foot_and_shelf(round);
		else
			mirror([0,0,1])
				with_foot_and_shelf(round);
	}
}

frame_vertex(round = false, foot = true, left=true);
