"""
MPAS Grid File Modifier
-----------------------

This script modifies the lonVertex variable in MPAS grid files by converting the range from (-pi, pi) to (0, 2*pi).
It takes a specified resolution value, copies the original grid file, modifies the lonVertex variable in the copied file, and saves the changes.

Instructions:
1. Set the 'datadir' variable to the directory containing the MPAS grid files.
2. Specify the desired resolution by setting the 'dx' variable to the corresponding resolution (e.g., "240km").
3. Run the script to modify the lonVertex variable in the specified grid file.

Dependencies:
- shutil
- numpy
- netCDF4

"""

import shutil
import numpy as np
import netCDF4 as nc

# Directory containing MPAS grid files
datadir = "/glade/scratch/fjudt/mpas_meshes"

# Resolution directory mapping resolution names to cell counts
resolution_dir = {
   "480km"  :     2562,
   "240km"  :    10242,
   "120km"  :    40962,
   "60km"   :   163842,
   "30km"   :   655362,
   "15km"   :  2621442,
   "7.5km"  : 10485762,
   "3.75km" : 41943042,
}

# Specify the desired resolution to modify lonVertex
dx = "15km"

# Source and destination file paths
src_file = f"{datadir}/x1.{resolution_dir[dx]}.grid.nc"
dst_file = f"{datadir}/x1.{resolution_dir[dx]}.grid.modified-lonVertex.nc"

# Copy the source file to the destination
shutil.copyfile(src_file, dst_file)

# Open the copied file for modification
nc_file = nc.Dataset(dst_file, 'r+')

# Access the lonVertex variable in the netCDF file
lonVertex_var = nc_file.variables['lonVertex']

# Modify the lonVertex variable by taking its modulo with 2*pi
lonVertex_var[:] = np.mod(lonVertex_var[:], 2*np.pi)

# Save and close the modified netCDF file
nc_file.close()

