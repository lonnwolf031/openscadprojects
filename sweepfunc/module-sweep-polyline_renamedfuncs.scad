polyline = [[0,0,0],[2,2,2],[6,4,8],[10,12,14]];
x = 0;
y = 1;
z = 2;

section = 10;
extra_space = 0.25*section;

numpoints = len(polyline);

for (n =[0:numpoints-1]) {
  // if not first point, because at P0 there is nothing to do

  // check if three value list
  pCur = polyline[n];
  if(n >= 1) {
    pPrev = polyline[n-1];
  }
  if(n < numpoints) {
    pNext = polyline[n+1];
  }

  if ((len(pPrev) == 3 || n<1) && len(pCur) == 3 && (len(pNext) == 3 || n == numpoints)) {
    if(n != 0) {
      // at P1 (and if larger than 1 polyline) and further there are rotate extrudes
      if(n >= 1 && numpoints >= 2)
      {
        tempX = xcoordProtate([pPrev[0],pPrev[1],pPrev[2]],[pCur[0],pCur[1],pCur[2]],[pNext[0],pNext[1],pNext[2]]);
        tempY = ycoordProtate([pPrev[0],pPrev[1],pPrev[2]], [pCur[0],pCur[1],pCur[2]],[pNext[0],pNext[1],pNext[2]]);
        tempZ = zcoordProtate([pPrev[0],pPrev[1],pPrev[2]], [pCur[0],pCur[1],pCur[2]],[pNext[0],pNext[1],pNext[2]]);
        translate([tempX,tempY,tempZ])
        rotate([anglexaxis([tempX,tempY,tempZ], [pCur[0],pCur[1],pCur[2]]),
        angleyaxis([tempX,tempY,tempZ], [pCur[0],pCur[1],pCur[2]]),
        anglezaxis([tempX,tempY,tempZ], [pCur[0],pCur[1],pCur[2]])])
        rotate_extrude(angle = theta([pPrev[0],pPrev[1],pPrev[2]],[pCur[0],pCur[1],pCur[2]]))
        shape();
      }

      // LINEAR EXTRUDE HERE
      if(numpoints == 2) {
          // from polyline at n linear extrude until [1]
          translate([pCur[0],pCur[1],pCur[2]])
          /// rotate angles from things
          rotate(anglexaxis([pCur[0],pCur[1],pCur[2]], [pNext[0],pNext[1],pNext[2]]),
          angleyaxis([pCur[0],pCur[1],pCur[2]], [pNext[0],pNext[1],pNext[2]]),
          anglezaxis([pCur[0],pCur[1],pCur[2]], [pNext[0],pNext[1],pNext[2]]))

          linear_extrude(height = lnelem([pCur[0],pCur[1],pCur[2]], [pNext[0],pNext[1],pNext[2]]), center = true)
          shape();
      }

      if(n>=2 && n < numpoints-1) {
        // translate to margin
        tempCoordMarginX = rotateVectorProjOntoVectXBeginNext([xPrevious,yPrevious,zPrevious], [xCurrent,yCurrent,zCurrent], [xNext,yNext,zNext]);
        tempCoordMarginY = rotateVectorProjOntoVectXBeginNext([xPrevious,yPrevious,zPrevious], [xCurrent,yCurrent,zCurrent], [xNext,yNext,zNext]);
        tempCoordMarginZ = rotateVectorProjOntoVectXBeginNext([xPrevious,yPrevious,zPrevious], [xCurrent,yCurrent,zCurrent], [xNext,yNext,zNext]);
        translate([tempCoordMarginX,tempCoordMarginY,tempCoordMarginZ])
        //rotate towards  n+1
        rotate(anglexaxis([tempCoordMarginX,tempCoordMarginY,tempCoordMarginZ], [pCur[0],pCur[1],pCur[2]]),
        angleyaxis([tempCoordMarginX,tempCoordMarginY,tempCoordMarginZ], [pCur[0],pCur[1],pCur[2]]),
        anglezaxis([tempCoordMarginX,tempCoordMarginY,tempCoordMarginZ], [pCur[0],pCur[1],pCur[2]]))
        linear_extrude(height = (lnelem([pCur[0],pCur[1],pCur[2]], [pNext[0],pNext[1],pNext[2]]) - (2 * margin)), center = true)
        shape();

      }
      if(n == numpoints-1) {
          //linear extrude until last point
          //translate and rotate
          linear_extrude(height = (lnelem([pCur[0],pCur[1],pCur[2]], [pNext[0],pNext[1],pNext[2]]) - margin), center = true)
          shape();
      }
    }
  }
}

