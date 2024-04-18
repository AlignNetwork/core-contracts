// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import { BaseScript } from "./Base.s.sol";
import { AlignIdRegistry } from "../src/AlignIdRegistry.sol";
import "../src/AlignAttestationStation.sol";
import "forge-std/src/console2.sol";

contract Deploy is BaseScript {
  function run() public broadcast returns (AlignAttestationStation alignStationImpl) {
    AlignIdRegistry aidr = AlignIdRegistry(0xaB128F232027dE26093E1A3e18179D81455a18Ea);
    alignStationImpl = new AlignAttestationStation(address(aidr)); // Replace address(1) with your admin address
  }
}
