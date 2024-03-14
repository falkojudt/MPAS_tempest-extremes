import sys
import os
import shutil
import netCDF4 as nc
import datetime
import re

def create_or_update_time_var(ncfile, time_diff_str, converted_str):
    """
    Function to create or update the 'time' variable in a NetCDF file.

    Parameters:
    - ncfile: NetCDF file object.
    - time_diff_str: String representing the time difference.
    - converted_str: String representing the reference time.

    Returns:
    - time_var: Updated 'time' variable object.
    """
    # Check if 'time' dimension exists, otherwise create it
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

# Input arguments
ifile = sys.argv[1]
ref_time_str = sys.argv[2]
time_diff_str = sys.argv[3]
tmpdir = sys.argv[4]
#print(ref_time_str, time_diff_str)

# Make a copy of the original file if it doesn't exist
# Split the path and filename
path, filename = os.path.split(ifile)

# Join the path and the copy filename to get the full path for the copy
filecopy = os.path.join(tmpdir, filename)
print("filecopy:", filecopy)

if not os.path.exists(filecopy):
 
    from netCDF4 import Dataset

    def copy_netcdf_variables(ifile, ofile, variables_to_copy):
        """
        Function to copy specific variables from one NetCDF file to another.

        Parameters:
        - ifile: Input NetCDF file to copy from.
        - ofile: Output NetCDF file to copy to.
        - variables_to_copy: List of variable names to copy.

        Returns:
        None
        """
        with Dataset(ifile, 'r') as src, Dataset(ofile, 'w') as dst:
            # Copy global attributes
            dst.setncatts(src.__dict__)
    
            # Copy dimensions
            for name, dimension in src.dimensions.items():
                dst.createDimension(name, len(dimension) if not dimension.isunlimited() else None)
    
            # Copy variables
            for var_name, var in src.variables.items():
                if var_name in variables_to_copy:
                    out_var = dst.createVariable(var_name, var.datatype, var.dimensions)
                    out_var.setncatts({k: var.getncattr(k) for k in var.ncattrs()})
                    out_var[:] = var[:]
    
            print("Variables copied successfully.")

    # Copy variables to new diag file 
    variables_to_copy = ["u10", "v10", "mslp", "height_500hPa", "height_250hPa", "meanT_500_300", "rainc", "rainnc"] 
    copy_netcdf_variables(ifile, filecopy, variables_to_copy)


with nc.Dataset(filecopy, 'r+') as ncfile:
    # Check if 'time' variable is in the correct format. 
    # If it doesn't exist or is not in the expected format, create or update it.
    time_var = create_or_update_time_var(ncfile, time_diff_str, ref_time_str)

print("Copy variables to new diag file and make variable 'time' TempestExtremes compliant...process completed.")

