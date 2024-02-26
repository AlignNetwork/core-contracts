// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.8.19 <0.9.0;

import { ValidatorRegistryV1 } from "../src/ValidatorRegistryV1.sol";
import { IEAS } from "@ethereum-attestation-service/eas-contracts/contracts/IEAS.sol";
import { AlignResolver } from "../src/AlignResolver.sol";

import { BaseScript } from "./Base.s.sol";

/// @dev See the Solidity Scripting tutorial: https://book.getfoundry.sh/tutorials/solidity-scripting
contract Deploy is BaseScript {
  function run() public broadcast returns (ValidatorRegistryV1 registry) {
    //registry = new ValidatorRegistryV1();
    registry = ValidatorRegistryV1(0x9Eb265476108e261f74B014ff34716E8BEad54a5);
    /* registry.addValidator{ value: 0.1 ether }(
      broadcaster,
      "https://bafybeiblo3bkuwr3iqdi3ajsqsnrgyt6a52mekpxzbwizbf2awyhreata4.ipfs.dweb.link/checkin.json",
      "align.network"
    ); */
    /* registry.addValidator{ value: 0.1 ether }(
      broadcaster,
      "https://bafybeiblo3bkuwr3iqdi3ajsqsnrgyt6a52mekpxzbwizbf2awyhreata4.ipfs.dweb.link/checkin.json",
      "frame.align.network"
    ); */

    /*  registry.addValidator{ value: 0.1 ether }(
      broadcaster,
      "https://bafybeihhjzjhxqkxpxqip4rlqxsce4tym2eakjtgpbfm5n7dl63gmwakkm.ipfs.dweb.link/twitter.json",
      "twitter.align.network"
    ); */
  }
}
