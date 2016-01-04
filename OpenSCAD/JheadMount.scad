$fn=80;

er=0.2;
eh=0.25;
baseX=30;
baseY=36.8+14;
baseZ=3;
baseMountZ=30;
translateX=-15;
eyeR=2;
rightSideX=8; // Set rightSideX=0 if support for fan duct are is not needed
jHeadElevation=18;

headTopToFanDuct=12.7;
fanDuctEdgeToMountHole=3;
fanDuctHW=30;
fanDuctMountEdge=5;

module fanDuctMount() {
    difference() {
        cube([fanDuctHW+2*fanDuctMountEdge,fanDuctHW+2*fanDuctMountEdge,fanDuctMountEdge]);
        translate([fanDuctMountEdge,fanDuctMountEdge,0]) {
            translate([fanDuctHW/2,fanDuctHW/2,-1]) cylinder(r=fanDuctHW/2,h=3); 
            translate([fanDuctEdgeToMountHole,fanDuctEdgeToMountHole,-1]) cylinder(r=1.7,h=3);
            translate([fanDuctEdgeToMountHole,fanDuctHW-fanDuctEdgeToMountHole,-1]) cylinder(r=1.7,h=3);
            translate([fanDuctHW-fanDuctEdgeToMountHole,fanDuctEdgeToMountHole,-1]) cylinder(r=1.7,h=3);
            translate([fanDuctHW-fanDuctEdgeToMountHole,fanDuctHW-fanDuctEdgeToMountHole,-1]) cylinder(r=1.7,h=3);
        }
        #hull() {
            translate([fanDuctMountEdge-eh,fanDuctMountEdge-eh,1]) cube([fanDuctHW+2*eh,fanDuctHW+2*eh,0.001]);
            translate([1,1,fanDuctMountEdge]) cube([fanDuctHW+2*fanDuctMountEdge-2,fanDuctHW+2*fanDuctMountEdge-2,0.001]);
        }
    }

}

module nutCutOut() {
    rotate([0,0,90]) cylinder(r=3.45,h=4.5,$fn=6);
}

module headCutOut() {
    cylinder(r=4,h=10);
}

module jhead() {
    jheadHAdj=0.45;
    jheadRAdj1=0.2;
    jheadRAdj2=0.3;
    cylinder(r=8+jheadRAdj1,h=3+jheadHAdj);
    cylinder(r=6+jheadRAdj2,h=12.7);
    translate([0,0,9-jheadHAdj]) cylinder(r=8+jheadRAdj1,h=3.7+2);
    
    //#translate([0,0,-23]) cylinder(r=22.3/2,h=10); //enable to see E3Dv6 radius
}


module mountScrew() {
    cylinder(r=1.5+er,h=50);
}


module base() {
    cube([baseX+rightSideX,baseY,baseZ]);
    translate([2,baseY-25,baseZ]) minkowski() {
      cube([baseX-4+rightSideX,baseY-25-3,0.001]);
      sphere(r=2);  
    }
    translate([0,baseY-12.7,0]) difference() {
         cube([baseX,12.7,baseMountZ]);
         translate([0,0,-1])cylinder(r=4,h=80);
         translate([baseX,0,-1]) cylinder(r=4,h=80);
    }
}

module eye() {
    difference() {
        minkowski() {
            cube([eyeR*2,eyeR*2,0.001]);
            translate([2,2,2]) sphere(r=2);
        }
        translate([(eyeR*2+4)/2,(eyeR*2+4)/2,-2]) cylinder(r=eyeR,h=10);
    }
}

module mount() {
    difference() {
        translate([translateX,0,0]) base();
        translate([0,baseY-12.8,jHeadElevation]) rotate([-90,0,0]) jhead();
        translate([7.5,18.5,-2]) mountScrew(); 
        translate([-7.5,18.5,-2]) mountScrew();  
        translate([translateX+baseX-4,baseY-5,-2]) {
            translate([0,0,1.5]) nutCutOut();
            mountScrew();
        } 
        translate([-translateX-baseX+4,baseY-5,-2]) {
            translate([0,0,1.5]) nutCutOut();
            mountScrew();
        }
        translate([-40,32+2,-2]) cube([80,8,3.5]); 
    }
    translate([translateX+baseX-1+rightSideX,baseY-(eyeR*2+4),0]) eye();
    translate([-translateX-baseX-(eyeR*2+4)+1,baseY-(eyeR*2+4),0]) eye();
    translate([translateX+baseX-(eyeR*2+4),baseY-1,0]) eye();
    translate([-translateX-baseX,baseY-1,0]) eye();
    translate([translateX+baseX-1,baseY-(eyeR*2+4),baseMountZ-4]) eye();
    translate([-translateX-baseX-(eyeR*2+4)+1,baseY-(eyeR*2+4),baseMountZ-4]) eye();
    translate([translateX+baseX-(eyeR*2+4),baseY-1,baseMountZ-4]) eye();
    translate([-translateX-baseX,baseY-1,baseMountZ-4]) eye();
}

module coolingDuctArm() {
    difference() {
        union() {
            translate([0,-5,0]) cylinder(r=10,h=baseZ);
            translate([5,-5,0]) cylinder(r=3,h=jHeadElevation-0.8-eh);
            translate([5,-5,0]) cylinder(r=5,h=6);
        }
        translate([5,-5,-1]) cylinder(r=1.5+2*er,h=20);
        translate([5,-5,-5+3]) nutCutOut();
    }
}

translate([22,27,0]) coolingDuctArm(); // remove this line to remove the cooling duct arm

difference() {
    mount();
    translate([-40,0,jHeadElevation-eh]) cube([80,80,80]);
}

translate([0,30,30]) rotate([180,0,0]) difference() {
    mount();
    translate([-40,-2,-1]) cube([80,80,jHeadElevation+eh+1]);
}


