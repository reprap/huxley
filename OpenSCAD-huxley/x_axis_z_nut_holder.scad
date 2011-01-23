include <parameters.scad>;
use <library.scad>;

clamp_holes=13;

module x_axis_z_nut_holder()
{
	difference()
	{
		cube([20,50,7], center=true);
		cylinder(r=rodsize/1.8, h= rodsize*10, center=true);
		translate([10,0,0])
		cube([20,2*rodsize/1.8,30], center=true);

		translate([0,x_bar_gap/2,7/2])
			rotate([0,90,0])
				cylinder(r=rodsize/2, h= rodsize*10, center=true);

		translate([0,-x_bar_gap/2,7/2])
			rotate([0,90,0])
				cylinder(r=rodsize/2, h= rodsize*10, center=true);

		for(a = [1, -1])
		for(b = [1, -1])
		for(c = [1, -1])
		translate([a*clamp_holes/2,b*x_bar_gap/2+c*clamp_holes/2,0])
				cylinder(r=screwsize/2, h= rodsize*10, center=true, $fn=15);
		translate([0,0,7/2])
			rodnut(position=0,washer=0);
	}
}

x_axis_z_nut_holder();
