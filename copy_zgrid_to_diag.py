import os
import sys
import subprocess
import netCDF4 as nc

ifile = sys.argv[1]

# Get the directory name by stripping away the filename
datadir = os.path.dirname(ifile)
print(datadir) 

if not os.path.exists(f'{datadir}/zgrid_lev0.nc'):
    print(f'{datadir}/zgrid_lev0.nc does not exist...create it')
    # Command 1: ncks -A -d nVertLevelsP1,0 -v zgrid init.nc dum
    command1 = ['ncks', '-A', '-d', 'nVertLevelsP1,0', '-v', 'zgrid', f'{datadir}/init.nc', f'{datadir}/dum']
    subprocess.run(command1)
    
    # Command 2: ncwa -a nVertLevelsP1 dum zgrid_lev0.nc
    command2 = ['ncwa', '-a', 'nVertLevelsP1', f'{datadir}/dum', f'{datadir}/zgrid_lev0.nc']
    subprocess.run(command2)

# Check if 'zgrid(nCells)' variable exists in ifile
with nc.Dataset(ifile, 'r') as ncfile:
    if 'zgrid(nCells)' not in ncfile.variables:
        # Command 3: ncks -A zgrid_lev0.nc diag*
        command3 = ['ncks', '-A', f'{datadir}/zgrid_lev0.nc', ifile]
        print(command3)
        subprocess.run(command3)
