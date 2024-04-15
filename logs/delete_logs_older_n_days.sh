#!/bin/bash

#set -x
set -e

if [ -z "$1" ]; then
    echo "no path to dir var"
    exit 1
fi

if [ -z "$2" ]; then
    echo "no days ago var"
    exit 1
fi


days_ago="$2"
logs_directory="$1"
timestamp=$(date "+%Y-%m-%d")
log_file="$logs_directory/clean_old_logs_$timestamp.log"

echo "$timestamp CLEAN JOB STARTED" >> "$log_file"
find "$logs_directory" -type f -mtime "+$days_ago" -exec rm {} \; -exec echo "$timestamp file deleted: {}" \; | tee -a "$log_file"
find "$logs_directory" -mindepth 1 -maxdepth 1 -type d -empty -mtime "+$days_ago" -exec rmdir {} \; -exec echo "$timestamp empty dir deleted: {}" \; | tee -a "$log_file"
echo "$timestamp CLEAN JOB ENDED" >> "$log_file"
