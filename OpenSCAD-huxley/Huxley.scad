/*rodsize = 6;	//threaded/smooth rod diameter in mm
xaxis = 182.5;	//width of base in mm
yaxis = 266.5;	//length of base in mm

screwsize = 3;	//bearing bore/screw diameter in mm
bearingsize = 10;	//outer diameter of bearings in mm
bearingwidth = 4;	//width of bearings in mm

rodnutsize = 0.8 * rodsize;
rodwashersize = 0.2 * rodsize;
nutsize = 0.8 * screwsize;
washersize = 0.2 * screwsize;
partthick = 2 * rodsize;
vertexrodspace = 2 * rodsize;

c = [0.3, 0.3, 0.3];
rodendoffset = rodnutsize + rodwashersize * 2 + partthick / 2;
vertexoffset = vertexrodspace + rodendoffset;

renderrodthreads = false;
renderscrewthreads = false;
fn = 36;*/

include <settings.scad>;
use <hardware.scad>;
use <frame_vertex.scad>;
use <z_base.scad>;
use <z_top.scad>;
use <y_bar_clamp.scad>;
use <carriage.scad>;
use <x_z_interface.scad>;


*%rotate([0, 0, -90]) translate([-125.93, -197.8, -158.3]) import_stl("mini-mendel-full.stl", convexity = 5);

for (side = [1, -1]){
	for (angle = [0, 120, -120]) rotate([angle, 0, 0]) {
		translate([side * (xaxis / 2 - rodendoffset), 0, -0.5 * yaxis / sqrt(3)]) rotate([90, 0, 0]) {
			rod(yaxis - vertexrodspace * 2, true);
			translate([0, 0, yaxis / 2]) rotate([-90, 30, -90]) frame_vertex();
			for (end = [1, -1]) {
				rodnut(end * (yaxis / 2 - vertexoffset + partthick / 2 + rodnutsize / 2 + rodwashersize), 1);
				rodnut(end * (yaxis / 2 - vertexoffset - partthick / 2 - rodnutsize / 2 - rodwashersize), 2);
			}
		}
		translate([0, (yaxis / 2 - vertexoffset) * side, -yaxis / 2 / sqrt(3) - 1 * rodsize]) rotate([0, 90, 0]) {
			if (angle / side == 120) {
				rod(xaxis + (partthick + rodsize) * 4 - partthick, true);
				for (end = [1, -1]) {
					rodnut(end * ((xaxis + (partthick + rodsize) * 4 - partthick) / 2 - rodendoffset + (partthick / 2 + rodnutsize / 2 + rodwashersize)), 1);
					rodnut(end * ((xaxis + (partthick + rodsize) * 4 - partthick) / 2 - rodendoffset - (partthick / 2 + rodnutsize / 2 + rodwashersize)), 2);
				}
			}
			else rod(xaxis, true);
			for (end = [1, -1]) {
				if (angle / side == -120) rodnut(end * (xaxis / 2 - rodsize / 2 - rodnutsize * 2 - 2 * rodwashersize * 1.5 - partthick * 2), 2);
				rodnut(end * (xaxis / 2 - rodendoffset + partthick / 2 + rodnutsize / 2 + rodwashersize), 1);
				rodnut(end * (xaxis / 2 - rodendoffset - partthick / 2 - rodnutsize / 2 - rodwashersize), 2);
			}
		}
	}
	translate([side * (xaxis / 2 - rodsize / 2 - rodnutsize * 1.5 - 2 * rodwashersize - partthick * 1.5), 0, -(yaxis / 2) * sqrt(3) / 3 + vertexoffset * sqrt(3) / 2]) {
		translate([0, 0, -rodsize / 2]) {
			rotate([90, 0, 0]) {
				rod(yaxis);
				carriage(100, -side);
			}
			for (end = [1, -1]) translate([0, end * (yaxis / 2 - vertexoffset / 2 + rodsize * sqrt(3) / 2), rodsize]) rotate([0, 0, ((end > 0) ? 0 : 180)]) y_bar_clamp();
		}
	}
	rotate([0, 0, 90]) scale([1, side, 1]) {
		translate([0, xaxis / 2 - rodnutsize - rodwashersize * 2 + rodsize, 0]) {
			translate([0, partthick + rodsize, yaxis * sqrt(3) / 3 - vertexoffset * sqrt(3) / 2 + rodsize / 2]) z_top();
			translate([0, 0, -(yaxis / 2) / sqrt(3)]) z_base();
			translate([0, 0, yaxis / 2 * (sqrt(3) / 2 - 1 / sqrt(3)) - partthick]) {
				rod(yaxis * sqrt(3) / 2, true);
				rotate([0, 0, -90]) leadscrewnut(side);
			}
			translate([0, partthick + rodsize, yaxis / 2 * (sqrt(3) / 2 - 1 / sqrt(3)) - partthick]) {
				rod(yaxis * sqrt(3) / 2);
				//rotate([0, 0, side * 90]) carriage(0, side);
			}
		}
		translate ([side * (rodsize + partthick), 0, yaxis / 2 * (sqrt(3) / 2 - 1 / sqrt(3)) - partthick]) rotate([90, 0, 0]) {
			rod(xaxis + (partthick + rodsize) * 4 - partthick);
			carriage(0, side);
		}
	}
}
translate([0, (partthick + rodsize)  / 2, -yaxis / 2 / sqrt(3) - rodsize]) rotate([0, 90, 0]) {
	rod(xaxis + (partthick + rodsize) * 4 - partthick, true);
	for (end = [1, -1]) {
		rodnut(end * ((xaxis + (partthick + rodsize) * 4 - partthick) / 2 - rodendoffset + (partthick / 2 + rodnutsize / 2 + rodwashersize)), 1);
		rodnut(end * (xaxis / 2 - rodendoffset - partthick / 2 - rodnutsize / 2 - rodwashersize), 2);
			}
}