module shape() {
    square(size = [2, 2], center = true);
}

// every argument is an [x,y,z] vector
function margin(polySegmentUntilN, polySegmentFromN) =
let (polySegmentUntilNx = polySegmentUntilN[0]) let (polySegmentUntilNy = polySegmentUntilN[1]) let (polySegmentUntilNz = polySegmentUntilN[2])
let (polySegmentFromNx = polySegmentFromN[0]) let (polySegmentFromNy = polySegmentFromN[1]) let (polySegmentFromNz = polySegmentFromN[2])
(0.5 * section + extra_space) / tan(0.5 * theta([polySegmentUntilNx,polySegmentUntilNy,polySegmentUntilNz], [polySegmentFromNx,polySegmentFromNy,polySegmentFromNz]));

function lnelem(p0, p1) =
let (x0 = p0[0]) let (x1 = p1[0]) let (y0 = p0[1]) let (y1 = p1[1]) let (z0 = p0[2]) let (z1 = p1[2])
abs(
  sqrt(
    pow(abs(x1 - x0),2)+
    pow(abs(y1 - y0),2)+
    pow(abs(z1 - z0),2)
  )
);

// scalar components HOWEVER does include power of two of length
function rotateScalarCompProjOntoVectPreviousEnd(pPrevious, pCurrent, pNext) =
  let (xPrevious = pPrevious[0]) let (yPrevious = pPrevious[1]) let (zPrevious = pPrevious[2])
  let (xCurrent = pCurrent[0]) let (yCurrent = pCurrent[1]) let (zCurrent = pCurrent[2])
  let (xNext = pNext[0]) let (yNext = pNext[1]) let (zNext = pNext[2])
  let (vecXrotate = xcoordProtate([xPrevious,yPrevious,zPrevious], [xCurrent,yCurrent,zCurrent], [xNext,yNext,zNext]))
  let (vecYrotate = ycoordProtate([xPrevious,yPrevious,zPrevious], [xCurrent,yCurrent,zCurrent], [xNext,yNext,zNext]))
  let (vecZrotate = zcoordProtate([xPrevious,yPrevious,zPrevious], [xCurrent,yCurrent,zCurrent], [xNext,yNext,zNext]))
dotproduct([xCurrent,yCurrent,zCurrent], [vecXrotate,vecYrotate,vecZrotate])/pow(lnelem([xPrevious,yPrevious,zPrevious], [xCurrent,yCurrent,zCurrent]),2);

function rotateScalarCompProjOntoVectBeginNext(pPrevious, pCurrent, pNext) =
  let (xPrevious = pPrevious[0]) let (yPrevious = pPrevious[1]) let (zPrevious = pPrevious[2])
  let (xCurrent = pCurrent[0]) let (yCurrent = pCurrent[1]) let (zCurrent = pCurrent[2])
  let (xNext = pNext[0]) let (yNext = pNext[1]) let (zNext = pNext[2])
  let (vecXrotate = xcoordProtate([xPrevious,yPrevious,zPrevious], [xCurrent,yCurrent,zCurrent], [xNext,yNext,zNext]))
  let (vecYrotate = ycoordProtate([xPrevious,yPrevious,zPrevious], [xCurrent,yCurrent,zCurrent], [xNext,yNext,zNext]))
  let (vecZrotate = zcoordProtate([xPrevious,yPrevious,zPrevious], [xCurrent,yCurrent,zCurrent], [xNext,yNext,zNext]))
