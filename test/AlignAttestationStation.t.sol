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
    string private claimType2 = "NYC Marathon Badge 2018"; // or prediction etc.
    string private claim = "I ran the NYC marathon on 11-05-2017";
    string private claim2 = "I ran the NYC marathon on 11-05-2018";
    string private claimProof = "https://results.nyrr.org/runner/1111/result/M2017";
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

        aas.registerType(false, claimType, claimLink, false);
        assertTrue(aas.isClaimTypeRegistered(claimTypeKey), "Claim type should be registered");

        // Attesting
        // Attempt to attest a claim
        aas.attest(toAlignId, claimTypeKey, claim, claimProof);

        // Check the attestation
        (string memory storedClaim, string memory storedClaimProof) =
            aas.getAttestationNonFungible(adminAlignId, toAlignId, claimTypeKey);
        console2.logString(storedClaim);
        assertEq(storedClaim, claim, "Claim data does not match");
        assertEq(storedClaimProof, claimProof, "Claim proof does not match");

        vm.expectRevert(bytes4(keccak256("AlreadyAttested()")));
        aas.attest(toAlignId, claimTypeKey, claim, claimProof);
    }

    function testRegisterFungible() public {
        // Attester = Admin
        uint256 adminAlignId = alignIdContract.idOf(admin);
        uint256 toAlignId = alignIdContract.idOf(to);
        bytes32 claimTypeKey = keccak256(abi.encodePacked(adminAlignId, claimType2));
        bytes32 attestationKey = keccak256(abi.encodePacked(adminAlignId, toAlignId, claimTypeKey));

        aas.registerType(true, claimType2, claimLink, false);
        assertTrue(aas.isClaimTypeRegistered(claimTypeKey), "Claim type should be registered");

        // Attesting
        console2.log(block.timestamp);
        // Attempt to attest a claim
        aas.attest(toAlignId, claimTypeKey, claim, claimProof);

        // Check the attestation
        (string memory storedClaim, string memory storedClaimProof) =
            aas.getAttestationFungible(adminAlignId, toAlignId, claimTypeKey, claim);
        console2.logString(storedClaim);
        assertEq(storedClaim, claim, "Claim data does not match");
        assertEq(storedClaimProof, claimProof, "Claim proof does not match");

        aas.attest(toAlignId, claimTypeKey, claim2, claimProof);

        (string memory storedClaim2, string memory storedClaimProof2) =
            aas.getAttestationFungible(adminAlignId, toAlignId, claimTypeKey, claim2);
        assertEq(storedClaim2, claim2, "Claim data does not match");
        assertEq(storedClaimProof2, claimProof, "Claim proof does not match");

        vm.expectRevert(bytes4(keccak256("AlreadyAttested()")));
        aas.attest(toAlignId, claimTypeKey, claim, claimProof);
        //aas.attest(adminAlignId, toAlignId, claimTypeKey, claim, claimProof);
    }
}
