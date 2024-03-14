#!/bin/bash

# Parameters
startdate="2020-01-20 00:00:00"  # Start date and time
interval_hours=6  # Interval in hours
num_iterations=208  # Number of iterations

# Convert startdate to timestamp
start_timestamp=$(date -ud "$startdate" +"%s")

# Loop through iterations
for ((i = 0; i < num_iterations; i++)); do
    # Calculate timestamp for current iteration
    current_timestamp=$((start_timestamp + i * 3600 * interval_hours))
    
    # Format timestamp to desired date format
    current_date=$(date -ud "@$current_timestamp" +"%Y-%m-%d_%H.%M.%S")
    
    # Print current date
    echo "$current_date"
done

