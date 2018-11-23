Include "WindTunnel.geo";
Include "parameters.geo";

// length units are chord-normalized.

ce = 0;

// top surface points.
top_lip_dx = nose_radius * Sin(nose_span * Pi / 180);
Point(ce++) = {top_lip_dx, airfoil_height, 0, airfoil_lc};
peak = ce - 1;
top_lip_y = airfoil_height - nose_radius * (1 - Cos(nose_span * Pi / 180));
Point(ce++) = {0, top_lip_y, 0, airfoil_lc};
top_lip = ce - 1;
Point(ce++) = {top_lip_dx, airfoil_height - nose_radius, 0, airfoil_lc};
nose_center = ce - 1;
top_slope_angle = Atan(top_lip_y / (1 - top_lip_dx));
Point(ce++) = {top_lip_dx + Sin(top_slope_angle) * airfoil_height, Cos(top_slope_angle) * airfoil_height, 0, airfoil_lc};
back_arc = ce - 1;
Point(ce++) = {top_lip_dx, 0, 0, airfoil_lc};
back_arc_center = ce - 1;


// bottom surface points.
Point(ce++) = {opening, 0, 0, airfoil_lc};
bottom_le = ce - 1;
Point(ce++) = {1, 0, 0, airfoil_lc};
te = ce - 1;

airfoil_lines[] = {};
airfoil_lines[] += ce;
Circle(ce++) = {top_lip, nose_center, peak};
airfoil_lines[] += ce;
Circle(ce++) = {peak, back_arc_center, back_arc};
airfoil_lines[] += ce;
Line(ce++) = {back_arc, te};
airfoil_lines[] += ce;
Line(ce++) = {te, bottom_le};
airfoil_lines[] += ce;
Line(ce++) = {bottom_le, top_lip};

airfoil_loop = ce;
Line Loop(ce++) = airfoil_lines[];

WindTunnelHeight = 20;
WindTunnelLength = 40;
WindTunnelLc = 3;
Call WindTunnel;

// Extrude and label wind tunnel region.
Surface(ce++) = {WindTunnelLoop, airfoil_loop};
extrusion_base = ce - 1;
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
Physical Surface("airfoil") = {ids[{7:10}]};
front_and_back[] = {ids[0], extrusion_base};
volumes[] = {ids[1]};

// Extrude and label airfoil interior.
ce += 10000; // skip id because new ones were generated in the previous extrusion.
Plane Surface(ce++) = airfoil_loop;
extrusion_base = ce - 1;
cellDepth = 0.1;
ids[] = Extrude {0, 0, cellDepth}
{
	Surface{extrusion_base};
	Layers{1};
	Recombine;
};
front_and_back[] += {ids[0], extrusion_base};
Physical Surface("frontAndBack") = front_and_back[];
volumes[] += {ids[1]};
Physical Volume("volume") = volumes[];

