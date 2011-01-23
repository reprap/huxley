include <parameters.scad>;
use <library.scad>;



module belt_bearing_holes(teardrop=false)
{
		translate([-vertex_gap/2, rodsize/3, 0])
			rotate([0,0,15])
			{
				translate([3*rodsize, 0, 0])
					if(teardrop)
						rotate([0,0,135])
							teardrop(r = screwsize / 2, h = 20*rodsize,  truncateMM=0.5);
					else
						cylinder(h = 20*rodsize, r = screwsize / 2, center = true, $fn = fn);
				translate([5.5*rodsize, 0, 0])
					if(teardrop)
						rotate([0,0,135])
							teardrop(r = screwsize / 2, h = 20*rodsize,  truncateMM=0.5);
					else
						cylinder(h = 20*rodsize, r = screwsize / 2, center = true, $fn = fn);
			}
}

module y_axis_motor_mount()
{
	difference()
	{
		translate([0, rodsize, 0])
			cube([vertex_gap+2*rodsize, 18*rodsize, 1.916666*rodsize], center = true);

                   // Mounting slots

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
			
		// Belt bearing end

		translate([0, 7*rodsize, 0])
			rotate([0,0,15])
				cube([2*(vertex_gap+rodsize), 10*rodsize, 3*rodsize], center = true);	
		translate([5.6*rodsize, 6*rodsize, 0])
			rotate([0,0,105])
				cube([2*(vertex_gap+rodsize), 6*rodsize, 3*rodsize], center = true);


		belt_bearing_holes(teardrop=false);

		// Motor mount

		translate([0,-4*rodsize,rodsize])
		{
			rotate([180,0,-30])
			{
				mirror([0,0,1])
					nema14(body=false, counterbore = 8);
				translate([0,nema14_square*1.05 ,-rodsize])
					cube([2*(vertex_gap+rodsize), 6*rodsize, 6*rodsize], center = true);
				translate([nema14_square*1.05 , 0, -rodsize])
					rotate([0,0,90])
						cube([2*(vertex_gap+rodsize), 6*rodsize, 6*rodsize], center = true);
			}
		}
	}
}

module y_limit_switch_mount(z_offset = 0)
{
	difference()
	{
		translate([6,10,2.5+ z_offset + 0.5*1.916666*rodsize])
			rotate([0,0,-30])
			{
				difference()
				{
					union()
					{
						cube([20, 22, 5], center = true);
						translate([-4,1.5,10])
							cube([12, 5, 20], center = true);
						translate([-7.5,5,10])
							cube([5, 12, 20], center = true);
					}
					translate([0,8,7])
						rotate([0,90,0])
							cylinder(h = 20*rodsize, r = limit_switch_hole_diameter/2, center = true, $fn = fn);
					translate([0,8,7+limit_switch_centres])
						rotate([0,90,0])
							cylinder(h = 20*rodsize, r = limit_switch_hole_diameter/2, center = true, $fn = fn);
				}
		
			}
		translate([-6,-10,2.5 + z_offset + 0.5*1.916666*rodsize])
			rotate([0,0,15])
				cube([60, 20, 25], center = true);
		belt_bearing_holes(teardrop=true);
	}
}

y_limit_switch_mount();
y_axis_motor_mount();