dotproduct([xNext,yNext,zNext], [vecXrotate,vecYrotate,vecZrotate])/pow(lnelem([xCurrent,yCurrent,zCurrent], [xNext,yNext,zNext]),2);

// to find location of vector minus margin
function rotateVectorProjOntoVectXPreviousEnd(pPrevious, pCurrent, pNext) =
let (xPrevious = pPrevious[0]) let (yPrevious = pPrevious[1]) let (zPrevious = pPrevious[2])
let (xCurrent = pCurrent[0]) let (yCurrent = pCurrent[1]) let (zCurrent = pCurrent[2])
let (xNext = pNext[0]) let (yNext = pNext[1]) let (zNext = pNext[2])
rotateScalarCompProjOntoVect([xPrevious,yPrevious,zPrevious], [xCurrent,yCurrent,zCurrent], [xNext,yNext,zNext])*xCurrent;

function rotateVectorProjOntoVectYPreviousEnd(pPrevious, pCurrent, pNext) =
let (xPrevious = pPrevious[0]) let (yPrevious = pPrevious[1]) let (zPrevious = pPrevious[2])
let (xCurrent = pCurrent[0]) let (yCurrent = pCurrent[1]) let (zCurrent = pCurrent[2])
let (xNext = pNext[0]) let (yNext = pNext[1]) let (zNext = pNext[2])
rotateScalarCompProjOntoVect([xPrevious,yPrevious,zPrevious], [xCurrent,yCurrent,zCurrent], [xNext,yNext,zNext])*yCurrent;

function rotateVectorProjOntoVectZPreviousEnd(pPrevious, pCurrent, pNext) =
let (xPrevious = pPrevious[0]) let (yPrevious = pPrevious[1]) let (zPrevious = pPrevious[2])
let (xCurrent = pCurrent[0]) let (yCurrent = pCurrent[1]) let (zCurrent = pCurrent[2])
let (xNext = pNext[0]) let (yNext = pNext[1]) let (zNext = pNext[2])
rotateScalarCompProjOntoVect([xPrevious,yPrevious,zPrevious], [xCurrent,yCurrent,zCurrent], [xNext,yNext,zNext])*zCurrent;

function rotateVectorProjOntoVectXBeginNext(pPrevious, pCurrent, pNext) =
let (xPrevious = pPrevious[0]) let (yPrevious = pPrevious[1]) let (zPrevious = pPrevious[2])
let (xCurrent = pCurrent[0]) let (yCurrent = pCurrent[1]) let (zCurrent = pCurrent[2])
let (xNext = pNext[0]) let (yNext = pNext[1]) let (zNext = pNext[2])
rotateScalarCompProjOntoVect([xPrevious,yPrevious,zPrevious], [xCurrent,yCurrent,zCurrent], [xNext,yNext,zNext])*xNext;

function rotateVectorProjOntoVectYBeginNext(pPrevious, pCurrent, pNext) =
let (xPrevious = pPrevious[0]) let (yPrevious = pPrevious[1]) let (zPrevious = pPrevious[2])
let (xCurrent = pCurrent[0]) let (yCurrent = pCurrent[1]) let (zCurrent = pCurrent[2])
let (xNext = pNext[0]) let (yNext = pNext[1]) let (zNext = pNext[2])
rotateScalarCompProjOntoVect([xPrevious,yPrevious,zPrevious], [xCurrent,yCurrent,zCurrent], [xNext,yNext,zNext])*yNext;

function rotateVectorProjOntoVectZBeginNext(pPrevious, pCurrent, pNext) =
let (xPrevious = pPrevious[0]) let (yPrevious = pPrevious[1]) let (zPrevious = pPrevious[2])
let (xCurrent = pCurrent[0]) let (yCurrent = pCurrent[1]) let (zCurrent = pCurrent[2])
let (xNext = pNext[0]) let (yNext = pNext[1]) let (zNext = pNext[2])
rotateScalarCompProjOntoVect([xPrevious,yPrevious,zPrevious], [xCurrent,yCurrent,zCurrent], [xNext,yNext,zNext])*zNext;

