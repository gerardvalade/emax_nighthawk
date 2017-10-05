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

module spacer(heigth)
{
	width = 14;
	dia = 9;
	hole = 3.5;
	color("red") difference() {	
		hull()
		{
			translate([0, width/2, 0])  cylinder(d=dia, h=heigth, center=false);
			translate([0, -width/2, 0])  cylinder(d=dia, h=heigth, center=false);
			
		}
		translate([0, width/2, -0.1])  cylinder(d=hole, h=heigth+1, center=false);
		translate([0, -width/2, -0.1])  cylinder(d=hole, h=heigth+1, center=false);
	}
}


translate([0, 0, 0]) rotate([0, 0, 0]) spacer(3.5);
translate([20, 0, 0]) rotate([0, 0, 0]) spacer(3.5);
translate([0, 40, 0]) rotate([0, 0, 0]) spacer(3.5);
translate([20, 40, 0]) rotate([0, 0, 0]) spacer(3.5);


//import("Cleanhawk_Spacer.STL");
