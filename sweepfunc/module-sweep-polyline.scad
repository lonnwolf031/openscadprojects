polyline = [[0,0,0],[2,2,2],[6,4,8],[10,12,14]];

section = 1;
extra_space = 0.25*section;

numpoints = len(polyline);

// LINEAR EXTRUDE HERE
if(numpoints == 2) {
    // from polyline at n linear extrude until [1]
    translate(polyline[n])
    /// rotate angles from things
    rotate([anglexaxis(polyline[n], polyline[n+1]),
    angleyaxis(polyline[n], polyline[n+1]),
    anglezaxis(polyline[n], polyline[n+1])])
    linear_extrude(height = lnelem(polyline[n], polyline[n+1]), center = true)
    shape();
}

// range is inclusive on both ends
for (n =[0:numpoints-1]) {
  // if not first point, because at P0 there is nothing to do

  if(n != 0) {
    // at P1 (and if larger than 1 polyline) and further there are rotate extrudes
    if(n >= 1 && numpoints >= 2 && n < numpoints-1)
    {
        rotateExtrMidPolyline(polyline[n-1], polyline[n], polyline[n+1]);
    }
    if(n>=2 && n < numpoints-1) {
        linearExtrMidPolyline(polyline[n-2], polyline[n-1], polyline[n], polyline[n+1]) ;
    }
    if(n == numpoints-1) {
        /// THIS THING
        linearExtrLatest(polyline[n-2], polyline[n-1], polyline[n]);
    }
  }

}

module rotateExtrMidPolyline(pPrev, pCur, pNext) {
  echo("pNext=",str(pNext));
  tempX = xcoordProtate(pPrev, pCur, pNext);
  tempY = ycoordProtate(pPrev, pCur, pNext);
  tempZ = zcoordProtate(pPrev, pCur, pNext);
  translate([tempX,tempY,tempZ])
  rotate([anglexaxis([tempX,tempY,tempZ], pCur),
  angleyaxis([tempX,tempY,tempZ], pCur),
  anglezaxis([tempX,tempY,tempZ], pCur)])
  rotate_extrude(angle = theta(pPrev,pCur,pNext))
  shape();
    //echo("theta",str(theta(pPrev,pCur,pNext)));
}


module linearExtrMidPolyline(pPrevPrev, pPrev, pCur, pNext) {
  // calculate temporary coordinates and length
  //temp coord around prev instead of cur?
  // CHECK IF MARGINS ARE ALRIGHT
  // ASSERT IF? --> DEBUG
  tempCoordMarginXbegin = rotateVectorProjOntoVectXBeginOfVecFromCur(pPrevPrev, pPrev, pCur);
  tempCoordMarginYbegin = rotateVectorProjOntoVectYBeginOfVecFromCur(pPrevPrev, pPrev, pCur);
  tempCoordMarginZbegin = rotateVectorProjOntoVectZBeginOfVecFromCur(pPrevPrev, pPrev, pCur);
  tempCoordMarginXnext = rotateVectorProjOntoVectXEndOfVecUntilCur(pPrev, pCur, pNext);
  tempCoordMarginYnext = rotateVectorProjOntoVectYEndOfVecUntilCur(pPrev, pCur, pNext);
  tempCoordMarginZnext = rotateVectorProjOntoVectZEndOfVecUntilCur(pPrev, pCur, pNext);
  lenExtrude = lnelem([tempCoordMarginXbegin,tempCoordMarginYbegin,tempCoordMarginZbegin],
  [tempCoordMarginXnext ,tempCoordMarginYnext ,tempCoordMarginZnext ]);

  translate([tempCoordMarginXbegin,tempCoordMarginYbegin,tempCoordMarginZbegin])
  //rotate towards  n+1
  // too many unnamed argumetns
  rotate([anglexaxis([tempCoordMarginXbegin,tempCoordMarginYbegin,tempCoordMarginZbegin], pCur),
  angleyaxis([tempCoordMarginXbegin,tempCoordMarginYbegin,tempCoordMarginZbegin], pCur),
  anglezaxis([tempCoordMarginXbegin,tempCoordMarginYbegin,tempCoordMarginZbegin], pCur)])
  linear_extrude(height = lenExtrude, center = true)
  shape();
}


