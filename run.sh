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

# Here you can choose to run in parallel or single-core.
# Comment out appropriately.

# Parallel decomposition of domain (comment this out if single-core):
decomposePar -case case
# Parallel run (comment this out if single-core):
mpirun -np 4 simpleFoam -case case -parallel

# Single-core run (comment this out if parallel):
#simpleFoam -case case

