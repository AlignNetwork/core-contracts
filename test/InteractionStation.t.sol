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
  uint256 private alignIdFee = 0.0028 ether;
  address private admin = address(1);
  address private to = address(2);
  address user2 = address(3);
  address withdrawer = address(4);
  address treasury = address(5);
  uint256 private protocolFee = 0.00028 ether;
  string private name = "Post";
  string private name2 = "Points"; // or prediction etc.
  string private iTypeCID = "bafyreihdaunebldfovtrp6iykh6seyw4hlcnbof6k54djr2gmvd35zvany";
  string private iTypeCID2 = "bafyreihdaunebldfovtrp6iykh6seyw4hlcnbof6k54djr2gmvd35zvawe";
  string private iCID = "bafyreibovgpqyml5m66jwpqcqmicqviixupqznm7lxpp6junas7tduvhwu";
  string private iCID2 = "bafyreihdaunebldfovtrp6iykh6seyw4hlcnbof6k54djr2gmvd35zvany";

  function setUp() public {
    // Admin = address(1)
    vm.deal(admin, 1 ether);
    vm.startPrank(admin);
    alignIdContract = new AlignIdRegistry(alignIdFee, address(5)); // Initialize with a registration fee
    verifyIPFS = new VerifyIPFS();
    intstation = new InteractionStation(address(alignIdContract), address(verifyIPFS), protocolFee, treasury);
    vm.stopPrank();
    // Admin registration
    vm.deal(admin, alignIdFee);
    vm.startPrank(admin);
    alignIdContract.register{ value: alignIdFee }();
    vm.stopPrank();

    // Recipient registration
    vm.deal(to, alignIdFee);
    vm.startPrank(to);
    alignIdContract.register{ value: alignIdFee }();
    vm.stopPrank();

    vm.deal(user2, alignIdFee);
    vm.startPrank(user2);
    alignIdContract.register{ value: alignIdFee }();
    vm.stopPrank();

    vm.deal(admin, protocolFee * 10);
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
    intstation.interact{ value: protocolFee }(toAlignId, iTypeKey, iCID, bytes32(0));

    bool storedInteraction = intstation.getICIDNonFungible(adminAlignId, toAlignId, iTypeKey);
    assertEq(storedInteraction, true, "Interaction data does not match");

    vm.expectRevert(bytes4(keccak256("AlreadyInteracted()")));
    vm.prank(admin);
    intstation.interact{ value: protocolFee }(toAlignId, iTypeKey, iCID, bytes32(0));
  }

  function testGetRegisterFungible() public {
    uint256 adminAlignId = alignIdContract.idOf(admin);
    uint256 toAlignId = alignIdContract.idOf(to);
    uint256 user2AlignId = alignIdContract.idOf(user2);
    bytes32 iTypeKey = keccak256(abi.encodePacked(adminAlignId, name2));

    vm.prank(admin);
    intstation.createIType(true, false, name2, iTypeCID, new bytes32[](0));
    assertTrue(intstation.isITypeRegistered(iTypeKey), "Interaction type should be registered");

    vm.prank(admin);
    intstation.interact{ value: protocolFee }(toAlignId, iTypeKey, iCID, bytes32(0));
    vm.deal(user2, 100 ether);
    vm.prank(user2);
    intstation.interact{ value: protocolFee }(user2AlignId, iTypeKey, iCID, bytes32(0));

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
    intstation.interact{ value: protocolFee }(toAlignId, iTypeKey, iCID, bytes32(0));

    bool storedInteraction = intstation.getICIDFungible(adminAlignId, toAlignId, iTypeKey, iCID);
    assertEq(storedInteraction, true, "Interaction data does not match");
    vm.prank(admin);
    intstation.interact{ value: protocolFee }(toAlignId, iTypeKey, iCID2, bytes32(0));

    bool storedInteraction2 = intstation.getICIDFungible(adminAlignId, toAlignId, iTypeKey, iCID2);
    assertEq(storedInteraction2, true, "Interaction data does not match");

    vm.startPrank(admin);
    vm.expectRevert(bytes4(keccak256("AlreadyInteracted()")));
    intstation.interact{ value: protocolFee }(toAlignId, iTypeKey, iCID, bytes32(0));
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
    intstation.interact{ value: protocolFee }(toAlignId, iTypeKey, iCID, bytes32(0));

    // Expecting a revert on attempting a second identical interaction
    vm.prank(admin);
    vm.expectRevert(bytes4(keccak256("AlreadyInteracted()")));
    intstation.interact{ value: protocolFee }(toAlignId, iTypeKey, iCID, bytes32(0));
  }

  function testAddITypeCID() public {
    uint256 adminAlignId = alignIdContract.idOf(admin);
    bytes32 iTypeKey = keccak256(abi.encodePacked(adminAlignId, name));

    vm.prank(admin);
    intstation.createIType(true, false, name, iTypeCID, new bytes32[](0));

    vm.prank(admin);
    intstation.addITypeCID(iTypeKey, iTypeCID2);

    string memory storedInteraction = intstation.getITypeCID(iTypeKey);
    assertEq(storedInteraction, iTypeCID2, "Interaction data does not match");
  }

  function testSetProtocolFee() public {
    vm.startPrank(admin);
    intstation.grantRoles(user2, intstation.FEE_SETTER_ROLE());
    vm.stopPrank();
    uint256 newProtocolFee = 1000 ether;
    vm.startPrank(user2);
    intstation.setProtocolFee(newProtocolFee);
    vm.stopPrank();

    assertEq(intstation.protocolFee(), newProtocolFee, "Protocol fee should be set correctly");
  }

  function testWithdrawByOwner() public {
    // Register a new ID for the user to generate balance in the contract
    vm.deal(to, protocolFee);
    vm.prank(to);
    uint256 adminAlignId = alignIdContract.idOf(admin);
    uint256 toAlignId = alignIdContract.idOf(to);
    bytes32 iTypeKey = keccak256(abi.encodePacked(adminAlignId, name2));

    vm.prank(admin);
    intstation.createIType(true, false, name2, iTypeCID, new bytes32[](0));
    assertTrue(intstation.isITypeRegistered(iTypeKey), "Interaction type should be registered");

    vm.prank(admin);
    intstation.interact{ value: protocolFee }(toAlignId, iTypeKey, iCID, bytes32(0));

    // Check treasury balance before withdrawal
    uint256 treasuryBalanceBefore = treasury.balance;

    // Withdraw funds as admin
    vm.prank(admin);
    intstation.withdraw();

    // Check contract balance after withdrawal
    uint256 contractBalanceAfter = address(intstation).balance;
    assertEq(contractBalanceAfter, 0, "Contract balance should be 0");

    // Check treasury balance after withdrawal
    uint256 treasuryBalanceAfter = treasury.balance;
    assertEq(treasuryBalanceAfter, treasuryBalanceBefore + protocolFee, "Treasury should receive withdrawn funds");
  }

  function testWithdrawByWithdrawer() public {
    // Register a new ID for the user to generate balance in the contract
    uint256 adminAlignId = alignIdContract.idOf(admin);
    uint256 toAlignId = alignIdContract.idOf(to);
    bytes32 iTypeKey = keccak256(abi.encodePacked(adminAlignId, name2));

    vm.prank(admin);
    intstation.createIType(true, false, name2, iTypeCID, new bytes32[](0));
    assertTrue(intstation.isITypeRegistered(iTypeKey), "Interaction type should be registered");

    vm.prank(admin);
    intstation.interact{ value: protocolFee }(toAlignId, iTypeKey, iCID, bytes32(0));

    // Grant withdrawer role to a different address
    vm.startPrank(admin);
    intstation.grantRoles(withdrawer, intstation.WITHDRAWER_ROLE());
    vm.stopPrank();

    // Check contract balance before withdrawal
    uint256 contractBalanceBefore = address(intstation).balance;
    assertEq(contractBalanceBefore, protocolFee, "Contract balance should be protocolFee");

    // Check treasury balance before withdrawal
    uint256 treasuryBalanceBefore = treasury.balance;

    // Withdraw funds as withdrawer
    vm.startPrank(withdrawer);
    intstation.withdraw();
    vm.stopPrank();

    // Check contract balance after withdrawal
    uint256 contractBalanceAfter = address(intstation).balance;
    assertEq(contractBalanceAfter, 0, "Contract balance should be 0");

    // Check treasury balance after withdrawal
    uint256 treasuryBalanceAfter = treasury.balance;
    assertEq(treasuryBalanceAfter, treasuryBalanceBefore + protocolFee, "Treasury should receive withdrawn funds");
  }

  function testWithdrawShouldFailWhenNotOwnerOrWithdrawer() public {
    uint256 adminAlignId = alignIdContract.idOf(admin);
    uint256 toAlignId = alignIdContract.idOf(to);
    bytes32 iTypeKey = keccak256(abi.encodePacked(adminAlignId, name2));

    vm.prank(admin);
    intstation.createIType(true, false, name2, iTypeCID, new bytes32[](0));
    assertTrue(intstation.isITypeRegistered(iTypeKey), "Interaction type should be registered");

    vm.prank(admin);
    intstation.interact{ value: protocolFee }(toAlignId, iTypeKey, iCID, bytes32(0));

    vm.startPrank(user2);
    vm.expectRevert(bytes4(keccak256("Unauthorized()")));
    intstation.withdraw();
    vm.stopPrank();
  }

  function testWithdrawShouldFailWhenNoTreasury() public {
    vm.prank(admin);
    InteractionStation intstation2 = new InteractionStation(
      address(alignIdContract),
      address(verifyIPFS),
      protocolFee,
      address(0)
    );

    uint256 adminAlignId = alignIdContract.idOf(admin);
    uint256 toAlignId = alignIdContract.idOf(to);
    bytes32 iTypeKey = keccak256(abi.encodePacked(adminAlignId, name2));

    vm.prank(admin);
    intstation.createIType(true, false, name2, iTypeCID, new bytes32[](0));
    assertTrue(intstation.isITypeRegistered(iTypeKey), "Interaction type should be registered");

    vm.prank(admin);
    intstation.interact{ value: protocolFee }(toAlignId, iTypeKey, iCID, bytes32(0));

    vm.startPrank(admin);
    vm.expectRevert(bytes4(keccak256("NoTreasurySet()")));
    intstation2.withdraw();
    vm.stopPrank();
  }

  function testSetTreasury() public {
    vm.startPrank(admin);
    intstation.setTreasury(address(6));
    vm.stopPrank();
    assertEq(intstation.treasury(), address(6), "Treasury should be set");
  }

  function testSetTreasuryShouldFailWhenNotOwner() public {
    vm.startPrank(user2);
    vm.expectRevert(bytes4(keccak256("Unauthorized()")));
    intstation.setTreasury(address(6));
    vm.stopPrank();
  }

  function testSetTreasuryShouldFailWhenSetToZeroAddress() public {
    uint256 adminAlignId = alignIdContract.idOf(admin);
    uint256 toAlignId = alignIdContract.idOf(to);
    bytes32 iTypeKey = keccak256(abi.encodePacked(adminAlignId, name2));

    vm.prank(admin);
    intstation.createIType(true, false, name2, iTypeCID, new bytes32[](0));
    assertTrue(intstation.isITypeRegistered(iTypeKey), "Interaction type should be registered");

    vm.prank(admin);
    intstation.interact{ value: protocolFee }(toAlignId, iTypeKey, iCID, bytes32(0));
    vm.startPrank(admin);
    vm.expectRevert(bytes4(keccak256("NoTreasurySet()")));
    intstation.setTreasury(address(0));
    vm.stopPrank();
  }

  function testSetPause() public {
    // Grant pauser role to a different address
    vm.startPrank(admin);
    intstation.grantRoles(to, intstation.PAUSER_ROLE());
    vm.stopPrank();

    // Pause the contract
    vm.prank(to);
    intstation.setPaused(true);

    // Check that the contract is paused
    assertEq(intstation.paused(), true, "Contract should be paused");

    // Attempt to register while paused
    vm.deal(user2, protocolFee);
    vm.startPrank(user2);
    uint256 adminAlignId = alignIdContract.idOf(admin);
    uint256 toAlignId = alignIdContract.idOf(to);
    bytes32 iTypeKey = keccak256(abi.encodePacked(adminAlignId, name2));
    vm.stopPrank();

    vm.prank(admin);
    intstation.createIType(true, false, name2, iTypeCID, new bytes32[](0));
    assertTrue(intstation.isITypeRegistered(iTypeKey), "Interaction type should be registered");

    vm.prank(admin);
    vm.expectRevert(bytes4(keccak256("Paused()")));
    intstation.interact{ value: protocolFee }(toAlignId, iTypeKey, iCID, bytes32(0));

    // Unpause the contract
    vm.prank(to);
    intstation.setPaused(false);

    // Check that the contract is unpaused
    assertEq(intstation.paused(), false, "Contract should be unpaused");

    // Register successfully after unpausing
    vm.prank(admin);
    intstation.interact{ value: protocolFee }(toAlignId, iTypeKey, iCID, bytes32(0));
  }
}
