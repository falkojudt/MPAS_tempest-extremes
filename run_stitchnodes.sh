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

experiment="dyamond_2"
dx="3.75km"

datadir="/glade/campaign/mmm/wmr/fjudt/projects/$experiment/$dx"
connectfile="/glade/scratch/fjudt/mpas_meshes/x1.${mesh_dict[$dx]}.grid-connectivity.txt"
echo $datadir

#----------- settings from Ullrich et al. 2021
# --in_fmt "lon,lat,slp,wind,zs" --range 8.0 --mintime "54h"
# --maxgap "24h"
# --threshold "wind,>=,10.0,10; lat,<=,50.0,10; lat,>=,-50.0,10; zs,<=,150.0,10"

range=4.0
mintime="54h"
maxgap="24h"
#threshold="wind,>=,10.0,10;wind,>=,17,8;wind,>=,32,0;lat,<=,45,1;lat,>=,0.0,1"
threshold="wind,>=,10.0,10;lat,<=,50.0,10;lat,>=,-50.0,10;zgrid,<=,150,10"
min_path_dist=5

rm -f $datadir/te/tc_tracks.txt

~/tempestextremes/bin/StitchNodes --in_connect $connectfile --in_list $datadir/te/detect-nodes_filelist.txt --out $datadir/te/tc_tracks.txt --in_fmt "lon,lat,slp,wind,zgrid" --range $range --mintime $mintime --maxgap $maxgap --threshold $threshold --min_path_dist $min_path_dist --out_file_format csv

