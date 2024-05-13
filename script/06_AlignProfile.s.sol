// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import { BaseScript } from "./Base.s.sol";
import { AlignIdRegistry } from "../src/AlignIdRegistry.sol";
import "../src/AlignAttestationStation.sol";
import "forge-std/src/console2.sol";

contract Deploy is BaseScript {
    function run() public broadcast returns (AlignAttestationStation alignStationImpl) {
        AlignIdRegistry aidr = AlignIdRegistry(0xaB128F232027dE26093E1A3e18179D81455a18Ea);
        alignStationImpl = AlignAttestationStation(0xb2BbB5Fd82373936C1561A4D4B3C88B4Adf41362); // Replace address(1)
            // with your admin address
        // Register the price prediction claim type
        string memory claimType = "Align Profile";
        string memory claimLink =
            "https://github.com/AlignNetwork/Attestation-Registry/blob/master/registry/AlignProfile.md";
        alignStationImpl.registerType(false, claimType, claimLink, false);

        // Attest the first claim type
        uint256 attesterAlignId = aidr.readId(broadcaster);
        // Claculate the ClaimTypeKey which is used as a reference to the attestation
        bytes32 claimTypeKey = keccak256(abi.encodePacked(attesterAlignId, claimType));

        string memory claim = "profile creation";
        string memory claimProof = "";
        alignStationImpl.attest(attesterAlignId, claimTypeKey, claim, claimProof);

        // Check the attestation
        (string memory storedClaim, string memory storedClaimProof) =
            alignStationImpl.getAttestationFungible(attesterAlignId, attesterAlignId, claimTypeKey, claim);
        console2.log("storedClaim: %s", string(abi.encodePacked(storedClaim)));
        console2.log("storedClaimProof: %s", string(abi.encodePacked(storedClaimProof)));
    }
}
