# Specify the resolution of the MPAS mesh 
# TODO: what to do for variable resolution meshes?
dx="3.75km"

#--- Set directories/files
meshdir="/glade/campaign/mmm/wmr/fjudt/mpas_meshes" # contains MPAS meshes
datadir="/glade/campaign/mmm/wmr/skamaroc/NSC_2023/3.75km_simulation_output_save" # contains diag/output files
tmpdir="/glade/derecho/scratch/fjudt/te/tmp" # directory to hold temporary files
trackdir="/glade/campaign/mmm/wmr/fjudt/projects/dyamond_3/${dx}/te" # directory where tc_tracks.txt file will be copied to 

initfile="/glade/campaign/mmm/wmr/skamaroc/NSC_2023/x1.41943042.static.nc" # init file


# Associative array mapping resolution names to mesh IDs (mesh spacing <-> number of grid cells)
# So far, the dictionary has  only quasi uniform resolution meshes
declare -A mesh_dict
mesh_dict["480km"]=2562
mesh_dict["240km"]=10242
mesh_dict["120km"]=40962
mesh_dict["60km"]=163842
mesh_dict["30km"]=655362
mesh_dict["15km"]=2621442
mesh_dict["7.5km"]=10458762
mesh_dict["3.75km"]=41943042
