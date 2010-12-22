targetresistance = 10;
coppercoverage = 0.7;
boardheight = 8 * 25.4;
boardwidth = 8 * 25.4;
copperthickness = 0.5; // measured in oz
holespacing = 114;
holesize = 3;
holetoedge = 7;
fn = 18;

idealelementcount = sqrt(targetresistance / 0.0005 * copperthickness * (boardheight / boardwidth * coppercoverage));
elementcount = 2 * round(idealelementcount / 2);
traceoffset = boardwidth / elementcount;
tracelength = elementcount * boardheight;
//tracesize = traceoffset * elementcount;
tracesize = tracelength * 0.0005 / targetresistance / copperthickness;
traceisolation = traceoffset - tracesize;
copperthicknessmm = copperthickness * 0.034;
holereroutesize = round((holetoedge + holesize + traceoffset) / boardwidth * elementcount / 2) * 2 + 1;

echo("element count:", elementcount);
echo("trace size (mm):", tracesize);
echo("trace isolation (mm):", traceisolation);
echo("trace size (mil):", tracesize / 0.0254);
echo("trace isolation (mil):", traceisolation / 0.0254);
echo("approximate trace length (mm):", tracelength);
echo("approximate copper coverage (%):", tracesize / traceoffset * 100);
echo("approximate resistance: (ohms)", tracelength / tracesize * 0.0005 / copperthickness);

difference() {
	color([0.2, 0.2, 0.2]) cube([boardwidth, boardheight, 3], center = true);
	//for (side = [1, -1]) for (end = [1, -1]) translate([(boardwidth / 2 - holetoedge) * side, holespacing / 2 * end, 0]) cylinder(r = holesize / 2, h = 4, center = true, $fn = fn);
	//cylinder(r = holesize / 2, h = 4, center = true, $fn = fn);
}

color([0.85, 0.6, 0.3])
for (face = [1, -1])
translate([0, 0, face * 1.5]) union() {
	translate([-traceoffset / 2, -boardheight / 2 + traceoffset / 2, 0]) square([boardwidth - traceisolation - traceoffset, tracesize], center = true);
	for (i = [0:elementcount - 2]) translate([-boardwidth / 2 + (i + 1) * traceoffset, (-boardheight + traceoffset * 2) * (i % 2) + boardheight / 2 - traceoffset / 2, 0]) square([traceoffset + tracesize, tracesize], center = true);
	for (i = [-(elementcount - 1) / 2:(elementcount - 1) / 2]) translate([i * traceoffset, traceoffset / 2, 0]) square([tracesize, boardheight - traceisolation - traceoffset], center = true);
	for (side = [1, -1]) translate([(boardwidth / 2 - traceoffset / 2) * side, -boardheight / 2 + traceoffset, 0]) square([tracesize, traceoffset + tracesize], center = true);
}

*color([0.85, 0.6, 0.3])
for (face = [1, -1])
translate([0, 0, face * 1.5]) difference() {
	square([boardheight, boardwidth], center = true);
	for (side = [1, -1]) {
		for (i = [0:elementcount / 2 - holereroutesize]) translate([i * traceoffset * side, (((elementcount / 2 - i) % 2 == 0) ? 1 : -1) * tracesize / 2 + traceoffset / 2, 0]) square([traceisolation, boardheight - tracesize + 0.01 - traceoffset], center = true);
		for (i = [0:holereroutesize]) translate([(boardwidth / 2 - i * traceoffset) * side, ((i % 2 == 0) ? 1 : -1) * tracesize / 2, 0]) square([traceisolation, holespacing - holesize - traceoffset * 2 + 0.01], center = true);
		for (i = [0:holereroutesize]) translate([(boardwidth / 2 - i * traceoffset) * side, boardheight / 2 - ((boardheight - holespacing) / 2 - holesize / 2 - traceoffset * 1.5 + traceisolation / 2) / 2 - tracesize / 2 + ((i % 2 == 0) ? 1 : -1) * tracesize / 2, 0]) square([traceisolation, (boardheight - holespacing) / 2 - holesize / 2 - traceoffset * 1.5 + traceisolation / 2], center = true);
		for (i = [0:holereroutesize]) translate([(boardwidth / 2 - i * traceoffset) * side, -boardheight / 2 + ((boardheight - holespacing) / 2 - holesize / 2 - traceoffset * 1.5 + traceisolation / 2) / 2 + tracesize / 2 + traceoffset / 2 + ((i % 2 == 0) ? 1 : -1) * tracesize / 2, 0]) square([traceisolation, (boardheight - holespacing) / 2 - holesize / 2 - traceoffset * 1.5 + traceisolation / 2 - traceoffset], center = true);
		for (end = [1, -1]) for(bend = [1, -1]) translate([(boardwidth - holereroutesize * traceoffset + (tracesize + traceisolation / 2) * -bend) / 2 * side, holespacing / 2 * end + (holesize / 2 + traceoffset / 2) * bend, 0]) square([traceoffset * holereroutesize - traceoffset + traceisolation / 2, traceisolation], center = true);
		translate([0, ((boardheight + traceisolation) / 2 - 0.01) * side, 0]) square([boardwidth + traceisolation * 2, traceisolation], center = true);
		translate([((boardheight + traceisolation) / 2 - 0.01) * side, 0, 0]) square([traceisolation, boardwidth + traceisolation * 2], center = true);
		for (end = [1, -1]) translate([(boardwidth / 2 - holetoedge) * side, holespacing / 2 * end, 0]) circle(r = holesize / 2, center = true, $fn = fn);
		//circle(r = holesize / 2 + traceisolation / 2, center = true, $fn = fn);
	}
	translate([0, -boardheight / 2 + tracesize + traceisolation / 2, 0]) square([boardwidth - tracesize * 2, traceisolation], center = true);
	translate([boardwidth / 2 - traceoffset, -boardheight / 2 + traceoffset / 2, 0]) square([traceisolation, traceoffset], center = true);
}