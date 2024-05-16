// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import { BaseScript } from "./Base.s.sol";
import { AlignIdRegistry } from "../src/AlignIdRegistry.sol";
import "../src/InteractionStation.sol";
import "../src/VerifyIPFS.sol";
import "forge-std/src/console2.sol";

contract Deploy is BaseScript {
  function run() public broadcast returns (InteractionStation alignStationImpl) {
    AlignIdRegistry aidr = AlignIdRegistry(0xaB128F232027dE26093E1A3e18179D81455a18Ea);
    VerifyIPFS verifyIPFS = new VerifyIPFS();
    alignStationImpl = new InteractionStation(address(aidr), address(verifyIPFS)); // Replace address(1) with your admin address
  }
}
