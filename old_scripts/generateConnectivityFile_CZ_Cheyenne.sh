#!/bin/bash

declare -A mesh_dict

mesh_dict["15km"]=2621442
mesh_dict["7.5km"]=10458762
mesh_dict["3.75km"]=41943042

run="3.75km"

scripfile="/glade/scratch/fjudt/mpas_meshes/x1.${mesh_dict[$run]}.grid.SCRIP.nc"
connectfile="/glade/scratch/fjudt/mpas_meshes/x1.${mesh_dict[$run]}.grid-connectivity.txt"

/glade/work/zarzycki/tempestextremes/bin/GenerateConnectivityFile --in_mesh $scripfile --out_type FV --out_connect $connectfile
