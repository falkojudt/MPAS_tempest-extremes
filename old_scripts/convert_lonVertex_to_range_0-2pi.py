import numpy as np
import netCDF4 as nc
import shutil

resolution_dir = { 
   "480km"  :     2562,
   "240km"  :    10242,
   "120km"  :    40962,
    "60km"  :   163842,
    "30km"  :   655362,
    "15km"  :  2621442,
    "7.5km" : 10485762,
    "3.75km": 41943042,
}


run = "240km"


datadir = "/glade/scratch/fjudt/mpas_meshes"

src_file = f"{datadir}/x1.{resolution_dir[run]}.grid.nc"
dst_file = f"{datadir}/x1.{resolution_dir[run]}.grid.modified-lonVertex.nc"

shutil.copyfile(src_file, dst_file)

nc_file = nc.Dataset(dst_file, 'r+')


lonVertex_var = nc_file.variables['lonVertex']
lonVertex_var[:] = np.mod(lonVertex_var[:], 2*np.pi)

nc_file.close()

