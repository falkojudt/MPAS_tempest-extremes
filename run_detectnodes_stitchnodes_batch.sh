#!/bin/bash -l
#PBS -N detectNodes
#PBS -A NMMM0013
#PBS -l select=4:ncpus=24:mpiprocs=8
#PBS -l walltime=04:00:00
#PBS -q casper
#PBS -j oe

module load cuda/11.8.0

export TMPDIR=/glade/derecho/scratch/$USER/temp
mkdir -p $TMPDIR

# Load dx, meshdir,  datadir, and mesh_dict.
. config.sh

#datadir=/glade/campaign/mmm/wmr/fjudt/projects/dyamond_2/${dx}
#datadir=/glade/derecho/scratch/fjudt

connectfile="${meshdir}/x1.${mesh_dict[$dx]}.grid-connectivity.txt"
echo "connectfile: " $connectfile

#----------- settings from Ullrich et al. 2021 (GMD)
# --searchbymin MSL
# --closedcontourcmd "MSL,200.0,5.5,0;_DIFF(Z(300hPa),Z(500hPa)),-58.8,6.5,1.0"
# --mergedist 6.0
# --outputcmd "MSL,min,0;_VECMAG(VAR_10U,VAR_10V),max,2;ZS,min,0

closedcontourcmd="mslp,300,5.5,0;_DIFF(height_250hPa,height_500hPa),-8.0,6.5,1.0"
mergedist=6.0
searchbymin="mslp"
outputcmd="mslp,min,0;_VECMAG(u10,v10),max,2;ter,min,0"

mpirun ~/tempestextremes/bin/DetectNodes --in_data_list "${tmpdir}/diag_filelist.txt" --in_connect $connectfile --searchbymin $searchbymin --closedcontourcmd $closedcontourcmd --mergedist $mergedist --out_file_list "$tmpdir/detect-nodes_filelist.txt" --outputcmd $outputcmd

#----------- settings from Ullrich et al. 2021 (GMD)
# --in_fmt "lon,lat,slp,wind,zs" --range 8.0 --mintime "54h"
# --maxgap "24h"
# --threshold "wind,>=,10.0,10; lat,<=,50.0,10; lat,>=,-50.0,10; zs,<=,150.0,10"

infmt="lon,lat,slp,wind,ter"
range=4.0
mintime="54h"
maxgap="24h"
threshold="wind,>=,10.0,10;lat,<=,50.0,10;lat,>=,-50.0,10;ter,<=,150,10"
min_path_dist=5

rm -f $tmpdir/tc_tracks.txt

~/tempestextremes/bin/StitchNodes --in_connect $connectfile --in_list $tmpdir/detect-nodes_filelist.txt --out $tmpdir/tc_tracks.txt --in_fmt $infmt --range $range --mintime $mintime --maxgap $maxgap --threshold $threshold --min_path_dist $min_path_dist --out_file_format csv

cp $tmpdir/tc_tracks.txt $trackdir/tc_tracks_6h.txt

mv log*.txt logs/
