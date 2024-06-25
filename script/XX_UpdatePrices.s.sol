// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import { Script } from "forge-std/src/Script.sol";
import { AlignIdRegistry } from "../src/AlignIdRegistry.sol";
import "../src/InteractionStation.sol";
import "forge-std/src/console2.sol";

contract Deploy is Script {
  function run() public {
    vm.startBroadcast();
    address intStationAddress = vm.envOr({ name: "INTERACTIONSTATION_CONTRACT", defaultValue: address(0) });
    address alignIdAddress = vm.envOr({ name: "ALIGNID_CONTRACT", defaultValue: address(0) });
    // Define Contracts Deployed on Arbitrum
    InteractionStation intStation = InteractionStation(intStationAddress);
    AlignIdRegistry alignId = AlignIdRegistry(alignIdAddress);
    console2.log("owner", alignId.owner());
    console2.log("owner is", intStation.owner());
    console2.log(msg.sender);
    uint256 alignIdFee = 290000000000000;
    alignId.setProtocolFee(alignIdFee);
    uint256 intStatationFee = 29000000000000;
    intStation.setProtocolFee(intStatationFee);

    vm.stopBroadcast();
  }
}
