include <parameters.scad>;


// inner and outer product.  Why aren't these standard?!!!?

function ip(v1 = [0,0,0], v2 = [0,0,0]) = v1.x*v2.x + v1.y*v2.y + v1.z*v2.z;

function op(v1 = [0,0,0], v2 = [0,0,0]) = [v1.y*v2.z - v1.z*v2.y, v1.z*v2.x - v1.x*v2.z, v1.x*v2.y - v1.y*v2.x];


// Make a RepRap teardrop with its axis along Z
// If truncated is true, chop the apex; if not, come to a point

// I stole this function from Erik...


module teardrop(radius, height, truncateMM)
{
	union()
	{
		if(truncateMM > 0)
		{
			intersection()
			{
				translate([truncateMM,0,height/2]) 
					scale([1,1,height])
						cube([radius*2.8275,radius*2,1],center=true);
				scale([1,1,height]) 
						rotate([0,0,3*45])
							cube([radius,radius,1]);
			}
		} else
		{
			scale([1,1,height])
				rotate([0,0,3*45])
					cube([radius,radius,1]);
		}
		cylinder(r=radius, h = height, $fn=20);
	}
}

// Make a cuboid with a 45 degree top for vertical slots etc

module cen_hat(size)
{
	translate([0, 0, size.x/sqrt(2)])
		union()
		{
			rotate([0, 45, 0])
				cube([size.x, size.y, 5*max(size.x, max(size.y, size.z))], center=true);
			rotate([0, -45, 0])
				cube([size.x, size.y, 5*max(size.x, max(size.y, size.z))], center=true);
		}
}

module hat_cube(size = [1,1,1], center = false)
{
	difference()
	{
		cube(size, center);
		if(center)
			translate([0, 0, size.z/2])
				cen_hat(size);
		else
			translate([size.x/2, size.y/2, size.z])
				cen_hat(size);
	}
}



module rod(length, threaded) if (threaded && renderrodthreads) {
	linear_extrude(height = length, center = true, convexity = 10, twist = -360 * length / rodpitch, $fn = fn)
		translate([rodsize * 0.1 / 2, 0, 0])
			circle(r = rodsize * 0.9 / 2, $fn = fn);
} else cylinder(h = length, r = rodsize / 2, center = true, $fn = fn);


module rodnut(position, washer) render() translate([0, 0, position]) {
	intersection() {
		scale([1, 1, 0.5]) sphere(r = 1.05 * rodsize, center = true);
		difference() {
			cylinder (h = rodnutsize, r = rodnutdiameter / 2, center = true, $fn = 6);
			rod(rodnutsize + 0.1);
		}
	}
	if (washer == 1 || washer == 4) rodwasher(((position > 0) ? -1 : 1) * (rodnutsize + rodwashersize) / 2);
	if (washer == 2 || washer == 4) rodwasher(((position > 0) ? 1 : -1) * (rodnutsize + rodwashersize) / 2);
}


module rodwasher(position) render() translate ([0, 0, position]) difference() {
	cylinder(r = rodwasherdiameter / 2, h = rodwashersize, center = true, $fn = fn);
	rod(rodwashersize + 0.1);
}


module screw(length, nutpos, washer, bearingpos = -1) union(){
	translate([0, 0, -length / 2]) if (renderscrewthreads) {
		linear_extrude(height = length, center = true, convexity = 10, twist = -360 * length / screwpitch, $fn = fn)
			translate([screwsize * 0.1 / 2, 0, 0])
				circle(r = screwsize * 0.9 / 2, $fn = fn);
	} else cylinder(h = length, r = screwsize / 2, center = true, $fn = fn);
	render() difference() {
		translate([0, 0, screwsize / 2]) cylinder(h = screwsize, r = screwsize, center = true, $fn = fn);
		translate([0, 0, screwsize]) cylinder(h = screwsize, r = screwsize / 2, center = true, $fn = 6);
	}
	if (washer > 0 && nutpos > 0) {
		washer(nutpos);
		nut(nutpos + washersize);
	} else if (nutpos > 0) nut(nutpos);
	if (bearingpos >= 0) bearing(bearingpos);
}


module bearing(position) render() translate([0, 0, -position - bearingwidth / 2]) union() {
	difference() {
		cylinder(h = bearingwidth, r = bearingsize / 2, center = true, $fn = fn);
		cylinder(h = bearingwidth * 2, r = bearingsize / 2 - 1, center = true, $fn = fn);
	}
	difference() {
		cylinder(h = bearingwidth - 0.5, r = bearingsize / 2 - 0.5, center = true, $fn = fn);
		cylinder(h = bearingwidth * 2, r = screwsize / 2 + 0.5, center = true, $fn = fn);
	}
	difference() {
		cylinder(h = bearingwidth, r = screwsize / 2 + 1, center = true, $fn = fn);
		cylinder(h = bearingwidth + 0.1, r = screwsize / 2, center = true, $fn = fn);
	}
}


module nut(position, washer) render() translate([0, 0, -position - nutsize / 2]) {
	intersection() {
		scale([1, 1, 0.5]) sphere(r = 1.05 * screwsize, center = true);
		difference() {
			cylinder (h = nutsize, r = nutdiameter / 2, center = true, $fn = 6);
			cylinder(r = screwsize / 2, h = nutsize + 0.1, center = true, $fn = fn);
		}
	}
	if (washer > 0) washer(0);
}


module washer(position) render() translate ([0, 0, -position - washersize / 2]) difference() {
	cylinder(r = washerdiameter / 2, h = washersize, center = true, $fn = fn);
	cylinder(r = screwsize / 2, h = washersize + 0.1, center = true, $fn = fn);
}


//rod(20);
//translate([rodsize * 2.5, 0, 0]) rod(20, true);
//translate([rodsize * 5, 0, 0]) screw(10, true);
//translate([rodsize * 7.5, 0, 0]) bearing();
//translate([rodsize * 10, 0, 0]) rodnut();
//translate([rodsize * 12.5, 0, 0]) rodwasher();
//translate([rodsize * 15, 0, 0]) nut();
//translate([rodsize * 17.5, 0, 0]) washer();

//hat_cube(size=[2,40,2], center=false);
