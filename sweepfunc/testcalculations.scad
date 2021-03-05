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
        translate(xcoordProtate([x0,y0,z0], [x1,y1,z1]),ycoordProtate([x0,y0,z0], [x1,y1,z1]),zcoordProtate([x0,y0,z0], [x1,y1,z1]))
        //rotate()

        //translate and rotate
        // rotate extrude
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

function anglexaxis([x0,y0,z0], [x1,y1,z1])  = arccos((abs(x1-x0)/lnelem([x0,y0,z0], [x1,y1,z1]) );
function angleyaxis([x0,y0,z0], [x1,y1,z1])  = arccos((abs(y1-y0)/lnelem([x0,y0,z0], [x1,y1,z1]) );
function anglezaxis([x0,y0,z0], [x1,y1,z1])  = arccos((abs(z1-x0)/lnelem([x0,y0,z0], [x1,y1,z1]) );

// calc angle between vectors, 0 being n, 1 being n+1
function theta([x0,y0,z0], [x1,y1,z1]) = acos((x1 * x0 +
y1 * y0 +
z1 * z0)
/ ( (abs(sqrt(
      pow(abs(x1),2)+
      pow(abs(y1),2)+
      pow(abs(z1),2)))*
    abs(sqrt(
      pow(abs(x0),2)+
      pow(abs(y0),2)+
      pow(abs(z0),2))
))));

lnxcomp = abs(x1-x0);
lnycomp = abs(y1-y0);
lnzcomp = abs(z1-z0);

// functions for rotate vector where x,y,z 0 = n-1, x,y,z 1 = n
function lnPolyPtVct([x0,y0,z0], [x1,y1,z1]) = (0.5*section+extra) / sin(0.5*theta([x0,y0,z0], [x1,y1,z1]));

function anglPolyPointXaxis([x0,y0,z0], [x1,y1,z1]) = anglexaxis([x0,y0,z0], [x1,y1,z1]) + theta([x0,y0,z0], [x1,y1,z1]) - 180;
function anglPolyPointYaxis([x0,y0,z0], [x1,y1,z1]) = angleyaxis([x0,y0,z0], [x1,y1,z1]) + theta([x0,y0,z0], [x1,y1,z1]) - 180;
function anglPolyPointZaxis([x0,y0,z0], [x1,y1,z1]) = anglezaxis([x0,y0,z0], [x1,y1,z1]) + theta([x0,y0,z0], [x1,y1,z1]) - 180;

function xcompVector([x0,y0,z0], [x1,y1,z1]) = lnPolyPtVct([x0,y0,z0], [x1,y1,z1]) * cos(anglPolyPointXaxis([x0,y0,z0], [x1,y1,z1]));
function ycompVector([x0,y0,z0], [x1,y1,z1]) = lnPolyPtVct([x0,y0,z0], [x1,y1,z1]) * cos(anglPolyPointYaxis([x0,y0,z0], [x1,y1,z1]));
function zcompVector([x0,y0,z0], [x1,y1,z1]) = lnPolyPtVct([x0,y0,z0], [x1,y1,z1]) * cos(anglPolyPointZaxis([x0,y0,z0], [x1,y1,z1]));

function xcoordProtate([x0,y0,z0], [x1,y1,z1]) = xcompVector([x0,y0,z0], [x1,y1,z1]) + x0;
function ycoordProtate([x0,y0,z0], [x1,y1,z1]) = ycompVector([x0,y0,z0], [x1,y1,z1]) + y0;
function zcoordProtate([x0,y0,z0], [x1,y1,z1]) = zcompVector([x0,y0,z0], [x1,y1,z1]) + z0;

// end of extrude - margin - translate from P to projection of margin (length) to x, y, z
