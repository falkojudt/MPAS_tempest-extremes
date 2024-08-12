#!/bin/bash -l
#PBS -N detectNodes
#PBS -A NMMM0013
#PBS -l select=2:ncpus=36
#PBS -l walltime=02:30:00
#PBS -q regular
#PBS -j oe

###----------------------------------------------
### Only works if data is not on /glade/campaign
###----------------------------------------------

export TMPDIR=/glade/scratch/$USER/temp
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

run="7.5km"

datadir="/glade/campaign/mmm/wmr/fjudt/projects/dyamond_1/$run"
connectfile="/glade/scratch/fjudt/mpas_meshes/x1.${mesh_dict[$run]}.grid-connectivity.txt"

mpiexec_mpt ./bin/DetectNodes --in_data_list "${datadir}/diag_filelist.txt" --in_connect $connectfile --searchbymin mslp --closedcontourcmd "mslp,200.0,5.5,0;temperature_500hPa,-1.5,6.5,2.0" --mergedist 6.0 --out_file_list "$datadir/detect-nodes_filelist.txt" --outputcmd "mslp,min,0;_VECMAG(u10,v10),max,2" 
