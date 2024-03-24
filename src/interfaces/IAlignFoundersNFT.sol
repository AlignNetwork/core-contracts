// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

interface IAlignFoundersNFT {
  // Function to set the Merkle root for the whitelist minting
  function setMerkleRoot(bytes32 _merkleRoot) external;

  // Function to enable public minting
  function enablePublicMint() external;

  // Function for whitelisted addresses to mint an NFT
  function whitelistMint(bytes32[] calldata _merkleProof) external payable;

  // Function for public minting of an NFT
  function publicMint() external payable returns (uint256);

  // Function to set the base URI for all token IDs
  function setBaseURI(string memory newBaseURI) external;

  // Function to withdraw the contract balance to the owner's address
  function withdraw() external;

  // Function to get the total supply of minted NFTs
  function totalSupply() external view returns (uint256);

  // Function to get the token URI of a specific token ID
  function tokenURI(uint256 tokenId) external view returns (string memory);

  // Event emitted when public minting is enabled
  event PublicMintEnabled();

  /**
   * @dev Returns the owner of the `tokenId` token.
   *
   * Requirements:
   *
   * - `tokenId` must exist.
   */
  function ownerOf(uint256 tokenId) external view returns (address owner);

  /**
   * @dev Transfers `tokenId` token from `from` to `to`.
   *
   * WARNING: Note that the caller is responsible to confirm that the recipient is capable of receiving ERC721
   * or else they may be permanently lost. Usage of {safeTransferFrom} prevents loss, though the caller must
   * understand this adds an external call which potentially creates a reentrancy vulnerability.
   *
   * Requirements:
   *
   * - `from` cannot be the zero address.
   * - `to` cannot be the zero address.
   * - `tokenId` token must be owned by `from`.
   * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
   *
   * Emits a {Transfer} event.
   */
  function transferFrom(address from, address to, uint256 tokenId) external;
}
