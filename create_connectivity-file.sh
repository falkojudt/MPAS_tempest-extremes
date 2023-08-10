#!/bin/bash

####################################################
# MPAS Grid Connectivity File Generation Script
####################################################

# This script generates a grid connectivity file using the 'GenerateConnectivityFile' command.

# Instructions:
# 1. Modify the 'mesh_dict' associative array to map resolution names to the corresponding mesh IDs.
# 2. Specify the desired resolution by setting the 'dx' variable to the desired resolution.
# 3. Set the 'scripfile' variable to the path of the SCRIP file.
# 4. Set the 'gridconnectivityfile' variable to the desired path for the grid connectivity file.
# 5. Run this script to generate the grid connectivity file.

# Associative array mapping resolution names to mesh IDs
declare -A mesh_dict
mesh_dict["480km"]=2562
mesh_dict["240km"]=10242
mesh_dict["120km"]=40962
mesh_dict["60km"]=163842
mesh_dict["30km"]=655362
mesh_dict["15km"]=2621442
mesh_dict["7.5km"]=10458762
mesh_dict["3.75km"]=41943042

# Specify the desired resolution for grid connectivity generation
dx="15km"

# Path to the SCRIP file
scripfile="/glade/scratch/fjudt/mpas_meshes/x1.${mesh_dict[$dx]}.grid.SCRIP.nc"

# Path for the grid connectivity file
gridconnectivityfile="/glade/scratch/fjudt/mpas_meshes/x1.${mesh_dict[$dx]}.grid-connectivity.txt"

# Run the 'GenerateConnectivityFile' command to generate the grid connectivity file
#./bin/GenerateConnectivityFile --in_mesh $scripfile --out_type FV --out_connect $gridconnectivityfile

#Note: For a 15-km mesh or higher resolution meshes, use:
/glade/work/zarzycki/tempestextremes/bin/GenerateConnectivityFile --in_mesh $scripfile --out_type FV --out_connect $gridconnectivityfile

