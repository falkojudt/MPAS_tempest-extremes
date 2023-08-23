#!/bin/bash

####################################################
# MPAS Grid Connectivity File Generation Script
####################################################

# This script generates a grid connectivity file using the 'GenerateConnectivityFile' command.

# Instructions:
# 1. Set the 'scripfile' variable to the path of the SCRIP file.
# 2. Set the 'gridconnectivityfile' variable to the desired path for the grid connectivity file.
# 3. Run this script to generate the grid connectivity file.

# Define dx, meshdir, datadir, and mesh_dict.
. config.sh

# Path to the SCRIP file
scripfile="${meshdir}/x1.${mesh_dict[$dx]}.grid.SCRIP.nc"

# Path for the grid connectivity file
gridconnectivityfile="${meshdir}/x1.${mesh_dict[$dx]}.grid-connectivity.txt"

# Run the 'GenerateConnectivityFile' command to generate the grid connectivity file
~/tempestextremes/bin/GenerateConnectivityFile --in_mesh $scripfile --out_type FV --out_connect $gridconnectivityfile

#Note: For a 15-km mesh or higher resolution meshes, use:
#/glade/work/zarzycki/tempestextremes/bin/GenerateConnectivityFile --in_mesh $scripfile --out_type FV --out_connect $gridconnectivityfile

echo "Created ${gridconnectivityfile} from ${scripfile}."
