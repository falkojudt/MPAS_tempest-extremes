#!/bin/bash -l
#PBS -N ncwa
#PBS -A NMMM0013
#PBS -l select=1:ncpus=1:mem=20GB
#PBS -l walltime=1:00:00
#PBS -q casper
#PBS -J 0-58
#PBS -j oe

export TMPDIR=/glade/scratch/$USER/temp
mkdir -p $TMPDIR

module load cdo
module load nco

dx="3.75km"
start_date="2016-08-01 00:00:00"
current_date=$(date -d "$start_date" +"%Y-%m-%d %H:%M:%S")
forecast_time=0
interval_hours=0.25
interval_seconds=$(echo "($interval_hours * 3600 + 0.5) / 1" | bc)

datapath="/glade/campaign/mmm/wmr/fjudt/projects/dyamond_1/${dx}"

i=${PBS_ARRAY_INDEX}

current_seconds=$((i * interval_seconds))
current_date=$(date -d "@$(( $(date -d "$start_date" +%s) + $current_seconds))" +"%Y-%m-%d %H:%M:%S")
current_date_formatted=$(date -d "$current_date" +"%Y-%m-%d_%H.%M.%S")
echo "Current date: $current_date_formatted"

ifile="${datapath}/diag.${current_date_formatted}.nc"
tmpfile="${datapath}/diag.${current_date_formatted}.nc_tmp"
rm -f $tmpfile

ncwa -a nVertLevelsP1 $ifile $tmpfile

mv $tmpfile $ifile
echo "moved $tmpfile to $ifile"
