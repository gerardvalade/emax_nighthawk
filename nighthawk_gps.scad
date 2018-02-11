// EMAX nighthawk accessories  - a OpenSCAD  
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

pillar_width = 47;
pilar_heigth = 35;
top_height = 10.5+1.2 +2;
bottom_height = pilar_heigth-top_height-0.4;

M3_dia = 3.7;
M3_hole = 2.5;
M3_hexa = 6.1;
M3_head_hole = 5.4+1;

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

module hexaprismx(
	ri =  1.0,  // radius of inscribed circle
	h  =  1.0)  // height of hexaprism
{ // -----------------------------------------------

	ra = ri*2/sqrt(3);
	cylinder(r = ra, h=h, $fn=6, center=false);
}




module pillar_hole(height)
{
	translate([0, 0, -0.1])  cylinder(d=5.5, h=height+0.2);
	translate([0, 0, 2])  cylinder(d=6.2, h=height-4, center=false);
}


module pillar_holes(height)
{
	for(y=[-1,1]) {
		translate([-5, y*pillar_width/2, 0]) {
			pillar_hole(height=height);
		}
	}
}



module antenna_bracket(thick=0.6, height=top_height, fullview=false)
{
	arm_length = 11;
	arm_heigth = 13;
	arm_pos_z = 5;//height;
	inner_tube_dia = 8.8*2/sqrt(3);// 11;
	out_tube_dia =  inner_tube_dia + 4;
	
	module sma(d=6.8, h=8, type=0)
	{
		rotate([0, 0, 30]) color("yellow")  {
			translate([0, 0,  -2]) cylinder(d=6, h=15, center=true);
			translate([0, 0,  0]) cylinder(d=inner_tube_dia, h=2, center=true, $fn=6);
			translate([0, 0,  3.5]) cylinder(d=inner_tube_dia, h=2, center=true, $fn=6);
		}
	}
	
	module pillar()
	{
		cylinder(d=12, h=height, $fn=30);
	}
	
	
	module plain()
	{

		
		//translate([-5, -pillar_width/2, 0])  
		{
			translate([0, 0, 0])  rotate([0, 0, 0]) pillar();
			hull()
			{
				translate([0, 0, 0])  cylinder(d=10, h=2, $fn=6);
				translate([0, -arm_length, 0])  cylinder(d=out_tube_dia, h=2, $fn=6);
			}
			
			translate([0, -arm_length/2, arm_pos_z/2])  cube([1.8, arm_length, arm_pos_z], center=true);
			//#translate([-12, -1, 0])   cube([10, 2, 6], center=false);
			
			translate([0, -arm_length, 0]) {
				translate([0, 0, 0])   cylinder(d=out_tube_dia, h=arm_pos_z,  $fn=6);
			}
		}
	}
	
	difference() {
		plain();
		pillar_hole(height=height);
		//translate([-5, -pillar_width/2, 0])   
		{
			translate([0, -arm_length, 0])  
			{
				
				translate([0, 0, -1])   cylinder(d=6.8, h=arm_pos_z+10, $fn=30);
				translate([0, 0, 1.8])   cylinder(d=inner_tube_dia, h=arm_pos_z, $fn=6);
			
			}
		}
	}
	if (fullview)
	{
		translate([0, -arm_length, -1.5]) sma();
	}
	
}


module gps_bracket(thick=0.6, height=top_height)
{
	gps_width = 26+0.6;
	gps_length= 21+0.6;
	
	arm_length = 20;
	arm_heigth = 13;
	arm_pos_z = 29-8+10;
	out_tube_dia =  8*2/sqrt(3) +3; 
	inner_tube_dia = out_tube_dia -5;
	
	fn = 30;
	module pillar()
	{
		cylinder(d=12, h=height, $fn=30);
	}
	
	
	module plain()
	{
		translate([0, 0, 0])  rotate([0, 0, 0]) pillar();
		hull()
		{
			translate([0, 0, 0])  cylinder(d=10, h=2, $fn=fn);
			translate([0, -arm_length, 0])  cylinder(d=out_tube_dia, h=2, $fn =fn);
		}
		
		translate([0, -arm_length/2, height/2])  cube([1.8, arm_length, height], center=true);
		translate([7, -0, 3])   cube([10, 3, 6], center=true);
		
