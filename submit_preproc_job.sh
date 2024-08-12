#!/bin/bash

# Define the start date, end date, and interval between time steps
export startdate="2020-01-20 00:00:00"
export enddate="2020-08-15 00:00:00"
export interval_hours=6  # Interval in hours

# Convert the dates to Unix timestamps
start_ts=$(date -d "$startdate" +%s)
end_ts=$(date -d "$enddate" +%s)

# Calculate the difference in seconds and then convert to days
diff_sec=$((end_ts - start_ts))
diff_days=$((diff_sec / 86400))

export simulation_length_days=$diff_days  # simulation length in days


# Calculate total_steps. total_steps is the ending index of the
# job array.
total_steps=$((simulation_length_days * 24 / interval_hours))

# Create logs directory if it doesn't exist
mkdir -p logs

# Submit the job with environment variables
qsub -J 0-${total_steps} \
    -v startdate,simulation_length_days,interval_hours \
    preprocess_diag_files.sh
