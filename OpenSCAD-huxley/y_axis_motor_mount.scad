include <parameters.scad>;
use <library.scad>;
include<nema14_motor.scad>

module y_axis_motor_mount()
{


	difference()
	{
		translate([0, rodsize, 0])
			cube([vertex_gap+2*rodsize, 17*rodsize, 1.5*rodsize], center = true);
		translate([-vertex_gap/2, 0, 0]) 
			cylinder(h = 3*rodsize, r = rodsize / 2, center = true, $fn = fn);
		translate([vertex_gap/2, 0, 0]) 
			cylinder(h = 3*rodsize, r = rodsize / 2, center = true, $fn = fn);

		translate([0, 7*rodsize, 0])
			rotate([0,0,15])
				cube([2*(vertex_gap+rodsize), 10*rodsize, 3*rodsize], center = true);	
		translate([5.6*rodsize, 6*rodsize, 0])
			rotate([0,0,105])
				cube([2*(vertex_gap+rodsize), 6*rodsize, 3*rodsize], center = true);

		translate([-vertex_gap/2, rodsize/3, 0])
			rotate([0,0,15])
			{
				translate([3*rodsize, 0, 0])
					cylinder(h = 3*rodsize, r = screwsize / 2, center = true, $fn = fn);
				translate([5.5*rodsize, 0, 0])
					cylinder(h = 3*rodsize, r = screwsize / 2, center = true, $fn = fn);
			}
		translate([0,-4*rodsize,-rodsize])
		rotate([180,0,-30])
		{
			nema14();
			cylinder(h = 5*rodsize, r = nema14_hub/1.9, center = true, $fn = fn);
			translate([0,nema14_square*1.05 ,-rodsize])
				cube([2*(vertex_gap+rodsize), 6*rodsize, 3*rodsize], center = true);
			translate([nema14_square*1.05 , 0, -rodsize])
				rotate([0,0,90])
				cube([2*(vertex_gap+rodsize), 6*rodsize, 3*rodsize], center = true);
		
		}
	}
}



y_axis_motor_mount();

