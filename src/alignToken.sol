// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.19;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract ATestnetAVS is ERC20, Ownable {
    constructor() ERC20("ATestnetAVS", "ATAVS") {
        _mint(msg.sender, 1_000_000 * 10 ** 18); // Minting initial supply
    }

    function mint(address to, uint256 amount) public onlyOwner {
        _mint(to, amount);
    }
}
