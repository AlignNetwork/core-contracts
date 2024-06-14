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
        # Default 
        # Sensible defaults all include name, summary, content, SEMVER version, if it inherits from another interaction type include those
        blog='{
          "version": "0.1.0",
          "name": "blog",
          "summary": "This is a blog post, it will have no more than 100,000 characters. General accepted rules of decency when posting, similar to X (formerly Twitter) rules and policies.",
          "content": {
            "from": "align id of poster",
            "post": "content of post",
            "image": "link to image",
            "dateOf": "date posted"
          }
        }'
        post='{
          "version": "0.1.0",
          "name": "post",
          "summary": "This is a simple post, it will have no more than 128 characters. General accepted rules of decency when posting, similar to X (formerly Twitter) rules and policies.",
          "content": {
            "from": "align id of poster",
            "post": "content of post",
            "image": "link to image",
            "dateOf": "date posted"
          }
        }'
        dispute='{
          "version": "0.1.0",
          "name": "dispute",
          "summary": "This is a simple dispute tracker, place all relevant information inside claim.",
          "content": { "to": "align id of recipient", "claim": "content of claim", "dateOf": "date posted" }
        }
        '
        points='{
          "version": "0.1.0",
          "name": "points",
          "summary": "This is a simple points tracker.",
          "content": { "from": "align id of awarder", "amount": "number of points", "dateOf": "date awarded" }
        }'
        align_points_program_1='{
            "version": "0.1.0",
            "name": "Align Testnet Program 1",
            "summary": "This is a points tracker for the Align Testnet Program 1.",
            "content": {
              "programStart": "UNIX timestamp of program start",
              "programEnd": "UNIX timestamp of program end",
              "reasons": [{"points": "number of points", "reason": "reason for awarding points"}]
            },
            "inherits": []
          }
          '
        profile='{
          "version": "0.1.1",
          "name": "align profile",
          "summary": "This is an Align Profile.",
          "content": {
            "image": "link to image",
            "name": "name of profile",
            "bio": "short 10000 character bio"
          }
        }'
        file='{
          "version": "0.1.0",
          "name": "align file upload",
          "summary": "This is a generic file upload.",
          "content": "Uint8Array of file contents"
        }'
        #upload "$blog"
        #upload "$post"
        #upload "$dispute"
        #upload "$points"
        #upload "$profile"
        upload "$file"
        ;;
    *)
        echo "Usage: $0 {Defaults}"
        exit 1
esac
