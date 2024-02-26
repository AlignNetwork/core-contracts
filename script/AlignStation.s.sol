// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import { BaseScript } from "./Base.s.sol";
import "../src/AlignStation.sol";

contract DeployScript is BaseScript {
  function run() external returns (AlignStation alignStationImpl) {
    alignStationImpl = new AlignStation(broadcaster); // Replace address(1) with your admin address
  }
}
