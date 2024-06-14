// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import { Script } from "forge-std/src/Script.sol";
import { AlignIdRegistry } from "../src/AlignIdRegistry.sol";
import "../src/InteractionStation.sol";
import "forge-std/src/console2.sol";

contract Deploy is Script {
  function run() public returns (InteractionStation intStation) {
    vm.startBroadcast();
    // Define Contracts Deployed on Arbitrum
    intStation = InteractionStation(0xBd9f89E3784840E5F56c958ED99Eb5297D52391a);

    // Parent Keys
    bytes32[] memory parentKeys = new bytes32[](0);

    /*
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
    */

    // Define the Interaction Name
    string memory name6 = "File";
    // Define the Interaction IPFS Hash (generated from ./bash/upload.sh, see README for instructions)
    string memory iTypeCID6 = "bafyreidwnrosplylb2tohmkphwr6puwgszegh6cbfnvc2l7fjy5sdr7aiu";
    // Create the Interaction Type
    bytes32 key6 = intStation.createIType(true, false, name6, iTypeCID6, parentKeys);
    console2.logBytes32(key6);
    // InteractionTypeKey: 0xa1b79868ca9899a72250bee77b0fae11fa916612624db2f9314a606857b486de
    vm.stopBroadcast();
  }
}
