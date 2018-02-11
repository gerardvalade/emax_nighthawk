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

use <nighthawk_frame.scad>;
use <nighthawk_video.scad>;
use <fpv_camera_holder.scad>;
use <nighthawk_gps.scad>;
use <sony_camera_holder.scad>
use <nighthawk_fc_receiver.scad>


//nighthawk_view();

//translate([0, 0, -12]) rotate([0, 0, 90]) nighthaw_frame();
//translate([0, 0, -2.15]) rotate([0, 0, 0]) nighthaw_plate();

translate([0, 0, 2.5]) {
	translate([0, 0, 0])rotate([0, 0, 180]) frsky_view3();
	
	translate([-40, 0, 0]) rotate([0, 0, 180]) gps_bracket_view();

	translate([-90, 0, 0]) rotate([0, 0, 0]) video_transmitter_view();
	
	translate([102.5, 0, 17.5])  sony_camera_view();
}

nighthawk_view();
