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
    string memory name = "Post";
    // Define the Interaction IPFS Hash (generated from ./bash/upload.sh, see README for instructions)
    string memory interaction = "bafyreihdaunebldfovtrp6iykh6seyw4hlcnbof6k54djr2gmvd35zvany";
    // Create the Interaction Type
    intStation.createInteractionType(true, true, name, interaction, new bytes32[](0));

    // Define the Interaction Name
    string memory name2 = "Blog";
    // Define the Interaction IPFS Hash (generated from ./bash/upload.sh, see README for instructions)
    string memory interaction2 = "bafyreib5xt5jddlzz6ymfysm2vzyyfhs43yqoch6spucgucze3yiszivsu";
    // Create the Interaction Type
    intStation.createInteractionType(true, true, name2, interaction2, new bytes32[](0));

    // Define the Interaction Name
    string memory name3 = "Dispute";
    // Define the Interaction IPFS Hash (generated from ./bash/upload.sh, see README for instructions)
    string memory interaction3 = "bafyreifvhntzospkaogvsuzsavzvrlawtvwgsac3lubqd5tj7c7ccl4dum";
    // Create the Interaction Type
    intStation.createInteractionType(true, true, name3, interaction3, new bytes32[](0));

    // Define the Interaction Name
    string memory name4 = "Points";
    // Define the Interaction IPFS Hash (generated from ./bash/upload.sh, see README for instructions)
    string memory interaction4 = "bafyreibovgpqyml5m66jwpqcqmicqviixupqznm7lxpp6junas7tduvhwu";
    // Create the Interaction Type
    intStation.createInteractionType(true, true, name4, interaction4, new bytes32[](0));
  }
}
