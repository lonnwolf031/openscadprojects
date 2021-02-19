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

polyline[n-1][x] = 0;
polyline[n-1][y] = 0;
polyline[n-1][z] = 0;

prevlnelem = 0;

prevpolyline[n-1][x] = 0;
prevpolyline[n-1][y] = 0;
prevpolyline[n-1][z] = 0;

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
        // extrude only if there is no more than 2 points
        if(numpoints < 2) {
            // from polyline at n linear extrude until [1]
        }

        if(n>=2) {
            // calc angle
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

            //if n >0
              // translate to current point --> to rotation points
              //



            // always: translate from origin to previous point
            // always: rotate from Origin
            // if n >0 translate margin
            //linear extrude until - margin unless n==max

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
                //linear extrude until point
            }


            // if n =>2 linear extrude from prevprev + margin until prev - margin


            // here: rotate extrude
            rot_angle = 180 - alpha;

        }


    }
    // for next iteration store current point
    prevlnelem = lnelem;
    prevpolyline[n-1][x] = polyline[n-1][x];
    prevpolyline[n-1][y] = polyline[n-1][y];
    prevpolyline[n-1][z] = polyline[n-1][z];
    polyline[n-1][x] = polyline[n][x];
    polyline[n-1][y] = polyline[n][y];
    polyline[n-1][z] = polyline[n][z];


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
