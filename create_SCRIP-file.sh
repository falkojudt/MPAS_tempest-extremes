#!/bin/bash -l

####################################################

# This script converts MPAS grid files to SCRIP format using the 'scrip_from_mpas' command.

# Instructions:
# 1. Install mpas_tools before running this script by running `conda install mpas_tools`.
# 2. Run this script to convert the MPAS grid file to SCRIP format.

# Load the 'conda' module
module load conda

# Activate conda environment with mpas_tools
conda activate mpas-tools

# Define dx, datadir, and mesh_dict.
. config.sh

# Path to the grid file with modified lonVertex variable
gridfile="/glade/scratch/fjudt/mpas_meshes/x1.${mesh_dict[$dx]}.grid.modified-lonVertex.nc"

# Path to the SCRIP output file
scripfile="/glade/scratch/fjudt/mpas_meshes/x1.${mesh_dict[$dx]}.grid.SCRIP.nc"

# Run the 'scrip_from_mpas' command to convert the grid file to SCRIP format
scrip_from_mpas -m $gridfile $scripfile

# Move the generated 'scrip.nc' file to the desired location
mv ./scrip.nc $scripfile


