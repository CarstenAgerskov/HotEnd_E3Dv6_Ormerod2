// fan duct for 30 mm fan
$fn=60;

ductPart1X=20;
ductPart1Y=3;
ductPart1Tx=0;

ductPart2R=10;
ductPart2H=20;
ductPart2Tx=4;

ductPart3R=15;
ductPart3H=10;
ductPart3Tx=8;

eR= 0.1;

module innerDuct() {
    hull() {
      translate([0,ductPart1Tx,ductPart2H+ductPart3H]) rotate([45,0,0]) cube([ductPart1X,ductPart1Y,0.001], center=true);
      translate([0,ductPart2Tx,ductPart3H]) cylinder(r=ductPart2R, h=0.001);    
    }

    hull () {
      translate([0,ductPart2Tx,ductPart3H]) cylinder(r=ductPart2R, h=0.001);    
      translate([0,ductPart3Tx,0]) cylinder(r=ductPart3R, h=0.001);    
    }
}

module outerDuct() {
    minkowski() {
        innerDuct();
        cube(1.5, center=true);
    }
}

module handle() {
    difference() {
        hull() {
            translate([-0.8,ductPart3Tx,0]) cube([1.6,ductPart3R,10]);
            translate([-0.8,1.5*ductPart3R,14]) rotate([0,90,0]) cylinder(r=5,h=1.6);
        }
        translate([-2,1.5*ductPart3R,14]) rotate([0,90,0]) cylinder(r=1.5+eR, h=10); 
    }
}

module holes() {
        holePos= [-12.05,12.05];
        for( i = holePos ) for( j = holePos ) {
            translate([i,j,-1]) cylinder(r=1.5+eR,h=10);
        }        
        for( i = holePos ) {
            j = 12.05;
            translate([i,j,1.5/2]) cylinder(r=3+eR,h=10);
        }
}

module duct() {
    difference() {
        union() {
            outerDuct();
            handle();
        }
        innerDuct();
        translate([0,ductPart1Tx,ductPart2H+ductPart3H]) rotate([45,0,0]) translate([0,0,1]) cube([ductPart1X,ductPart1Y,2], center=true);
        translate([0,ductPart3Tx,-1]) cylinder(r=ductPart3R, h=1.2);    
        translate([0,ductPart3Tx,0]) holes();
    }
}

module fanMount() {
    translate([0,ductPart3Tx,0]) {
        difference() {
            cube([2*ductPart3R+1,2*ductPart3R+1,1.5],center=true);
            holes();
            cylinder(r=ductPart3R-1,h=2,center=true);
        }
    }
}


module coolingDuct() {
    fanMount();
    duct();
}

coolingDuct();
