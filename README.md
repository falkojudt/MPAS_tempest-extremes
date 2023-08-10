# MPAS_tempest-extremes
Tempest Extremes for Analyzing Tropical Cyclones in MPAS Data: scripts and software guide 

Introduction:

Tempest Extremes (TE) is a tool designed to analyze extreme weather events in weather and climate model output. This guide will walk you through the step-by-step process of running TE on MPAS (Model for Prediction Across Scales) output data. The instructions provided here are specifically tailored for NCAR's Casper data analysis cluster. Additionally, we will provide you with scripts for data pre-processing and running TE. If you are new to TE, it is recommended to refer to the [TE user guide](https://climate.ucdavis.edu/tempestextremes.php). Please note that you need to modify certain elements such as directories and the \`#pbs -A project\_code\` in the batch job scripts to suit your specific setup.

Prerequisites:

Before proceeding with the TE analysis, ensure that you have the following prerequisites in place:

1\. Access to MPAS output data files (e.g., \`diag.2020-01-20\_00.00.00.nc\`).

2\. Familiarity with TE concepts and usage as provided in the [TE user guide](https://climate.ucdavis.edu/tempestextremes.php#DetectNodes).

Accessing the scripts:

The scripts required to pre-process the data and run TE can be downloaded by cloning this repository, or you can find them on NCAR's glade filesystem in the following directory: `/glade/u/home/fjudt/projects/mpas-tools/tempest_extremes`

Pre-processing steps:

Before running Tempest Extremes, some pre-processing steps need to be performed to ensure compatibility with the tool. Steps 1-3 only need to be done once for each MPAS mesh, **and only if a connectivity file does not exist**. Check for a connectivity file for a given mesh here: \`/glade/campaign/mmm/wmr/fjudt/mpas\_meshes/x1.XXXXXX.grid-connectivity.txt\`, where XXXXXX represents the number of cells in the mesh. For example, the 15-km MPAS mesh has 2621442 cells, so we would look for the connectivity file \`x1.2621442.grid-connectivity.txt\`. If such a file does not exist, proceed with Steps 1-3 below; otherwise, continue with Step 4.

Note: If you need to run Step 2 (Creating a SCRIP file), ensure you have installed the 'mpas-tools' package from <https://github.com/MPAS-Dev/MPAS-Tools>. Here we assume it's installed into a Conda environment named "mpas-tools". The other Python scripts should be compatible with the 'npl' environment on Casper.

Step 1. Converting the lonVertex Range in the MPAS mesh file

MPAS has the \`lonVertex\` range from (-pi, pi), but creating a connectivity file requires a range from (0, 2pi). To convert the \`lonVertex\` range from (-pi, pi) to (0, 2pi), use the script \`convert\_lonVertex.py\`. In that script, choose the mesh you are using.

To run on Casper:

    module load conda
    conda activate npl
    python convert_lonVertex.py

Step 2. Creating a SCRIP File

This step is needed because the MPAS mesh file is not SCRIP-conform. To generate a SCRIP file from the MPAS mesh file, use the script \`create\_SCRIP-file.sh\`. In that script, choose your MPAS mesh via the \`dx\` variable (e.g., \`dx="15km"\`).

To run on Casper:

    ./create_SCRIP-file.sh

Step 3. Creating a Grid Connectivity File

The connectivity file is what TE needs to read the unstructured MPAS data. Create a grid connectivity file by executing the script \`create\_connectivity-file.sh\`. Again, choose your MPAS mesh via the \`dx\` variable (e.g., \`dx="15km"\`).

To run on Casper:

    ./create_connectivity-file.sh

Note: For a 15-km mesh or higher resolution meshes, use the second executable that is in the script (commented out by default) and execute the script from Cheyenne.

Now we should have a connectivity file, and we can move on to pre-process the actual MPAS \`diag\` files.

Step 4. Pre-processing MPAS Diagnostic Files

Before running TE on the MPAS diagnostic files, some additional pre-processing steps are required. These steps should be performed for each output file, but with the batch scripts provided, this can be done efficiently. The \`preprocess\_diag\_files.sh\` script combines all the pre-processing steps.

To submit on Casper:

    qsub preprocess_diag_files.sh

Don't forget to change the project account key and update the paths in the script.

The following steps are included in `preprocess_diag_files.sh`:

1\. Rename the dimension "Time" to "time" via the python script `make_time_te_compliant.py`

2\. Add a numeric "time" variable (TE does not support MPAS's \`xtime\` variable) via the python script `make_time_te_compliant.py`.

3\. Add surface topography (height of the lowest model level) to the files. This is necessary to filter out false alarms related to topography via the python script `copy_zgrid_to_diag.py`.

Running Tempest Extremes:

Step 1. Creating Filelists

To run TE efficiently, we need to provide a filelist of the \`diag\` files and a filelist specifying the output files from \`detectNodes\`. Run the \`make\_filelist.sh\` script to create a text file containing the \`--in\_data\` argument for a sequence of processing operations (one per line) and a text file containing an equal number of lines to \`--in\_data\_list\` specifying the output nodefiles from each input datafile. This will generate a list of diagnostic files that TE will run on.

To run on Casper:

    ./make_filelist

Step 2. Running TE

To run TE, specifically \`DetectNodes\` for the detection of nodal features and \`StitchNodes\` to connect nodal features together in time, producing paths associated with singular features, use the script \`run\_detectnodes\_stitchnodes\_batch.sh\` to submit a batch job for parallelization. If it runs correctly, it will produce a \`tc\_tracks.txt\` file that contains the TC tracks. You can use this file for further analysis.

To run on Casper:

    qsub run_detectnodes_stitchnodes_batch.sh

Ensure you have made necessary changes to the project account key and paths in the script.

That should be it!
