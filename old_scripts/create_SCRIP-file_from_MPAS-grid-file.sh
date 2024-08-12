#!/bin/bash

module load conda
conda activate mpas-tools

datadir="/glade/campaign/mmm/wmr/fjudt/projects/dyamond_1/$run"

declare -A mesh_dict
mesh_dict["480km"]=2562
mesh_dict["240km"]=10242
mesh_dict["120km"]=40962
mesh_dict["60km"]=163842
mesh_dict["30km"]=655362
mesh_dict["15km"]=2621442
mesh_dict["7.5km"]=10458762
mesh_dict["3.75km"]=41943042

run="240km"

gridfile="/glade/scratch/fjudt/mpas_meshes/x1.${mesh_dict[$run]}.grid.modified-lonVertex.nc"
scripfile="/glade/scratch/fjudt/mpas_meshes/x1.${mesh_dict[$run]}.grid.SCRIP.nc"

scrip_from_mpas -m $gridfile $scripfile

mv ./scrip.nc $scripfile
