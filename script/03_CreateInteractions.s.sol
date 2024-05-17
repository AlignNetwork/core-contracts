// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import { BaseScript } from "./Base.s.sol";
import { AlignIdRegistry } from "../src/AlignIdRegistry.sol";
import "../src/InteractionStation.sol";
import "forge-std/src/console2.sol";

contract Deploy is BaseScript {
  function run() public broadcast returns (InteractionStation intStation) {
    // Define Contracts Deployed on Align Testnet
    intStation = InteractionStation(0x53C2b512a644E8c652df0396b0e53046f9ceC251);

    // Define the Interaction Name
    string memory name = "Post";
    // Define the Interaction IPFS Hash (generated from ./bash/upload.sh, see README for instructions)
    string memory interaction = "bafyreihdaunebldfovtrp6iykh6seyw4hlcnbof6k54djr2gmvd35zvany";
    bytes32[] memory links = new bytes32[](0);
    // Create the Interaction Type
    bytes32 key = intStation.createInteractionType(true, true, name, interaction, links);
    console2.logBytes32(key);
    //InteractionTypeKey: 0x30abf47b1bc62b7c4a62363358e236cf55104f33cd9aa5b6d0766177ff04f450

    // Define the Interaction Name
    string memory name2 = "Blog";
    // Define the Interaction IPFS Hash (generated from ./bash/upload.sh, see README for instructions)
    string memory interaction2 = "bafyreib5xt5jddlzz6ymfysm2vzyyfhs43yqoch6spucgucze3yiszivsu";
    // Create the Interaction Type
    bytes32 key2 = intStation.createInteractionType(true, true, name2, interaction2, new bytes32[](0));
    console2.logBytes32(key2);
    //InteractionTypeKey:  0x37bc0487179bf0e5859e1e81de587362f08f1e99a4dd4818e7ec9db5acbe85d4

    // Define the Interaction Name
    string memory name3 = "Dispute";
    // Define the Interaction IPFS Hash (generated from ./bash/upload.sh, see README for instructions)
    string memory interaction3 = "bafyreifvhntzospkaogvsuzsavzvrlawtvwgsac3lubqd5tj7c7ccl4dum";
    // Create the Interaction Type
    bytes32 key3 = intStation.createInteractionType(true, true, name3, interaction3, new bytes32[](0));
    console2.logBytes32(key3);
    //InteractionTypeKey:  0x5ccef2e75faf813914ca81514683bb551f97b0dabb1a7b88078d8d047c8d71d1

    // Define the Interaction Name
    string memory name4 = "Points";
    // Define the Interaction IPFS Hash (generated from ./bash/upload.sh, see README for instructions)
    string memory interaction4 = "bafyreibovgpqyml5m66jwpqcqmicqviixupqznm7lxpp6junas7tduvhwu";
    // Create the Interaction Type
    bytes32 key4 = intStation.createInteractionType(true, true, name4, interaction4, new bytes32[](0));
    console2.logBytes32(key4);
    //InteractionTypeKey:  0xeb5b8c1f556f61bc01e9276ec4536dbe23e4240b8487374f984d6031e5cd21dc
  }
}
