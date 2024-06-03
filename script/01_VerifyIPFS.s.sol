// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import { BaseScript } from "./Base.s.sol";
import { AlignIdRegistry } from "../src/AlignIdRegistry.sol";
import "../src/InteractionStation.sol";
import "../src/VerifyIPFS.sol";
import "forge-std/src/console2.sol";

contract Deploy is BaseScript {
  function run() public broadcast returns (VerifyIPFS verifyIPFS) {
    verifyIPFS = new VerifyIPFS();
  }
}