function dotproduct(p0, p1) =
let (x0 = p0[0]) let (x1 = p1[0]) let (y0 = p0[1]) let (y1 = p1[1]) let (z0 = p0[2]) let (z1 = p1[2])
x0 * x1 + y0 * y1 + z0 * z1;

function anglexaxis(p0, p1)  =
let (x0 = p0[0]) let (x1 = p1[0]) let (y0 = p0[1]) let (y1 = p1[1]) let (z0 = p0[2]) let (z1 = p1[2])
arccos((abs(x1-x0)/lnelem(p0, p1)));

function angleyaxis(p0, p1)  =
let (x0 = p0[0]) let (x1 = p1[0]) let (y0 = p0[1]) let (y1 = p1[1]) let (z0 = p0[2]) let (z1 = p1[2])
arccos((abs(y1-y0)/lnelem(p0, p1)));

function anglezaxis(p0, p1)  =
let (x0 = p0[0]) let (x1 = p1[0]) let (y0 = p0[1]) let (y1 = p1[1]) let (z0 = p0[2]) let (z1 = p1[2])
arccos((abs(z1-x0)/lnelem(p0, p1)));

function lnxcomp(p0, p1) =
let (x0 = p0[0]) let (x1 = p1[0]) let (y0 = p0[1]) let (y1 = p1[1]) let (z0 = p0[2]) let (z1 = p1[2])
abs(x1-x0);

function lnycomp(p0, p1) =
let (x0 = p0[0]) let (x1 = p1[0]) let (y0 = p0[1]) let (y1 = p1[1]) let (z0 = p0[2]) let (z1 = p1[2])
abs(y1-y0);

function lnzcomp(p0, p1) =
let (x0 = p0[0]) let (x1 = p1[0]) let (y0 = p0[1]) let (y1 = p1[1]) let (z0 = p0[2]) let (z1 = p1[2])
abs(z1-z0);


