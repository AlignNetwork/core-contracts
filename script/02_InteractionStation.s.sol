// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import { BaseScript } from "./Base.s.sol";
import { AlignIdRegistry } from "../src/AlignIdRegistry.sol";
import "../src/InteractionStation.sol";
import "../src/VerifyIPFS.sol";
import "forge-std/src/console2.sol";

contract Deploy is BaseScript {
  function run() public broadcast returns (InteractionStation alignStationImpl) {
    AlignIdRegistry aidr = AlignIdRegistry(0xaE57e1B93DA10a7B5e746B2d17B0b3c7D90B2dDa);
    VerifyIPFS verifyIPFS = VerifyIPFS(0x3298154306f25E98efD779a8DCEB1322C4073345);
    alignStationImpl = new InteractionStation(address(aidr), address(verifyIPFS));
    // Returns: 0xEe8710c0B14155541E151783A8C76422d0d5a676
  }
}
