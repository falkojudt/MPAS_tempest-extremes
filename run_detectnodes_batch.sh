#!/bin/bash -l
#PBS -N detectNodes
#PBS -A NMMM0013
#PBS -l select=4:ncpus=24:mpiprocs=8
#PBS -l walltime=3:00:00
#PBS -q casper
#PBS -j oe

export TMPDIR=/glade/derecho/scratch/$USER/tmp
mkdir -p $TMPDIR

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
connectfile="/glade/derecho/scratch/fjudt/mpas_meshes/x1.${mesh_dict[$dx]}.grid-connectivity.txt"

#----------- settings from Ullrich et al. 2021
# --searchbymin MSL
# --closedcontourcmd "MSL,200.0,5.5,0;_DIFF(Z(300hPa),Z(500hPa)),-58.8,6.5,1.0"
# --mergedist 6.0
# --outputcmd "MSL,min,0;_VECMAG(VAR_10U,VAR_10V),max,2;ZS,min,0


#closedcontourcmd="mslp,300,5.5,0;_AVG(temperature_500hPa,temperature_250hPa),-1.0,6.5,1.0"
#closedcontourcmd="mslp,300,5.5,0;_DIFF(height_200hPa,height_850hPa),-45.0,10,1.0"
closedcontourcmd="mslp,200,5.5,0;_DIFF(height_250hPa,height_500hPa),-6.0,6.5,1.0;_AVG(temperature_500hPa,temperature_250hPa),-2.0,6.5,1.0"
mergedist=6.0
searchbymin="mslp"
outputcmd="mslp,min,0;_VECMAG(u10,v10),max,2;zgrid,min,0"

mpirun ~/tempestextremes/bin/DetectNodes --in_data_list "${datadir}/te/diag_filelist.txt" --in_connect $connectfile --searchbymin $searchbymin --closedcontourcmd $closedcontourcmd --mergedist $mergedist --out_file_list "$datadir/te/detect-nodes_filelist.txt" --outputcmd $outputcmd
