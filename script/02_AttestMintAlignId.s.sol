// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import { BaseScript } from "./Base.s.sol";
import { AlignIdRegistry } from "../src/AlignIdRegistry.sol";
import "../src/AlignAttestationStation.sol";
import "forge-std/src/console2.sol";

contract Deploy is BaseScript {
  function run() public broadcast returns (AlignAttestationStation alignStationImpl) {
    AlignIdRegistry aidr = AlignIdRegistry(0xaB128F232027dE26093E1A3e18179D81455a18Ea);
    alignStationImpl = AlignAttestationStation(0xb2BbB5Fd82373936C1561A4D4B3C88B4Adf41362); // Replace address(1) with your admin address
    // Register the first claim type
    string memory claimType = "Align Identity Testnet v2";
    string
      memory claimLink = "https://github.com/AlignNetwork/Attestation-Registry/blob/master/registry/MintAlignIdTestnetV2.md";
    alignStationImpl.registerType(false, claimType, claimLink, false);

    // Attest the first claim type
    uint256 attesterAlignId = aidr.readId(broadcaster);
    // Claculate the ClaimTypeKey which is used as a reference to the attestation
    bytes32 claimTypeKey = keccak256(abi.encodePacked(attesterAlignId, claimType));

    string memory claim = "I minted my Align Identity on Align Testnet v2";
    // copied from original minting of alignid
    string memory claimProof = "0xb136129c6ebbec493b86db4c72d97a9075182b0c6e6dc69ba34553fa5560c201";
    alignStationImpl.attest(attesterAlignId, claimTypeKey, claim, claimProof);

    // Check the attestation
    (string memory storedClaim, string memory storedClaimProof) = alignStationImpl.getAttestationNonFungible(
      attesterAlignId,
      attesterAlignId,
      claimTypeKey
    );
    console2.log("storedClaim: %s", string(abi.encodePacked(storedClaim)));
    console2.log("storedClaimProof: %s", string(abi.encodePacked(storedClaimProof)));
  }
}
