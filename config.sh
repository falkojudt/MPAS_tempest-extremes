# Specify the resolution
dx=7.5km

# Directory containing MPAS mesh files
meshdir=/glade/scratch/fjudt/mpas_meshes

# Directory containing MPAS output files
datadir=/glade/campaign/mmm/wmr/fjudt/projects/dyamond_1/$dx

# Modify the 'mesh_dict' associative array to map resolution names to the corresponding mesh IDs.
# Associative array mapping resolution names to mesh IDs
declare -A mesh_dict
mesh_dict["480km"]=2562
mesh_dict["240km"]=10242
mesh_dict["120km"]=40962
mesh_dict["60km"]=163842
mesh_dict["30km"]=655362
mesh_dict["15km"]=2621442
mesh_dict["7.5km"]=10458762
mesh_dict["3.75km"]=41943042
