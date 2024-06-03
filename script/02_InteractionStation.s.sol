// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import { BaseScript } from "./Base.s.sol";
import { AlignIdRegistry } from "../src/AlignIdRegistry.sol";
import "../src/InteractionStation.sol";
import "../src/VerifyIPFS.sol";
import "forge-std/src/console2.sol";

contract Deploy is BaseScript {
  function run() public broadcast returns (InteractionStation alignStationImpl) {
    AlignIdRegistry aidr = AlignIdRegistry(0x9b9d85e9eD23CB6AbCD3128CB70ECfdF6C406689);
    VerifyIPFS verifyIPFS = VerifyIPFS(0xd56C687294923C04C6c62F31FF2722336B37aC89);
    alignStationImpl = new InteractionStation(address(aidr), address(verifyIPFS)); // Replace address(1) with your admin address
    // Returns: 0x6F5Bfd716Cf7F7dB4A3e312D591d5b42275fF8c0
  }
}
