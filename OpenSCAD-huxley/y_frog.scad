include <parameters.scad>;
use <library.scad>;

xbars=120;
ylength=86;
d=22;
w=5;

difference()
{
	union()
	{
		strut(p1=[0,-ylength/2,0], p2=[0,ylength/2 , 0], wide=w, deep=d, round=2);
		strut(p1=[0,-ylength/2,0], p2=[xbars, 0, 0], wide=w, deep=d, round=2);
		strut(p1=[0,ylength/2,0], p2=[xbars,0 , 0], wide=w, deep=d, round=2);
		translate([0,0,-w])
		{
			strut(p1=[0,-ylength/2,0], p2=[0,ylength/2 , 0], wide=2*w + 1, deep=w, round=2);
			strut(p1=[0,-ylength/2,0], p2=[xbars, 0, 0], wide=2*w + 1, deep=w, round=2);
			strut(p1=[0,ylength/2,0], p2=[xbars,0 , 0], wide=2*w + 1, deep=w, round=2);
		}
	
	}

	translate([])
		cylinder(r=screwsize/2,h=2*d, center=true