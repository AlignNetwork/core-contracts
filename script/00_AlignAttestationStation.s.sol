// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import { BaseScript } from "./Base.s.sol";
import { AlignIdRegistry } from "../src/AlignIdRegistry.sol";
import "../src/AlignAttestationStation.sol";
import "forge-std/src/console2.sol";

contract Deploy is BaseScript {
  function run() public broadcast returns (AlignAttestationStation alignStationImpl) {
    AlignIdRegistry aidr = new AlignIdRegistry();
    alignStationImpl = new AlignAttestationStation(address(aidr)); // Replace address(1) with your admin address
    // Register Deployer as the first Align Id
    aidr.register(address(broadcaster), address(broadcaster));
  }
}
