// XT90Holder for Tarot 680 - a OpenSCAD 
// Copyright (C) 2015  Gerard Valade

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
length = 27;
width = 30;
heigth = 13;
M3_dia = 3.5;
M3_hole = 2.5;

module roundCornersCube(x,y,z,r)  // Now we just substract the shape we have created in the four corners
{
	module createMeniscus(h,radius) // This module creates the shape that needs to be substracted from a cube to make its corners rounded.
	{
		difference(){        //This shape is basicly the difference between a quarter of cylinder and a cube
		   translate([radius/2+0.1,radius/2+0.1,0]){
		      cube([radius+0.2,radius+0.1,h+0.2],center=true);         // All that 0.x numbers are to avoid "ghost boundaries" when substracting
		   }
		
		   cylinder(h=h+0.2,r=radius,$fn = 25,center=true);
		}
	
	}
	difference(){
	   cube([x,y,z], center=true);
	
	translate([x/2-r,y/2-r]){  // We move to the first corner (x,y)
	      rotate(0){  
	         createMeniscus(z,r); // And substract the meniscus
	      }
	   }
	   translate([-x/2+r,y/2-r]){ // To the second corner (-x,y)
	      rotate(90){
	         createMeniscus(z,r); // But this time we have to rotate the meniscus 90 deg
	      }
	   }
	      translate([-x/2+r,-y/2+r]){ // ... 
	      rotate(180){
	         createMeniscus(z,r);
	      }
	   }
	      translate([x/2-r,-y/2+r]){
	      rotate(270){
	         createMeniscus(z,r);
	      }
	   }
	}
}


module XT90Base()
{
	translate([0,0,(heigth)/2]) {
		cube([length,width,heigth], center=true);
		translate([(length-5)/2,0,0]) cube([5,30,heigth], center=true);
		//#translate([0, -17,6]) cube([31, 12, 24], center=true);
	}
}
module XT90BasePlate()
{
	translate([0,0,1.8/2]) {
		difference() {
			cube([length+0.5,width+0.5,1.8], center=true);
			hull() {
				translate([0, -4, 0]) cylinder(d=12, h=10, center=true);
				translate([0, 4, 0]) cylinder(d=12, h=10, center=true);
			}
		}
	}
}

module XT90positf(cut=4.9)
{
	difference() {
		cube([20,21,10], center=true);
		translate([0, 10.5, 5]) rotate([45, 0, 0]) cube([21,cut,cut], center=true);
		translate([0, 10.5, -5]) rotate([45, 0, 0]) cube([21,cut,cut], center=true);
	}
	
}
	

module XT90HoleScrew(dia=2.2)
{
	for(x=[1,-1]) for(y=[1, -1]) translate([x*10, y*12.5, 2]) cylinder(d=dia, h=10, center=true);	
	//#for(x=[1,-1]) for(y=[1, -1]) translate([x*10, y*43/2, 2]) cylinder(d=dia, h=10, center=true);	
}

module XT90Hole()
{
	translate([(length-20)/2+0.02, 0, 10/2+0.4]) {
		XT90positf(cut=4.4);
		translate([0, 0, -5]) cube([20,21,10], center=true);
		translate([-6.5, -2, 3.5+1]) cube([6.4,15,2], center=true);
		translate([-(20+10)/2 + 0.02, 0, -1.5])cube([10, 19.5, 12], center=true);
	}
}

module XT90()
{
	translate([0, 0, heigth]) rotate([0, 180, 0]) {
		difference()
		{
			union() {
				difference() {
				XT90Base();
				translate([0,0,0]) rotate([45, 0, 0]) translate([0,0,24])  cube([50, 10, 10], center=true);
				translate([0,0,0]) rotate([45, 0, 0]) translate([0,24,0])  cube([50, 10, 10], center=true);
				
				}
				translate([12.5, -21, 6.5])  difference()
				{
					translate([0,1,0]) cube([2, 13, 13], center=true);
					translate([-10, 1, 0]) rotate([0, 90, 0]) cylinder(d=6.6, h=20);
					translate([0,0,0]) rotate([45, 0, 0]) translate([0,0,12])  cube([10, 10, 10], center=true);
					translate([0,0,0]) rotate([45, 0, 0]) translate([0,0,12])  cube([10, 10, 10], center=true);
				}
				
			}
			XT90Hole();
			XT90HoleScrew(M3_hole);
		}
	}
}
module XT90Plate()
{
	difference() {
		XT90BasePlate();
		XT90HoleScrew(dia=2.7);
	}
}


module XT90_holder()
{
	module plain()
	{
		translate([0, 0, 1.5])  roundCornersCube(16+10, 56-0.8, 2, 3);
		roundCornersCube(16, 30, 2, 3);
		
	}
	module hole()
	{
		for(y=[1, -1]) translate([0, y*43/2, 2]) cylinder(d=M3_dia, h=10, center=true);	
	}
	difference() {
		plain();
		XT90HoleScrew(dia=2.7);
		hole();
		
	}
	
}

module XT90_plate()
{
	pillar_width = 47;
	module plain()
	{
		//translate([0, 0, 1.5])  roundCornersCube(16+11, 56-0.8, 3, 3);
		translate([0, 0, 1.5])  roundCornersCube(16+11, 49, 3, 3);
		for(y=[-1,1])
			translate([0, y*pillar_width/2, 0])  cylinder(d=8, h=18);
		//roundCornersCube(16, 30, 2, 3);
		
	}
	module hole()
	{
		//for(y=[1, -1]) translate([0, y*43/2, 2]) cylinder(d=M3_dia, h=10, center=true);	
		for(y=[-1,1])
			translate([0, y*pillar_width/2, -1])  cylinder(d=5.5, h=25);
	}
	difference() {
		plain();
		translate([0, 4, 0]) XT90HoleScrew(M3_dia);
		hole();
	}
	
}

module view()
{
	translate([0, 0, 0])  
	{
		translate([0, -4, 0])  rotate([0, 0, 0])  XT90_plate();
		translate([0, 0, 13+3])  rotate([0, 180, 0]) XT90();
		
	}
}

//view();
translate([0, 0, 0])  XT90_plate();
translate([0, 80, 0])  rotate([0, 0, 0]) XT90();

//translate([0, 0, 0])  rotate([0, 0, 0]) XT90_holder();
//translate([0, 80, 0]) XT90Plate();