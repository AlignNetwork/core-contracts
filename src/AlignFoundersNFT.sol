// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.19;

import "solmate/src/tokens/ERC721.sol";
import "openzeppelin-solidity/utils/Strings.sol";
import "openzeppelin-solidity/access/Ownable.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "@openzeppelin/contracts/utils/cryptography/MerkleProof.sol";
import "./interfaces/IAlignNFTStaking.sol";

error MintPriceNotPaid();
error MaxSupply();
error NonExistentTokenURI();
error WithdrawTransfer();
error PublicMintingNotEnabled();

contract AlignFoundersNFT is ERC721, Ownable, ReentrancyGuard {
  using Strings for uint256;

  event PublicMintEnabled();

  string public baseURI;
  uint256 public _totalSupply;
  uint256 public constant MAX_SUPPLY = 10000;
  uint256 public constant MINT_PRICE = 0.15 ether;

  bytes32 public merkleRoot;
  uint256 public mintStartTime;
  bool public isPublicMintEnabled = false;
  // Mapping to keep track of which addresses have minted
  mapping(address => bool) public hasMinted;

  IAlignNFTStaking public staker;

  constructor(
    string memory _name,
    string memory _symbol,
    string memory _baseURI,
    bytes32 _merkleRoot
  ) ERC721(_name, _symbol) Ownable() {
    baseURI = _baseURI;
    merkleRoot = _merkleRoot;
  }

  // Set the Merkle Root
  function setMerkleRoot(bytes32 _merkleRoot) external onlyOwner {
    merkleRoot = _merkleRoot;
  }

  function setStaker(address _staker) external onlyOwner {
    staker = IAlignNFTStaking(_staker);
  }

  // Enable public minting
  function enablePublicMint() external onlyOwner {
    isPublicMintEnabled = true;
    emit PublicMintEnabled();
  }

  function setMintStartTime(uint256 timestamp) external onlyOwner {
    mintStartTime = timestamp;
  }

  // Whitelisted minting
  function whitelistMint(bytes32[] calldata _merkleProof) external payable nonReentrant {
    require(block.timestamp < mintStartTime + 24 hours, "Whitelist minting period is over");
    require(!hasMinted[msg.sender], "Address has already minted");
    require(msg.value >= MINT_PRICE, "Ether sent is not correct");

    // Verify the merkle proof.
    bytes32 leaf = keccak256(abi.encodePacked(msg.sender));
    require(MerkleProof.verify(_merkleProof, merkleRoot, leaf), "Invalid proof.");

    // Mint NFT
    _safeMint(address(staker), _totalSupply);
    staker.stakeFor(msg.sender, _totalSupply);
    _totalSupply++;
    hasMinted[msg.sender] = true;
  }

  function publicMint() external payable returns (uint256) {
    if (isPublicMintEnabled || block.timestamp >= mintStartTime + 24 hours) revert PublicMintingNotEnabled();
    if (msg.value != MINT_PRICE) revert MintPriceNotPaid();
    if (_totalSupply >= MAX_SUPPLY) revert MaxSupply();

    _safeMint(msg.sender, _totalSupply);
    _totalSupply++;
    return _totalSupply;
  }

  function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
    if (ownerOf(tokenId) == address(0)) {
      revert NonExistentTokenURI();
    }
    return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
  }

  function setBaseURI(string memory newBaseURI) external onlyOwner {
    baseURI = newBaseURI;
  }

  function withdraw() external onlyOwner {
    uint256 balance = address(this).balance;
    payable(owner()).transfer(balance);
  }

  function totalSupply() public view returns (uint256) {
    return _totalSupply;
  }
}
