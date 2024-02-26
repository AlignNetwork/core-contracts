#!/bin/bash


# Function to deploy each script
deploy_script() {
    local script_name=$1
    echo "Deploying $script_name..."
    unset PRIVATE_KEY
    unset ETH_FROM
    source .env && forge script script/$script_name:Deploy --fork-url $RPC_URL --broadcast --private-key $PRIVATE_KEY --legacy --skip-simulation --gas-price 0 --gas-limit 1000000000
    #localhost: 
    #source .env && forge script script/$script_name:Deploy --rpc-url http://localhost:8545 --broadcast

    echo "Deployed $script_name!"
}

# Check for command line argument
case $1 in
    ATNFT)
        # Deploy Align Test NFT
        deploy_script "Align.s.sol"
        ;;
    AR)
        # Deploy EAS resolver
        deploy_script "AlignResolver.s.sol"
        ;;
    VR)
        # Deploy EAS resolver
        deploy_script "ValidatorRegistry.s.sol"
        ;;
    AOE)
        # Deploy Align Open Edition
        deploy_script "AlignOE.s.sol"
        ;;
    *)
        echo "Usage: $0 {AR|VR}"
        exit 1
esac
