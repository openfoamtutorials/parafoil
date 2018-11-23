Include "Airfoil.geo";
Include "WindTunnel.geo";
Include "parameters.geo";

// Units are multiples of chord.

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

Surface(ce++) = {WindTunnelLoop, airfoil_loop};
TwoDimSurf = ce - 1;

cellDepth = 0.1;

ids[] = Extrude {0, 0, cellDepth}
{
	Surface{TwoDimSurf};
	Layers{1};
	Recombine;
};

/*
Arguments[] = {0, bendHeight, thickness, AirfoilLc, 0, 0, 2};
Call Airfoil;
AirfoilLoop = Results[0];


Surface(ce++) = {WindTunnelLoop, AirfoilLoop};
TwoDimSurf = ce - 1;

cellDepth = 0.1;

ids[] = Extrude {0, 0, cellDepth}
{
	Surface{TwoDimSurf};
	Layers{1};
	Recombine;
};

Physical Surface("outlet") = {ids[2]};
Physical Surface("walls") = {ids[{3, 5}]};
Physical Surface("inlet") = {ids[4]};
Physical Surface("airfoil") = {ids[{6:11}]};
Physical Surface("frontAndBack") = {ids[0], TwoDimSurf};
Physical Volume("volume") = {ids[1]};
*/
