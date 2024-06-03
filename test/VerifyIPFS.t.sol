// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import { PRBTest } from "@prb/test/src/PRBTest.sol";
import "../src/VerifyIPFS.sol";
import "forge-std/src/console2.sol";

contract VerifyIPFSTest is PRBTest {
  VerifyIPFS private verifyIPFS;

  function setUp() public {
    verifyIPFS = new VerifyIPFS();
    vm.deal(address(this), 100 ether);
  }

  function testVerifyIPFS() public {
    string memory ipfsHash = "bafyreihdaunebldfovtrp6iykh6seyw4hlcnbof6k54djr2gmvd35zvawe";
    bool result = verifyIPFS.isCID(ipfsHash);
    assertTrue(result, "IPFS hash should be verified");
  }

  function testVerifyIPFSFail() public {
    string memory ipfsHash = "1234567890";
    vm.expectRevert(bytes4(keccak256("NotCIDv1()")));
    verifyIPFS.isCID(ipfsHash);
  }
}
