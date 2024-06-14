// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.19;

import { AlignIdRegistry } from "../src/AlignIdRegistry.sol";
import { Script } from "forge-std/src/Script.sol";

import "forge-std/src/console2.sol";

contract Deploy is Script {
  function run() public {
    vm.startBroadcast();
    AlignIdRegistry aidr;
    aidr = new AlignIdRegistry(0.0028 ether, 0x6AEebD700ced60FAc2a912140aCc96340df806c9); // Initialize with a registration fee
    aidr.grantRoles(0x3b478Bc113cE8Fd0777e68CdE100F64b9fa63792, aidr.PAUSER_ROLE());
    aidr.grantRoles(0x3b478Bc113cE8Fd0777e68CdE100F64b9fa63792, aidr.FEE_SETTER_ROLE());
    aidr.grantRoles(0x3b478Bc113cE8Fd0777e68CdE100F64b9fa63792, aidr.WITHDRAWER_ROLE());
    // Register Deployer as the first Align Id
    aidr.register{ value: 0.0028 ether }();
    vm.stopBroadcast();
  }
}
