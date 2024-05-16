#!/bin/bash

source ./upload.sh

# Function to deploy each script
deploy_script() {
    local script_name=$1
    echo "Deploying $script_name..."
    unset PRIVATE_KEY
    unset ETH_FROM
    source .env && forge script script/$script_name:Deploy --fork-url $RPC_URL --broadcast --private-key $PRIVATE_KEY --legacy --skip-simulation --gas-price 0 --gas-limit 1000000000 -vvv
    #localhost: 
    #source .env && forge script script/$script_name:Deploy --rpc-url http://localhost:8545 --broadcast

    echo "Deployed $script_name!"
}

# Check for command line argument
case $1 in
    IdRegistry)
        # Deploy AlignIdRegistry
        deploy_script "00_AlignIdRegistry.s.sol"
        ;;
    InteractionStation)
        # Deploy Align Attestation Station
        deploy_script "01_InteractionStation.s.sol"
        ;;
    DefaultInteractions)
        # Default 
        blog='{"name":"blog","summary":"This is a blog post, it will have no more than 100,000 characters. General accepted rules of decency when posting, similar to X (formerly Twitter) rules and policies.","content": {"from": "align id of poster","post": "content of post", "image": "link to image","dateOfPost":"date posted"}}'
        post='{"name":"post","summary":"This is a simple post, it will have no more than 128 characters. General accepted rules of decency when posting, similar to X (formerly Twitter) rules and policies.","content": {"from": "align id of poster","post": "content of post", "image": "link to image","dateOfPost":"date posted"}}'
        upload "$blog"
        upload "$post"
        ;;
    *)
        echo "Usage: $0 {IdRegistry|InteractionStation|DefaultInteractions}"
        exit 1
esac
