#!/bin/bash

. config.sh
echo meshdir: $meshdir

datadir=/glade/derecho/scratch/fjudt
connectfile=${meshdir}/x1.${mesh_dict[$dx]}.grid-connectivity.txt
echo connectfile: $connectfile
#closedcontourcmd="mslp,300,5.5,0;_AVG(temperature_500hPa,temperature_250hPa),-1.0,6.5,1.0"
#closedcontourcmd="mslp,300,5.5,0;_DIFF(height_200hPa,height_850hPa),-45.0,10,1.0"
closedcontourcmd="mslp,300,5.5,0;_DIFF(height_250hPa,height_500hPa),-8.0,6.5,1.0"
mergedist=6.0
searchbymin="mslp"
outputcmd="mslp,min,0;_VECMAG(u10,v10),max,2" ###;zgrid,min,0"

~/tempestextremes/bin/DetectNodes --in_data_list "${datadir}/te/diag_filelist.txt" --in_connect $connectfile --searchbymin $searchbymin --closedcontourcmd $closedcontourcmd --mergedist $mergedist --out_file_list "$datadir/te/detect-nodes_filelist.txt" --outputcmd $outputcmd


range=5.0
mintime="54h"
maxgap="24h"
#threshold="wind,>=,10.0,10;wind,>=,17,8;wind,>=,32,0;lat,<=,45,1;lat,>=,0.0,1"
threshold="wind,>=,10.0,10;lat,<=,50.0,10;lat,>=,-50.0,10" ###;zgrid,<=,150,10"
min_path_dist=5

rm -f $datadir/te/tc_tracks.txt

~/tempestextremes/bin/StitchNodes --in_connect $connectfile --in_list $datadir/te/detect-nodes_filelist.txt --out $datadir/te/tc_tracks.txt --in_fmt "lon,lat,slp,wind,zgrid" --range $range --mintime $mintime --maxgap $maxgap --threshold $threshold --min_path_dist $min_path_dist --out_file_format csv

# clean up
#rm -f log*.txt
