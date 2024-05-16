// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract VerifyIPFS {
  error NotCIDv0();
  error NotCIDv1();
  error NotCID();

  function isCID(string memory hash) public pure returns (bool) {
    if (isCIDv0(hash)) {
      return true;
    }
    if (isCIDv1(hash)) {
      return true;
    }
    revert NotCID();
  }

  function isCIDv0(string memory hash) public pure returns (bool) {
    bytes memory b = bytes(hash);

    // Check for length typically 46 for CIDv0, and starts with 'Qm'
    if (b.length == 46 && b[0] == bytes1("Q") && b[1] == bytes1("m")) {
      for (uint i = 2; i < b.length; i++) {
        bytes1 char = b[i];

        // Check if characters belong to the Base58 character set
        bool isValidBase58Char = (char >= "1" && char <= "9") ||
          (char >= "A" && char <= "H") ||
          (char >= "J" && char <= "N") ||
          (char >= "P" && char <= "Z") ||
          (char >= "a" && char <= "k") ||
          (char >= "m" && char <= "z");

        if (!isValidBase58Char) {
          revert NotCIDv0();
        }
      }
      return true;
    }
    revert NotCIDv0();
  }

  function isCIDv1(string memory hash) public pure returns (bool) {
    bytes memory b = bytes(hash);

    // Check if it starts with 'b' for Base32 encoding of CIDv1
    if (b[0] != bytes1("b")) {
      revert NotCIDv1();
    }

    // Base32 character set check for the rest of the hash
    for (uint i = 1; i < b.length; i++) {
      if ((b[i] < "2" || b[i] > "7") && (b[i] < "a" || b[i] > "z")) {
        revert NotCIDv1();
      }
    }

    return true;
  }
}
