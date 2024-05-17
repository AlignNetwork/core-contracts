// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import { BaseScript } from "./Base.s.sol";
import { AlignIdRegistry } from "../src/AlignIdRegistry.sol";
import "../src/InteractionStation.sol";
import "../src/VerifyIPFS.sol";
import "forge-std/src/console2.sol";

contract Deploy is BaseScript {
  function run() public broadcast returns (InteractionStation alignStationImpl) {
    AlignIdRegistry aidr = AlignIdRegistry(0xf44AABcd0ABdB3Ae3857E6737b6FC931FeCFb243);
    VerifyIPFS verifyIPFS = VerifyIPFS(0x64E627E8eE1833c1d3Ec4dDA21A81B58f04976b9);
    alignStationImpl = new InteractionStation(address(aidr), address(verifyIPFS)); // Replace address(1) with your admin address
    // Returns: 0x53C2b512a644E8c652df0396b0e53046f9ceC251
  }
}
