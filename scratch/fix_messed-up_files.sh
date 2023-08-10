#!/bin/bash

module load nco

start_date="2016-08-01 01:30:00"
end_date="2016-08-01 18:15:00"
interval_minutes=15

datadir="/glade/campaign/mmm/wmr/fjudt/projects/dyamond_1/15km"

current_date="$start_date"

while [ "$(date -d "$current_date" +%s)" -le "$(date -d "$end_date" +%s)" ]
do
    echo $current_date
    current_date_formatted=$(date -d "$current_date" +"%Y-%m-%d_%H.%M.%S")
    filepath="${datadir}/diag.$current_date_formatted.nc"
    echo $filepath

    # check if file exists, if not skip to next time interval
    if [ ! -f "$filepath" ]; then
        echo "File $filepath not found, skipping."
        current_date=$(date -d "$current_date $interval" +"%Y-%m-%d_%H.%M.%S")
        continue
    fi
   
    if ncdump -h $filepath | grep -q "int time"; then
        echo "The file contains a variable named 'int time'"
        rm -f  ${filepath}_notime
        ncks -C -x -v time $filepath ${filepath}_notime
    else
        echo "The file does not contain a variable named 'int time'"
        # further commands for when the variable does not exist
    fi 
    
    ncrename -d time,Time ${filepath}_notime ${filepath}_notime_newdim
    
    /usr/bin/cp -rf ${filepath}_notime_newdim ${filepath}
       
    current_date=$(date -d "$current_date $interval_minutes minutes" +"%Y-%m-%d %H:%M:%S")
done

