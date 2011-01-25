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

stretch=1.5;
halfwidth=12;

module z_height_adjuster()
{
	difference()
	{
		union()
		{
			union()
			{
				strut(p1=[-halfwidth,0,0], p2=[-10,0,stretch*halfwidth],  wide = 3, deep = 8);
				strut(p1=[halfwidth,0,0], p2=[10,0,stretch*halfwidth],  wide = 3, deep = 8);
				strut(p1=[-halfwidth,0,0], p2=[0,0,-stretch*halfwidth],  wide = 3, deep = 8);
				strut(p1=[halfwidth,0,0], p2=[0,0,-stretch*halfwidth],  wide = 3, deep = 8);
			}
			translate([halfwidth,0,0])
				cube([5,8,8],center=true);
	
			translate([-halfwidth,0,0])
				cube([5,8,8],center=true);

			translate([0,-6,stretch*halfwidth])
			{
				difference()
				{
					cube([25,20,5],center=true);
					for(a = [1, -1])
					for(b = [1, -1])
					translate([a*clamp_holes/2,b*clamp_holes/2,-5*rodsize])
							rotate([0,0,90])
								teardrop(r=screwsize/2, h= rodsize*10, truncateMM=-1);

				}
			}
	
			translate([0,0,-stretch*halfwidth])
				cube([10,8,5],center=true);
		}
		rotate([90,0,0])
			rotate([0,90,0])
			{
				translate([0,0,-50])
					teardrop(r=screwsize/2,h=100,truncateMM=-1);
				translate([0,0,halfwidth+20])
					pentanut(height=10);
			}
	}
}

x_axis_z_nut_holder();

translate([0,20,-stretch*halfwidth-15])
z_height_adjuster();