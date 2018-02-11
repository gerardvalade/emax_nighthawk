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

length = 55;
width = 55;
fc_hole_width = 30.5;
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


module battery_holder()
{
	hole_width = 48;
	hole_pos1 = 80.5;
	hole_pos2 = hole_pos1 + 63.80;
	battery_width = 36;
	battery_heigth = 26;
	battery_length = 105;
	length = 90;
	width = hole_width + 2; // 56
	heigth = battery_heigth-23+20;
	pillar_heigth = heigth;
	thin = 3;
	
	module sangle()
	{
		dia1 = 6;
		dia2 = 9;
		heigth = 1.5;
		lg = 20;
		difference()
		{
			translate([0, 0, heigth/2]) cube([length-15, dia2, heigth], center=true);
//			translate([0, 0, 0])  hull() {
//				translate([(length+dia2/2)/2, 0, 0]) cylinder(d=dia2, h=heigth);
//				translate([-(length+dia2/2)/2, 0, 0]) cylinder(d=dia2, h=heigth);
//			}
			for(x = [-1,  1])
			translate([x*20, 0, 0])  hull() {
				translate([lg/2, 0, -0.1]) cylinder(d=dia1, h=heigth+1);
				translate([-lg/2, 0, -0.1]) cylinder(d=dia1, h=heigth+1);
			}
		}
	}
	module plain()
	{
		extra_length = 2.8;
		translate([0, 0, heigth/2]) roundCornersCube(length, width, heigth, 3);
		translate([0, 0, 3/2]) roundCornersCube(battery_length+2*extra_length, width, 3, 3);
		for(x = [0, battery_length+extra_length])
			//translate([-(battery_length+extra_length)/2 + x, 0, 15/2]) cube([extra_length, 20, 15], center=true);
			translate([-(battery_length+extra_length)/2 + x, 0, 15/2]) rotate([0, 90, 0]) roundCornersCube(15, 20, extra_length, 3.5);
			
		for(x = [-1, 1]) for(y = [-1, 1]) {
			translate([x*hole_pos1/2, y*hole_width/2, 0]) cylinder(d=8, h=heigth, center=false);
		}
		
		
	}
	
	module hole()
	{
		translate([0, 0, battery_heigth/2+3]) cube([battery_length, battery_width, battery_heigth], center = true);
		for(y = [-1, 1])
		{
			translate([0, y*(width/2+4), 0])  hull() {
				translate([30.1, 0, -0.1]) cylinder(d=15, h=heigth+1);
				translate([-30.1, 0, -0.1]) cylinder(d=15, h=heigth+1);
			}
			
		}
		translate([-hole_pos1/2, 0, 0]) 
		for(x = [0, hole_pos1, hole_pos2]) for(y = [-1, 1]) {
			translate([x, y*hole_width/2, 0]) {
				translate([0, 0, -0.1]) cylinder(d=3.5, h=heigth+5, center=false);
				translate([0, 0, -3]) cylinder(d=5.5, h=pillar_heigth+0.1, center=false);
				translate([0, 0, pillar_heigth-5-3]) cylinder(d=6, h=5, center=false);
			
			}
		}
		
		for(x = [-2: 2]) for(y = [-1, 1]) {
			translate([x*12, y*20, heigth/2]) rotate([90, 0, 0]) //cylinder(d=8, h=heigth, center=true);
			 hull() {
				translate([0, 2, 0]) cylinder(d=8, h=heigth+1, center=true);
				translate([0, -2, 0]) cylinder(d=8, h=heigth+1, center=true);
			}
		}
		for(x = [-1: 1])
		translate([x*35, 0, -1]) roundCornersCube(28, battery_width-12, 10, 8);
		
//		for(y = [-1, 1])
//		{
//			translate([0, y*0, 0])  hull() {
//				translate([30.1, 0, -0.1]) cylinder(d=25, h=10);
//				translate([-30.1, 0, -0.1]) cylinder(d=25, h=10);
//			}
//			
//		}
	}
	difference()
	{
		plain();
		hole();
	}
	
	//color("yellow") translate([0, 0, battery_heigth/2+3]) cube([battery_length, battery_width, battery_heigth], center = true);
	for(x = [-1, 1]) for(y = [-1, 1]) {
		translate([0, y*22.5, 0]) sangle();
	}
}


translate([0, 0, 0]) rotate([0, 0, 0]) battery_holder();
