#!/bin/bash


read_properties()
{
    filename=$1
    # Read the file and extract key-value pairs
    while IFS='=' read -r key value; do
        # Skip empty lines or lines starting with #
        if [[ -z $key || $key == \#* ]]; then
            continue
        fi

        # Trim leading/trailing whitespace from key
        key=$(echo "$key" | awk '{gsub(/^ +| +$/,"")} {print $0}')

        # Extract the value after the first equals sign
        value="${line#*=}"
        value=$(echo "$value" | awk '{gsub(/^ +| +$/,"")} {print $0}')

        # Assign value to the variable dynamically
        declare "$key"="$value"
    done < "$filename"

    echo $filename
    echo "key1: $key1"
    echo "key2: $key2"
    echo "key3: $key3"
    echo "key4: $key4"




}


importSystemAzureVars()
{
    resourceVar=$1
    enviromentVar=$2
    globalVar=$3

    read_properties $resourceVar 
    read_properties $enviromentVar 
    read_properties $globalVar 





}    