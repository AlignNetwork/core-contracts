// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import { PRBTest } from "@prb/test/src/PRBTest.sol";
import "../src/AlignAttestationStation.sol";
import "../src/AlignIdRegistry.sol";
import "forge-std/src/console2.sol";

contract AlignStationTest is PRBTest {
  AlignAttestationStation private aas;
  AlignIdRegistry private alignIdContract;
  address private admin = address(1);
  address private to = address(3);
  string private claimType = "NYC Marathon Badge 2017"; // or prediction etc.
  bytes32 private claim = keccak256("I ran the NYC marathon on 11-05-2017");
  bytes32 private claimProof = keccak256("https://results.nyrr.org/runner/1111/result/M2017");
  string private claimLink = "https://results.nyrr.org/runner/";

  function setUp() public {
    // Admin = address(1)
    vm.prank(admin);
    alignIdContract = new AlignIdRegistry();
    aas = new AlignAttestationStation(address(alignIdContract));
    address owner = alignIdContract.owner();
    console2.log("owner: %s", owner);
    // Register the Admin as the only Attester to ensure it has an alignId
    vm.prank(admin);
    alignIdContract.register(admin, admin);
    // Recipient
    vm.prank(admin);
    alignIdContract.register(to, to);
  }

  function testRegisterType() public {
    // Attester = Admin
    uint256 adminAlignId = alignIdContract.idOf(admin);
    uint256 toAlignId = alignIdContract.idOf(to);
    bytes32 claimTypeKey = keccak256(abi.encodePacked(adminAlignId, claimType));
    bytes32 attestationKey = keccak256(abi.encodePacked(adminAlignId, toAlignId, claimTypeKey));

    aas.registerType(adminAlignId, claimType, claimLink);
    assertTrue(aas.isClaimTypeRegistered(claimTypeKey), "Claim type should be registered");

    // Attesting
    // Attempt to attest a claim
    aas.attest(adminAlignId, toAlignId, claimTypeKey, claim, claimProof);

    // Check the attestation
    (bytes32 attesterKeyOut, bytes32 storedClaim, bytes32 storedClaimProof) = aas.getAttestation(
      adminAlignId,
      toAlignId,
      claimTypeKey
    );
    assertEq(attesterKeyOut, attestationKey, "Attester key does not match");
    assertEq(storedClaim, claim, "Claim data does not match");
    assertEq(storedClaimProof, claimProof, "Claim proof does not match");
    /*     // Event assertions
    vm.expectEmit(true, true, true, true);
    emit alignStation.Attested(attester, userAlignId, attestType, claim, claimProof); */
  }
}
