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

prevlnelem = 0;


lnelem = 0;

section = 10;
extra_space = 0.25*section;
 // margin will be defined later based on angle
margin = 0;


numpoints = len(polyline);

for (n =[0:numpoints-1]) {
    // if not first point
    if(n != 0) {
        //calc length etc
        lnelem = abs(
          sqrt(
            pow(abs((polyline[n][x]-polyline[n-1][x])),2)+
            pow(abs((polyline[n][y]-polyline[n-1][y])),2)+
            pow(abs((polyline[n][z]-polyline[n-1][z])),2)
          )
        );
        anglexaxis = arccos((abs(polyline[n][x]-polyline[n-1][x])/lnelem);
        angleyaxis = arccos((abs(polyline[n][y]-polyline[n-1][y])/lnelem);
        anglezaxis = arccos((abs(polyline[n][z]-polyline[n-1][x])/lnelem);

        lnxcomp = abs(polyline[n][x]-polyline[n-1][x]);
        lnycomp = abs(polyline[n][y]-polyline[n-1][y]);
        lnzcomp = abs(polyline[n][z]-polyline[n-1][z]);

        // if n>=2 there will be a rotate between two vectors
        if(n>=2) {
            // calc angle between vectors
            alpha = acos((polyline[n][x] * polyline[n-1][x] +
            polyline[n][y] * polyline[n-1][y] +
            polyline[n][z] * polyline[n-1][z])
            / ( (abs(sqrt(
                  pow(abs(polyline[n][x]),2)+
                  pow(abs(polyline[n][y]),2)+
                  pow(abs(polyline[n][z]),2)))*
                abs(sqrt(
                  pow(abs(polyline[n-1][x]),2)+
                  pow(abs(polyline[n-1][y]),2)+
                  pow(abs(polyline[n-1][z]),2))
            ))));
            // here comes def of margin
            margin = tan(0.5*(180-alpha))*(0.5*section+extra_space);
            // here: rotate extrude
            rot_angle = 180 - alpha;
            // calculate translation distance
            rot_dist = sin(0.5*alpha)/(0.5*section+extra_space);
              // translate to current point --> to rotation points

            translate([polyline[n-1][x],polyline[n-1][y],polyline[n-1][z]])

            //rotate(0.5*alpha)

            // always: translate from origin to previous point
            // always: rotate from Origin
            // if n >0 translate margin
            //linear extrude until - margin unless n==max

            // extrude only if there is no more than 2 points


        }
        // LINEAR EXTRUDE HERE
        if(numpoints < 2) {
            // from polyline at n linear extrude until [1]
        }

        if(n==2) {
            translate([prevpolyline[n-1][x],prevpolyline[n-1][y],prevpolyline[n-1][z]])
            linear_extrude(height = (prevlnelem-margin), center = true)square([20, 10], center = true);
        }
        if(n>=2 && n < numpoints-1) {
            translate([prevpolyline[n-1][x],prevpolyline[n-1][y],prevpolyline[n-1][z]])
            //linear extrude from point + margin in direction until point - margin
            linear_extrude(height = (prevlnelem-margin), center = true)square([20, 10], center = true);
        }
        if(n == numpoints-1) {
            //linear extrude until last point
        }

    }
    // for next iteration store current point
    prevlnelem = lnelem;



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
