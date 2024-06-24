// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import { Script } from "forge-std/src/Script.sol";
import { AlignIdRegistry } from "../src/AlignIdRegistry.sol";
import "../src/InteractionStation.sol";
import "forge-std/src/console2.sol";

contract Deploy is Script {
  function run() public returns (InteractionStation intStation) {
    address intStationAddress = vm.envOr({ name: "INTERACTIONSTATION_CONTRACT", defaultValue: address(0) });
    vm.startBroadcast();
    // Define Contracts Deployed on Arbitrum
    intStation = InteractionStation(intStationAddress);

    // Parent Keys
    bytes32[] memory parentKeys = new bytes32[](0);

    /* // Define the Interaction Name
    string memory name = "NFT";
    // Define the Interaction IPFS Hash (generated from ./bash/upload.sh, see README for instructions)
    string memory iTypeCID = "bafyreihufviukzlecs6btoce4bkrqdebfbg3k4nyjadcpz6xhj4isxw6t4";
    // Create the Interaction Type
    bytes32 key = intStation.createIType(true, false, name, iTypeCID, parentKeys);
    console2.logBytes32(key);
    // InteractionTypeKey: 0xa1b79868ca9899a72250bee77b0fae11fa916612624db2f9314a606857b486de

    // Define the Interaction Name
    string memory name1 = "File";
    // Define the Interaction IPFS Hash (generated from ./bash/upload.sh, see README for instructions)
    string memory iTypeCID1 = "bafyreidwnrosplylb2tohmkphwr6puwgszegh6cbfnvc2l7fjy5sdr7aiu";
    // Create the Interaction Type
    bytes32 key1 = intStation.createIType(true, false, name1, iTypeCID1, parentKeys);
    console2.logBytes32(key1);
    // InteractionTypeKey: 0xa1b79868ca9899a72250bee77b0fae11fa916612624db2f9314a606857b486de

    // Define the Interaction Name
    string memory name2 = "Meme";
    // Define the Interaction IPFS Hash (generated from ./bash/upload.sh, see README for instructions)
    string memory iTypeCID2 = "bafyreibuhgptzc4qtjkibjmqvnosqvnxeazdym2qb72aahwjfqkkueryjy";
    // Create the Interaction Type
    bytes32 key2 = intStation.createIType(true, false, name2, iTypeCID2, parentKeys);
    console2.logBytes32(key2); */
    // InteractionTypeKey: 0xa1b79868ca9899a72250bee77b0fae11fa916612624db2f9314a606857b486de

    // Create the Interaction Type
    string memory name3 = "Dispute";
    // Define the Interaction IPFS Hash (generated from ./bash/upload.sh, see README for instructions)
    string memory iTypeCID3 = "bafyreiezsbnvcjagvzwkys27xmmtmaa4bes2ioofrs2wh6hi7gmzgtufqi";
    // Create the Interaction Type
    bytes32 key3 = intStation.createIType(true, false, name3, iTypeCID3, parentKeys);
    console2.logBytes32(key3);
    vm.stopBroadcast();
  }
}
