#!/bin/bash

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

datadir="/glade/campaign/mmm/wmr/fjudt/projects/dyamond_1/$run"
connectfile="/glade/scratch/fjudt/mpas_meshes/x1.${mesh_dict[$run]}.grid-connectivity.txt"
#closedcontourcmd="mslp,300,5.5,0;_AVG(temperature_500hPa,temperature_250hPa),-1.0,6.5,1.0"
#closedcontourcmd="mslp,200,5.5,0;_DIFF(height_200hPa,height_850hPa),-45.0,10,1.0"
closedcontourcmd="mslp,200,5.5,0;_DIFF(height_250hPa,height_500hPa),-4.0,10,1.0"
mergedist=6.0
searchbymin="mslp"
outputcmd="mslp,min,0;_VECMAG(u10,v10),max,2;zgrid,min,0"

mpirun ~/tempestextremes/bin/DetectNodes --in_data_list "${datadir}/te/diag_filelist.txt" --in_connect $connectfile --searchbymin $searchbymin --closedcontourcmd $closedcontourcmd --mergedist $mergedist --out_file_list "$datadir/te/detect-nodes_filelist.txt" --outputcmd $outputcmd

# clean up
#rm -f log*.txt
