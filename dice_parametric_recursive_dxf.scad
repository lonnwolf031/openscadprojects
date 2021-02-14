/*
    Author: Lonneke Kolkman
    LonnWolf.
*/

side = 40; // cube side size
engravingDepth = 3; 
scaleEngraving = 0.2;

module die(i) {
    if(i==0) {
        cube(side, center=true);
    }
    else {
        if(i%2==0) {
            difference() {
                rotate([90,0,0])die(i-1);
                engrave(i);
            }
        }
        else {
            difference() {
                rotate([0,90,0])die(i-1);
                engrave(i);
            }
        }
    }
}

module engrave(i) {
    engraveside = str("dxfSide",i,".dxf");
    translate([-0.5*side,-0.5*side,0.5*side])
    linear_extrude(height = engravingDepth, center=true)
    resize([scaleEngraving*side,scaleEngraving*side,0])
    import(engraveside);
}
die(6);