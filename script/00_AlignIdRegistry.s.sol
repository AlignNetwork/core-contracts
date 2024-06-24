// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.19;

import { AlignIdRegistry } from "../src/AlignIdRegistry.sol";
import { Script } from "forge-std/src/Script.sol";

import "forge-std/src/console2.sol";

contract Deploy is Script {
  function run() public {
    address worker = vm.envOr({ name: "WORKER", defaultValue: address(0) });
    address treasury = vm.envOr({ name: "TREASURY", defaultValue: address(0) });
    vm.startBroadcast();
    AlignIdRegistry aidr;
    aidr = new AlignIdRegistry(0.0028 ether, treasury); // Initialize with a registration fee
    aidr.grantRoles(worker, aidr.PAUSER_ROLE());
    aidr.grantRoles(worker, aidr.FEE_SETTER_ROLE());
    aidr.grantRoles(worker, aidr.WITHDRAWER_ROLE());
    // Register Deployer as the first Align Id
    aidr.register{ value: 0.0028 ether }();

    vm.stopBroadcast();
  }
}
