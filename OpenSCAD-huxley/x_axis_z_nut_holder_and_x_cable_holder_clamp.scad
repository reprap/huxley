include <parameters.scad>;
use <library.scad>;

clamp_holes=13;

module x_axis_z_nut_holder()
{
	difference()
	{
		cube([20,50,7], center=true);
		cylinder(r=rodsize/1.8, h= rodsize*10, center=true, $fn=20);
		translate([10,0,0])
			cube([20,2*rodsize/1.8,30], center=true);

		for(a = [1, -1])
		{
			translate([0,a*x_bar_gap/2,7/2])
				rotate([0,90,0])
					cylinder(r=rodsize/2, h= rodsize*10, center=true, $fn=20);

			for(b = [1, -1])
			for(c = [1, -1])
			translate([a*clamp_holes/2,b*x_bar_gap/2+c*clamp_holes/2,0])
					cylinder(r=screwsize/2, h= rodsize*10, center=true, $fn=15);
		}
		translate([0,0,7/2-0.2])
			cylinder(r=rodsize, h= 5, center=true, $fn=6);
	}
}


module x_cable_support_clamp()
{

	difference()
	{
		cube([20,20,6],center=true);

		for(a = [1, -1])
		{

			for(b = [1, -1])
			translate([a*clamp_holes/2,b*clamp_holes/2,-5*rodsize])
					rotate([0,0,90])
						cylinder(r=screwsize/2, h= rodsize*20, center=true, $fn=15);
		}

		translate([3,0,1.7])
		rotate([0,90,0])
			cylinder(r=1.5, h= 20, center=true, $fn=15);
		translate([3,0,4.7])
			cube([20, 3, 6], center=true);

	}

}

x_axis_z_nut_holder();

translate([0,15,-15])
	x_cable_support_clamp();