/*
This script generates a teardrop shape at the appropriate angle to prevent overhangs greater than 45 degrees. The angle is in degrees, and is a rotation around the Y axis. You can then rotate around Z to point it in any direction. Rotation around Y or Z will cause the angle to be wrong.
*/

/*module teardrop(radius, length, angle) {
	rotate([0, angle, 0]) union() {
		linear_extrude(height = length, center = true, convexity = radius, twist = 0)
			circle(r = radius, center = true, $fn = 30);
		linear_extrude(height = length, center = true, convexity = radius, twist = 0)
			projection(cut = false) rotate([0, -angle, 0]) translate([0, 0, radius * sin(45) * 1.5]) cylinder(h = radius * sin(45), r1 = radius * sin(45), r2 = 0, center = true, $fn = 30);
	}
		
	//I worked this portion out when a bug was causing the projection above to take FOREVER to calculate. It works as a replacement, and I figured I'd leave it here just in case.
	
		#polygon(points = [[radius * cos(-angle / 2), radius * sin(-angle / 2), 0],[radius * cos(-angle / 2), radius * -sin(-angle / 2), 0],[(sin(-angle - 45) + cos(-angle - 45)) * radius, 0, 0]], paths = [[0, 1, 2]]);
		#polygon(points = [[radius * -cos(-angle / 2), radius * sin(-angle / 2), 0],[radius * -cos(-angle / 2), radius * -sin(-angle / 2), 0],[(sin(-angle - 45) + cos(-angle - 45)) * radius, 0, 0]], paths = [[0, 1, 2]]);
		#polygon(points = [[radius * sin(-angle / 2), radius * cos(-angle / 2), 0],[radius * sin(-angle / 2), radius * -cos(-angle / 2), 0],[(sin(-angle - 45) + cos(-angle - 45)) * radius, 0, 0]], paths = [[0, 1, 2]]);
	
}
*/

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

//translate([0, -15, 0]) teardrop(5, 20, 90);
//translate([0, 0, 0]) teardrop(5, 20, 60);
//translate([0, 15, 0]) teardrop(5, 20, 45);