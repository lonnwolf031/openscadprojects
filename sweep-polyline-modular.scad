polyline = [[0,0,0],[2,2,2],[6,4,8],[10,12,14]];


/*

(foo.length); //2
(foo[0].length); //3

    TotalWidth = dxf_dim(file="drawing.dxf", name="TotalWidth",
                        layer="SCAD.Origin", origin=[0, 0], scale=1);
        echo(str(polyline[n][x])); //prints x point

        translate([5,0,0])
    */

// from onwards in module

x = 0;
y = 1;
z = 2;

prevx = 0;
prevy = 0;
prevz = 0;

prevlnelem = 0;

prevprevx = 0;
prevprevy = 0;
prevprevz = 0;

lnelem = 0;

lenxcomp = 0;
lenycomp = 0;
lenzcomp = 0;

section = 10;
extra_space = 0.25*section;
 // margin will be defined later based on angle
margin = 0;


numpoints = len(polyline);

for (n =[0:numpoints-1]) {
    lenxcomp = 0;
    lenycomp = 0;
    lenzcomp = 0;
    // if not first point
    if(n != 0) {
        //calc length of vector
        lnelem = abs(sqrt(
        pow(abs((polyline[n][x]-prevx)),2)+
        pow(abs((polyline[n][y]-prevy)),2)+
        pow(abs((polyline[n][z]-prevz)),2)));
        // calc direction angles from cosines
        anglxcomp  = acos(lenxcomp/abs(lnelem));
        anglycomp  = acos(lenycomp/abs(lnelem));
        anglzcomp  = acos(lenzcomp/abs(lnelem));

        // extrude only if there is no more than 2 points
        if(numpoints < 2) {
            // from polyline at n linear extrude until [1]
        }

        if(n>=2) {
            // calc angle
            alpha = acos((polyline[n][x] * prevx +
            polyline[n][y] * prevy +
            polyline[n][z] * prevz)
            / ( (abs(sqrt(
            pow(abs(polyline[n][x]),2)+
            pow(abs(polyline[n][y]),2)+
            pow(abs(polyline[n][z]),2)))*
                abs(sqrt(
            pow(abs(prevx),2)+
            pow(abs(prevy),2)+
            pow(abs(prevz),2))))));
            // here comes def of margin
            margin = tan(0.5*(180-alpha))*(0.5*section+extra_space);
            // here: first move to point (translate to point)

            // then: calculate and rotate for direction (from origin to point)

            // here: linear extude until:
            // if n = 2 linear extrude until first fillet n=1 (prevprev - prev - margin)

            if(n==2) {
                translate([prevprevx,prevprevy,prevprevz])
                linear_extrude(height = (prevlnelem-margin), center = true)square([20, 10], center = true);
            }
            if(n>=2 && n < numpoints-1) {
                translate([prevprevx,prevprevy,prevprevz])
                //linear extrude from point + margin in direction until point - margin
                linear_extrude(height = (prevlnelem-margin), center = true)square([20, 10], center = true);
            }
            if(n == numpoints-1) {
                //linear extrude until point
            }


            // if n =>2 linear extrude from prevprev + margin until prev - margin


            // here: rotate extrude
            rot_angle = 180 - alpha;

        }


    }
    // for next iteration store current point
    prevlnelem = lnelem;
    prevprevx = prevx;
    prevprevy = prevy;
    prevprevz = prevz;
    prevx = polyline[n][x];
    prevy = polyline[n][y];
    prevz = polyline[n][z];


}

module shape() {
    square(size = [2, 2], center = true);
}



module sweep_polyline(shape, polyline) {

}
rotate([90,0,0])
translate([20, -30, 0])
        linear_extrude(height = 20, center = true)
            square([20, 10], center = true);
