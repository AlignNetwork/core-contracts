// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.19;

import { AlignIdRegistry } from "../src/AlignIdRegistry.sol";

import { BaseScript } from "./Base.s.sol";

/// @dev See the Solidity Scripting tutorial: https://book.getfoundry.sh/tutorials/solidity-scripting
contract Deploy is BaseScript {
  function run() public broadcast returns (AlignIdRegistry aidr) {
    aidr = new AlignIdRegistry(0.002 ether, address(5)); // Initialize with a registration fee
    // Register Deployer as the first Align Id
    aidr.register{ value: 0.002 ether }();
  }
}