		translate([0, -arm_length, 0]) {
			translate([0, 0, 0])   cylinder(d=out_tube_dia, h=arm_pos_z,  $fn=fn);
			translate([0, 0, arm_pos_z]) {
				hull() {
					translate([0, 0, 0])   cylinder(d=out_tube_dia, h=0.2, $fn=fn);
					translate([0, 0, arm_heigth])   roundCornersCube(gps_width+3, gps_length+3, 0.1, 3);
				}
				translate([0, 0, arm_heigth+6/2])   roundCornersCube(gps_width+3, gps_length+3, 6, 3);
			
			}
		}
	}
	
	difference() {
		plain();
		pillar_hole(height=height);
		
		translate([+8, 0, 4])   rotate([90, 0, 0]) hull() {
			cylinder(d=3.2, h= 10, center=true);
			translate([0, 2, 0]) cylinder(d=3, h= 10, center=true);
		}
		translate([0, -arm_length, 0])  
		{
			
			translate([0, 7.5, 3.6])   rotate([0, 90, 0]) cylinder(d=3, h=100, center=true);
			translate([0, 0, -1])   cylinder(d=inner_tube_dia, h=arm_pos_z+10, $fn=fn);
			translate([0, 0, arm_pos_z])  
			{
				translate([0, 0, 3]) hull() {
					translate([0, 0, 0.1])   roundCornersCube(10, 10, 0.2, 3);
					translate([0, 0, arm_heigth+0.2])   roundCornersCube(gps_width-3, gps_length-3, 0.2, 3);
				}
				translate([0, 0, arm_heigth+10/2])   cube([gps_width, gps_length, 10], center=true);
				translate([gps_width/2, 0, arm_heigth+10/2])   cube([10, 3.5, 10], center=true);
				translate([-gps_width/2, 6, arm_heigth+10/2])   cube([10, 3.5, 10], center=true);
				translate([-gps_width/2, -6, arm_heigth+10/2])   cube([10, 3.5, 10], center=true);
				hull() {
					translate([0, 0, 2.5+3])  rotate([0, 90, 0])  cylinder(d=2, h=30, center=true);
					translate([0, 0, arm_heigth-6]) rotate([0, 90, 0])  cylinder(d=8, h=30, center=true);
				}
				hull() {
					translate([0, -0, 2.5+3])  rotate([0, 90, 90])  cylinder(d=2, h=30, center=true);
					translate([0, -0, arm_heigth-6]) rotate([0, 90, 90])  cylinder(d=8, h=30, center=true);
				}
				
			}
		
		}
		
	}
	
}



module beeper_bottom_plate(thick=1.4, fullview=false)
{
	ra = M3_hexa*2/sqrt(3);
	r8 = 8*2/sqrt(3);
	rot = -22;

	module pillar()
	{
		cylinder(d=10, h=bottom_height, $fn=30);
	}
	
	module plain()
	{
		difference() {
			translate([-2, 0, thick/2]) cube([15, 50, thick], center=true);
			for(y=[-1, 1]) translate([0, y*(pillar_width+15)/2, (thick/2)])  rotate([0, 0, y*rot]) cube([20, 15, thick*2], center=true);
		}
		for(y=[-1,1])
		{
			translate([-5, y*pillar_width/2, 0])  rotate([0, 0, y*90-90]) pillar();
		}
	}

	
	difference() {
		union() {
			plain();
			for(y=[-1, 1]) translate([2, y*(pillar_width-1.5)/2,(bottom_height)/2])  rotate([0, 0, y*rot]) cube([8, thick, bottom_height], center=true);
		}
		
		for(x=[0]) for(y=[1, -1]) translate([x*8, y*12, 0]) {
			cylinder(d=M3_dia, h=10, center=true);
		}	
		
		pillar_holes(height=bottom_height);
	
	}
	if (fullview)
	{
		sma_hole(type=3);
	}
}

module gps_bracket_view()
{
	//for(y=[-1,1]) translate([0, y*pillar_width/2, 0])  color("red") cylinder(d=5, h=pilar_heigth+1.01);
	translate([5, 0, bottom_height])  
	{
		translate([0, 0, -0.4])  rotate([0, 180, 180]) beeper_bottom_plate(fullview=false);
	}
	translate([0, -pillar_width/2, bottom_height]) rotate([0, 0, 45])  {
		 gps_bracket();
	}
	translate([0, pillar_width/2, bottom_height+top_height]) rotate([0, 180, 180]) antenna_bracket(fullview=true);
}



//translate([80, 0, 0]) gps_bracket_view();

translate([-0, 0, 0])  beeper_bottom_plate();
translate([-30, -20, 0])  gps_bracket();
translate([-30, 20, 0]) rotate([0, 0, 180]) antenna_bracket();
