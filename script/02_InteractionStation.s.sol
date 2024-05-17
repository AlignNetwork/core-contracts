// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import { BaseScript } from "./Base.s.sol";
import { AlignIdRegistry } from "../src/AlignIdRegistry.sol";
import "../src/InteractionStation.sol";
import "../src/VerifyIPFS.sol";
import "forge-std/src/console2.sol";

contract Deploy is BaseScript {
  function run() public broadcast returns (InteractionStation alignStationImpl) {
    AlignIdRegistry aidr = AlignIdRegistry(0xD821932b7d8F2DE2e53845E4b8ab66aD661cA130);
    VerifyIPFS verifyIPFS = VerifyIPFS(0x16BB489abDCE7f194052Dd3097DBB0DBE2d1F805);
    alignStationImpl = new InteractionStation(address(aidr), address(verifyIPFS)); // Replace address(1) with your admin address
    // Returns: 0xf581E6dfA593346E9c8163dD3Ed533ba9733A97a
  }
}
