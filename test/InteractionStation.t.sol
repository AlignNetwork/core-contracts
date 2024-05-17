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
  string private interaction = "bafyreihdaunebldfovtrp6iykh6seyw4hlcnbof6k54djr2gmvd35zvany";
  string private interaction2 = "bafyreibovgpqyml5m66jwpqcqmicqviixupqznm7lxpp6junas7tduvhwu";
  string private link = "bafyreihdaunebldfovtrp6iykh6seyw4hlcnbof6k54djr2gmvd35zvany"; // ipfs link to interaction definition

  function setUp() public {
    // Admin = address(1)
    vm.prank(admin);
    alignIdContract = new AlignIdRegistry();
    verifyIPFS = new VerifyIPFS();
    intstation = new InteractionStation(address(alignIdContract), address(verifyIPFS));
    address owner = alignIdContract.owner();
    console2.log("owner: %s", owner);
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
    bytes32 interactionTypeKey = keccak256(abi.encodePacked(adminAlignId, name));
    vm.prank(admin);
    intstation.createInteractionType(false, false, name, link, new bytes32[](0));
    assertTrue(intstation.isinteractionTypeRegistered(interactionTypeKey), "Interaction type should be registered");

    vm.prank(admin);
    intstation.interact(toAlignId, interactionTypeKey, interaction);

    string memory storedInteraction = intstation.getInteractionNonFungible(adminAlignId, toAlignId, interactionTypeKey);
    console2.logString(storedInteraction);
    assertEq(storedInteraction, interaction, "Interaction data does not match");

    vm.expectRevert(bytes4(keccak256("AlreadyInteracted()")));
    vm.prank(admin);
    intstation.interact(toAlignId, interactionTypeKey, interaction);
  }

  function testGetRegisterFungible() public {
    uint256 adminAlignId = alignIdContract.idOf(admin);
    uint256 toAlignId = alignIdContract.idOf(to);
    bytes32 interactionTypeKey = keccak256(abi.encodePacked(adminAlignId, name2));

    vm.prank(admin);
    intstation.createInteractionType(true, false, name2, link, new bytes32[](0));
    assertTrue(intstation.isinteractionTypeRegistered(interactionTypeKey), "Interaction type should be registered");

    console2.log(block.timestamp);
    vm.prank(admin);
    intstation.interact(toAlignId, interactionTypeKey, interaction);

    string memory storedInteraction = intstation.getInteractionFungible(
      adminAlignId,
      toAlignId,
      interactionTypeKey,
      interaction
    );
    assertEq(storedInteraction, interaction, "Interaction data does not match");
  }

  function testRegisterFungible() public {
    uint256 adminAlignId = alignIdContract.idOf(admin);
    uint256 toAlignId = alignIdContract.idOf(to);
    bytes32 interactionTypeKey = keccak256(abi.encodePacked(adminAlignId, name2));

    vm.prank(admin);
    intstation.createInteractionType(true, false, name2, link, new bytes32[](0));
    assertTrue(intstation.isinteractionTypeRegistered(interactionTypeKey), "Interaction type should be registered");

    console2.log(block.timestamp);
    vm.prank(admin);
    intstation.interact(toAlignId, interactionTypeKey, interaction);

    string memory storedInteraction = intstation.getInteractionFungible(
      adminAlignId,
      toAlignId,
      interactionTypeKey,
      interaction
    );
    console2.logString(storedInteraction);
    assertEq(storedInteraction, interaction, "Interaction data does not match");
    vm.prank(admin);
    intstation.interact(toAlignId, interactionTypeKey, interaction2);

    string memory storedInteraction2 = intstation.getInteractionFungible(
      adminAlignId,
      toAlignId,
      interactionTypeKey,
      interaction2
    );
    assertEq(storedInteraction2, interaction2, "Interaction data does not match");

    vm.startPrank(admin);
    vm.expectRevert(bytes4(keccak256("AlreadyInteracted()")));
    intstation.interact(toAlignId, interactionTypeKey, interaction);
    vm.stopPrank();
  }

  function testAlreadyInteractedFungibleRevert() public {
    uint256 adminAlignId = alignIdContract.idOf(admin);
    bytes32 interactionTypeKey = keccak256(abi.encodePacked(adminAlignId, name));

    vm.prank(admin);
    intstation.createInteractionType(true, false, name, link, new bytes32[](0));

    // First interaction
    uint256 toAlignId = alignIdContract.idOf(to);
    vm.prank(admin);
    intstation.interact(toAlignId, interactionTypeKey, interaction);

    // Expecting a revert on attempting a second identical interaction
    vm.prank(admin);
    vm.expectRevert(bytes4(keccak256("AlreadyInteracted()")));
    intstation.interact(toAlignId, interactionTypeKey, interaction);
  }
}
