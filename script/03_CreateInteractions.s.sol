// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import { BaseScript } from "./Base.s.sol";
import { AlignIdRegistry } from "../src/AlignIdRegistry.sol";
import "../src/InteractionStation.sol";
import "forge-std/src/console2.sol";

contract Deploy is BaseScript {
  function run() public broadcast returns (InteractionStation intStation) {
    // Define Contracts Deployed on Align Testnet
    intStation = InteractionStation(0x6F5Bfd716Cf7F7dB4A3e312D591d5b42275fF8c0);

    // Parent Keys
    bytes32[] memory parentKeys = new bytes32[](0);

    // Define the Interaction Name
    string memory name = "Post";
    // Define the Interaction IPFS Hash (generated from ./bash/upload.sh, see README for instructions)
    string memory iTypeCID = "bafyreihdaunebldfovtrp6iykh6seyw4hlcnbof6k54djr2gmvd35zvany";
    // Create the Interaction Type
    bytes32 key = intStation.createIType(true, true, name, iTypeCID, parentKeys);
    console2.logBytes32(key);
    //InteractionTypeKey: 0x30abf47b1bc62b7c4a62363358e236cf55104f33cd9aa5b6d0766177ff04f450

    // Define the Interaction Name
    string memory name2 = "Blog";
    // Define the Interaction IPFS Hash (generated from ./bash/upload.sh, see README for instructions)
    string memory iTypeCID2 = "bafyreib5xt5jddlzz6ymfysm2vzyyfhs43yqoch6spucgucze3yiszivsu";
    // Create the Interaction Type
    bytes32 key2 = intStation.createIType(true, false, name2, iTypeCID2, parentKeys);
    console2.logBytes32(key2);
    //InteractionTypeKey:  0x37bc0487179bf0e5859e1e81de587362f08f1e99a4dd4818e7ec9db5acbe85d4

    // Define the Interaction Name
    string memory name3 = "Dispute";
    // Define the Interaction IPFS Hash (generated from ./bash/upload.sh, see README for instructions)
    string memory iTypeCID3 = "bafyreifvhntzospkaogvsuzsavzvrlawtvwgsac3lubqd5tj7c7ccl4dum";
    // Create the Interaction Type
    bytes32 key3 = intStation.createIType(true, true, name3, iTypeCID3, parentKeys);
    console2.logBytes32(key3);
    //InteractionTypeKey:  0x5ccef2e75faf813914ca81514683bb551f97b0dabb1a7b88078d8d047c8d71d1

    // Define the Interaction Name
    string memory name4 = "Points";
    // Define the Interaction IPFS Hash (generated from ./bash/upload.sh, see README for instructions)
    string memory iTypeCID4 = "bafyreibovgpqyml5m66jwpqcqmicqviixupqznm7lxpp6junas7tduvhwu";
    // Create the Interaction Type
    bytes32 key4 = intStation.createIType(true, true, name4, iTypeCID4, parentKeys);
    console2.logBytes32(key4);
    //InteractionTypeKey:  0xeb5b8c1f556f61bc01e9276ec4536dbe23e4240b8487374f984d6031e5cd21dc

    // Define the Interaction Name
    string memory name5 = "Blog2";
    // Define the Interaction IPFS Hash (generated from ./bash/upload.sh, see README for instructions)
    string memory iTypeCID5 = "bafyreievxqcpnsjlbupugzaqkklrqcd3ngs7wbcmfzq4ulsnpahykdonkm";
    // Create the Interaction Type
    bytes32 key5 = intStation.createIType(true, false, name5, iTypeCID5, parentKeys);
    console2.logBytes32(key5);
    //InteractionTypeKey:  0x37bc0487179bf0e5859e1e81de587362f08f1e99a4dd4818e7ec9db5acbe85d4

    // Define the Interaction Name
    string memory name6 = "Profile";
    // Define the Interaction IPFS Hash (generated from ./bash/upload.sh, see README for instructions)
    string memory iTypeCID6 = "bafyreiepkdmnbw66cqz4jqg4uukuhxopbgl4jspyx37rowtsf25b7oywh4";
    // Create the Interaction Type
    bytes32 key6 = intStation.createIType(true, false, name6, iTypeCID6, parentKeys);
    console2.logBytes32(key6);
  }
}
