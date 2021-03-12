polyline = [[0,0,0],[2,2,2],[6,4,8],[10,12,14]];
t=3;

lnelemTemp = 0;

section = 10;
extra_space = 0.25*section;
 // margin will be defined later based on angle
margin = 0;

numpoints = len(polyline);

for (n =[0:numpoints-1]) {
  // if not first point, because at P0 there is nothing to do
    if(n != 0) {
      // at P1 (and if larger than 1 polyline) and further there are rotates
      if(n >= 1 && numpoints >= 2)
      {
        translate(xcoordProtate([polyline[n-1][x],polyline[n-1][y],polyline[n-1][z]],[polyline[n][x],polyline[n][y],polyline[n][z]],[polyline[n+1][x],polyline[n+1][y],polyline[n+1][z]]),
          ycoordProtate([polyline[n-1][x],polyline[n-1][y],polyline[n-1][z]], [polyline[n][x],polyline[n][y],polyline[n][z]],[polyline[n+1][x],polyline[n+1][y],polyline[n+1][z]),
          zcoordProtate([polyline[n-1][x],polyline[n-1][y],polyline[n-1][z]], [polyline[n][x],polyline[n][y],polyline[n][z]],[polyline[n+1][x],polyline[n+1][y],polyline[n+1][z]))
        //rotate()

        //translate and rotate
        // rotate extrude
        // end of extrude - margin - translate from P to projection of margin (length) to x, y, z
      }

      // LINEAR EXTRUDE HERE
      if(numpoints == 2) {
          // from polyline at n linear extrude until [1]
      }

      if(n>=2 && n < numpoints-1) {

      }
      if(n == numpoints-1) {
          //linear extrude until last point
      }
      prevlnelem = lnelem;
  }

}

module shape() {
    square(size = [2, 2], center = true);
}

function dirvx([x0,y0,z0], [x1,y1,z1]) = x1-x0; //replace polyline... by x1 and x0
function dirvy([x0,y0,z0], [x1,y1,z1]) = y1-y0;
function dirvz([x0,y0,z0], [x1,y1,z1]) = z1-z0;

function equationx(x) = x1 + dirvx * x;
function equationy(y) = y1 + dirvy * y;
function equationz(z) = z1 + dirvz * z;

function partderiveqx(x) = dirvx;
function partderiveqy(y) = dirvy;
function partderiveqz(z) = dirvz;

function symmeqxv([x0,y0,z0], [x1,y1,z1]) = (x - x0) / dirvx([x0,y0,z0], [x1,y1,z1]);
function symmeqyv([x0,y0,z0], [x1,y1,z1]) = (y - y0) / dirvy([x0,y0,z0], [x1,y1,z1]);
function symmeqzv([x0,y0,z0], [x1,y1,z1]) = (z - z0) / dirvz([x0,y0,z0], [x1,y1,z1]);

function lnelem([x0,y0,z0], [x1,y1,z1]) = abs(
  sqrt(
    pow(abs(x1 - x0),2)+
    pow(abs(y1 - y0),2)+
    pow(abs(z1 - z0),2)
  )
);

// figure out how to divide this into x, y z components
function rotateVectorProjOntoVect([xPrevious,yPrevious,zPrevious], [xCurrent,yCurrent,zCurrent], [xNext,yNext,zNext]) =
  let (vecXrotate = xcoordProtate([xPrevious,yPrevious,zPrevious], [xCurrent,yCurrent,zCurrent], [xNext,yNext,zNext]))
  let (vecYrotate = ycoordProtate([xPrevious,yPrevious,zPrevious], [xCurrent,yCurrent,zCurrent], [xNext,yNext,zNext]))
  let (vecZrotate = zcoordProtate([xPrevious,yPrevious,zPrevious], [xCurrent,yCurrent,zCurrent], [xNext,yNext,zNext]))
(dotproduct([xCurrent,yCurrent,zCurrent, [vecXrotate,vecYrotate,vecZrotate])/lnelem([x0,y0,z0], [x1,y1,z1])^2)*(xCurrent,yCurrent,zCurrent);

function dotproduct([x0,y0,z0], [x1,y1,z1]) = x0 * x1 + y0 * y1 + z0 * z1;

function anglexaxis([x0,y0,z0], [x1,y1,z1])  = arccos((abs(x1-x0)/lnelem([x0,y0,z0], [x1,y1,z1]) );
function angleyaxis([x0,y0,z0], [x1,y1,z1])  = arccos((abs(y1-y0)/lnelem([x0,y0,z0], [x1,y1,z1]) );
function anglezaxis([x0,y0,z0], [x1,y1,z1])  = arccos((abs(z1-x0)/lnelem([x0,y0,z0], [x1,y1,z1]) );

function lnxcomp([x0,y0,z0], [x1,y1,z1]) = abs(x1-x0);
function lnycomp([x0,y0,z0], [x1,y1,z1]) = abs(y1-y0);
function lnzcomp([x0,y0,z0], [x1,y1,z1]) = abs(z1-z0);

// calc angle between vectors, 0 being n, 1 being n+1
function theta([polySegmentUntilNx,polySegmentUntilNy,polySegmentUntilNz], [polySegmentFromNx,polySegmentFromNy,polySegmentFromNz]) = acos(
(lnxcomp(polySegmentFromNx) * lnxcomp(polySegmentToNx) +
lnycomp(polySegmentFromNy) * lnycomp(polySegmentToNy) +
lnzcomp(polySegmentFromNz) * lnzcomp(polySegmentToNz))
/ ( (abs(sqrt(
      pow(abs(lnxcomp(polySegmentToNx)),2)+
      pow(abs(lnycomp(polySegmentToNy)),2)+
      pow(abs(lnzcomp(polySegmentToNz)),2)))*
    abs(sqrt(
      pow(abs(lnxcomp(polySegmentFromNx)),2)+
      pow(abs(lnycomp(polySegmentFromNy)),2)+
      pow(abs(lnzcomp(polySegmentFromNz)),2))
))));



// functions for rotate vector where x,y,z 0 = n-1, x,y,z 1 = n
function lnRotationPointVector([xPrevious,yPrevious,zPrevious], [xCurrent,yCurrent,zCurrent], [xNext,yNext,zNext])) = (0.5*section+extra) / sin(0.5*theta([xCurrent,yCurrent,zCurrent],[xNext,yNext,zNext])));

function anglPolylineSegmentXaxis([xPrevious,yPrevious,zPrevious], [xCurrent,yCurrent,zCurrent], [xNext,yNext,zNext]) = anglexaxis([xPrevious,yPrevious,zPrevious], [xCurrent,yCurrent,zCurrent]) + theta([xCurrent,yCurrent,zCurrent], [xNext,yNext,zNext]) - 180;
function anglPolylineSegmentYaxis([xPrevious,yPrevious,zPrevious], [xCurrent,yCurrent,zCurrent], [xNext,yNext,zNext]) = angleyaxis([xPrevious,yPrevious,zPrevious], [xCurrent,yCurrent,zCurrent]) + theta([xCurrent,yCurrent,zCurrent], [xNext,yNext,zNext]) - 180;
function anglPolylineSegmentZaxis([xPrevious,yPrevious,zPrevious], [xCurrent,yCurrent,zCurrent], [xNext,yNext,zNext]) = anglezaxis([xPrevious,yPrevious,zPrevious], [xCurrent,yCurrent,zCurrent]) + theta([xCurrent,yCurrent,zCurrent], [xNext,yNext,zNext]) - 180;

function xcompRotationVector([xPrevious,yPrevious,zPrevious], [xCurrent,yCurrent,zCurrent], [xNext,yNext,zNext])) = lnRotationPointVector([xPrevious,yPrevious,zPrevious], [xCurrent,yCurrent,zCurrent]) * cos(anglPolylineSegmentXaxis([xPrevious,yPrevious,zPrevious], [xCurrent,yCurrent,zCurrent], [xNext,yNext,zNext])));
function ycompRotationVector([xPrevious,yPrevious,zPrevious], [xCurrent,yCurrent,zCurrent], [xNext,yNext,zNext])) = lnRotationPointVector([xPrevious,yPrevious,zPrevious], [xCurrent,yCurrent,zCurrent]) * cos(anglPolylineSegmentYaxis([xPrevious,yPrevious,zPrevious], [xCurrent,yCurrent,zCurrent], [xNext,yNext,zNext])));
function zcompRotationVector([xPrevious,yPrevious,zPrevious], [xCurrent,yCurrent,zCurrent], [xNext,yNext,zNext])) = lnRotationPointVector([xPrevious,yPrevious,zPrevious], [xCurrent,yCurrent,zCurrent]) * cos(anglPolylineSegmentZaxis([xPrevious,yPrevious,zPrevious], [xCurrent,yCurrent,zCurrent], [xNext,yNext,zNext])));

function xcoordProtate([xPrevious,yPrevious,zPrevious], [xCurrent,yCurrent,zCurrent], [xNext,yNext,zNext]) = xcompRotationVector([xPrevious,yPrevious,zPrevious], [xCurrent,yCurrent,zCurrent], [xNext,yNext,zNext])) + xPrevious;
function ycoordProtate([xPrevious,yPrevious,zPrevious], [xCurrent,yCurrent,zCurrent], [xNext,yNext,zNext]) = ycompRotationVector([xPrevious,yPrevious,zPrevious], [xCurrent,yCurrent,zCurrent], [xNext,yNext,zNext])) + yPrevious;
function zcoordProtate([xPrevious,yPrevious,zPrevious], [xCurrent,yCurrent,zCurrent], [xNext,yNext,zNext]) = zcompRotationVector([xPrevious,yPrevious,zPrevious], [xCurrent,yCurrent,zCurrent], [xNext,yNext,zNext])) + zPrevious;
