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
import os
import re

# Directory containing MPAS grid files
meshdir = "/glade/derecho/scratch/fjudt/mpas_meshes"

# Read the configuration from config.sh
with open('config.sh', 'r') as config_file:
    config_lines = config_file.readlines()

# Extract the desired resolution from the config file
dx_line = [line for line in config_lines if line.startswith('dx=')][0]
dx_match = re.match(r'dx=(\d+\.\d+|\d+)km', dx_line)
if dx_match:
    dx_value = dx_match.group(1) + "km"
else:
    raise ValueError("Could not extract resolution from config.sh")

# Extract the meshdir from the config file
meshdir_line = [line for line in config_lines if line.startswith('meshdir=')][0]
meshdir_match = re.match(r'meshdir=(.*)', meshdir_line)
if meshdir_match:
    meshdir = meshdir_match.group(1)
else:
    raise ValueError("Could not extract meshdir from config.sh")

# Extract the datadir from the config file
datadir_line = [line for line in config_lines if line.startswith('datadir=')][0]
datadir_match = re.match(r'datadir=(.*)', datadir_line)
if datadir_match:
    datadir_template = datadir_match.group(1)
else:
    raise ValueError("Could not extract datadir from config.sh")
# Replace $dx with the dx_value in the datadir template
datadir = datadir_template.replace('$dx', dx_value)

# Extract the mesh_dict from the config file
mesh_dict = {}
in_mesh_dict = False
for line in config_lines:
    if line.startswith('declare -A mesh_dict'):
        in_mesh_dict = True
    elif in_mesh_dict and line.strip() == '}':
        break
    elif in_mesh_dict:
        key, value = line.strip().split('=', 1)
        key = re.search(r'"([^"]+)"', key).group(1)  # Extract key within double quotes
        mesh_dict[key] = int(value)

# Check if the desired resolution is in the mesh_dict
if dx_value in mesh_dict:
    desired_resolution = dx_value
    desired_mesh_id = mesh_dict[dx_value]
else:
    raise ValueError("Desired resolution not found in mesh_dict")

# Now you can use 'desired_resolution' and 'desired_mesh_id' in your script
print("Desired Resolution:", desired_resolution)
print("Desired Mesh ID:", desired_mesh_id)
print("data directory:", datadir)
print("mesh directory:", meshdir)

# Source and destination file paths
src_file = f"{meshdir}/x1.{desired_mesh_id}.grid.nc"
dst_file = f"{meshdir}/x1.{desired_mesh_id}.grid.modified-lonVertex.nc"
base, ext = os.path.splitext(src_file)
dst_file = base + ".modified-lonVertex" + ext

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

