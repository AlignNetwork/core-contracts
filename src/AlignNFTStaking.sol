// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.19;

import "solmate/src/tokens/ERC721.sol";
import "openzeppelin-solidity/access/Ownable.sol";
import "openzeppelin-solidity/token/ERC721/utils/ERC721Holder.sol";
import "./interfaces/IAlignFoundersNFT.sol";
import "openzeppelin-solidity/token/ERC721/IERC721Receiver.sol";

error NotOwner();
error MintingInProgress();
error StakedIndexNotFound(uint256 id);

contract AlignNFTStaking is Ownable, IERC721Receiver {
  IAlignFoundersNFT public nft;

  struct StakerInfo {
    uint256[] stakedTokenIds;
    mapping(uint256 => uint256) stakeTime;
  }

  mapping(address => StakerInfo) stakers;

  event Staked(address indexed staker, uint256 indexed id, uint256 timestamp);
  event Unstaked(address indexed staker, uint256 indexed id, uint256 timestamp);

  constructor(address _nft) {
    nft = IAlignFoundersNFT(_nft);
  }

  function stakeFor(address nftOwner, uint256 id) external onlyOwner {
    stakers[nftOwner].stakedTokenIds.push(id);
    stakers[nftOwner].stakeTime[id] = block.timestamp;
    emit Staked(nftOwner, id, block.timestamp);
  }

  function stake(uint256 id) external {
    if (nft.ownerOf(id) != address(msg.sender)) revert NotOwner();
    stakers[msg.sender].stakedTokenIds.push(id);
    stakers[msg.sender].stakeTime[id] = block.timestamp;
    nft.transferFrom(msg.sender, address(this), id);

    emit Staked(msg.sender, id, block.timestamp);
  }

  function unstake(uint256 id) external {
    if (nft.totalSupply() < 10_000) revert MintingInProgress();
    uint256 index = getStakedIndex(id);
    deleteStakedId(index);
    stakers[msg.sender].stakeTime[id] = 0;
    nft.transferFrom(address(this), msg.sender, id);
    emit Unstaked(msg.sender, id, block.timestamp);
  }

  function getStakedIndex(uint256 id) private view returns (uint256 i) {
    uint256[] memory stakedTokenIds = stakers[msg.sender].stakedTokenIds;
    for (i = 0; i < stakedTokenIds.length; i++) {
      if (stakedTokenIds[i] == id) return i;
    }
    revert StakedIndexNotFound(id);
  }

  function deleteStakedId(uint256 index) internal {
    uint256 len = stakers[msg.sender].stakedTokenIds.length;
    stakers[msg.sender].stakedTokenIds[index] = stakers[msg.sender].stakedTokenIds[len - 1];
    stakers[msg.sender].stakedTokenIds.pop();
  }

  /// @notice Get staked amount (tokedn quantity)
  /// @param owner - owner address
  /// @return staked token quantity
  function getStakedAmount(address owner) external view returns (uint256) {
    return stakers[owner].stakedTokenIds.length;
  }

  /// @notice Get array of staked ids
  /// @param owner - owner address
  /// @return uint256[] - array of staked token ids
  function getStakedIds(address owner) external view returns (uint256[] memory) {
    return stakers[owner].stakedTokenIds;
  }

  function onERC721Received(address, address, uint256, bytes calldata) external pure override returns (bytes4) {
    return this.onERC721Received.selector;
  }
}
