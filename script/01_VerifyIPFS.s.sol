// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import { Script } from "forge-std/src/Script.sol";
import { AlignIdRegistry } from "../src/AlignIdRegistry.sol";
import "../src/InteractionStation.sol";
import "../src/VerifyIPFS.sol";
import "forge-std/src/console2.sol";

contract Deploy is Script {
  function run() public returns (VerifyIPFS verifyIPFS) {
    vm.startBroadcast();
    verifyIPFS = new VerifyIPFS();
    vm.stopBroadcast();
  }
}
