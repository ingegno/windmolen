// Licence: Creative Commons, Attribution
// Created: 17-10-2014 by bmcage http://www.thingiverse.com/bmcage

// windmill wiekhouder

rack = "no";  //[yes, no]
//number in x direction
rack_x = 5;
//distance in rack
rack_dist_x = 42;
//number in y directionuse 
rack_y = 2;
//distance in rack
rack_dist_y = 35;


if (rack == "yes") {
 translate([-(rack_x-1)/2 * rack_dist_x,-(rack_y-1)/2 * rack_dist_y,0])
 for (i=[1:rack_x]) {
   for (j=[1:rack_y]) {
     translate([(i-1)*rack_dist_x, (j-1)*rack_dist_y, 0])
      translate([0,5,0]) wiekholder();
   }
 }
} else {
  translate([0,0,0]) wiekholder();
}


use <utils/build_plate.scad>;

//for display only, doesn't contribute to final object
build_plate_selector = 0; //[0:Replicator 2,1: Replicator,2:Thingomatic,3:Manual]

//when Build Plate Selector is set to "manual" this controls the build plate x dimension
build_plate_manual_x = 100; //[100:400]

//when Build Plate Selector is set to "manual" this controls the build plate y dimension
build_plate_manual_y = 100; //[100:400]

build_plate(build_plate_selector,build_plate_manual_x,build_plate_manual_y); 

//modules

diam=60;
h = 2;
baseh = 8;
indiam=10;
wiekh = 4;
bouth = 0.3;
schroefd = 3; //m3 to fix the blades
height=baseh+wiekh+bouth;
wiekwidth = 15;
holderwidth=wiekwidth+4;
withpulley = true;

eps=1e-1;

module base() {
	difference() {
		cylinder(d=diam, h=height,$fn=50);
		translate([0,0,-eps])cylinder(d=indiam,h=2*h+height+2*eps,$fn=50);
		difference() {
			translate([0,0,-1*eps])cylinder(d=diam-2*holderwidth, h=height+2*eps,$fn=50);
			translate([0,0,-2*eps])cylinder(d=indiam+2*holderwidth, h=height+4*eps,$fn=50);
		}
	}
  translate([indiam/2,-holderwidth/2,0])cube([(diam-indiam)/2-holderwidth,holderwidth,height]);
  rotate([0,0,90])translate([indiam/2,-holderwidth/2,0])cube([(diam-indiam)/2-holderwidth,holderwidth,height]);
  rotate([0,0,180])translate([indiam/2,-holderwidth/2,0])cube([(diam-indiam)/2-holderwidth,holderwidth,height]);
  rotate([0,0,-90])translate([indiam/2,-holderwidth/2,0])cube([(diam-indiam)/2-holderwidth,holderwidth,height]);
}

module wiek() {
for (i=[0:3]) {
rotate([0,0,i*90]) translate([-diam,0,h+sin(30)*wiekwidth/2+cos(30)*(wiekh/2+bouth/2)]) rotate([30,0,0]) translate([0,-wiekwidth/2,-wiekh/2-bouth/2]) cube([diam,wiekwidth,wiekh+bouth]);
}
//rotate([0,0,90])translate([-diam,-wiekwidth/2,h]) rotate([30,0,0])  cube([2*diam,wiekwidth,wiekh+bouth]);
}

module boutgat() {
  translate([indiam/2+schroefd/2+6,0,height-h-eps])cylinder(d=schroefd,h=2*h, $fn=20);
  translate([diam/2-schroefd/2-6,0,height-h-eps])cylinder(d=schroefd,h=2*h, $fn=20);
}

module boutgaten() {
  boutgat();
  rotate([0,0,90])  boutgat();
  rotate([0,0,180])  boutgat();
  rotate([0,0,-90])  boutgat();
}

module wiekholder() {
  translate([0,0,eps])mirror([0,0,1]) {
	difference() {
		base();
		wiek();
      boutgaten();
	}
   difference() {
	   cylinder(d=indiam+eps, h=height+eps,$fn=50);
		translate([0,0,-eps])cylinder(d=schroefd, h=height+eps+2*eps,$fn=50);
	}
	}
	if (withpulley) {
		pulley();
		difference() {
			translate([0,0,-h])cylinder(d=diam, h=h,$fn=50);
			translate([0,0,-h-eps])cylinder(d=4, h=h+2*eps,$fn=50);
		}
	}
}

//wiek();
//optional belt
// based on thing 5620  - in public domain

//Diameter of the pulley (mm)
pulleyD = 54; //[10:200]
//Diameter screw hole in middle (mm)
innerD = pulleyD-6; // [0:10]
//Width of the pulley belt (mm)
beltwidth= 3; //[1:6]
//facets on the pulley
facets = 60; //[10:100]

//height lips that hold the belt on (added to pullyD) (mm)
lipheight = 3; //[1:10]
//thickness of the upper lip (mm)
lipthickness = 1; //[0:10]
//Angle the top lip overhang makes (increase to lower the profile)
topangle = 45; 
//number of holes in the section
holenr = 0; //[0:10]
//gap size to avoid holes interconnecting (increase on interconnect)
gap = 5; //[0:20]
//second row of holes or not
secondholes = "True";  //[True, False]

function pi()=3.14159265358979323846;

$fn=facets; //faceting

module pulley() {
//construction
translate([0,0,0])
	difference(){
	union(){
		cylinder(r=lipheight+pulleyD/2, h=lipthickness);
		cylinder(r=pulleyD/2, h = lipthickness*2+beltwidth+lipheight*cos(topangle));
		translate([0,0,lipthickness*2+beltwidth+lipheight*cos(topangle)])cylinder(r=lipheight+pulleyD/2, h=lipthickness);
		translate([0,0,beltwidth+lipthickness*2])cylinder(r1=pulleyD/2, r2=lipheight+pulleyD/2, h=lipheight*cos(topangle));
		}
		translate([0,0,-1])cylinder(r=innerD/2, h=lipthickness*2+beltwidth+lipheight*2);
   	holes();
}
}

widthhole=2*pi()*((pulleyD/2-innerD/2)/2-holenr/2)/(holenr+1);
lengthhole=(pulleyD-innerD)/2-gap;

module holes(){
	for (i=[1:holenr]) {
		rotate([0,0,i*360/holenr])
		translate([lengthhole/2+innerD/2+gap/2,0,-1]) scale([lengthhole/2,widthhole/2,1]) 
			cylinder(r=1, h=2*lipthickness+beltwidth+lipheight*4);
        if (secondholes == "True") {
            rotate([0,0,i*360/holenr+360/holenr/2])
            translate([3*lengthhole/4+innerD/2+gap/2,0,-1]) scale([lengthhole/4,widthhole/3,1]) 
                cylinder(r=1, h=2*lipthickness+beltwidth+lipheight*4);
        }
	}
}
