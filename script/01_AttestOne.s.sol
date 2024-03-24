// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import { BaseScript } from "./Base.s.sol";
import { AlignIdRegistry } from "../src/AlignIdRegistry.sol";
import "../src/AlignAttestationStation.sol";
import "forge-std/src/console2.sol";

contract Deploy is BaseScript {
  function run() public broadcast returns (AlignAttestationStation alignStationImpl) {
    AlignIdRegistry aidr = AlignIdRegistry(0x25624B58db7642324c153DF6E810b45D6c16138D);
    alignStationImpl = AlignAttestationStation(0xC369370f2c3BF45A2DD0F11E30a3072436A17d49); // Replace address(1) with your admin address
    // Register the first claim type
    string memory claimType = "Align Identity Testnet v2";
    string
      memory claimLink = "https://github.com/AlignNetwork/Attestation-Registry/blob/master/registry/MintAlignIdTestnetV2.md";
    alignStationImpl.registerType(aidr.idOf(broadcaster), claimType, claimLink);

    // Attest the first claim type
    uint256 attesterAlignId = aidr.readId(broadcaster);
    // Claculate the ClaimTypeKey which is used as a reference to the attestation
    bytes32 claimTypeKey = keccak256(abi.encodePacked(attesterAlignId, claimType));

    bytes32 claim = keccak256("I minted my Align Identity on Align Testnet v2");
    bytes32 claimProof = keccak256("0x2b243d614df0ca88a1bf8ed243c94b4c57769ef30aa39ae55ee25bc4105f92b4");
    alignStationImpl.attest(attesterAlignId, attesterAlignId, claimTypeKey, claim, claimProof);

    // Check the attestation
    (bytes32 attesterKeyOut, bytes32 storedClaim, bytes32 storedClaimProof) = alignStationImpl.getAttestation(
      attesterAlignId,
      attesterAlignId,
      claimTypeKey
    );
    console2.log("attesterKeyOut: %s", string(abi.encodePacked(attesterKeyOut)));
    console2.log("storedClaim: %s", string(abi.encodePacked(storedClaim)));
    console2.log("storedClaimProof: %s", string(abi.encodePacked(storedClaimProof)));
  }
}
