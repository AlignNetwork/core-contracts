// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import { BaseScript } from "./Base.s.sol";
import { AlignIdRegistry } from "../src/AlignIdRegistry.sol";
import "../src/InteractionStation.sol";
import "forge-std/src/console2.sol";

contract Deploy is BaseScript {
  function run() public broadcast returns (InteractionStation intStation) {
    // Define Contracts Deployed on Align Testnet
    intStation = InteractionStation(0xb2BbB5Fd82373936C1561A4D4B3C88B4Adf41362);

    // Define the Interaction Name
    string memory name = "My Interaction";
    // Define the Interaction IPFS Hash (generated from ./bash/upload.sh, see README for instructions)
    string memory interaction = "bafyreiaoc343iy3mbibgj73cskrppcc5tcilbmkwp4xhvrmkmuzyuezp6u";

    // Create the Interaction Type and returns the key
    // Note: It uses the AlignIdRegistry to get the alignId, it will use the msg.sender
    // of this call which is the broadcaster
    // i.e. the PRIVATE_KEY you set in the .env file
    intStation.createInteractionType(true, true, name, interaction, new bytes32[](0));
  }
}
