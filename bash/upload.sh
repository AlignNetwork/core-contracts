#!/bin/bash

# Define the URL
#dataNetworkUrl="http://ipfs-dev.align.network/upload"
dataNetworkUrl="http://ipfs.align.network/upload" # Prod
#dataNetworkUrl="http://localhost:4003/upload"

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
  echo $response
  name=$(echo "$data" | grep -o '"name": "[^"]*' | sed 's/"name": "//')
  cid_field=$(echo "$response" | grep -o '"cid":"[^"]*' | sed 's/"cid":"//' | sed 's/".*//')


  echo -e "$name - $cid_field"
}

# Check for command line argument
case $1 in
    Defaults)
        file='{
          "version": "0.1.0",
          "name": "align file upload",
          "summary": "This is a generic file upload.",
          "content": "Uint8Array of file contents"
        }'
        meme='{
          "version": "0.1.0",
          "name": "align meme upload",
          "summary": "This is a generic meme upload.",
          "content": "Uint8Array of meme contents"
        }'
        nft='{
          "version": "0.1.0",
          "name": "align nft upload",
          "summary": "This is a generic NFT upload.",
          "content": "Uint8Array of NFT contents"
        }'
        dispute='{
          "version": "0.1.0",
          "name": "align dispute upload",
          "summary": "This is a generic dispute on an interaction.",
          "content": "Uint8Array of dispute contents"
        }'
        #upload "$file"
        #upload "$meme"
        #upload "$nft"
        upload "$dispute"
        ;;
    *)
        echo "Usage: $0 {Defaults}"
        exit 1
esac
