// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import { PRBTest } from "@prb/test/src/PRBTest.sol";
import "../src/InteractionStation.sol";
import "../src/AlignIdRegistry.sol";
import "../src/VerifyIPFS.sol";
import "forge-std/src/console2.sol";

contract AlignStationTest is PRBTest {
  InteractionStation private intstation;
  AlignIdRegistry private alignIdContract;
  VerifyIPFS private verifyIPFS;
  address private admin = address(1);
  address private to = address(2);
  string private name = "Post";
  string private name2 = "Points"; // or prediction etc.
  string private iTypeCID = "bafyreihdaunebldfovtrp6iykh6seyw4hlcnbof6k54djr2gmvd35zvany";
  string private iTypeCID2 = "bafyreihdaunebldfovtrp6iykh6seyw4hlcnbof6k54djr2gmvd35zvawe";
  string private iCID = "bafyreibovgpqyml5m66jwpqcqmicqviixupqznm7lxpp6junas7tduvhwu";
  string private iCID2 = "bafyreihdaunebldfovtrp6iykh6seyw4hlcnbof6k54djr2gmvd35zvany";

  function setUp() public {
    // Admin = address(1)
    vm.prank(admin);
    alignIdContract = new AlignIdRegistry();
    verifyIPFS = new VerifyIPFS();
    intstation = new InteractionStation(address(alignIdContract), address(verifyIPFS));
    address owner = alignIdContract.owner();
    vm.prank(admin);
    alignIdContract.register(admin);
    // Recipient
    vm.prank(admin);
    alignIdContract.register(to);
  }

  function testCreateInteractionType() public {
    // Attester = Admin
    uint256 adminAlignId = alignIdContract.idOf(admin);
    uint256 toAlignId = alignIdContract.idOf(to);
    bytes32 iTypeKey = keccak256(abi.encodePacked(adminAlignId, name));
    vm.prank(admin);
    intstation.createIType(false, false, name, iTypeCID, new bytes32[](0));
    assertTrue(intstation.isITypeRegistered(iTypeKey), "Interaction type should be registered");

    vm.prank(admin);
    intstation.interact(toAlignId, iTypeKey, iCID, bytes32(0));

    bool storedInteraction = intstation.getICIDNonFungible(adminAlignId, toAlignId, iTypeKey);
    assertEq(storedInteraction, true, "Interaction data does not match");

    vm.expectRevert(bytes4(keccak256("AlreadyInteracted()")));
    vm.prank(admin);
    intstation.interact(toAlignId, iTypeKey, iCID, bytes32(0));
  }

  function testGetRegisterFungible() public {
    uint256 adminAlignId = alignIdContract.idOf(admin);
    uint256 toAlignId = alignIdContract.idOf(to);
    bytes32 iTypeKey = keccak256(abi.encodePacked(adminAlignId, name2));

    vm.prank(admin);
    intstation.createIType(true, false, name2, iTypeCID, new bytes32[](0));
    assertTrue(intstation.isITypeRegistered(iTypeKey), "Interaction type should be registered");

    vm.prank(admin);
    intstation.interact(toAlignId, iTypeKey, iCID, bytes32(0));

    bool storedInteraction = intstation.getICIDFungible(adminAlignId, toAlignId, iTypeKey, iCID);
    assertEq(storedInteraction, true, "Interaction data does not match");
  }

  function testRegisterFungible() public {
    uint256 adminAlignId = alignIdContract.idOf(admin);
    uint256 toAlignId = alignIdContract.idOf(to);
    bytes32 iTypeKey = keccak256(abi.encodePacked(adminAlignId, name2));

    vm.prank(admin);
    intstation.createIType(true, false, name2, iTypeCID, new bytes32[](0));
    assertTrue(intstation.isITypeRegistered(iTypeKey), "Interaction type should be registered");

    vm.prank(admin);
    intstation.interact(toAlignId, iTypeKey, iCID, bytes32(0));

    bool storedInteraction = intstation.getICIDFungible(adminAlignId, toAlignId, iTypeKey, iCID);
    assertEq(storedInteraction, true, "Interaction data does not match");
    vm.prank(admin);
    intstation.interact(toAlignId, iTypeKey, iCID2, bytes32(0));

    bool storedInteraction2 = intstation.getICIDFungible(adminAlignId, toAlignId, iTypeKey, iCID2);
    assertEq(storedInteraction2, true, "Interaction data does not match");

    vm.startPrank(admin);
    vm.expectRevert(bytes4(keccak256("AlreadyInteracted()")));
    intstation.interact(toAlignId, iTypeKey, iCID, bytes32(0));
    vm.stopPrank();
  }

  function testAlreadyInteractedFungibleRevert() public {
    uint256 adminAlignId = alignIdContract.idOf(admin);
    bytes32 iTypeKey = keccak256(abi.encodePacked(adminAlignId, name));

    vm.prank(admin);
    intstation.createIType(true, false, name, iTypeCID, new bytes32[](0));

    // First interaction
    uint256 toAlignId = alignIdContract.idOf(to);
    vm.prank(admin);
    intstation.interact(toAlignId, iTypeKey, iCID, bytes32(0));

    // Expecting a revert on attempting a second identical interaction
    vm.prank(admin);
    vm.expectRevert(bytes4(keccak256("AlreadyInteracted()")));
    intstation.interact(toAlignId, iTypeKey, iCID, bytes32(0));
  }

  function testAddITypeCID() public {
    uint256 adminAlignId = alignIdContract.idOf(admin);
    bytes32 iTypeKey = keccak256(abi.encodePacked(adminAlignId, name));

    vm.prank(admin);
    intstation.createIType(true, false, name, iTypeCID, new bytes32[](0));

    vm.prank(admin);
    intstation.addITypeCID(iTypeKey, iTypeCID2);

    string memory storedInteraction = intstation.getITypeCID(iTypeKey);
    console2.logString(storedInteraction);
    assertEq(storedInteraction, iTypeCID2, "Interaction data does not match");
  }
}
