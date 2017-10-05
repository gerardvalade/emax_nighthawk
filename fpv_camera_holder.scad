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


$fn= 30;

camera_width=32.19;	
plate_width=33;
//camera_width_fixing_hole=28;
hole_dia=1.8;
//holder_pad_heigth=14;
connector_depth = 5.1;

sony_camera_type =[28, 14];
eachine_camera_type =[27, 14];
function camera_width_fixing_hole(type) = type[0];
function holder_pad_heigth(type) = type[1];
thick=1.2;

// size is a vector [w, h, d]
module roundedBox(size, radius, sidesonly)
{
	rot = [ [0,0,0], [90,0,90], [90,90,0] ];
	if (sidesonly) {
		cube(size - [2*radius,0,0], true);
		cube(size - [0,2*radius,0], true);
		for (x = [radius-size[0]/2, -radius+size[0]/2],
				 y = [radius-size[1]/2, -radius+size[1]/2]) {
			translate([x,y,0]) cylinder(r=radius, h=size[2], center=true);
		}
	}
	else {
		cube([size[0], size[1]-radius*2, size[2]-radius*2], center=true);
		cube([size[0]-radius*2, size[1], size[2]-radius*2], center=true);
		cube([size[0]-radius*2, size[1]-radius*2, size[2]], center=true);

		for (axis = [0:2]) {
			for (x = [radius-size[axis]/2, -radius+size[axis]/2],
					y = [radius-size[(axis+1)%3]/2, -radius+size[(axis+1)%3]/2]) {
				rotate(rot[axis]) 
					translate([x,y,0]) 
					cylinder(h=size[(axis+2)%3]-2*radius, r=radius, center=true);
			}
		}
		for (x = [radius-size[0]/2, -radius+size[0]/2],
				y = [radius-size[1]/2, -radius+size[1]/2],
				z = [radius-size[2]/2, -radius+size[2]/2]) {
			translate([x,y,z]) sphere(radius);
		}
	}
}

module pad(d, h)
{	
	difference() {
		cylinder(d=d, h=h, center=true);	
		cylinder(d=hole_dia, h=h+10, center=true);	
	
	}
}
module camera_pad(type, d, h)
{
	for (x=[-1,1]) {
		for (y=[-1,1]) {
			translate([x*camera_width_fixing_hole(type)/2, y*camera_width_fixing_hole(type)/2, h/2]) cylinder(d=d, h=h, center=true);
		}
	}
}

module sony_camera(type)
{
	module vision_cone(a=120)
	{
		color("LightYellow", 0.1) {
		 	cylinder(h=cos(a/2)*80, r1=0, r2=sin(a/2)*80, center=false);
		}
		color("red") rotate([0, a/2, 0]) cylinder(h=85, d=0.4, center=false);
		color("red") rotate([0, -a/2, 0]) cylinder(h=85, d=0.4, center=false);
	}
	
	difference() {
		union() {
			color("brown") translate([0, 0, 1.7/2]) cube([32, 32, 1.7], center=true);
			translate([0, 0, 1.7]) color("gray") {
				translate([0, 0, 6.4/2]) roundedBox([16, 16, 8], 2, true);
				translate([0, 0, 0]) cylinder(d=15, h=14.5);
				translate([0, 0, 0]) cylinder(d=11.8, h=23);
				translate([0, 0, 23-3.3]) cylinder(d=14, h=3.3);
				
				hull()
				{
					translate([0, 19.5/2, 0]) cylinder(d=4, 3.15);
					translate([0, -19.5/2, 0]) cylinder(d=4, 3.15);
				}
				
			}
		}
		for (y=[-1,1]) {
			translate([0, y*19.5/2, -0.1]) cylinder(d=2, h=6);
		}
		translate([0, 0, -1]) 	camera_pad(type=type, d=3, h=20);
	
	}
	translate([0,0,22]) vision_cone(120);
	
}

module camera_bracket(type, thin=0.6)
{

	module plate(d=5, h=1.8)
	{
		translate([0, 0, thick/2]) roundedBox([plate_width, plate_width, thick], 2, true);
	}
	module plate_pad(d, h)
	{
		for (x=[-1,1]) {
			for (y=[-1,1]) {
				translate([x*plate_width_fixing_hole/2, y*plate_width_fixing_hole/2-holder_pad_offset, h/2]) cylinder(d=d, h=h, center=true);
			}
		}
	}
	module main_plate() {
		difference() {
			union(){
				plate();
				camera_pad(type, d=4.5, h=holder_pad_heigth(type));
				camera_pad(type, d=5.5, h=4);
			}
			//translate([0, 0, -1])  cylinder(d=40, h=5);
			translate([0, 0, -0.1]) roundedBox([17, 17, 2], 2, true);
			translate([0, 0, -1]) 	camera_pad(type, d=hole_dia, h=20);
			translate([0, 0, -1]) hull()
				{
					translate([0, 19.5/2, 0]) cylinder(d=4.5, 3.15);
					translate([0, -19.5/2, 0]) cylinder(d=4.5, 3.15);
				}
			
		}
	}
	translate([0, 0, 0]) main_plate();
	//translate([0, -50, 0]) top_plate();
}

module sony_camera_bracket()
{
	camera_bracket(sony_camera_type);
}
module sony_camera_view(type= sony_camera_type)
{
	translate([0, 0, 0]) rotate([0, -90, 0])  {
		sony_camera_bracket(type);
		translate([0, 0, holder_pad_heigth(type)+1.7]) rotate([0, 180, 0]) sony_camera(sony_camera_type);
	}

}
module eachine_camera_bracket()
{
	camera_bracket(eachine_camera_type);
}
module eachine_camera_view(type= eachine_camera_type)
{
	translate([0, 0, 0]) rotate([0, -90, 0])  {
		sony_camera_bracket(type);
		translate([0, 0, holder_pad_heigth(type)+1.7]) rotate([0, 180, 0]) sony_camera(sony_camera_type);
	}

}

//translate([0, 0, 0]) sony_camera_bracket();
translate([40, 0, 0]) eachine_camera_bracket();
//
//translate([0, 100, 0])  sony_camera_view();