Include "WindTunnel.geo";
Include "parameters.geo";

// length units are chord-normalized.

ce = 0;

all_points[] = {}; // used for aoa rotation later.

// top surface points.
top_lip_dx = nose_radius * Sin(nose_span * Pi / 180);
all_points[] += ce;
Point(ce++) = {top_lip_dx, airfoil_height, 0, airfoil_lc};
peak = ce - 1;
top_lip_y = airfoil_height - nose_radius * (1 - Cos(nose_span * Pi / 180));
all_points[] += ce;
Point(ce++) = {0, top_lip_y, 0, airfoil_lc};
top_lip = ce - 1;
all_points[] += ce;
Point(ce++) = {top_lip_dx, airfoil_height - nose_radius, 0, airfoil_lc};
nose_center = ce - 1;
top_slope_angle = Atan(airfoil_height / (1 - top_lip_dx));
all_points[] += ce;
Point(ce++) = {top_lip_dx + Sin(top_slope_angle) * airfoil_height, Cos(top_slope_angle) * airfoil_height, 0, airfoil_lc};
back_arc = ce - 1;
all_points[] += ce;
Point(ce++) = {top_lip_dx, 0, 0, airfoil_lc};
back_arc_center = ce - 1;

// bottom surface points.
bottom_le = ce;
all_points[] += ce;
Point(ce++) = {opening, 0, 0, airfoil_lc};
te_bottom = ce;
all_points[] += ce;
Point(ce++) = {trailing_edge_location, 0, 0, te_lc};
te_height = (1 - trailing_edge_location) * Tan(top_slope_angle);
te_top = ce;
all_points[] += ce;
Point(ce++) = {trailing_edge_location, te_height, 0, te_lc};

// Now rotate points for aoa.
Macro RotatePoints
    angle = Arguments[0];
    center[] = Arguments[{1:3}];
    pointIds[] = Arguments[{4 : #Arguments[] - 1}];
    Rotate {{0, 0, 1}, {center[0], center[1], center[2]}, angle}
    {
        Point{pointIds[]};
    }
Return

Macro RotateAirfoilPoints
    // rotates pointId about origin.
    Arguments[0] *= -1.0;
    Arguments[{1:3}] = {0, 0, 0}; // rotation center.
    Arguments[{4 : #Arguments[] - 1}] = Arguments[{4 : #Arguments[] - 1}];
    Call RotatePoints;
Return

Arguments[] = {aoa * Pi / 180, 0, 0, 0, all_points[]};
Call RotateAirfoilPoints;

airfoil_lines[] = {};
airfoil_lines[] += ce;
Circle(ce++) = {top_lip, nose_center, peak};
airfoil_lines[] += ce;
Circle(ce++) = {peak, back_arc_center, back_arc};
airfoil_lines[] += ce;
Line(ce++) = {back_arc, te_top};
airfoil_lines[] += ce;
Line(ce++) = {te_top, te_bottom};
airfoil_lines[] += ce;
Line(ce++) = {te_bottom, bottom_le};
airfoil_lines[] += ce;
Line(ce++) = {bottom_le, top_lip};

airfoil_loop = ce;
Line Loop(ce++) = airfoil_lines[];

WindTunnelHeight = 20;
WindTunnelLength = 40;
WindTunnelLc = 1;
Call WindTunnel;

// Extrude and label wind tunnel region.
Surface(ce++) = {WindTunnelLoop, airfoil_loop};
extrusion_base = ce - 1;
// Recombine Surface{extrusion_base};
cellDepth = 0.1;
ids[] = Extrude {0, 0, cellDepth}
{
	Surface{extrusion_base};
	Layers{1};
	Recombine;
};
Physical Surface("outlet") = {ids[2]};
Physical Surface("walls") = {ids[{3, 5}]};
Physical Surface("inlet") = {ids[4]};
front_and_back[] = {ids[0], extrusion_base};
volumes[] = {ids[1]};

// Extrude and label airfoil interior.
ce += 10000; // skip id because new ones were generated in the previous extrusion.
Plane Surface(ce++) = airfoil_loop;
extrusion_base = ce - 1;
// Recombine Surface{extrusion_base};
cellDepth = 0.1;
ids[] = Extrude {0, 0, cellDepth}
{
	Surface{extrusion_base};
	Layers{1};
	Recombine;
};
Physical Surface("airfoil") = {ids[{2:6}]};
front_and_back[] += {ids[0], extrusion_base};
Physical Surface("frontAndBack") = front_and_back[];
volumes[] += {ids[1]};
Physical Volume("volume") = volumes[];

