// derived from https://www.climberg.de/

module line(p1,p2,w) {
    hull() {
        translate(p1) circle(r=w);
        translate(p2) circle(r=w);
    }
}
module polyline(points, index, w) {
    if(index &lt; len(points)) {
        line(points[index - 1], points[index],w);
        polyline(points, index + 1, w);
    }
}

function choose(n, k)=
     k == 0? 1
    : (n * choose(n - 1, k - 1)) / k;

function _point_on_bezier_rec(points,t,i,c)=
    len(points) == i ? c
    : _point_on_bezier_rec(points,t,i+1,c+choose(len(points)-1,i) * pow(t,i) * pow(1-t,len(points)-i-1) * points[i]);

function _point_on_bezier(points,t)=
    _point_on_bezier_rec(points,t,0,[0,0]);

//a bezier curve with any number of control points
//parameters:
//points - the control points of the bezier curve (number of points is variable)
//resolution - the sampling resolution of the bezier curve (number of returned points)
//returns:
//resolution number of samples on the bezier curve
function bezier(points,resolution)=[
for (t =[0:1.0/resolution:1+1.0/(resolution/2)]) _point_on_bezier(points,t)
];

resolution = 100;
$fn = resolution;

radius = 20;
height = 90;
strength = 1;

p0 = [radius,0];
p1 = [radius*3,height*0.2];
p2 = [-radius,height*0.4];
p3 = [radius*3,height*0.7];
p4 = [0,height*0.8];
p5 = [radius*0.8,height*1];


translate([0,0,-strength]) cylinder(r=radius+strength,h=strength*2);
rotate_extrude()
polyline(bezier([p0,p1,p2,p3,p4,p5],resolution),1,strength);

//create a 3D rotational model with a bezier curve of given points, resolution and thickness
module bezier_model(points,resolution,thickness) {
    translate([0,0,thickness/2]) rotate_extrude() polyline(bezier(points,resolution),1,thickness/2);
}
