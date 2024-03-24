// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

interface IAlignNFTStaking {
  // Function to allow the owner to stake a token on behalf of a user.
  function stakeFor(address nftOwner, uint256 id) external;

  // Function to allow users to stake their own tokens.
  function stake(uint256 id) external;

  // Function for users to unstake their tokens.
  function unstake(uint256 id) external;

  /// @notice Get staked amount (tokedn quantity)
  /// @param owner - owner address
  /// @return staked token quantity
  function getStakedAmount(address owner) external view returns (uint256);

  /// @notice Get array of staked ids
  /// @param owner - owner address
  /// @return uint256[] - array of staked token ids
  function getStakedIds(address owner) external view returns (uint256[] memory);
}
