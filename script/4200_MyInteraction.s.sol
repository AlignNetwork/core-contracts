// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import { BaseScript } from "./Base.s.sol";
import { AlignIdRegistry } from "../src/AlignIdRegistry.sol";
import "../src/InteractionStation.sol";
import "forge-std/src/console2.sol";

contract Deploy is BaseScript {
  function run() public broadcast returns (InteractionStation intStation) {
    // Define Contracts Deployed on Align Testnet
    intStation = InteractionStation(0xf581E6dfA593346E9c8163dD3Ed533ba9733A97a);

    // Define the Interaction Name
    string memory name = "My Interaction";
    // Define the Interaction IPFS Hash (generated from ./bash/upload.sh, see README for instructions)
    string memory iTypeCID = "bafyreihdaunebldfovtrp6iykh6seyw4hlcnbof6k54djr2gmvd35zvany";
    bytes32[] memory parentKeys = new bytes32[](0);

    // Create the Interaction Type and returns the key
    // Note: It uses the AlignIdRegistry to get the alignId, it will use the msg.sender
    // of this call which is the broadcaster
    // i.e. the PRIVATE_KEY you set in the .env file
    intStation.createIType(true, true, name, iTypeCID, parentKeys);
  }
}