module linearExtrLatest(pPrevPrev, pPrev, pCur) {
  //linear extrude until last point
  //translate and rotate
  // do something about margin here
  tempCoordMarginXbegin = rotateVectorProjOntoVectXBeginOfVecFromCur(pPrevPrev, pPrev, pCur);
  tempCoordMarginYbegin = rotateVectorProjOntoVectYBeginOfVecFromCur(pPrevPrev, pPrev, pCur);
  tempCoordMarginZbegin = rotateVectorProjOntoVectZBeginOfVecFromCur(pPrevPrev, pPrev, pCur);
    lenExtrude = lnelem([tempCoordMarginXbegin,tempCoordMarginYbegin,tempCoordMarginZbegin],
  pCur);
  linear_extrude(height = lenExtrude, center = true)
  shape();
}

module shape() {
    square(size = [section, section], center = true);
}

// every argument is an [x,y,z] vector
function margin(pPrevious, pCurrent, pNext) =
(0.5 * section + extra_space) / tan(0.5 * theta(pPrevious, pCurrent, pNext));

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
function rotateScalarCompProjOntoVectEndOfVecUntilCur(pPrevious, pCurrent, pNext) =
  let (xPrevious = pPrevious[0]) let (yPrevious = pPrevious[1]) let (zPrevious = pPrevious[2])
  let (xCurrent = pCurrent[0]) let (yCurrent = pCurrent[1]) let (zCurrent = pCurrent[2])
  let (xNext = pNext[0]) let (yNext = pNext[1]) let (zNext = pNext[2])
  let (vecXrotate = xcoordProtate(pPrevious, pCurrent, pNext))
  let (vecYrotate = ycoordProtate(pPrevious, pCurrent, pNext))
  let (vecZrotate = zcoordProtate(pPrevious, pCurrent, pNext))
dotproduct(pCurrent, [vecXrotate,vecYrotate,vecZrotate])/pow(lnelem(pPrevious, pCurrent),2);

function rotateScalarCompProjOntoVectBeginOfVecFromCur(pPrevious, pCurrent, pNext) =
  let (xPrevious = pPrevious[0]) let (yPrevious = pPrevious[1]) let (zPrevious = pPrevious[2])
  let (xCurrent = pCurrent[0]) let (yCurrent = pCurrent[1]) let (zCurrent = pCurrent[2])
  let (xNext = pNext[0]) let (yNext = pNext[1]) let (zNext = pNext[2])
  let (vecXrotate = xcoordProtate(pPrevious, pCurrent, pNext))
  let (vecYrotate = ycoordProtate(pPrevious, pCurrent, pNext))
  let (vecZrotate = zcoordProtate(pPrevious, pCurrent, pNext))
dotproduct(pNext, [vecXrotate,vecYrotate,vecZrotate])/pow(lnelem(pCurrent, pNext),2);

// to find location of vector minus margin
function rotateVectorProjOntoVectXEndOfVecUntilCur(pPrevious, pCurrent, pNext) =
let (xPrevious = pPrevious[0]) let (yPrevious = pPrevious[1]) let (zPrevious = pPrevious[2])
let (xCurrent = pCurrent[0]) let (yCurrent = pCurrent[1]) let (zCurrent = pCurrent[2])
let (xNext = pNext[0]) let (yNext = pNext[1]) let (zNext = pNext[2])
rotateScalarCompProjOntoVectEndOfVecUntilCur(pPrevious, pCurrent, pNext)*xCurrent;

function rotateVectorProjOntoVectYEndOfVecUntilCur(pPrevious, pCurrent, pNext) =
let (xPrevious = pPrevious[0]) let (yPrevious = pPrevious[1]) let (zPrevious = pPrevious[2])
let (xCurrent = pCurrent[0]) let (yCurrent = pCurrent[1]) let (zCurrent = pCurrent[2])
let (xNext = pNext[0]) let (yNext = pNext[1]) let (zNext = pNext[2])
rotateScalarCompProjOntoVectEndOfVecUntilCur(pPrevious, pCurrent, pNext)*yCurrent;

function rotateVectorProjOntoVectZEndOfVecUntilCur(pPrevious, pCurrent, pNext) =
let (xPrevious = pPrevious[0]) let (yPrevious = pPrevious[1]) let (zPrevious = pPrevious[2])
let (xCurrent = pCurrent[0]) let (yCurrent = pCurrent[1]) let (zCurrent = pCurrent[2])
let (xNext = pNext[0]) let (yNext = pNext[1]) let (zNext = pNext[2])
rotateScalarCompProjOntoVectEndOfVecUntilCur(pPrevious, pCurrent, pNext)*zCurrent;

