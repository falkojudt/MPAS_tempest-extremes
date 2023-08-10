import sys
import os
import shutil
import netCDF4 as nc
import datetime
import re

def create_or_update_time_var(ncfile, time_diff_str, converted_str):
    if 'time' not in ncfile.dimensions:
        if 'Time' in ncfile.dimensions:
            print("Rename 'Time' to 'time'")
            ncfile.renameDimension('Time', 'time')
        else:
            print("Create 'time' dimension.")
            ncfile.createDimension('time')

    if 'time' not in ncfile.variables:
        print("Add numeric time variable.")
        time_var = ncfile.createVariable('time', 'f', ('time',))
        time_var.units = f'hours since {ref_time_str}'
        time_var.long_name = 'valid time'
        time_var[:] = time_diff_str
    else:
        time_var = ncfile.variables['time']
        
    return time_var


ifile = sys.argv[1]
ref_time_str = sys.argv[2]
time_diff_str = sys.argv[3]
#print(ref_time_str, time_diff_str)

# Make a copy of the original file if it doesn't exist
filecopy = ifile + "_copy"
if not os.path.exists(filecopy):
    shutil.copyfile(ifile, filecopy)

with nc.Dataset(ifile, 'r+') as ncfile:
    # Check if 'time' variable is in the correct format. 
    # If it doesn't exist or is not in the expected format, create or update it.
    time_var = create_or_update_time_var(ncfile, time_diff_str, ref_time_str)

print("Process completed.")

