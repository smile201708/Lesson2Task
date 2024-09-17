// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

/**
发行NFT
*/
contract MyNFT is ERC721, Ownable {
    uint256 public tokenCounter;

    constructor() ERC721("MyFirstNFT", "NFT") Ownable(msg.sender) { // 传递msg.sender给Ownable构造函数
        tokenCounter = 0;
    }

    function createNFT(address recipient) public onlyOwner {
        _safeMint(recipient, tokenCounter);
        tokenCounter += 1;
    }

    function batchCreateNFT(address[] memory recipients) public onlyOwner {
        for (uint256 i = 0; i < recipients.length; i++) {
            createNFT(recipients[i]);
        }
    }
}
