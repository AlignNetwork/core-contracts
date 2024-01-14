// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.19;

import "solmate/src/tokens/ERC721.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

error MintPriceNotPaid();
error MaxSupply();
error NonExistentTokenURI();
error WithdrawTransfer();

contract AlignTesterNFT is ERC721, Ownable {
    using Strings for uint256;

    string public baseURI;
    uint256 public _totalSupply;
    uint256 public constant MAX_SUPPLY = 10000;
    uint256 public constant MINT_PRICE = 0.025 ether;



    constructor(
        string memory _name,
        string memory _symbol,
        string memory _baseURI
    )
        ERC721(_name, _symbol)
        Ownable()
    {
        baseURI = _baseURI;
    }

    function mintTo(address recipient) external payable returns (uint256) {
        if (msg.value != MINT_PRICE) {
            revert MintPriceNotPaid();
        }
         
        if (_totalSupply >= MAX_SUPPLY) {
            revert MaxSupply();
        }
        _safeMint(recipient, _totalSupply);
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
}