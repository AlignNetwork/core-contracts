// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.19;

import { PRBTest } from "@prb/test/src/PRBTest.sol";
import "../src/AlignNFT.sol";

contract AlignedNFTTest is PRBTest {

    AlignTesterNFT private nft;

    function setUp() public {
        // Deploy NFT contract
        nft = new AlignTesterNFT("NFT_tutorial", "TUT", "baseUri");
    }

    function test_RevertMintWithoutValue() public {
        vm.expectRevert(MintPriceNotPaid.selector);
        nft.mintTo(address(1));
    }

    function test_MintPricePaid() public {
        nft.mintTo{value: 0.01 ether}(address(1));
    }


    function test_RevertMintToZeroAddress() public {
        vm.expectRevert("INVALID_RECIPIENT");
        nft.mintTo{value: 0.01 ether}(address(0));
    }




    function test_RevertUnSafeContractReceiver() public {
        // Adress set to 11, because first 10 addresses are restricted for precompiles
        vm.etch(address(11), bytes("mock code"));
        vm.expectRevert(bytes(""));
        nft.mintTo{value: 0.01 ether}(address(11));
    }

    function test_WithdrawalWorksAsOwner() public {
        // Mint an NFT, sending eth to the contract
        Receiver receiver = new Receiver();
        address payable payee = payable(address(0x1337));
        uint256 priorPayeeBalance = payee.balance;
        nft.mintTo{value: nft.MINT_PRICE()}(address(receiver));
        // Check that the balance of the contract is correct
        assertEq(address(nft).balance, nft.MINT_PRICE());
        uint256 nftBalance = address(nft).balance;
        // Withdraw the balance and assert it was transferred
        nft.withdrawPayments(payee);
        assertEq(payee.balance, priorPayeeBalance + nftBalance);
    }

    function test_RevertIf_WithdrawalAsNotOwner() public {
        // Mint an NFT, sending eth to the contract
        Receiver receiver = new Receiver();
        nft.mintTo{value: nft.MINT_PRICE()}(address(receiver));
        // Check that the balance of the contract is correct
        assertEq(address(nft).balance, nft.MINT_PRICE());
        // Confirm that a non-owner cannot withdraw
        vm.startPrank(address(0xd3ad));
        vm.expectRevert("Ownable: caller is not the owner");
        nft.withdrawPayments(payable(address(0xd3ad)));
        vm.stopPrank();
    }

    function test_setBaseURI() public {
        nft.mintTo{value: 0.01 ether}(address(1));
        nft.setBaseURI("https://nft.storage/");
        assertEq(nft.baseURI(), "https://nft.storage/");
        // return token 1 tokenURI
        assertEq(nft.tokenURI(1), "https://nft.storage/1");
    }

    function test_mintOne() public {
        nft.mintTo{value: 0.01 ether}(address(1));
        assertEq(nft.balanceOf(address(1)), 1);
        assertEq(nft.ownerOf(1), address(1));
    }

    function test_WithdrawOwner() public {
        nft.mintTo{value: 0.01 ether}(address(1));
        uint256 balance = address(nft).balance;
        nft.withdrawPayments(payable(address(1)));
        assertEq(address(nft).balance, 0);
        assertEq(address(1).balance, balance);
    }

    function test_RevertWithdrawNotOwner() public {
        nft.mintTo{value: 0.01 ether}(address(1));
        vm.startPrank(address(0xd3ad));
        vm.expectRevert("Ownable: caller is not the owner");
        nft.withdrawPayments(payable(address(0xd3ad)));
        vm.stopPrank();
    }

    function test_TransferOwnable() public {
        nft.transferOwnership(address(1));
        assertEq(nft.owner(), address(1));
    }

}

contract Receiver is ERC721TokenReceiver {
    function onERC721Received(
        address operator,
        address from,
        uint256 id,
        bytes calldata data
    ) external override returns (bytes4) {
        return this.onERC721Received.selector;
    }
}