include <parameters.scad>;
use <library.scad>;

zax= 57;
zay = 84;
zaz=20;

//import_stl("../z-leadscrew-base-motor_2.stl", convexity = 7);


module z_axis_motor_base()
{
	mirror([0,0,1])
		difference()
		{
			// Starting block

			cube([zax,zay,zaz]);

			// Holes in it - colour them so we can distinguish them

			color([0.4,0.4,1,1])
			{

// Body cavity

				//translate([-6,45,-40])
					//cube([35,50,130]);
				translate([8,11,-16])
					cube([31,30,30]);
				//translate([39,44,-16])
					//cube([12,30,30]);
				//translate([39,20,-16])
					//cube([12,13,30]);
				translate([10,15,-6])
					cube([70,58,15]);

// The adjuster slot

				translate([37,43,-40])
					rotate([0,0,45])
						cube([3.5,35,130]);
				
				
// The bearing holder

				translate([26,26,0])
					rotate([0,0,180])
						bearing_holder(radius=9.5);
				
// Vertical M3 screw holes

				//translate([12,14,0])
					//cylinder(r=screwsize/2,h=zay,center=true,$fn=20);
				translate([51,30,0])
					cylinder(r=screwsize/2,h=zay,center=true,$fn=20);
				translate([51,53,0])
					cylinder(r=screwsize/2,h=zay,center=true,$fn=20); 

// The Z rod notch

				translate([1,26,0])
					cylinder(r=rodsize/2,h=zay,center=true,$fn=20); 
				
// The M6 rod in the triangle frame

				translate([44,-10,14])
					rotate([0,-90,0])
						rotate([-90,0,0])
							teardrop(radius=rodsize/2,height=zay*2,truncateMM=0.5);
		
// The M6 strengthening rods that run across
		
				translate([zax+10,6,6])
					rotate([0,-90,0])
						teardrop(radius=rodsize/2,height=zay*2,truncateMM=0.5);
				
				translate([zax+10,78,6])
					rotate([0,-90,0])
						teardrop(radius=rodsize/2,height=zay*2,truncateMM=0.5);
				
//  Z-rod clamp M3 holes

				translate([20,20,10])
					rotate([0,-90,0])
					{
						teardrop(radius=screwsize/2,height=zay*2,truncateMM=0);
						translate([0,0,25])
						pentanut(10);
					}
				
				translate([20,32,10])
					rotate([0,-90,0])
					{
						teardrop(radius=screwsize/2,height=zay*2,truncateMM=0);
						translate([0,0,25])
						pentanut(10);
					}
				
// Z clamp notch

				translate([0,26,10])
					cube([2,25,40], center=true);
			}
		}
}

z_axis_motor_base();