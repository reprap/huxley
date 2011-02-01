include <parameters.scad>;
use <library.scad>;

xbars=120;
ylength=86;
d=22;
w=5;

// Triangle values

yl2 = ylength/2;
a = (yl2*yl2 + xbars*xbars)/(2*xbars);
b = xbars - a;
theta = atan(xbars/yl2);


module accesories(holes=false)
{
	for(i=[-1,1])
		translate([0,i*yl2,0])
			rotate([-90,180,180])
				adjustable_bearing(true,holes);
	
	translate([xbars,0,0])
		rotate([-90,180,0])
			adjustable_bearing(false,holes);
	if(!holes)
	{
		rotate([90,0,0])
			rod(1.5*ylength,false);
		
		translate([xbars,0,0])
			rotate([90,0,0])
				rod(1.5*ylength,false);
	}
}

accesories(false);

translate([-13, -yl2-10,-14])
cube([xbars+26, ylength+20, 5]);