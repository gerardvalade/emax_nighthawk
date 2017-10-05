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


transmitter_heigth = 10.65;
transmitter_width=30.5;
transmitter_length=37;

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


module video_transmitter()
{
	translate([0, 0, transmitter_heigth/2])  color("gray") cube([transmitter_length, transmitter_width, transmitter_heigth], center=true);
	translate([-37/2+3.5, 0, transmitter_heigth]) {
		translate([0, 0, 11.30]) color("red") cylinder(d=7.23, h=42.66);
		translate([0, 0, 0]) color("yellow") cylinder(d=7.5, h=11.30);
		translate([0, 0, 3]) color("yellow") hexaprismx(ri=4, h=6.2, $fn=6);
		
	} 	
	
}

module video_bracket_simple(heigth)
{
	thick = 2.5;
	width = transmitter_width+2*thick+1;
	heigth = transmitter_heigth+thick+0.5;
	length  = 10;
	translate([0, 0, 0])  difference()
	{
		union()
		{
			translate([0, 0, (heigth)/2])  cube([length, width, heigth], center=true);
			translate([0, 0, (thick)/2])  cube([length, 56, thick], center=true);
			for(y=[-1, 1]) translate([0, y*43/2, 0]) cylinder(d=6, h=thick+3);
		}
		translate([0, 0, transmitter_heigth/2-0.05])  cube([transmitter_length+1, transmitter_width+1, transmitter_heigth+0.4], center=true);
		for(y=[-1, 1]) translate([0, y*43/2, -1])  cylinder(d=M3_dia, h=10);
	}
}
module video_led_bracket(heigth)
{
	thick = 2;
	width = 43;
	heigth = 2;
	length  = 3;
	led_pos = 28;
	ra = M3_hexa*2/sqrt(3);
	translate([0, 0, 0])  difference()
	{
		union()
		{
			translate([0, 0, (thick)/2])  cube([5, width, thick], center=true);
			for(y=[-1, 1]) {
				translate([0, y*43/2, 0]) cylinder(d=10, h=thick+3);
				translate([led_pos/2-2, y*43/2, (thick)/2])  cube([led_pos, 9, thick], center=true);
				translate([led_pos/2-2, y*43/2, (thick+3)/2])  cube([led_pos, 3, thick+3], center=true);
			}
		}
		for(y=[-1, 1]) translate([0, y*43/2, -1])  cylinder(d=M3_dia, h=10);
		for(y=[-1, 1]) translate([0, y*43/2, thick])  cylinder(d=ra, h=4, $fn=6); //hexaprismx(ri=M3_hexa, h=5);
	}
	translate([led_pos, 0, 13.5/2]) mirror([0, 0, 1]) mirror([1, 0, 0])  led_plate(13.5);
}

module led_plate(heigth)
{ 
	led_length = 54.4 + 1;
	difference()
	{
		cube([4.7, led_length+3, heigth], center=true);
		translate([-0.8, 0, +0.5-1.5]) cube([3.2, led_length, 12], center=true);
		for(x = [-1, 1]) {
			translate([0, x*25, 0]) rotate([0, 90, 0]) hull()
			{
				translate([1.5, 0, 0])  cylinder(d=4, h=15, center=true, $fn=50);
				translate([-1.5, 0, 0])  cylinder(d=4, h=15, center=true, $fn=50);
				
			}
		}
	}
}

module video_bracket(heigth)
{
	thick = 1.8;
	width = transmitter_width+2*thick+1;
	heigth = transmitter_heigth+thick+0.5;
	length  = 14;
	offset = -11;
	
	
	

	module triangle()
	{
		for(y = [0]) {
			translate([-length/2, 13+y, 0])
			cube([length, 12, heigth]);
			//rotate([0, -90, 0]) linear_extrude(height = 1, center = true, convexity = 10, twist = 0) polygon(points=[[0, 0],[heigth-thick, 0],[0, 10.8]], convexity=10);
		}
	
	}	
	module triangle2()
	{
		for(y = [0:2.8:length-1]) {
			translate([-length/2, 13+y, 0]) cube([length, 0.8, heigth]);
			//rotate([0, -90, 0]) linear_extrude(height = 1, center = true, convexity = 10, twist = 0) polygon(points=[[0, 0],[heigth-thick, 0],[0, 10.8]], convexity=10);
		}
	
	}	
	module triangle1()
	{
		for(x = [0:2.8:length-1]) {
			translate([x-length/2+0.5, 17.15, thick])
			rotate([0, -90, 0]) linear_extrude(height = 1, center = true, convexity = 10, twist = 0) polygon(points=[[0, 0],[heigth-thick, 0],[0, 10.8]], convexity=10);
		}
	
	}
	
		
	translate([0, 0, 0])  difference()
	{
		union()
		{
			//translate([0, 0, heigth/2])  cube([length, width, heigth], center=true);
			translate([0, 0, heigth/2])  cube([length, 51, heigth], center=true);
			translate([0, 0, heigth-1/2])  cube([length, 50, 1], center=true);
			translate([0, 0, (thick)/2])  cube([length, 50, thick], center=true);
			for(y=[-1, 1]) translate([0, y*43/2, 0]) cylinder(d=6, h=thick+3);
			triangle();
			mirror([0, 1, 0]) triangle();
			for(y=[-1, 1]) translate([0, y*43/2, 0])  cylinder(d=M3_head_hole+1.5, h=heigth);
			translate([offset, 0, 0]) for(y=[-1, 1]) translate([0, y*12.9, heigth-thick])  
			{
				cube([transmitter_length+5, 4.8, thick*2], center=true);
			}
		}
		translate([0, 0, transmitter_heigth-0.05])	hull()
		{
			translate([0, 18/2, 0]) cylinder(d=length-6, h=thick*2);
			translate([0,  -18/2, 0]) cylinder(d=length-6, h=thick*2);
		}
		
		translate([offset, 0, transmitter_heigth/2-0.05])  cube([transmitter_length+1, transmitter_width+1, transmitter_heigth+0.4], center=true);
		for(y=[-1, 1]) translate([0, y*43/2, -1])  cylinder(d=M3_dia, h=heigth+5);
		for(y=[-1, 1]) translate([0, y*43/2, thick])  cylinder(d=M3_head_hole, h=heigth+15);

		for(y = [-1,1]) {
			translate([0, y*25, 12]) 	rotate([y*35, 0, 0]) cube([length+12, 12, heigth+15], center=true);
			//rotate([0, -90, 0]) linear_extrude(height = 1, center = true, convexity = 10, twist = 0) polygon(points=[[0, 0],[heigth-thick, 0],[0, 10.8]], convexity=10);
		}

	}
		
	
	//translate([-32.8, 0, -13.4/2+heigth])	rotate([0, 0, 0]) led_plate(13.4);	
	
}

module video_transmitter_view()
{
	//translate([5, 0, 0]) rotate([0, 0, 0]) video_bracket_simple();
	translate([5, 0, 0]) rotate([0, 0, 0]) video_bracket();
	translate([-6, 0, 0]) rotate([0, 0, 0]) video_transmitter();
	translate([5, 0, -2]) rotate([0, 180, 0])  video_led_bracket();
}
//translate([80, 0, 0]) video_transmitter_view();
//translate([-30, 0, 0]) rotate([0, 0, 0]) video_bracket_simple();
translate([0, 0, 13]) rotate([0, 180, 0]) video_bracket();
translate([-70, 0, 0]) rotate([0, 0, 0])  video_led_bracket();

