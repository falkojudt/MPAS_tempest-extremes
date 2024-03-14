import os
import sys
import subprocess
import netCDF4 as nc

### this script copies the terrain height variable ("ter") 
### into the previously generated diag files.


ifile = sys.argv[1]
initfile = sys.argv[2]

# Get the directory name by stripping away the filename
datadir = os.path.dirname(ifile)


##if not os.path.exists(f'{datadir}/terrain_height.nc'):
##    print(f'{datadir}/terrain_height.nc does not exist...create it')
##    ### old method:
##    ### Command 1: ncks -A -d nVertLevelsP1,0 -v zgrid init.nc dum
##    ### command1 = ['ncks', '-A', '-d', 'nVertLevelsP1,0', '-v', 'zgrid', f'{initfile}', f'{datadir}/dum']
##    ### new method:
##    # Command 1: ncks -A -v ter init.nc dum
##    command1 = ['ncks', '-A', '-v', 'ter', f'{initfile}', f'{datadir}/terrain_height.nc']
##    subprocess.run(command1)
##    
##    # Command 2: ncwa -a nVertLevelsP1 dum zgrid_lev0.nc
##    #command2 = ['ncwa', '-a', 'nVertLevelsP1', f'{datadir}/dum', f'{datadir}/zgrid_lev0.nc']
##    #subprocess.run(command2)

# If 'ter(nCells)' variable does not exists in ifile, copy it from the init.nc file 
with nc.Dataset(ifile, 'r') as ncfile:
    if 'ter(nCells)' not in ncfile.variables:
       print(f"'ter' not in {ifile}...need to copy it from {initfile}")
       subprocess.run(['ncks', '-A', '-v', 'ter', f'{initfile}', ifile])
