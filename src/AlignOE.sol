// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.19;

import "solmate/src/tokens/ERC721.sol";
import "openzeppelin-solidity/utils/Strings.sol";
import "openzeppelin-solidity/access/Ownable.sol";

error MintPriceNotPaid();
error MaxSupply();
error NonExistentTokenURI();
error WithdrawTransfer();

contract AlignOENFT is ERC721, Ownable {
  using Strings for uint256;

  string public baseURI;
  uint256 public _totalSupply;
  uint256 public constant MINT_PRICE = 0.1 ether;

  // Mapping to track the number of NFTs minted by each address
  mapping(address => uint256) public mintedCount;

  constructor(string memory _name, string memory _symbol, string memory _baseURI) ERC721(_name, _symbol) Ownable() {
    baseURI = _baseURI;
  }

  function mintTo(address recipient) external payable returns (uint256) {
    if (msg.value != MINT_PRICE) {
      revert MintPriceNotPaid();
    }

    _safeMint(recipient, _totalSupply);
    // Increment the count of NFTs minted by the recipient
    mintedCount[recipient]++;
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

  function withdrawPayments(address payable payee) external onlyOwner {
    uint256 balance = address(this).balance;
    payable(payee).transfer(balance);
  }

  function totalSupply() public view returns (uint256) {
    return _totalSupply;
  }

  // Function to check if an address has minted an NFT
  function hasMinted(address _address) public view returns (uint256) {
    return mintedCount[_address] > 0 ? mintedCount[_address] : 0;
  }
}
