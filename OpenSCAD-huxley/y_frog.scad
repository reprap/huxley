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

p0=[0,yl2,0];
p1=[0,-yl2,0];
p2=[xbars,0,0];

p00=p0+[12,-12,0];
p11=p1+[12,12,0];
p22=p2+[-20,0,0] ;

module accesories(holes=false)
{
	// Bearings

	translate(p0)
		rotate([-90,180,180])
			adjustable_bearing(true,holes);

	translate(p1)
		rotate([-90,180,180])
			adjustable_bearing(true,holes);
	
	translate(p2)
		rotate([-90,180,0])
			adjustable_bearing(false,holes);


	if(!holes)
	{
		// Clearance

		//mirror([0,0,1])
			//cube([10,10,20]);

		// Limit switch

		translate([56,-yl2-20,6])
			cube([2,20,2]);

		// Y belt

		translate([28,-100,-5.7-1.5])
			cube([6,200,1.5]);
		translate([28,-100,-5.7-1.5+8.75])
			cube([6,200,1.5]);

		// Y rods

		rotate([90,0,0])
			rod(1.5*ylength,false);
		
		translate([xbars,0,0])
			rotate([90,0,0])
				rod(1.5*ylength,false);
	}
}

module belt_clamp_holes()
{

		translate([-5,0,0])
			cylinder(r=screwsize/2, h=50, center=true, $fn=10);
		translate([5,0,0])
			cylinder(r=screwsize/2, h=50, center=true, $fn=10);
}

module belt_clamp(depth=6, nut=false, holes=false)
{
	if(holes)
		belt_clamp_holes();
	else
		difference()
		{
			cube([16,8,depth], center=true);
			belt_clamp_holes();
		}
}

module y_frog()
{
	translate([0, 0,-14])
	{
		difference()
		{
			union()
			{
				translate([-13, -yl2-10,0])
					cube([xbars+26, ylength+20, 5]);
				strut(p00, p11, 10,10,2);
				strut(p00, p22, 10,10,2);
				strut(p11, p22, 10,10,2);
				translate([xbars/2-6.5, -(ylength +50)/2,-5])
					cube([16, ylength+50, 10]);
				translate([-13, -8,-5])
					cube([30, 16, 10]);
			}


			translate(p0+[0, 20,-25])
				rotate([0,0,-90+theta])
					cube([xbars+26+50, ylength+20+50, 5+50]);
			
			mirror([0,1,0])
				translate(p0+[0, 20,-25])
					rotate([0,0,-90+theta])
						cube([xbars+26+50, ylength+20+50, 5+50]);
			
			accesories(holes=true);
	
			linear_extrude(height = 100, center = true, convexity = 10, twist = 0)
				polygon(points=[[p00.x,p00.y],[p11.x,p11.y],[p22.x,p22.y]]);

			translate([31,-yl2+4,0])
				belt_clamp(depth=6, holes=true);

			translate([31,yl2-4,0])
				belt_clamp(depth=6, holes=true);

			for(i=[-1,1])
			{
				translate([xbars*0.8, i*ylength/2.4,-2.75])
					rotate([0,-90,0])
						teardrop(r=screwsize/2, h = 50, truncateMM=0.5);
	
				translate([xbars*0.8, i*ylength/3.2,-2.75])
					rotate([0,-90,0])
						teardrop(r=screwsize/2, h = 50, truncateMM=0.5);
			}

			translate([-10, 25,-2.75])
				rotate([0,-90,90])
					teardrop(r=screwsize/2, h = 50, truncateMM=0.5);
	
			translate([0, 25,-2.75])
				rotate([0,-90,90])
					teardrop(r=screwsize/2, h = 50, truncateMM=0.5);
			
		}
	}
}



difference()
{
	y_frog();
	translate([-100, 0,-100]) cube([500, 500, 500]);
	translate([xbars/2-6.5+8, -250,-100]) cube([500, 500, 500]);
}

difference()
{
	y_frog();
	mirror([0,1,0])
		translate([-100, 0,-100]) cube([500, 500, 500]);
	translate([xbars/2-6.5+8, -250,-100]) cube([500, 500, 500]);
}

intersection()
{
	y_frog();
	translate([xbars/2-6.5+8, -250,-100]) cube([500, 500, 500]);
}


translate([31,-yl2+4,-2.7])
{
	belt_clamp(depth=6, nut=true, holes=false);
	translate([0,0,-5.5])
		belt_clamp(depth=2, nut = false, holes=false);
}
accesories(false);