include <parameters.scad>;
use <library.scad>;

zax= 57;
zay = 84;
zaz=20;

//import_stl("../z-leadscrew-base-motor_2.stl", convexity = 7);

module bearing_and_mount_screw(teardrop=false)
{

				translate([23,26,0])
					rotate([0,0,180])
						bearing_holder(radius=9.5);

				translate([12,14,0])
					if(teardrop)
						rotate([0,0,-90])
							teardrop(r=screwsize/2,h=zay,truncateMM=-1);
					else
						cylinder(r=screwsize/2,h=zay,center=true,$fn=20);
}

module z_axis_motor_base()
{
		difference()
		{
			// Starting block

			cube([zax,zay,zaz]);

			// Holes in it - colour them so we can distinguish them

			color([0.4,0.4,1,1])
			{

// Body cavity

				translate([0,0,-1])
				{
					translate([4,38,-3])
						cube([35,36,15]);
					translate([8,11,0])
						cube([31,30,15]);
					translate([25,15,-5])
						cube([40,50,15]);
				}
				
// Motor holes

				translate([21.5,57.5,20])
					nema14(body=false, counterbore=-1);


				bearing_and_mount_screw(teardrop=false);
				

				
// Vertical M3 screw holes


				translate([46,30,0])
					cylinder(r=screwsize/2,h=zay,center=true,$fn=20);
				translate([46,53,0])
					cylinder(r=screwsize/2,h=zay,center=true,$fn=20); 

// The Z rod notch

				translate([1,26,0])
					cylinder(r=rodsize/2,h=zay,center=true,$fn=20); 
				
// The M6 rod in the triangle frame

				translate([52,-10,14])
					rotate([0,-90,0])
						rotate([-90,0,0])
							teardrop(r=rodsize/2,h=zay*2,truncateMM=0.5);
		
// The M6 strengthening rods that run across
		
				translate([zax+10,6,6])
					rotate([0,-90,0])
						teardrop(r=rodsize/2,h=zay*2,truncateMM=0.5);
				
				translate([zax+10,78,6])
					rotate([0,-90,0])
						teardrop(r=rodsize/2,h=zay*2,truncateMM=0.5);
				
//  Z-rod clamp M3 holes

				translate([20,20,10])
					rotate([0,-90,0])
					{
						teardrop(r=screwsize/2,h=zay*2,truncateMM=0);
						translate([0,0,25])
						pentanut(10);
					}
				
				translate([20,32,10])
					rotate([0,-90,0])
					{
						teardrop(r=screwsize/2,h=zay*2,truncateMM=0);
						translate([0,0,25])
						pentanut(10);
					}
				
// Z clamp notch

				translate([0,26,10])
					cube([2,25,40], center=true);
			}
		}
}


module z_limit_switch_holder()
{
	difference()
	{
		translate([8,4,zaz])
		{
			difference()
			{
				cube([25,15,40]);

				translate([-5,5,5])
					cube([30,15,40]);

				translate([-10, -5, 0])
					rotate([0,7,0])
						cube([20,100,100],center=true);
				translate([35, -5, 0])
					rotate([0,-7,0])
						cube([20,100,100],center=true);

				translate([12.5+limit_switch_centres/2,0,37])
					rotate([90,0,0])
						cylinder(r=limit_switch_hole_diameter/2,h=zay,center=true,$fn=20);
				translate([12.5-limit_switch_centres/2,0,37])
					rotate([90,0,0])
						cylinder(r=limit_switch_hole_diameter/2,h=zay,center=true,$fn=20);
			}
		}
		bearing_and_mount_screw(teardrop=true);
	}
}

z_limit_switch_holder();
//z_axis_motor_base();

