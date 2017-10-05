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
	width = 81;
	length  = 135;
	dia = 9;
	
	module arm()
	{
		M3_hole = 3.5;
		arm_lenght = 94;
		arm_width = 24;
		translate([-arm_width/2, 0, 0])  difference()
		{
			translate([0, -5, 0]) rotate([0, 0, 0]) cube([arm_width, arm_lenght, 3]); 	
			translate([arm_width/2-7, 0, -1]) cylinder(d=M3_hole, h=10);
			translate([arm_width/2+7, 0, -1]) cylinder(d=M3_hole, h=10);
		}
	}
	module arm_pos()
	{
		translate([27.7, 49.8, 9]) rotate([0, 0, -65]) arm();
	}
	
	translate([-width/2, -length/2-2.6, 0])   import("Cleanhawk_Spacer.STL");
}

module frame()
{
	thin = 1.4;
	height = 3.5;
	M3_hole = 3.8;
	arm_height = height;
	arm_lenght = 94;
	arm_width = 24;
	corner_dia = 2;
	
	module frame_back()
	{
		translate([0, 59.1-6, 0]) difference() {
			union() {
				translate([0, 0, 0]) cube([10, thin, height]);
				translate([10, 0, 0]) rotate([0, 0, 14.7]) cube([18.5, thin, height]);
				//translate([0, -5.75, 0]) cube([8.5, 7.4, height]);
			}
			//translate([-0.01, -4.75, -0.1]) cube([6.5, 6.5, height+1]);
		}
	}
	
	module frame_front()
	{
		translate([0, -70+6, 0]) {
			cube([8, thin, height]);
			translate([8, 0, 0]) rotate([0, 0, 12.5]) 				cube([20.5, thin, height]);
		}
	}
	module arm()
	{
		translate([-arm_width/2, 0, 0])  difference()
		{
			translate([0, -5, 0]) rotate([0, 0, 0]) cube([arm_width, arm_lenght, 3]); 	
		}
	}

	module arm_holder(hole=false)
	{
		arm_lenght = 10;
		module createMeniscus(h,radius) // This module creates the shape that needs to be substracted from a cube to make its corners rounded.
			difference(){        //This shape is basicly the difference between a quarter of cylinder and a cube
		   		translate([radius/2+0.1,radius/2+0.1,0]){
		      		cube([radius+0.2,radius+0.1,h+0.2],center=true);         // All that 0.x numbers are to avoid "ghost boundaries" when substracting
		   		}
		
		   	cylinder(h=h+0.2,r=radius,$fn = 25,center=true);
		}


		module roundCornersCube(x,y,z,r)  // Now we just substract the shape we have created in the four corners
		difference(){
		   cube([x,y,z], center=true);
		
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

		
		translate([28, 49.7, 0]) rotate([0, 0, -65])
		translate([0, 0, 0])  
		{
			if (!hole) translate([0, 1, height/2]) roundCornersCube(arm_width, arm_lenght, height, 4);
			
			if (hole) { 	
				//#translate([0, -0, 3.5+3.3]) cube([7.5, arm_lenght+5, 7], center=true);
				translate([0-7, 0, -1]) cylinder(d=M3_hole, h=10);
				translate([0+7, 0, -1]) cylinder(d=M3_hole, h=10);
				//#translate([0, -5, 5+arm_height]) rotate([0, 0, 0]) cube([arm_width+0.8, 25, 10], center=true); 
			}
		}
	}
	
	module half1()
	{
		difference(){
			union() {
				translate([28, 64.5, 0]) cylinder(d = corner_dia, h=height);
				translate([27.5, 64, 0]) rotate([0, 0, -65]) cube([27, thin, height]);
				translate([39.7, 39.5, 0]) cylinder(d = corner_dia, h=height);
				translate([38.9, 39.6, 0]) rotate([0, 0, -130]) cube([17.8, thin, height]);
				translate([28.2, 25.7, 0]) cylinder(d = corner_dia, h=height);
				translate([27.3, 25.5, 0]) rotate([0, 0, -90]) cube([26, thin, height]);
				arm_holder();
		
			}
			arm_holder(true);
		}
	}
	module half()
	{
		//#frame_back();
		half1();
		mirror([0, 1, 0]) half1();
		//frame_front();
	}
	difference() {
		union() {
			translate([0, 0, 0]) half();
			mirror([1, 0, 0]) half();
		}
	}
		
}

module hole()
{
	head_dia=5.37;
	dia = 3.5;
	height = 20;
	color("yellow") for(x =[1, -1])
	for(y =[1, -1])
	{
		translate([ x*(55.5-head_dia)/2, y*(117.5-head_dia)/2, 0]) cylinder(d = dia, h=height);
		translate([ x*(67.20-head_dia)/2, y*(92-head_dia)/2, 0]) cylinder(d = dia, h=height);
		
	}
}

//translate([0, 0, 0]) rotate([0, 0, 0]) hole();
translate([0, 0, 0]) rotate([0, 0, 0]) frame();

//translate([0, 0, 0]) rotate([0, 0, 0]) spacer(3.5);

//import("Cleanhawk_Spacer.STL");
