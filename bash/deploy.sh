#!/bin/bash

source "$(dirname "$0")/upload.sh"

# Function to deploy each script
deploy_script() {
    local script_name=$1
    echo "Deploying $script_name..."
    unset PRIVATE_KEY
    unset ETH_FROM
    source .env && forge script script/$script_name:Deploy --fork-url $RPC_URL --broadcast --private-key $PRIVATE_KEY --legacy --skip-simulation --gas-price 0 --gas-limit 1000000000 -vvv --via-ir
    
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
    VerifyIPFS)
        # Deploy AlignIdRegistry
        deploy_script "01_VerifyIPFS.s.sol"
        ;;
    InteractionStation)
        # Deploy Align Attestation Station
        deploy_script "02_InteractionStation.s.sol"
        ;;
    CreateInteractions)
        # Deploy Align Attestation Station
        deploy_script "03_CreateInteractions.s.sol"
        ;;
    DefaultInteractions)
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
          blog2='{
          "version": "0.1.0",
          "name": "blog new",
          "summary": "This is a blog post, it will have no more than 100,000 characters. General accepted rules of decency when posting, similar to X (formerly Twitter) rules and policies.",
          "content": {
            "from": "align id of poster",
            "post": "content of post",
            "image": "link to image",
            "dateOf": "date posted"
          }
        }'
        profile='{
          "version": "0.1.0",
          "name": "align profile",
          "summary": "This is an Align Profile.",
          "content": {
            "image": "link to image",
            "name": "name of profile",
            "bio": "short 10000 character bio"
          }
        }'
        zk='{
          "version": "0.1.0",
          "name": "twitter zkproof",
          "summary": "An uploaded zkproof created from the Align Chrome Extension to prove ownership of a Twitter Account.",
          "content": {
            "proof": "zk proof from Align Chrome Extension",
          }
        }'
        ai='{
          "version": "0.1.0",
          "name": "ai vector embeddings",
          "summary": "AI vector embeddings storage.",
          "content": {
            "vector embeddings": "",
          }
        }'
        #upload "$blog"
        #upload "$post"
        #upload "$dispute"
        #upload "$points"
        #upload "$align_points_program_1"
        #upload "$blog2"
        upload "$profile"
        #upload "$zk"
        #upload "$ai"
        ;;
    MyInteraction)
        # Deploy Align Attestation Station
        deploy_script "4200_MyInteraction.s.sol"
        ;;
    *)
        echo "Usage: $0 {IdRegistry|InteractionStation|VerifyIPFS|CreateInteractions|DefaultInteractions|MyInteraction}"
        exit 1
esac
