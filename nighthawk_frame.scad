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
use <cleanhawk_top.scad>;
use <cleanhawk_bottom.scad>;

$fn=30;

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

module nighthawk_arm()
{
	M3_hole = 3.5;
	arm_length = 94;
	arm_width = 24;
	
	module motor_holder()
	{
		translate([0, arm_length, 1.5]) difference() {
			cylinder(d=28, h=3, center=true);
			cylinder(d=5, h=4, center=true);
			for(i=[1:4]) {
			rotate([0, 0, i*90]) hull() {
				translate([16/2, 0, 0]) cylinder(d=M3_hole, h=5, center=true);
				translate([19/2, 0, 0]) cylinder(d=M3_hole, h=5, center=true);
			}
			rotate([0, 0, i*90+45]) hull() {
				translate([16/2, 0, 0]) cylinder(d=2, h=5, center=true);
				translate([19/2, 0, 0]) cylinder(d=2, h=5, center=true);
			}
			}
		
		}
		
	}
	
	translate([-arm_width/2, 0, 0])  difference()
	{
		translate([0, -5, 0]) rotate([0, 0, 0]) cube([arm_width, arm_length, 3]); 	
		translate([arm_width/2, arm_length, 1.5]) cylinder(d=28, h=4, center=true);
		translate([arm_width/2-7, 0, -1]) cylinder(d=M3_hole, h=10);
		translate([arm_width/2+7, 0, -1]) cylinder(d=M3_hole, h=10);
	}
	motor_holder();
}

module spacer(heigth)
{
	width = 81;
	length  = 135;
	dia = 9;
	
