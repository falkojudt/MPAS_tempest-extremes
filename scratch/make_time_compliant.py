import glob
import shutil
import numpy as np
import netCDF4 as nc
import datetime
import re

def calculate_time_diff(filepath, ref_time):
    pattern = r'\d{4}-\d{2}-\d{2}_\d{2}.\d{2}.\d{2}'
    match = re.search(pattern, filepath)
    time_str = match.group(0)
    
    filename_time = datetime.datetime.strptime(time_str, '%Y-%m-%d_%H.%M.%S')
    time_diff = filename_time - ref_time
    
    time_in_hours = time_diff.total_seconds() / 3600.0
    print("time_diff", time_diff, "time_in_hours", time_in_hours)    
    return time_diff, time_in_hours

def delete_var(ncfile, varname):
    del ncfile.variables[varname]

def create_time_var(ncfile, time_diff):
    time_var = ncfile.createVariable('time', 'f', ('time',))
    time_var.units = 'hours since 2016-08-01 00:00:00'
    time_var.long_name = 'valid time'
    time_var[:] = time_diff.total_seconds() / 3600.0

    return time_var



python script.py "$filename"

experiment = "dyamond_2"
dx = "3.75km"

datadir = "/glade/campaign/mmm/wmr/fjudt/projects/"+experiment+"/"+dx
ref_time = datetime.datetime(2020, 1, 20, 0, 0, 0)

for filepath in sorted(glob.glob(datadir + '/diag.*nc')):
    
    # make a copy of the original data just in case something goes wrong
    src_file = filepath
    dst_file = filepath + "_copy"
    print(src_file)
    
    # make copy of original file if it doesn't exist
    if not os.path.exists(dst_file):
        shutil.copyfile(src_file, dst_file)

    ncfile = nc.Dataset(src_file, 'r+')
    
    if 'time' in ncfile.dimensions and 'time' in ncfile.variables and ncfile.variables['time'].datatype == np.float32:
        print("Nothing to do here")

    else:
        print("The file does not have a 'time' dimension and variable.")                    
        
        ncfile.renameDimension('Time', 'time')
        
        # Calculate the time difference from the reference time
        time_diff, time_in_hours = calculate_time_diff(src_file, ref_time)
        print("time_diff", time_diff)        
        
        # Create time variable
        time_var = create_time_var(ncfile, time_diff)
        
        ncfile.close() 

