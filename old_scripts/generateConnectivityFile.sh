#!/bin/bash

declare -A mesh_dict
mesh_dict["480km"]=2562
mesh_dict["240km"]=10242
mesh_dict["120km"]=40962
mesh_dict["60km"]=163842
mesh_dict["30km"]=655362
mesh_dict["15km"]=262144
mesh_dict["7.5km"]=10458762
mesh_dict["3.75km"]=41943042

dx="240km"

scripfile="/glade/scratch/fjudt/mpas_meshes/x1.${mesh_dict[$dx]}.grid.SCRIP.nc"
gridconnectivityfile="/glade/scratch/fjudt/mpas_meshes/x1.${mesh_dict[$dx]}.grid-connectivity.txt"

./bin/GenerateConnectivityFile --in_mesh $scripfile --out_type FV --out_connect $gridconnectivityfile