	module arm_pos()
	{
		translate([27.7, 49.8, 9]) rotate([0, 0, -65]) nighthawk_arm();
	}
	nighthawk_arm();
	translate([-width/2, -length/2-2.6, 0])   import("Cleanhawk_Spacer.STL");
}
module nighthaw_camera_plate()
{
	translate([0, 0, 0]) rotate([0, 0, 0])
	{ 
		difference() {
			translate([0, 0, 0]) cube([35, 41, 2.2], center=true);
			translate([0, 0, -2]) cylinder(d=24.8, 4);
			//translate([0, 0, -2]) cylinder(d=35, 4);
			//#translate([35/2, 0, -2]) rotatecylinder(d=3, 14);
			hull()
			{
				translate([0, 24.8/2, -2]) cylinder(d=6, 4);
				translate([0, -24.8/2, -2]) cylinder(d=6, 4);
			}
			for(rot=[1:4])
			rotate([0, 0, rot*90+45]) 
			hull()
			{
				translate([40/2, 0, -2]) cylinder(d=2.5, 4);
				translate([35/2, 0, -2]) cylinder(d=2.5, 4);
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

pilar_height = 35;
pillar_width = 47;


module nighthawk_pillar()
{
	translate([8, 0, 0]) { 
		translate([0, 0, pilar_height]) {
			difference() {
				//translate([0, 0, 0]) roundCornersCube(155,56,1.5,3);
				for(x=[-71, -8, 72]) for(y=[-1,1])
				{
					translate([x, y*pillar_width/2, -0.1])cylinder(d=2.5, h=1.8);
				}
			
			}
		}
		for(x=[-71, -8, 72]) for(y=[-1,1])
		{
			translate([x, y*pillar_width/2, 0])  difference() {
				color("red") cylinder(d=5, h=pilar_height+.01);
				translate([0, 0, -0.1])cylinder(d=2.5, h=pilar_height+1);
			}
				
		}
	
	}

}

module nighthawk_pillar_hole(d, h)
{
	translate([0, 0, 0]) { 
		//for(x=[-71, -8, 72]) for(y=[-1,1])
		for(x=[-40, 40, 104]) for(y=[-1,1])
		{
			translate([x, y*pillar_width/2, 0])  difference() {
				//color("red") cylinder(d=5, h=pilar_height+.01);
				cylinder(d=d, h=h);
			}
				
		}
	
	}
}


module nighthaw_main_plate(zz=0)
{
	thick = 2.15;
	M3_hole = 3;
	
	plate_length = 223;
	plate_width = 56.15;
	plate_diff = 11.5;

	module hull_hole(l)
	{
		translate([0, 0, -0.1])  hull()
		{
			translate([0, 0, 0]) cylinder(d = M3_hole, h=thick+0.5);
			translate([l, 0, 0]) cylinder(d = M3_hole, h=thick+0.5);
		}
		
	}

	module hole()
	{
		//translate([-103.47+5.65, 0,  thick/2]) rotate([0, 0, 0]) roundCornersCube(16, 30, thick+1, 3);
		translate([-plate_length/2+8+5.65, 0,  thick/2]) rotate([0, 0, 0]) roundCornersCube(16, 30, thick+1, 3);
		for(y=[1, -1])	{
			translate([-plate_length/2+11, y*42/2, -0.1])  hull_hole(l=23);
			translate([plate_length/2-33, y*42/2, -0.1])  rotate([0, 0, 180]) hull_hole(l=20);
			translate([plate_length/2-19, y*12/2, -0.1])  rotate([0, 0, y*90]) hull_hole(l=8.5);
		}
		translate([plate_length/2-5.5, 0, -0.1])  rotate([0, 0, 180]) hull_hole(l=15);
		translate([-plate_length/2+100, 0, -0.1])  {
			hull()
			{
				translate([0, -10, 0]) cylinder(d = M3_hole, h=thick+0.5);
				translate([0, 10, 0]) cylinder(d = M3_hole, h=thick+0.5);
			}
			for(y=[1, -1])	{
			hull()
			{
				translate([-23/2, y*42/2, 0]) cylinder(d = M3_hole, h=thick+0.5);
				translate([23/2, y*42/2, 0]) cylinder(d = M3_hole, h=thick+0.5);
			}
			
			}
		}
		//#color("green") translate([-plate_length/2+100, 0, 0]) rotate([90, 0, 0]) cylinder(d = 0.5, h=100, center=true);
//		translate([224/2-17.5+20, 0, 0]) cylinder(d = M3_hole, h=thick+0.5);
//		#translate([112/2, 42/2, -0.1])  cylinder(d = M3_hole, h=thick+0.5+100);


	}
	
	module plain()
	{
		translate([0, 0, thick/2]) {
			roundCornersCube(plate_length, plate_width, thick, 3);	
		}	
		//color("red") translate([-plate_length/2+100, 0, 0]) rotate([90, 0, 0]) cylinder(d = 0.5, h=100, center=true);
		//nighthawk_pillar();
	}
	module arm2()
	{
		module arm1()
		{
			translate([-50, 26,  thick/2]) rotate([0, 0, 115]) roundCornersCube(18, 34, thick, 3);
			translate([-38, 25,  thick/2]) rotate([0, 0, 140]) roundCornersCube(23, 23, thick, 3);
			color("gray", 0.3) translate([-48, 26,  -3]) rotate([0, 0, 30])  translate([0,3,0]) nighthawk_arm();
			
		}
		arm1();
		mirror([0, 1, 0]) arm1();
	}
		
	module hole2()
	{
		translate([44/2, 0,  thick/2]) {
			roundCornersCube(44, 30, thick+1, 3);
			hull()
			{
				translate([-44/2, -30/2, 0]) cylinder(d = 3.2, h=thick);
				translate([44/2, 30/2, 0]) cylinder(d = 3.2, h=thick);
			}
		
		}
	}
	module hole2x()
	{
		translate([44/2, 0,  0]) {
			//roundCornersCube(44, 30, thick+1, 3);
			hull()
			{
				translate([-44/2, -30/2, 0]) cylinder(d = 3.2, h=thick);
				translate([44/2, 30/2, 0]) cylinder(d = 3.2, h=thick);
			}
		
			hull()
			{
				translate([-44/2, 30/2, 0]) cylinder(d = 3.2, h=thick);
				translate([44/2, -30/2, 0]) cylinder(d = 3.2, h=thick);
			}
		}
	}
	module M3_screw(length=10)
	{
		h = 2.7;
		translate([0, 0, h/2+1])  {
			difference() {
				color("white") cylinder(d = 5.4, h=h);
				translate([0, 0, 0]) color("red") cylinder(d = 3, h=5, $fn=6);
			}
			translate([0, 0, -7.1-h]) color("white") cylinder(d = 3, h=length);
		}
	}
	difference()
	{
		union() {
			translate([plate_diff, 0, 0]) plain();
			arm2();
			mirror([1, 0, 0]) arm2();
			for(x =[1, -1])	for(y =[1, -1])
			{
				translate([ x*(117.5-head_dia)/2, y*(55.5-head_dia)/2, -0.1+zz]) M3_screw();
				translate([ x*(92-head_dia)/2, y*(67.20-head_dia)/2, -0.1+zz]) M3_screw();
			}
		}
		translate([plate_diff, 0, 0]) hole();
			
		head_dia=5.37;
		for(x =[1, -1])	for(y =[1, -1])
		{
			translate([ x*(117.5-head_dia)/2, y*(55.5-head_dia)/2, -0.1]) cylinder(d = M3_hole, h=thick+0.5);
			translate([ x*(92-head_dia)/2, y*(67.20-head_dia)/2, -0.1]) cylinder(d = M3_hole, h=thick+0.5);
			
			translate([ x*(30.5)/2, y*(30.5)/2, -0.1]) cylinder(d = M3_hole, h=thick+0.5);
			hull() {
				translate([ x*(39)/2, y*(39)/2, -0.1]) cylinder(d = M3_hole, h=thick+0.5);
				translate([ x*(42)/2, y*(42)/2, -0.1]) cylinder(d = M3_hole, h=thick+0.5);
			}
		}
		translate([0, 0, -0.1]) nighthawk_pillar_hole(d=M3_hole, h=3);
		translate([26+8, 0,  thick/2]) roundCornersCube(16, 30, thick+1, 3);
		translate([-71.5, 0,  0]) hole2();
		translate([49, 0,  0]) hole2();
	}
		translate([-71.5, 0,  0]) hole2x();
		translate([49, 0,  0]) hole2x();
	//color("green") translate([26, 0, 0.2]) rotate([90, 0, 0]) cylinder(d = 0.5, h=110, center=true);
	translate([0, 0, thick+0.1]) color("red")
		difference() { 
			nighthawk_pillar_hole(d=5, h=pilar_height+0.1);
			nighthawk_pillar_hole(d=3, h=pilar_height+1);
		}
	translate([104, 0, 35/2+2.4])rotate([0, 90, 0]) nighthaw_camera_plate();
}

module nighthaw_top_plate()
{
	thick = 1.5;
	M3_hole = 3;
	
	plate_length = 152;
	plate_width = 56.15;
	plate_diff = 11.5;
	color("gray", 0.1)  difference() {
		translate([26+6, 0,  thick/2]) roundCornersCube(plate_length, plate_width, thick, 3);
		translate([0, 0, -0.1]) nighthawk_pillar_hole(d=M3_hole, h=2);
	}
	// Battery
	translate([0, 0,  (28)/2+thick]) color("blue", 0.8) cube([103, 32, 28], center=true);
}


module nighthaw_bottom_plate()
{
	thick = 2.15;
	M3_hole = 3;
	
	plate_length = 125;
	plate_width = 56.15;
	plate_diff = 0;

	module hull_hole(l)
	{
		translate([0, 0, -0.1])  hull()
		{
			translate([0, 0, 0]) cylinder(d = M3_hole, h=thick+0.5);
			translate([l, 0, 0]) cylinder(d = M3_hole, h=thick+0.5);
		}
		
	}

	module plain()
	{
		translate([0, 0, thick/2]) {
			roundCornersCube(plate_length, plate_width, thick, 3);	
		}	
		//color("red") translate([-plate_length/2+100, 0, 0]) rotate([90, 0, 0]) cylinder(d = 0.5, h=100, center=true);
		//nighthawk_pillar();
	}
	module arm2()
	{
		module arm1()
		{
			translate([-50, 26,  thick/2]) rotate([0, 0, 115]) roundCornersCube(18, 34, thick, 3);
			translate([-38, 25,  thick/2]) rotate([0, 0, 140]) roundCornersCube(23, 23, thick, 3);
			
		}
		arm1();
		mirror([0, 1, 0]) arm1();
	}
		
	difference()
	{
		union() {
			translate([plate_diff, 0, 0]) plain();
			arm2();
			mirror([1, 0, 0]) arm2();
		}
			
		head_dia=5.37;
		for(x =[1, -1])	for(y =[1, -1])
		{
			translate([ x*(117.5-head_dia)/2, y*(55.5-head_dia)/2, -0.1]) cylinder(d = M3_hole, h=thick+0.5);
			translate([ x*(92-head_dia)/2, y*(67.20-head_dia)/2, -0.1]) cylinder(d = M3_hole, h=thick+0.5);
			
		}
		translate([0, 0, -0.1]) nighthawk_pillar_hole(d=6, h=3);
	}
}


module nighthawk_view(zz = 0)
{
	translate([0, 0, 0]) {
		rotate([0, 0, 0])   nighthaw_main_plate(12);
		translate([0, 0, -zz-10]) {
			rotate([0, 0, 90]) color("green")  cleanhawk_top_frame();

			translate([0, 0, -zz-2]) {
				rotate([0, 0, 0]) color("blue", 0.3) nighthaw_bottom_plate();
				translate([0, 0, -zz-3.5]) {
					rotate([0, 0, 90]) color("green")  cleanhawk_bottom_frame();
				
					translate([0, 0, -zz-2]) rotate([0, 0, 0]) color("gray", 0.3) nighthaw_bottom_plate();
				
				}
			}
		}
	}
}

nighthawk_view(zz=4);
//nighthaw_main_plate();






