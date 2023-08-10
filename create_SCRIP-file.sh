#!/bin/bash -l

####################################################

# This script converts MPAS grid files to SCRIP format using the 'scrip_from_mpas' command.

# Instructions:
# 1. Make sure the 'conda' command is available on your system.
# 2. Activate the 'mpas-tools' Conda environment before dxning this script.
# 3. Set the 'datadir' variable to the directory containing the MPAS mesh files.
# 4. Modify the 'mesh_dict' associative array to map resolution names to the corresponding mesh IDs.
# 5. Specify the desired resolution by setting the 'dx' variable to the desired resolution.
# 6. Run this script to convert the MPAS grid file to SCRIP format.

# Load the 'conda' module
module load conda

# Activate the 'mpas-tools' environment (get it from https://github.com/MPAS-Dev/MPAS-Tools)
conda activate mpas-tools

# Directory containing MPAS files
datadir="/glade/campaign/mmm/wmr/fjudt/projects/dyamond_1/$dx"

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

# Specify the desired resolution to convert
dx="15km"

# Path to the grid file with modified lonVertex variable
gridfile="/glade/scratch/fjudt/mpas_meshes/x1.${mesh_dict[$dx]}.grid.modified-lonVertex.nc"

# Path to the SCRIP output file
scripfile="/glade/scratch/fjudt/mpas_meshes/x1.${mesh_dict[$dx]}.grid.SCRIP.nc"

# Run the 'scrip_from_mpas' command to convert the grid file to SCRIP format
scrip_from_mpas -m $gridfile $scripfile

# Move the generated 'scrip.nc' file to the desired location
mv ./scrip.nc $scripfile


