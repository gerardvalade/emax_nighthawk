// EMAX nighthawk accessories  - a OpenSCAD 
// Copyright (C) 2016  Gerard Valade

// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.

// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.

// You should have received a copy of the GNU General Public License
// along with this program.  If not, see <http://www.gnu.org/licenses/>.

$fn=30;


M3_dia = 3.6;
M3_hole = 2.5;
M3_hexa = 5.4+0.4;
M3_head_hole = 5.4+0.7;

module hexaprismx(
	ri =  1.0,  // radius of inscribed circle
	h  =  1.0)  // height of hexaprism
{ // -----------------------------------------------

	ra = ri*2/sqrt(3);
	cylinder(r = ra, h=h, $fn=6, center=false);
}



xt60_length = 10;//21;
xt60_width = 27;
xt60_heigth = 11;

function xt60_length() = xt60_length;
function xt60_width() = xt60_width;
function xt60_heigth() = xt60_heigth;


module xt60_footprint(cut=4)
{
	hh = 8.5;
	difference() {
		union() {
			translate([0, 0, hh/2-0.05]) cube([xt60_length+0.05, 16.2, hh], center=true);
			//translate([-16 + 0.02, 0, -2.2+4]) cube([16, 15.2, 11.5], center=true);
		}
		//translate([0, 8.1+1, hh/2+4]) rotate([45, 0, 0]) cube([xt60_length-4.5,cut,cut], center=true);
		translate([(xt60_length-8)/2 , 0, hh-0.8/2]) cube([3.5, 7, 0.4], center=true);
	}
}
	

module xt60_screw_hole(dia=2.2, h=10, $fn=20)
{
	for(x=[0]) for(y=[1, -1]) translate([x*8, y*12, 0]) {
		cylinder(d=dia, h=h, center=true);
	}	
}

module xt60_bracket()
{
	module plain()
	{
		translate([0,0,(xt60_heigth)/2])  cube([xt60_length, xt60_width, xt60_heigth], center=true);
		translate([0,0,(xt60_heigth)/2]) xt60_screw_hole(dia=M3_head_hole+3, h=xt60_heigth);
	}
	module hole()
	{
		translate([0, 0, 0]) {
			xt60_footprint();
		}
	}

	translate([0, 0, xt60_heigth]) rotate([0, 180, 0]) {
		difference()
		{
			plain();
			translate([0, 0, 0]) hole();
			translate([0, 0, xt60_heigth/2]) xt60_screw_hole(M3_dia, h=xt60_heigth+1);
			translate([0, 0, xt60_heigth/2+2.8]) xt60_screw_hole(M3_head_hole, h=xt60_heigth);
		}
	}
}



translate([0, 0, 0])  rotate([0, 0, 0]) xt60_bracket();