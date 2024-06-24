#!/bin/bash

deploy_mainnet() {
    local script_name=$1
    echo "Deploying $script_name... to mainnet"
    source .env.prod && forge script script/$script_name:Deploy --account OPALIGNDEPLOYER --fork-url $RPC_URL --broadcast -vvv --via-ir --verify
    
    echo "Deployed $script_name to mainnet!"
}

deploy_testnet() {
    local script_name=$1
    echo "Deploying $script_name... to testnet"
    unset PRIVATE_KEY
    source .env && forge script script/$script_name:Deploy --private-key $PRIVATE_KEY --fork-url $RPC_URL --broadcast  -vvv --via-ir 
    
    echo "Deployed $script_name to testnet!"
}


deploy_script() {
    local script_name=$1
    local network=$2
    if [ "$network" == "testnet" ]; then
        deploy_testnet $script_name
    else
        
        deploy_mainnet $script_name
    fi
}


# Check for command line argument
if [ $# -lt 2 ]; then
    echo "Usage: $0 {IdRegistry|VerifyIPFS|InteractionStation|VerifyContracts|CreateInteractions|ChangeRoles} {mainnet|testnet}"
    exit 1
fi

script=$1
network=$2

case $script in
    AlignIdRegistry)
        # Deploy AlignIdRegistry
        
        deploy_script "00_AlignIdRegistry.s.sol" $network
        ;;
    VerifyIPFS)
        # Deploy AlignIdRegistry
        deploy_script "01_VerifyIPFS.s.sol" $network
        ;;
    InteractionStation)
        # Deploy Align Attestation Station
        deploy_script "02_InteractionStation.s.sol" $network
        ;;
    VerifyContracts)
        #source .env.prod && forge script script/00_AlignIdRegistry.s.sol:Deploy --rpc-url $RPC_URL --verify --via-ir --account OPALIGNDEPLOYER $network
        #source .env.prod && forge script script/01_VerifyIPFS.s.sol:Deploy --rpc-url $RPC_URL --verify --via-ir --account OPALIGNDEPLOYER $network
        #source .env.prod && forge script script/02_InteractionStation.s.sol:Deploy --rpc-url $RPC_URL --verify --via-ir --account OPALIGNDEPLOYER $network
        ;;
    CreateInteractions)
        # Deploy Align Attestation Station
        deploy_script "03_CreateInteractions.s.sol" $network
        ;;
    ChangeRoles)
        # Deploy Align Attestation Station
        deploy_script "X1_AlignIdChangeRoles.s.sol" $network
        ;;
    *)
        echo "Usage: $0 {AlignIdRegistry|InteractionStation|VerifyIPFS|CreateInteractions|ChangeRoles} {mainnet|testnet}"
        exit 1
esac
