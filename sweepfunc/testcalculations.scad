polyline = [[0,0,0],[2,2,2],[6,4,8],[10,12,14]];
t=3;

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
    pow(abs(x1 - x0),2)+ // (x1-x0)
    pow(abs(y1 - y0),2)+
    pow(abs(z1 - z0),2)
  )
);

anglexaxis = arccos((abs(x1-x0)/lnelem([x0,y0,z0], [x1,y1,z1]) );
angleyaxis = arccos((abs(y1-y0)/lnelem([x0,y0,z0], [x1,y1,z1]) );
anglezaxis = arccos((abs(z1-x0)/lnelem([x0,y0,z0], [x1,y1,z1]) );

// calc angle between vectors
function alpha([x0,y0,z0], [x1,y1,z1]) = acos((x1 * x0 +
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
// To find f x , regard y as a constant and differentiate f 共x, y兲 with respect to x .

function lnparallelsegmProt([x0,y0,z0], [x1,y1,z1])  =
(a * sin(0.5*alpha([x0,y0,z0], [x1,y1,z1])))/sin((360-2*alpha([x0,y0,z0], [x1,y1,z1]))/2);
