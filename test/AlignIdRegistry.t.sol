// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import { PRBTest } from "@prb/test/src/PRBTest.sol";
import "../src/AlignIdRegistry.sol";
import "forge-std/src/console2.sol";

contract AlignIdTest is PRBTest {
  AlignIdRegistry alignId;
  address admin = address(1);
  address user = address(2);
  address user2 = address(3);
  address withdrawer = address(4);
  address treasury = address(5);
  uint256 private protocolFee = 0.002 ether;

  // Events
  event AlignIdRegistered(address indexed to, uint256 indexed id);
  event Transfer(uint256 indexed id, address indexed from, address indexed to);
  event ProtocolFeeUpdated(uint256 newFee);
  event PausedState(bool paused);
  event Withdrawn(uint256 amount);
  event TreasuryUpdated(address newTreasury);

  function setUp() public {
    vm.startPrank(admin);
    alignId = new AlignIdRegistry(protocolFee, treasury);
    vm.stopPrank();
  }

  ///// Test Register /////////////////////////////////
  function testRegister() public {
    vm.deal(user, protocolFee);
    vm.prank(user);
    alignId.register{ value: protocolFee }();

    // Check that the ID was registered
    uint256 alignIdOfUser = alignId.idOf(user);
    assertEq(alignIdOfUser, 1, "User should have an ID of 1");
  }

  function testRegisterPaused() public {
    vm.deal(user, protocolFee);
    vm.prank(user);
    alignId.register{ value: protocolFee }();

    vm.prank(admin);
    alignId.setPaused(true);

    vm.expectRevert(bytes4(keccak256("Paused()")));
    alignId.register{ value: protocolFee }();
  }

  function testRegisterShouldFailWithIncorrectAmount() public {
    vm.deal(user, 0.005 ether);
    vm.prank(user);
    // Attempt to register an ID with incorrect amount
    vm.expectRevert(bytes4(keccak256("IncorrectAmount()")));
    alignId.register{ value: 0.005 ether }();
  }

  function testRegisterShouldFailIdExists() public {
    vm.deal(user, protocolFee);
    vm.prank(user);
    alignId.register{ value: protocolFee }();

    vm.deal(user, protocolFee);
    vm.prank(user);
    vm.expectRevert(bytes4(keccak256("IdExists()")));
    alignId.register{ value: protocolFee }();
  }

  function testRegisterEmitsIdRegistered() public {
    vm.deal(user, protocolFee);
    vm.startPrank(user);
    vm.expectEmit(true, true, false, true);
    emit AlignIdRegistered(user, 1);
    alignId.register{ value: protocolFee }();
    vm.stopPrank();
  }

  /////////////////////////////////////////////////////

  /// Test Register To ////////////////////////////////
  function testRegisterTo() public {
    vm.deal(user, protocolFee);
    alignId.registerTo{ value: protocolFee }(user);

    // Check that the ID was registered
    uint256 alignIdOfUser = alignId.idOf(user);
    assertEq(alignIdOfUser, 1, "User should have an ID of 1");
  }

  function testRegisterToPaused() public {
    vm.deal(user, protocolFee);
    vm.prank(user);
    alignId.registerTo{ value: protocolFee }(user);

    vm.prank(admin);
    alignId.setPaused(true);

    vm.expectRevert(bytes4(keccak256("Paused()")));
    alignId.registerTo{ value: protocolFee }(user);
  }

  function testRegisterToShouldFailWithIncorrectAmount() public {
    vm.deal(user, 0.005 ether);
    vm.prank(user);
    // Attempt to register an ID with incorrect amount
    vm.expectRevert(bytes4(keccak256("IncorrectAmount()")));
    alignId.registerTo{ value: 0.005 ether }(user);
  }

  function testRegisterToShouldFailIdExists() public {
    vm.deal(user, protocolFee);
    vm.prank(user);
    alignId.registerTo{ value: protocolFee }(user);

    vm.deal(user, protocolFee);
    vm.prank(user);
    vm.expectRevert(bytes4(keccak256("IdExists()")));
    alignId.registerTo{ value: protocolFee }(user);
  }

  function testRegisterToEmitsIdRegistered() public {
    vm.deal(user, protocolFee);
    vm.startPrank(user);
    vm.expectEmit(true, true, false, true);
    emit AlignIdRegistered(user, 1);
    alignId.registerTo{ value: protocolFee }(user);
    vm.stopPrank();
  }

  /////////////////////////////////////////////////////

  /// Test Transfer //////////////////////////////////
  function testTransfer() public {
    vm.deal(user, protocolFee);
    vm.prank(user);
    // Register a new ID for the user
    alignId.register{ value: protocolFee }();

    // Check that the ID was registered
    uint256 alignIdOfUser = alignId.idOf(user);
    assertEq(alignIdOfUser, 1, "User should have an ID of 1");

    // Transfer the ID to another user
    vm.startPrank(user);
    alignId.transfer(user, user2);
    vm.stopPrank();

    // Check that the ID was transferred
    uint256 alignIdOfUser2 = alignId.idOf(user2);
    assertEq(alignIdOfUser2, 1, "User2 should have an ID of 1");

    // Check that the id of user is now 0
    uint256 alignIdOfUserAfterTransfer = alignId.idOf(user);
    assertEq(alignIdOfUserAfterTransfer, 0, "User should have an ID of 0");
  }

  function testTransferShouldFailWhenSourceHasNoId() public {
    // Attempt to transfer ID from an address without an ID
    vm.expectRevert(bytes4(keccak256("SourceHasNoId()")));
    vm.prank(user);
    alignId.transfer(user, user2);
  }

  function testTransferShouldFailWhenDestinationHasId() public {
    vm.deal(user, protocolFee);
    vm.deal(user2, protocolFee);
    vm.prank(user);
    // Register a new ID for the user
    alignId.register{ value: protocolFee }();
    vm.prank(user2);
    // Register a new ID for user2
    alignId.register{ value: protocolFee }();

    // Attempt to transfer ID to an address that already has an ID
    vm.expectRevert(bytes4(keccak256("DestinationHasId()")));
    vm.prank(user);
    alignId.transfer(user, user2);
  }

  function testTransferShouldFailWhenSourceIsNotOwner() public {
    vm.deal(user, protocolFee);
    vm.prank(user);
    alignId.register{ value: protocolFee }();

    vm.startPrank(user2);
    vm.expectRevert(bytes4(keccak256("NotOwner()")));
    alignId.transfer(user, user2);
    vm.stopPrank();
  }

  function testTransferShouldEmitTransferEvent() public {
    vm.deal(user, protocolFee);
    vm.startPrank(user);
    alignId.register{ value: protocolFee }();
    uint256 userId = alignId.readId(user);

    vm.expectEmit(true, true, true, false);
    emit Transfer(userId, user, user2);
    alignId.transfer(user, user2);
    vm.stopPrank();
  }

  /////////////////////////////////////////////////////

  /// Test Withdraw //////////////////////////////////

  function testWithdrawByOwner() public {
    // Register a new ID for the user to generate balance in the contract
    vm.deal(user, protocolFee);
    vm.prank(user);
    alignId.register{ value: protocolFee }();

    // Check treasury balance before withdrawal
    uint256 treasuryBalanceBefore = treasury.balance;

    // Withdraw funds as admin
    vm.prank(admin);
    alignId.withdraw();

    // Check contract balance after withdrawal
    uint256 contractBalanceAfter = address(alignId).balance;
    assertEq(contractBalanceAfter, 0, "Contract balance should be 0");

    // Check treasury balance after withdrawal
    uint256 treasuryBalanceAfter = treasury.balance;
    assertEq(treasuryBalanceAfter, treasuryBalanceBefore + protocolFee, "Treasury should receive withdrawn funds");
  }

  function testWithdrawByWithdrawer() public {
    // Register a new ID for the user to generate balance in the contract
    vm.deal(user, protocolFee);
    vm.prank(user);
    alignId.register{ value: protocolFee }();

    // Grant withdrawer role to a different address
    vm.startPrank(admin);
    alignId.grantRoles(withdrawer, alignId.WITHDRAWER_ROLE());
    vm.stopPrank();

    // Check contract balance before withdrawal
    uint256 contractBalanceBefore = address(alignId).balance;
    assertEq(contractBalanceBefore, protocolFee, "Contract balance should be protocolFee");

    // Check treasury balance before withdrawal
    uint256 treasuryBalanceBefore = treasury.balance;

    // Withdraw funds as withdrawer
    vm.startPrank(withdrawer);
    alignId.withdraw();
    vm.stopPrank();

    // Check contract balance after withdrawal
    uint256 contractBalanceAfter = address(alignId).balance;
    assertEq(contractBalanceAfter, 0, "Contract balance should be 0");

    // Check treasury balance after withdrawal
    uint256 treasuryBalanceAfter = treasury.balance;
    assertEq(treasuryBalanceAfter, treasuryBalanceBefore + protocolFee, "Treasury should receive withdrawn funds");
  }

  function testWithdrawShouldFailWhenNotOwnerOrWithdrawer() public {
    vm.deal(user, protocolFee);
    vm.prank(user);
    alignId.register{ value: protocolFee }();

    vm.startPrank(user2);
    vm.expectRevert(bytes4(keccak256("Unauthorized()")));
    alignId.withdraw();
    vm.stopPrank();
  }

  function testWithdrawShouldFailWhenNoTreasury() public {
    vm.prank(admin);
    AlignIdRegistry alignId2 = new AlignIdRegistry(protocolFee, address(0));

    vm.deal(user, protocolFee);
    vm.prank(user);
    alignId2.register{ value: protocolFee }();

    vm.startPrank(admin);
    vm.expectRevert(bytes4(keccak256("NoTreasurySet()")));
    alignId2.withdraw();
    vm.stopPrank();
  }

  /////////////////////////////////////////////////////

  function testSetTreasury() public {
    vm.startPrank(admin);
    alignId.setTreasury(address(6));
    vm.stopPrank();

    assertEq(alignId.treasury(), address(6), "Treasury should be set");
  }

  function testSetTreasuryShouldFailWhenSetToZeroAddress() public {
    vm.deal(user, protocolFee);
    vm.prank(user);
    alignId.register{ value: protocolFee }();

    vm.startPrank(admin);
    vm.expectRevert(bytes4(keccak256("NoTreasurySet()")));
    alignId.setTreasury(address(0));
    vm.stopPrank();
  }

  function testSetPause() public {
    // Grant pauser role to a different address
    vm.startPrank(admin);
    alignId.grantRoles(user, alignId.PAUSER_ROLE());
    vm.stopPrank();

    // Pause the contract
    vm.prank(user);
    alignId.setPaused(true);

    // Check that the contract is paused
    assertEq(alignId.paused(), true, "Contract should be paused");

    // Attempt to register while paused
    vm.deal(user2, protocolFee);
    vm.prank(user2);
    vm.expectRevert(bytes4(keccak256("Paused()")));
    alignId.register{ value: protocolFee }();

    // Unpause the contract
    vm.prank(user);
    alignId.setPaused(false);

    // Check that the contract is unpaused
    assertEq(alignId.paused(), false, "Contract should be unpaused");

    // Register successfully after unpausing
    vm.prank(user2);
    alignId.register{ value: protocolFee }();
    uint256 alignIdOfUser2 = alignId.idOf(user2);
    assertEq(alignIdOfUser2, 1, "User2 should have an ID of 1");
  }

  function testSetProtocolFee() public {
    // Set a new protocol fee
    uint256 newProtocolFee = 1000 ether;
    vm.prank(admin);
    alignId.setProtocolFee(newProtocolFee);

    // Check that the new protocol fee is set correctly
    assertEq(alignId.protocolFee(), newProtocolFee, "Protocol fee should be set correctly");
  }

  function testReadId() public {
    // Register a user
    vm.deal(user, protocolFee);
    vm.prank(user);
    alignId.register{ value: protocolFee }();

    // Check that the user's ID is set correctly
    uint256 userId = alignId.readId(user);
    assertEq(userId, 1, "User's ID should be set correctly");
  }

  function testReadIdOf() public {
    // Register a user
    vm.deal(user, protocolFee);
    vm.prank(user);
    alignId.register{ value: protocolFee }();

    // Check that the user's ID is set correctly
    uint256 userId = alignId.idOf(user);
    assertEq(userId, 1, "User's ID should be set correctly");
  }

  function testReadIdOfNotRegistered() public {
    // Check that the ID of a non-registered user is 0
    uint256 userId = alignId.idOf(user);
    assertEq(userId, 0, "User's ID should be 0");
  }
}
