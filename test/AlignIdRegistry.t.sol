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

  function setUp() public {
    alignId = new AlignIdRegistry();
  }

  function testACase_Register() public {
    // Register a new ID for the user
    alignId.register(user);

    // Check that the ID was registered
    uint256 alignIdOfUser = alignId.idOf(user);
    assertEq(alignIdOfUser, 1, "User should have an ID of 1");
  }

  function testRegisterShouldFailWithIdExists() public {
    // Register a new ID for the user
    alignId.register(user);

    // Attempt to register the ID again
    vm.expectRevert(bytes4(keccak256("IdExists()")));
    alignId.register(user);
  }

  function testCCase_RegisterFromNonAdmin() public {
    // Attempt to register an ID from a non-admin address
    vm.expectRevert(bytes4(keccak256("Unauthorized()")));
    vm.startPrank(user);
    alignId.register(user);
    vm.stopPrank();
  }

  function testDCase_RegisterDev() public {
    // Register a new ID for the user
    alignId.registerDev(user);

    // Check that the ID was registered
    uint256 alignIdOfUser = alignId.idOf(user);
    assertEq(alignIdOfUser, 10_002, "User should have an ID of 10_001");
  }

  function testTransferId() public {
    // Register a new ID for the user
    alignId.register(user);

    // Check that the ID was registered
    uint256 alignIdOfUser = alignId.idOf(user);
    assertEq(alignIdOfUser, 1, "User should have an ID of 1");

    // Transfer the ID to another user
    vm.startPrank(user);
    alignId.transferId(user, user2);
    vm.stopPrank();

    // Check that the ID was transferred
    uint256 alignIdOfUser2 = alignId.idOf(user2);
    assertEq(alignIdOfUser2, 1, "User2 should have an ID of 1");
  }
}
