// This contains subroutines to get vector directions.
// All Macros expect Arguments[] and outputs Results[].
// Gmsh quirk: Results cannot be accessed on same line of Call, e.g. Call X; x = Results[0];

Macro Vector
    start[] = Arguments[{0:2}];
    Results[]  = Arguments[{3:5}];
    Results[0] -= start[0];
    Results[1] -= start[1];
    Results[2] -= start[2];
Return

Macro Scale
    Results[] = Arguments[{0:2}];
    scaleFactor = Arguments[3];
    Results[0] *= scaleFactor;
    Results[1] *= scaleFactor;
    Results[2] *= scaleFactor;
Return

Macro Magnitude
    Results[0] = Sqrt(Arguments[0]^2 + Arguments[1]^2 + Arguments[2]^2);
Return

Macro Normalize
    Call Magnitude;
    Arguments[3] = 1.0 / Results[0];
    Call Scale;
Return

Macro Add
    Results[] = Arguments[{0:2}];
    Results[0] += Arguments[3];
    Results[1] += Arguments[4];
    Results[2] += Arguments[5];
Return

Macro Cross
    Results[0] = Arguments[0] * Arguments[4] - Arguments[1] * Arguments[3];
Return

Macro Translated
    Results[] = Arguments[{0:2}];
    Results[0] += Arguments[3];
    Results[1] += Arguments[4];
    Results[2] += Arguments[5];
Return

Macro Dot
    Results[0] = Arguments[0] * Arguments[3];
    Results[0] += Arguments[1] * Arguments[4];
    Results[0] += Arguments[2] * Arguments[5];
Return

Macro Angle
    firstVector[] = Arguments[{0:2}];
    secondVector[] = Arguments[{3:5}];
    Call Cross;
    cross = Results[0];
    Arguments[] = firstVector[]; Call Normalize;
    firstNorm[] = Results[{0:2}];
    Arguments[] = secondVector[]; Call Normalize;
    secondNorm[] = Results[{0:2}];
    Arguments[] = {firstNorm[], secondNorm[]}; Call Dot;
    // Sorry for the meandering logic, but Else is not working as expected.
    dot = Results[0];
    sign = 1.0;
    Results[0] = 0.0;
    If (cross < 0)
        sign = -1.0;
        Results[0] = 2 * Pi;
    EndIf
    Results[0] += sign * Acos(dot);
Return

Macro Rotated
    vector = Arguments[{0:2}];
    angle = Arguments[3]; // radians.
    Results[0] = vector[0] * Cos(angle) - vector[1] * Sin(angle);
    Results[1] = vector[0] * Sin(angle) + vector[1] * Cos(angle);
    Results[2] = 0;
Return

