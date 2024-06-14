// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.19;

import { AlignIdRegistry } from "../src/AlignIdRegistry.sol";

import { BaseScript } from "./Base.s.sol";

contract Deploy is BaseScript {
  function run() public broadcast returns (AlignIdRegistry aidr) {
    aidr = AlignIdRegistry(0x8F97d988da02e141EBaBFA4639b9bC9E25aa5759); // Initialize with a registration fee
    //aidr.revokeRoles(0xA09b3D27CFc9B06A8ADe24D921faff9DE4E132D1, aidr.PAUSER_ROLE());
    aidr.grantRoles(0x5D6f3684E686ac7EB84716f242B34Bc194967B9f, aidr.PAUSER_ROLE());
  }
}
