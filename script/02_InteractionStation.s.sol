// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import { AlignIdRegistry } from "../src/AlignIdRegistry.sol";
import { Script } from "forge-std/src/Script.sol";

import "../src/InteractionStation.sol";
import "../src/VerifyIPFS.sol";
import "forge-std/src/console2.sol";

contract Deploy is Script {
  function run() public returns (InteractionStation alignStationImpl) {
    address worker = vm.envOr({ name: "WORKER", defaultValue: address(0) });
    address treasury = vm.envOr({ name: "TREASURY", defaultValue: address(0) });
    address vipfs = vm.envOr({ name: "VERIFYIPFS_CONTRACT", defaultValue: address(0) });
    address alignId = vm.envOr({ name: "ALIGNID_CONTRACT", defaultValue: address(0) });

    vm.startBroadcast();
    AlignIdRegistry aidr = AlignIdRegistry(alignId);
    VerifyIPFS verifyIPFS = VerifyIPFS(vipfs);
    alignStationImpl = new InteractionStation(address(aidr), address(verifyIPFS), 0.00028 ether, treasury);
    // Returns:
    alignStationImpl.grantRoles(worker, alignStationImpl.PAUSER_ROLE());
    alignStationImpl.grantRoles(worker, alignStationImpl.FEE_SETTER_ROLE());
    alignStationImpl.grantRoles(worker, alignStationImpl.WITHDRAWER_ROLE());
    vm.stopBroadcast();
  }
}
