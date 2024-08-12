import os
import subprocess
import pandas as pd
import netCDF4 as nc



datadir = "/glade/campaign/mmm/wmr/fjudt/projects/dyamond_1/15km/"
variable_to_delete = "time"
start_date_str = "2016-08-01 01:00:00"
end_date_str = "2016-08-01 02:00:00"
interval_minutes = 15

start_date = pd.to_datetime(start_date_str)
end_date = pd.to_datetime(end_date_str)


while start_date <= end_date:
    filename = datadir + "diag." + start_date.strftime('%Y-%m-%d_%H.%M.%S') + ".nc"
    new_filename = datadir + "diag." + start_date.strftime('%Y-%m-%d_%H.%M.%S') + ".new.nc"
    print(filename)

    # open source file
    src_file = nc.Dataset(filename, "r")

    # create destination file
    dst_file = nc.Dataset(new_filename, "w")

    # copy dimensions from source to destination, renaming "time" dimension to "Time"
    for dimname, dim in src_file.dimensions.items():
        if dimname == "time":
            dst_file.createDimension("Time", None)
        else:
            dst_file.createDimension(dimname, len(dim))

    # copy data variables to destination file, skipping "time" variable
    for name, variable in src_file.variables.items():
        if name != "time":
            x = dst_file.createVariable(name, variable.datatype, variable.dimensions)
            dst_file[name][:] = src_file[name][:]

    # close files
    src_file.close()
    dst_file.close()

    # Replace the original file with the new file
    #os.rename(new_filename, filename)

    # increment current date
    start_date += pd.Timedelta(minutes=interval_minutes)








    ## Open the original netCDF file for reading
    #with nc.Dataset(filename, "r") as src:
    #
    #    # Create a new netCDF file for writing
    #    with nc.Dataset(new_filename, "w") as dst:
    #
    #        # Copy global attributes from the source to the destination
    #        dst.setncatts(src.__dict__)
    #
    #        # Copy dimensions from the source to the destination, renaming "time" to "Time"
    #        for name, dimension in src.dimensions.items():
    #            if name == "time":
    #                print('   dim is "time", rename to "Time"')
    #                dst.createDimension("Time", len(dimension) if not dimension.isunlimited() else None)
    #            else:
    #                dst.createDimension(name, len(dimension) if not dimension.isunlimited() else None)
    #
    #        # Copy variables from the source to the destination, except the one to delete
    #        for name, variable in src.variables.items():
    #            if name != variable_to_delete:
    #                x = dst.createVariable(name, variable.datatype, variable.dimensions)
    #                if name == "time":
    #                    print("   variable 'time' exists...don't copy")
    #                    x.setncatts(variable.__dict__)
    #                    x.long_name = "Time"
    #                else:
    #                    x.setncatts(variable.__dict__)
    #                    dst[name][:] = src[name][:]
    #
    ## Replace the original file with the new file
    #os.rename(new_filename, filename)
    #
    ## increment current date
    #start_date += pd.Timedelta(minutes=interval_minutes)


#datadir = "/glade/campaign/mmm/wmr/fjudt/projects/dyamond_1/15km/"
#start_date_str = "2016-08-01 00:00:00"
#end_date_str = "2016-08-01 01:00:00"
#interval_minutes = 15
#
#start_date = pd.to_datetime(start_date_str)
#end_date = pd.to_datetime(end_date_str)
#
#
## loop over all time intervals
#while start_date <= end_date:
#    filename = datadir + "diag." + start_date.strftime('%Y-%m-%d_%H.%M.%S') + ".nc"
#    print(filename)
#    # check if file exists, if not skip to next time interval
#    if not os.path.isfile(filename):
#        print("File " + filename + " not found, skipping.")
#        start_date += pd.Timedelta(minutes=interval_minutes)
#        continue
#
#    # open netcdf file
#    with nc.Dataset(filename, "r+") as nc_file:
#        # check if dimension "time" exists
#        if "time" in nc_file.dimensions:
#            print("time dim is 'time'...need to rename to 'Time'")
#            # rename dimension "time" to "Time"
#            nc_file.renameDimension("time", "Time")
#            print("Dimension 'time' renamed to 'Time' in file " + filename)
# 
#        
#
#    # increment current date
#    start_date += pd.Timedelta(minutes=interval_minutes)
