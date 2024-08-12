#!/bin/bash

# Run this script to create a text file containing the `--in_data` argument
# for a sequence of processing operations (one per line) and a text file 
# containing an equal number of lines to `--in_data_list` specifying the output
# nodefiles from each input datafile. This will generate a list of diagnostic 
# files that TE will run on.

# Define dx, meshdir, datadir, and mesh_dict.
. config.sh

#datadir=${tmpdir}

#if [ ! -d "$datadir/te" ]; then
#    mkdir "$datadir/te"
#fi

#--- 3-hourly
#ls ${tmpdir}/diag.${dx}.20??-??-??_{00,03,06,09,12,15,18,21}.00.00.nc > ${tmpdir}/diag_filelist.txt
#ls ${datadir}/diag.20??-??-??_{00,03,06,09,12,15,18,21}.00.00.nc > $datadir/te/diag_filelist.txt
#--- 6-hourly
ls ${tmpdir}/diag.${dx}.20??-??-??_{00,06,12,18}.00.00.nc > $tmpdir/diag_filelist.txt

#make detect-nodes fileliest 
source_file="${tmpdir}/diag_filelist.txt"
dest_file="${tmpdir}/detect-nodes_filelist.txt"

cp $source_file $dest_file

# Replace all instances of "diag" with "detect-nodes"
sed -i 's/diag/detect-nodes/g' "$dest_file"

# Replace all instances of ".nc" with ".txt"
sed -i 's/.nc/.txt/g' "$dest_file"
