#!/bin/bash -l
#PBS -N te_preprocess
#PBS -A NMMM0013
#PBS -l select=1:ncpus=1:mem=20GB
#PBS -l walltime=1:00:00
#PBS -q casper
####PBS -J 0-496
#PBS -j oe

################################################################################
# In this script, $PBS_ARRAY_INDEX is converted to a datetime string that matches
# an MPAS diagnostic file. The job array range is typically set using
# #PBS -J FIRST-LAST, where FIRST represents 0 (0 hours after $startdate), and
# LAST is calculated based on the simulation length in days multiplied by 24
# hours per day divided by the $interval_hours value. This is done in the 
# submit_preproc_job.sh script.
#
# The script calls two Python scripts:
#   1. make_time_te_compliant.py: Fixes the issue of MPAS diag files having the
#      wrong time format for TE.
#   2. copy_ter_to_diag.py: Copies the terrain height into each diag file.
###----------------------------------------------------------------------------

# Set up temporary directory
export TMPDIR="/glade/derecho/scratch/$USER/tmp"
mkdir -p "$TMPDIR"

# Load required modules
module load cdo
module load nco
module load conda
conda activate npl

# Define dx, meshdir, datadir, and mesh_dict.
. config.sh
echo "meshdir: ${meshdir}"
echo "datadir: ${datadir}"
echo "tmpdir: ${tmpdir}"
echo "trackdir: ${trackdir}"
echo "initfile: ${initfile}"

# Get the current date and forecast time
i=${PBS_ARRAY_INDEX:-0}
current_seconds=$(awk "BEGIN {printf \"%.0f\", ($i * $interval_hours * 3600)}")
forecast_time=$(awk "BEGIN {printf \"%.2f\", ($i * $interval_hours)}")
current_date=$(date -ud "@$(( $(date -ud "$startdate" +%s) + $current_seconds))" +"%Y-%m-%d_%H.%M.%S")

ifile="${datadir}/diag.${dx}.${current_date}.nc"
#ifile="${datadir}/diag.${current_date}.nc"

# Display information
echo "------------------------"
echo "Processing file: $ifile"
echo "Forecast time: $forecast_time hours since $startdate"

#--- copy relevant variables to new diag file and add numeric time variable 
#    to diag file and rename dimension "Time" to "time"
python make_time_te_compliant.py "$ifile" "$startdate" "$forecast_time" "$tmpdir"

#--- optional: Copy terrain height to diag files. Needed to filter out condidates that
#    are tied to topography.
ifile="${tmpdir}/diag.${dx}.${current_date}.nc"
python copy_ter_to_diag.py "$ifile" "$initfile"

# Move log files to logs directory
mv te_preprocess* logs/

