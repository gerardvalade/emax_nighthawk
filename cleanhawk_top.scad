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


module cleanhawk_top_frame()
{
	thin = 1.5;
	height = 10;
	M3_hole = 3.8;
	arm_height = height - 4;
	arm_lenght = 94;
	arm_width = 24.8;
	corner_dia = 2;
	
	module frame_back()
	{
		/*translate([0, 0.5, 0])
		{
			translate([0, 59.1, 0]) difference() {
				union() {
					translate([0, 0, 0]) cube([10, thin, height]);
					translate([10, 0, 0]) rotate([0, 0, 14.7]) cube([18.5, thin, height]);
					translate([0, -5.75, 0]) cube([8.5/2, 7.4, height]);
				}
				translate([-0.01, -4.75, -0.1]) cube([6.5/2, 6.5, height+1]);
			}
		
		}*/
		translate([0, 59.1+0.8, 0]) difference() {
			union() {
				translate([0, 0, 0]) cube([10, thin, height]);
				translate([10, 0, 0]) rotate([0, 0, 14.7]) cube([18.5, thin, height]);
				translate([0, -5.75-0.3, 0]) cube([8.5/2, 7.4, height]);
			}
			translate([-0.01, -4.75-0.3, -0.1]) cube([6.5/2, 6.5+0.5, height+1]);
		}
	}
	
	module frame_front()
	{
		translate([0, -70-0.8, 0])
		{
			difference() {
				union() {
					translate([0, 0, 0]) cube([8, thin, height]);
					translate([0, 0, 0]) cube([8.5/2, 8.8, height]);
				}
				translate([-0.01, -0.05, -0.1]) cube([6.5/2, 6.5+1, height+1]);
			}
			translate([8, 1, 0]) cylinder(d = corner_dia, h=height);
			translate([8, 0, 0]) rotate([0, 0, 12.5]) {
				difference() {
					cube([20.5, thin, height]);
					for(i = [0, 1, -1])
					translate([20.5/2+i*5, 10, height/2]) rotate([90, -15, 0]) hull()
					{
						translate([0, 2, 0]) cylinder(d = 2.5, h=20);
						translate([0, -2, 0]) cylinder(d = 2.5, h=20);
					}
				}
				
			}
		
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
				translate([0, -0, 3.5+3.3]) cube([7.5, arm_lenght+5, 7], center=true);
				translate([0-7, 0, -1]) cylinder(d=M3_hole, h=10);
				translate([0+7, 0, -1]) cylinder(d=M3_hole, h=10);
				translate([0, -5, 5+arm_height]) rotate([0, 0, 0]) cube([arm_width+0.8, 25, 10], center=true); 
			}
		}
	}
	
	module half1()
	{
		difference(){
			union() {
				translate([28-0.4, 64.5+0.8, 0]) cylinder(d = corner_dia, h=height);
				translate([27.5, 64, 0]) rotate([0, 0, -65]) translate([-0.9, 0, 0]) cube([28.3, thin, height]);
				translate([39.7, 39.5, 0]) cylinder(d = corner_dia, h=height);
				translate([38.9, 39.6, 0]) rotate([0, 0, -130]) cube([17.8, thin, height]);
				translate([28.2, 25.7, 0]) cylinder(d = corner_dia, h=height);
				translate([27.3, 25.5, 0]) rotate([0, 0, -90]) cube([26, thin, height]);
				arm_holder();
		
			}
			arm_holder(true);
			for(i = [0:3])
				translate([15, 5+i*5.5, height/2]) rotate([0, 90, 0]) rotate([0, 0, 15]) hull()
				{
					translate([2, 0, 0]) cylinder(d = 2.5, h=20);
					translate([-2, 0, 0]) cylinder(d = 2.5, h=20);
				}
		}
	}
	module half()
	{
		frame_back();
		half1();
		mirror([0, 1, 0]) half1();
		frame_front();
	}
	difference() {
		union() {
			translate([0, 0, 0]) half();
			mirror([1, 0, 0]) half();
		}
		//#translate([-0.0, 57.5, height/2]) cube([6.5, 6.5, height+1], center=true);
		//#translate([-0.0, -67, height/2]) cube([6.5, 6.5, height+1], center=true);
		translate([0, 66, 0]) rotate([0, 0, 14.7]) 
				for(i = [0:3])
				translate([11+i*4, 0, height/2])  rotate([90, -15, 0]) hull()
				{
					translate([0, 2, 0]) cylinder(d = 2.5, h=10);
					translate([0, -2, 0]) cylinder(d = 2.5, h=10);
				}
		translate([-8-6-2.5, 70, 8]) rotate([90, 0, 0])
		{ 
			hull()
			{
				translate([0, 0, 0]) cylinder(d = 6, h=20);
				translate([5, 0, 0]) cylinder(d = 6, h=20);
			}
			hull()
			{
				translate([0, 0, 0]) cylinder(d = 6, h=20);
				translate([0, 2, 0]) cylinder(d = 6, h=20);
			}
			hull()
			{
				translate([5, 0, 0]) cylinder(d = 6, h=20);
				translate([5, 2, 0]) cylinder(d = 6, h=20);
			}
		
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

translate([80, 0, 0]) rotate([0, 0, 0]) cleanhawk_top_frame();


