#!/bin/bash

# Define the URL
dataNetworkUrl="http://localhost:4200/upload"

# Function to upload data
upload() {
  local data=$1
  # Make the POST request using curl
  response=$(curl -s -X POST "$dataNetworkUrl" \
    -H "Content-Type: application/json" \
    -d "$data")

  if [ $? -ne 0 ]; then
      echo "Error uploading data check network connection"
      exit 1
  fi
  echo "$response"
}