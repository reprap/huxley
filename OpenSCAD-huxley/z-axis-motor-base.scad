include <parameters.scad>;
use <library.scad>;

zax= 57;
zay = 84;
zaz=20;

import_stl("../z-leadscrew-base-motor_2.stl", convexity = 7);

//translate([0,0,-10])
//cube([zax,zay,zaz/20]);

/*translate([26,26,0])
rotate([0,0,180])
bearing_holder(radius=9.5);

translate([21.5,57.5,20])
{
	cylinder(r=nema14_hub/1.9,h=zay,center=true);
	nema14();
}*/
color([0.4,0.4,1,1])
{
translate([12,14,0])
	cylinder(r=screwsize/2,h=zay,center=true,$fn=10);
translate([51,14,0])
	cylinder(r=screwsize/2,h=zay,center=true,$fn=10);
translate([51,38,0])
	cylinder(r=screwsize/2,h=zay,center=true,$fn=10); 

translate([1,26,0])
	cylinder(r=rodsize/2,h=zay,center=true,$fn=10); 

translate([44,-10,14])
rotate([0,-90,0])
rotate([-90,0,0])
teardrop(radius=rodsize/2,height=zay*2,truncateMM=0.5);


translate([zax+10,7,6])
rotate([0,-90,0])
teardrop(radius=rodsize/2,height=zay*2,truncateMM=0.5);

translate([zax+10,77,6])
rotate([0,-90,0])
teardrop(radius=rodsize/2,height=zay*2,truncateMM=0.5);

translate([20,20,10])
rotate([0,-90,0])
teardrop(radius=screwsize/2,height=zay*2,truncateMM=0);

translate([20,32,10])
rotate([0,-90,0])
teardrop(radius=screwsize/2,height=zay*2,truncateMM=0);

translate([0,26,10])
cube([2,25,40], center=true);

}