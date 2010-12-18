rodsize = 6;	//threaded/smooth rod diameter in mm
xaxis = 182.5;	//width of base in mm
yaxis = 266.5;	//length of base in mm


screwsize = 3;	//bearing bore/screw diameter in mm
bearingsize = 10;	//outer diameter of bearings in mm
bearingwidth = 4;	//width of bearings in mm


rodpitch = rodsize / 6;
rodnutsize = 0.8 * rodsize;
rodnutdiameter = 1.9 * rodsize;
rodwashersize = 0.2 * rodsize;
rodwasherdiameter = 2 * rodsize;
screwpitch = screwsize / 6;
nutsize = 0.8 * screwsize;
nutdiameter = 1.9 * screwsize;
washersize = 0.2 * screwsize;
washerdiameter = 2 * screwsize;
partthick = 2 * rodsize;
vertexrodspace = 2 * rodsize;


c = [0.3, 0.3, 0.3];
rodendoffset = rodnutsize + rodwashersize * 2 + partthick / 2;
vertexoffset = vertexrodspace + rodendoffset;


renderrodthreads = false;
renderscrewthreads = false;
fn = 36;
