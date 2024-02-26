// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import { PRBTest } from "@prb/test/src/PRBTest.sol";
import "../src/AlignStation.sol";
import "../src/AlignId.sol";
import "forge-std/src/console2.sol";

contract AlignStationTest is PRBTest {
  AlignStation private alignStation;
  AlignId private alignId;
  address private attester = address(1);
  address private user = address(2);
  string private claimType = "NYC Marathon Badge 2017";
  bytes private claim = "I ran the NYC marathon on 11-05-2017";
  bytes private claimProof = "https://results.nyrr.org/runner/1111/result/M2017";

  function setUp() public {
    alignId = new AlignId(address(3));
    alignStation = new AlignStation(address(alignId));
    // Register the attester to ensure it has an alignId
    vm.prank(address(3));
    alignId.register(attester, address(0));
  }

  function testAttest() public {
    // Register the user to simulate a more realistic scenario
    vm.prank(address(3));
    alignId.register(user, address(0));
    uint256 userAlignId = alignId.idOf(user);
    uint256 attesterAlignId = alignId.idOf(attester);

    // Attesting
    vm.prank(attester); // Simulate the call from the attester's address
    bytes memory claimKey = abi.encodePacked(keccak256(abi.encode(attesterAlignId, claimType)));
    alignStation.attest(attester, user, claimKey, claim, claimProof);

    // Verifications
    bytes memory typeKey = abi.encodePacked(keccak256(abi.encode(attesterAlignId, claimType)));
    (uint256 attesterAlignIdOut, bytes memory claimOut, bytes memory claimProofOut) = alignStation.attestations(
      userAlignId,
      typeKey
    );

    assertEq(attesterAlignIdOut, attesterAlignId, "The stored attesterAlignId should match");
    assertEq(claimOut, claim, "The stored claim should match the attested claim");
    assertEq(claimProofOut, claimProof, "The stored claimProof should match the attested claimProof");

    /*     // Event assertions
    vm.expectEmit(true, true, true, true);
    emit alignStation.Attested(attester, userAlignId, attestType, claim, claimProof); */
  }

  function testRegister() public {
    // Register a new user
    vm.prank(address(3));
    alignId.register(user, user);
    // Verifications
    uint256 userAlignId = alignId.idOf(user);
    console2.log("userAlignId: ", userAlignId);
    assertEq(userAlignId, 2, "The user's alignId should be 1");

    // Event assertions
    //vm.expectEmit(true, true, true, true);
    //emit alignStation.Register(user, userAlignId, address(0));
  }

  function testRegisterNotMsgSender() public {
    // Register a new user from a different address
    vm.prank(user); // Simulate the call from the user's address
    vm.expectRevert("only admin can register");
    alignId.register(user, address(0));
  }

  /* function testStoreType() public {
    uint256 attesterAlignId = alignStation.idOf(attester);

    // Store a new attestType
    vm.prank(attester); // Ensure msg.sender is as expected by the function
    alignStation.storeType(attester, attestType);

    // Verifications
    bytes32 typeKey = keccak256(abi.encode(attester, attestType));
    bytes32 storedTypes = alignStation.attesterToTypeKeys(attesterAlignId, 0);
    assertEq(storedTypes, typeKey, "The stored typeKey should match the expected typeKey");

    // Event assertions
    //vm.expectEmit(true, true, true, true);
    //emit AlignStation.TypeStored(attester, attestType);
  } */
}
