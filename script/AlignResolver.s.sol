// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.8.19 <0.9.0;

import { AlignResolver } from "../src/AlignResolver.sol";
import { IEAS } from "@ethereum-attestation-service/eas-contracts/contracts/IEAS.sol";
import { BaseScript } from "./Base.s.sol";

/// @dev See the Solidity Scripting tutorial: https://book.getfoundry.sh/tutorials/solidity-scripting
contract Deploy is BaseScript {
    function run() public broadcast returns (AlignResolver foo) {
        foo = new AlignResolver(
            IEAS(0xd37555E77B61a0c13B0eEED15a61138Bb494A6F9),broadcaster);
    }
}