function rotateVectorProjOntoVectXBeginOfVecFromCur(pPrevious, pCurrent, pNext) =
let (xNext = pNext[0])
rotateScalarCompProjOntoVectBeginOfVecFromCur(pPrevious, pCurrent, pNext)*xNext;

function rotateVectorProjOntoVectYBeginOfVecFromCur(pPrevious, pCurrent, pNext) =
let (xPrevious = pPrevious[0]) let (yPrevious = pPrevious[1]) let (zPrevious = pPrevious[2])
let (xCurrent = pCurrent[0]) let (yCurrent = pCurrent[1]) let (zCurrent = pCurrent[2])
let (xNext = pNext[0]) let (yNext = pNext[1]) let (zNext = pNext[2])
rotateScalarCompProjOntoVectBeginOfVecFromCur(pPrevious, pCurrent, pNext)*yNext;

function rotateVectorProjOntoVectZBeginOfVecFromCur(pPrevious, pCurrent, pNext) =
let (xPrevious = pPrevious[0]) let (yPrevious = pPrevious[1]) let (zPrevious = pPrevious[2])
let (xCurrent = pCurrent[0]) let (yCurrent = pCurrent[1]) let (zCurrent = pCurrent[2])
let (xNext = pNext[0]) let (yNext = pNext[1]) let (zNext = pNext[2])
rotateScalarCompProjOntoVectBeginOfVecFromCur(pPrevious, pCurrent, pNext)*zNext;

function dotproduct(p0, p1) =
let (x0 = p0[0]) let (x1 = p1[0]) let (y0 = p0[1]) let (y1 = p1[1]) let (z0 = p0[2]) let (z1 = p1[2])
x0 * x1 + y0 * y1 + z0 * z1;

function anglexaxis(p0, p1)  =
let (x0 = p0[0]) let (x1 = p1[0]) let (y0 = p0[1]) let (y1 = p1[1]) let (z0 = p0[2]) let (z1 = p1[2])
echo("lnelemPtempPcur",str(lnelem(p0,p1)))
acos(abs(x1-x0)/lnelem(p0, p1));

function angleyaxis(p0, p1)  =
let (x0 = p0[0]) let (x1 = p1[0]) let (y0 = p0[1]) let (y1 = p1[1]) let (z0 = p0[2]) let (z1 = p1[2])
acos(abs(y1-y0)/lnelem(p0, p1));

function anglezaxis(p0, p1)  =
let (x0 = p0[0]) let (x1 = p1[0]) let (y0 = p0[1]) let (y1 = p1[1]) let (z0 = p0[2]) let (z1 = p1[2])
acos(abs(z1-x0)/lnelem(p0, p1));

function lnxcomp(p0, p1) =
let (x0 = p0[0]) let (x1 = p1[0]) let (y0 = p0[1]) let (y1 = p1[1]) let (z0 = p0[2]) let (z1 = p1[2])
abs(x1-x0);

function lnycomp(p0, p1) =
let (x0 = p0[0]) let (x1 = p1[0]) let (y0 = p0[1]) let (y1 = p1[1]) let (z0 = p0[2]) let (z1 = p1[2])
abs(y1-y0);

function lnzcomp(p0, p1) =
let (x0 = p0[0]) let (x1 = p1[0]) let (y0 = p0[1]) let (y1 = p1[1]) let (z0 = p0[2]) let (z1 = p1[2])
// undef
assert(!is_undef(z1),str(z1,z0))
abs(z1-z0);


function theta(pPrevious, pCurrent, pNext) =
// check somewhere theta not used when pCurrent is nmax
acos(
  //ln things need TWO arguments
(lnxcomp(pCurrent, pNext) * lnxcomp(pPrevious, pCurrent) +
lnycomp(pCurrent, pNext) * lnycomp(pPrevious, pCurrent) +
lnzcomp(pCurrent, pNext) * lnzcomp(pPrevious, pCurrent))
/ ( (abs(sqrt(
      pow(abs(lnxcomp(pPrevious, pCurrent)),2)+
      pow(abs(lnycomp(pPrevious, pCurrent)),2)+
      pow(abs(lnzcomp(pPrevious, pCurrent)),2)))*
    abs(sqrt(
      pow(abs(lnxcomp(pCurrent, pNext)),2)+
      pow(abs(lnycomp(pCurrent, pNext)),2)+
      pow(abs(lnzcomp(pCurrent, pNext)),2))
))));


