/*
This script generates a teardrop shape at the appropriate angle to prevent overhangs greater than 45 degrees. The angle is in degrees, and is a rotation around the Y axis. You can then rotate around Z to point it in any direction. Rotation around Y or Z will cause the angle to be wrong.
*/

module teardrop(radius, length, angle) {
	rotate([0, angle, 0]) union() {
		linear_extrude(height = length, center = true, convexity = radius, twist = 0)
			circle(r = radius, center = true, $fn = 30);
		linear_extrude(height = length, center = true, convexity = radius, twist = 0)
			projection(cut = false) rotate([0, -angle, 0]) translate([0, 0, radius * sin(45) * 1.5]) cylinder(h = radius * sin(45), r1 = radius * sin(45), r2 = 0, center = true, $fn = 30);
	}
		
	//I worked this portion out when a bug was causing the projection above to take FOREVER to calculate. It works as a replacement, and I figured I'd leave it here just in case.
	/*
		#polygon(points = [[radius * cos(-angle / 2), radius * sin(-angle / 2), 0],[radius * cos(-angle / 2), radius * -sin(-angle / 2), 0],[(sin(-angle - 45) + cos(-angle - 45)) * radius, 0, 0]], paths = [[0, 1, 2]]);
		#polygon(points = [[radius * -cos(-angle / 2), radius * sin(-angle / 2), 0],[radius * -cos(-angle / 2), radius * -sin(-angle / 2), 0],[(sin(-angle - 45) + cos(-angle - 45)) * radius, 0, 0]], paths = [[0, 1, 2]]);
		#polygon(points = [[radius * sin(-angle / 2), radius * cos(-angle / 2), 0],[radius * sin(-angle / 2), radius * -cos(-angle / 2), 0],[(sin(-angle - 45) + cos(-angle - 45)) * radius, 0, 0]], paths = [[0, 1, 2]]);
	*/
}

translate([0, -15, 0]) teardrop(5, 20, 90);
translate([0, 0, 0]) teardrop(5, 20, 60);
translate([0, 15, 0]) teardrop(5, 20, 45);