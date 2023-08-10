#!/bin/bash

experiment="dyamond_2"
dx=30km

datadir="/glade/campaign/mmm/wmr/fjudt/projects/$experiment/$dx"

if [ ! -d "$datadir/te" ]; then
    mkdir "$datadir/te"
fi

#--- 3-hourly
ls ${datadir}/diag.2020-0?-??_{00,03,06,09,12,15,18,21}.00.00.nc > $datadir/te/diag_filelist.txt
#--- 6-hourly
ls ${datadir}/diag.2020-0?-??_{00,06,12,18}.00.00.nc > $datadir/te/diag_filelist.txt

#make detect-nodes fileliest 
source_file="$datadir/te/diag_filelist.txt"
dest_file="$datadir/te/detect-nodes_filelist.txt"

cp $source_file $dest_file


# Replace all instances of "diag" with "detect-nodes"
sed -i 's/diag/te\/detect-nodes/g' "$dest_file"

# Replace all instances of ".nc" with ".txt"
sed -i 's/.nc/.txt/g' "$dest_file"
