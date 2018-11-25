#!/bin/sh

# Quit script if any step has error:
set -e

# Make the mesh (msh2 is recognized by gmshToFoam):
gmsh -format msh2 -3 -o main.msh mesh/main.geo
# Convert the mesh to OpenFOAM format:
gmshToFoam main.msh -case case
# Tell OpenFOAM to recognize internal faces as physical surfaces:
createBaffles -case case -dict system/baffleDict -overwrite
# Adjust polyMesh/boundary:
changeDictionary -case case
# Finally, run the simulation:
simpleFoam -case case

