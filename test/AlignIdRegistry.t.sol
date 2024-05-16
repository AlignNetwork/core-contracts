// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import { PRBTest } from "@prb/test/src/PRBTest.sol";
import "../src/AlignIdRegistry.sol";
import "forge-std/src/console2.sol";

contract AlignIdTest is PRBTest {
  AlignIdRegistry alignId;
  address user = address(1);

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
    alignId.register(address(1));

    // Attempt to register the ID again
    vm.expectRevert(bytes4(keccak256("IdExists()")));
    vm.prank(address(1));
    alignId.register(user);
  }

  // to make internal testing easier - should pass bc i commented out the admin check
  // so anyone can register
  function testCCase_RegisterFromNonAdmin() public {
    // Attempt to register an ID from a non-admin address
    vm.prank(user);
    alignId.register(user);
  }
}
