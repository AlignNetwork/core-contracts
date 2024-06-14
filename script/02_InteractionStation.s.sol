// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import { AlignIdRegistry } from "../src/AlignIdRegistry.sol";
import { Script } from "forge-std/src/Script.sol";

import "../src/InteractionStation.sol";
import "../src/VerifyIPFS.sol";
import "forge-std/src/console2.sol";

contract Deploy is Script {
  function run() public returns (InteractionStation alignStationImpl) {
    vm.startBroadcast();
    AlignIdRegistry aidr = AlignIdRegistry(0x35Ca546EC4Bc72aBBc59731af15bA6D802fa625C);
    VerifyIPFS verifyIPFS = VerifyIPFS(0x94006b400D299469CB1157334D6A95f2BE8C251B);
    alignStationImpl = new InteractionStation(
      address(aidr),
      address(verifyIPFS),
      0.00028 ether,
      0x6AEebD700ced60FAc2a912140aCc96340df806c9
    );
    // Returns: 0xBd9f89E3784840E5F56c958ED99Eb5297D52391a
    alignStationImpl.grantRoles(0x3b478Bc113cE8Fd0777e68CdE100F64b9fa63792, alignStationImpl.PAUSER_ROLE());
    alignStationImpl.grantRoles(0x3b478Bc113cE8Fd0777e68CdE100F64b9fa63792, alignStationImpl.FEE_SETTER_ROLE());
    alignStationImpl.grantRoles(0x3b478Bc113cE8Fd0777e68CdE100F64b9fa63792, alignStationImpl.WITHDRAWER_ROLE());
    vm.stopBroadcast();
  }
}
