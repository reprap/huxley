include <parameters.scad>;
use <library.scad>;

module y_idler()
{


	difference()
	{
		translate([0, rodsize, 0])
			cube([vertex_gap+2*rodsize, 4*rodsize, 1.5*rodsize], center = true);

		translate([-vertex_gap/2, 0, 0]) 
			union()
			{
				cylinder(h = 3*rodsize, r = rodsize / 2, center = true, $fn = fn);
				translate([-rodsize, 0, 0]) 
					cube([2*rodsize, rodsize, 3*rodsize], center=true);
			}
			
		translate([vertex_gap/2, 0, 0]) 
			union()
			{
				cylinder(h = 3*rodsize, r = rodsize / 2, center = true, $fn = fn);
				translate([rodsize, 0, 0]) 
					cube([2*rodsize, rodsize, 3*rodsize], center=true);
			}
			

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
	}
}

y_idler();

