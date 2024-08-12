#!/bin/bash -l
#PBS -N copy_zgrid
#PBS -A NMMM0013
#PBS -l select=1:ncpus=1
#PBS -l walltime=24:00:00
#PBS -q casper
#PBS -j oe

export TMPDIR=/glade/scratch/$USER/temp
mkdir -p $TMPDIR

module load conda 
conda activate mpas-tools
module load nco

python -u copy_zgrid_to_diag.py