function theta(polySegmentUntilN, polySegmentFromN) =
let (polySegmentUntilNx = polySegmentUntilN[0]) let (polySegmentUntilNy = polySegmentUntilN[1]) let (polySegmentUntilNz = polySegmentUntilN[2])
let (polySegmentFromNx = polySegmentFromN[0]) let (polySegmentFromNy = polySegmentFromN[1]) let (polySegmentFromNz = polySegmentFromN[2])
acos(
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
function lnRotationPointVector(pPrevious, pCurrent, pNext) =
let (xPrevious = pPrevious[0]) let (yPrevious = pPrevious[1]) let (zPrevious = pPrevious[2])
let (xCurrent = pCurrent[0]) let (yCurrent = pCurrent[1]) let (zCurrent = pCurrent[2])
let (xNext = pNext[0]) let (yNext = pNext[1]) let (zNext = pNext[2])
(0.5*section+extra_space) / sin(0.5*theta(pCurrent, pNext));

function anglPolylineSegmentXaxis(pPrevious, pCurrent, pNext) =
let (xPrevious = pPrevious[0]) let (yPrevious = pPrevious[1]) let (zPrevious = pPrevious[2])
let (xCurrent = pCurrent[0]) let (yCurrent = pCurrent[1]) let (zCurrent = pCurrent[2])
let (xNext = pNext[0]) let (yNext = pNext[1]) let (zNext = pNext[2])
anglexaxis(pPrevious, pCurrent) + theta(pCurrent, pNext) - 180;

function anglPolylineSegmentYaxis(pPrevious, pCurrent, pNext) =
let (xPrevious = pPrevious[0]) let (yPrevious = pPrevious[1]) let (zPrevious = pPrevious[2])
let (xCurrent = pCurrent[0]) let (yCurrent = pCurrent[1]) let (zCurrent = pCurrent[2])
let (xNext = pNext[0]) let (yNext = pNext[1]) let (zNext = pNext[2])
angleyaxis(pPrevious, pCurrent) + theta(pCurrent, pNext) - 180;

function anglPolylineSegmentZaxis(pPrevious, pCurrent, pNext) =
let (xPrevious = pPrevious[0]) let (yPrevious = pPrevious[1]) let (zPrevious = pPrevious[2])
let (xCurrent = pCurrent[0]) let (yCurrent = pCurrent[1]) let (zCurrent = pCurrent[2])
let (xNext = pNext[0]) let (yNext = pNext[1]) let (zNext = pNext[2])
anglezaxis(pPrevious, pCurrent) + theta(pCurrent, pNext) - 180;

function xcompRotationVector(pPrevious, pCurrent, pNext) =
let (xPrevious = pPrevious[0]) let (yPrevious = pPrevious[1]) let (zPrevious = pPrevious[2])
let (xCurrent = pCurrent[0]) let (yCurrent = pCurrent[1]) let (zCurrent = pCurrent[2])
let (xNext = pNext[0]) let (yNext = pNext[1]) let (zNext = pNext[2])
lnRotationPointVector(pPrevious, pCurrent) * cos(anglPolylineSegmentXaxis(pPrevious, pCurrent, pNext));

function ycompRotationVector(pPrevious, pCurrent, pNext) =
let (xPrevious = pPrevious[0]) let (yPrevious = pPrevious[1]) let (zPrevious = pPrevious[2])
let (xCurrent = pCurrent[0]) let (yCurrent = pCurrent[1]) let (zCurrent = pCurrent[2])
let (xNext = pNext[0]) let (yNext = pNext[1]) let (zNext = pNext[2])
lnRotationPointVector(pPrevious, pCurrent) * cos(anglPolylineSegmentYaxis(pPrevious, pCurrent, pNext));

function zcompRotationVector(pPrevious, pCurrent, pNext) =
let (xPrevious = pPrevious[0]) let (yPrevious = pPrevious[1]) let (zPrevious = pPrevious[2])
let (xCurrent = pCurrent[0]) let (yCurrent = pCurrent[1]) let (zCurrent = pCurrent[2])
let (xNext = pNext[0]) let (yNext = pNext[1]) let (zNext = pNext[2])
lnRotationPointVector(pPrevious, pCurrent) * cos(anglPolylineSegmentZaxis(pPrevious, pCurrent, pNext));

function xcoordProtate(pPrevious, pCurrent, pNext) =
let (xPrevious = pPrevious[0]) let (yPrevious = pPrevious[1]) let (zPrevious = pPrevious[2])
let (xCurrent = pCurrent[0]) let (yCurrent = pCurrent[1]) let (zCurrent = pCurrent[2])
let (xNext = pNext[0]) let (yNext = pNext[1]) let (zNext = pNext[2])
xcompRotationVector(pPrevious, pCurrent, pNext) + xPrevious;

function ycoordProtate(pPrevious, pCurrent, pNext) =
let (xPrevious = pPrevious[0]) let (yPrevious = pPrevious[1]) let (zPrevious = pPrevious[2])
let (xCurrent = pCurrent[0]) let (yCurrent = pCurrent[1]) let (zCurrent = pCurrent[2])
let (xNext = pNext[0]) let (yNext = pNext[1]) let (zNext = pNext[2])
ycompRotationVector(pPrevious, pCurrent, pNext) + yPrevious;

function zcoordProtate(pPrevious, pCurrent, pNext) =
let (xPrevious = pPrevious[0]) let (yPrevious = pPrevious[1]) let (zPrevious = pPrevious[2])
let (xCurrent = pCurrent[0]) let (yCurrent = pCurrent[1]) let (zCurrent = pCurrent[2])
let (xNext = pNext[0]) let (yNext = pNext[1]) let (zNext = pNext[2])
zcompRotationVector(pPrevious, pCurrent, pNext) + zPrevious;
