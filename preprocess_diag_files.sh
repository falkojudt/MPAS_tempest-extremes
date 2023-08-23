#!/bin/bash -l
#PBS -N te_preprocess
#PBS -A NMMM0013
#PBS -l select=1:ncpus=1:mem=20GB
#PBS -l walltime=1:00:00
#PBS -q casper
#PBS -J 0-1
#PBS -j oe

################################################################################
# Parallelization using "Job Arrays" for Efficient Job Execution
#
# This script demonstrates the use of job arrays for parallelization in Bash.
# The environment variable $PBS_ARRAY_INDEX is utilized as an argument in running
# the jobs. The variable is set by the scheduler in each of the array subjobs,
# and it spans the range of values specified in the #PBS -J array directive.
#
# In this script, $PBS_ARRAY_INDEX is converted to a datetime string that matches
# an MPAS diagnostic file. The job array range is typically set using
# #PBS -J FIRST-LAST, where FIRST represents 0 (0 hours after $startdate), and
# LAST is calculated based on the simulation length in days multiplied by 24
# hours per day divided by the $interval_hours value.
#
# The script calls two Python scripts:
#   1. make_time_te_compliant.py: Fixes the issue of MPAS diag files having the
#      wrong time format for TE.
#   2. copy_zgrid_to_diag.py: Copies the height of the lowest model level into
#      each diag file.
###----------------------------------------------------------------------------

# Set up temporary directory
export TMPDIR="/glade/scratch/$USER/temp"
mkdir -p "$TMPDIR"

# Load required modules
module load cdo
module load nco
module load conda
conda activate npl

# Define dx, meshdir, datadir, and mesh_dict.
. config.sh
echo "datadir: ${datadir}"

# Define some parameters
startdate="2016-08-01 00:00:00"
interval_hours=1

# Get the current date and forecast time
i=${PBS_ARRAY_INDEX}
current_seconds=$(awk "BEGIN {printf \"%.0f\", ($i * $interval_hours * 3600)}")
forecast_time=$(awk "BEGIN {printf \"%.2f\", ($i * $interval_hours)}")
current_date=$(date -d "@$(( $(date -d "$startdate" +%s) + $current_seconds))" +"%Y-%m-%d_%H.%M.%S")

ifile="${datadir}/diag.${current_date}.nc"

# Display information
echo "Processing file: $ifile"
echo "Forecast time: $forecast_time hours since $startdate"

#--- add numeric time variable to diag file and rename dimension "Time" to "time"
python make_time_te_compliant.py "$ifile" "$startdate" "$forecast_time"

#--- optional: add height of lowest model level to diag files to filter out condidates that
#    are tied to topography
python copy_zgrid_to_diag.py "$ifile"