// functions for rotate vector where x,y,z 0 = n-1, x,y,z 1 = n
function lnRotationPointVector(pPrevious, pCurrent, pNext) =
let (xPrevious = pPrevious[0]) let (yPrevious = pPrevious[1]) let (zPrevious = pPrevious[2])
let (xCurrent = pCurrent[0]) let (yCurrent = pCurrent[1]) let (zCurrent = pCurrent[2])
let (xNext = pNext[0]) let (yNext = pNext[1]) let (zNext = pNext[2])
(0.5*section+extra_space) / sin(0.5*theta(pPrevious, pCurrent, pNext));

function anglPolylineSegmentXaxis(pPrevious, pCurrent, pNext) =
let (xPrevious = pPrevious[0]) let (yPrevious = pPrevious[1]) let (zPrevious = pPrevious[2])
let (xCurrent = pCurrent[0]) let (yCurrent = pCurrent[1]) let (zCurrent = pCurrent[2])
let (xNext = pNext[0]) let (yNext = pNext[1]) let (zNext = pNext[2])
anglexaxis(pPrevious, pCurrent) + theta(pPrevious, pCurrent, pNext) - 180;

function anglPolylineSegmentYaxis(pPrevious, pCurrent, pNext) =
let (xPrevious = pPrevious[0]) let (yPrevious = pPrevious[1]) let (zPrevious = pPrevious[2])
let (xCurrent = pCurrent[0]) let (yCurrent = pCurrent[1]) let (zCurrent = pCurrent[2])
let (xNext = pNext[0]) let (yNext = pNext[1]) let (zNext = pNext[2])
angleyaxis(pPrevious, pCurrent) + theta(pPrevious, pCurrent, pNext) - 180;

function anglPolylineSegmentZaxis(pPrevious, pCurrent, pNext) =
let (xPrevious = pPrevious[0]) let (yPrevious = pPrevious[1]) let (zPrevious = pPrevious[2])
let (xCurrent = pCurrent[0]) let (yCurrent = pCurrent[1]) let (zCurrent = pCurrent[2])
let (xNext = pNext[0]) let (yNext = pNext[1]) let (zNext = pNext[2])
anglezaxis(pPrevious, pCurrent) + theta(pPrevious, pCurrent, pNext) - 180;

function xcompRotationVector(pPrevious, pCurrent, pNext) =
let (xPrevious = pPrevious[0]) let (yPrevious = pPrevious[1]) let (zPrevious = pPrevious[2])
let (xCurrent = pCurrent[0]) let (yCurrent = pCurrent[1]) let (zCurrent = pCurrent[2])
let (xNext = pNext[0]) let (yNext = pNext[1]) let (zNext = pNext[2])
lnRotationPointVector(pPrevious, pCurrent, pNext) * cos(anglPolylineSegmentXaxis(pPrevious, pCurrent, pNext));

function ycompRotationVector(pPrevious, pCurrent, pNext) =
let (xPrevious = pPrevious[0]) let (yPrevious = pPrevious[1]) let (zPrevious = pPrevious[2])
let (xCurrent = pCurrent[0]) let (yCurrent = pCurrent[1]) let (zCurrent = pCurrent[2])
let (xNext = pNext[0]) let (yNext = pNext[1]) let (zNext = pNext[2])
lnRotationPointVector(pPrevious, pCurrent, pNext) * cos(anglPolylineSegmentYaxis(pPrevious, pCurrent, pNext));

function zcompRotationVector(pPrevious, pCurrent, pNext) =
let (xPrevious = pPrevious[0]) let (yPrevious = pPrevious[1]) let (zPrevious = pPrevious[2])
let (xCurrent = pCurrent[0]) let (yCurrent = pCurrent[1]) let (zCurrent = pCurrent[2])
let (xNext = pNext[0]) let (yNext = pNext[1]) let (zNext = pNext[2])
lnRotationPointVector(pPrevious, pCurrent, pNext) * cos(anglPolylineSegmentZaxis(pPrevious, pCurrent, pNext));

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
