#!/bin/bash


# Function to deploy each script
deploy_script() {
    local script_name=$1
    echo "Deploying $script_name..."
    unset ETH_FROM
    source .env && forge script script/$script_name:Deploy --account ALIGNDEPLOYER --fork-url $RPC_URL --broadcast  --legacy --skip-simulation -vvv --via-ir 
    
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
    VerifyContracts)
        source .env && forge script script/00_AlignIdRegistry.s.sol:Deploy --rpc-url $RPC_URL --verify --via-ir --account ALIGNDEPLOYER
        source .env && forge script script/01_VerifyIPFS.s.sol:Deploy --rpc-url $RPC_URL --verify --via-ir --account ALIGNDEPLOYER
        source .env && forge script script/02_InteractionStation.s.sol:Deploy --rpc-url $RPC_URL --verify --via-ir --account ALIGNDEPLOYER
        ;;
    CreateInteractions)
        # Deploy Align Attestation Station
        deploy_script "03_CreateInteractions.s.sol"
        ;;
    ChangeRoles)
        # Deploy Align Attestation Station
        deploy_script "X1_AlignIdChangeRoles.s.sol"
        ;;
    *)
        echo "Usage: $0 {IdRegistry|InteractionStation|VerifyIPFS|CreateInteractions|DefaultInteractions|MyInteraction|ChangeRoles}"
        exit 1
esac
