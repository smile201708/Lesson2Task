// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/IERC721.sol";

contract NFTSwap {
    struct Order {
        IERC721 nftContract;
        uint256 tokenId;
        address payable seller;
        uint256 price;
        bool sold;
    }

    mapping(uint256 => Order) public orders;
    mapping(uint256 => bool) public orderExists; // 用于跟踪订单是否存在

    event Listed(address indexed seller, uint256 indexed tokenId, uint256 price);
    event Revoked(address indexed seller, uint256 indexed tokenId);
    event Updated(address indexed seller, uint256 indexed tokenId, uint256 newPrice);
    event Purchased(address indexed buyer, uint256 indexed tokenId, uint256 price);

    function list(IERC721 nftContract, uint256 tokenId, uint256 price) public {
        require(nftContract.ownerOf(tokenId) == msg.sender, "Not the owner");
        require(price > 0, "Price must be greater than 0");
        require(!orderExists[tokenId], "Order already exists");

        nftContract.transferFrom(msg.sender, address(this), tokenId);

        orders[tokenId] = Order({
            nftContract: nftContract,
            tokenId: tokenId,
            seller: payable(msg.sender),
            price: price,
            sold: false
        });

        orderExists[tokenId] = true; // 标记订单为存在

        emit Listed(msg.sender, tokenId, price);
    }

    function revoke(uint256 tokenId) public {
        Order storage order = orders[tokenId];
        require(order.seller == msg.sender, "Not the seller");
        require(!order.sold, "Order already sold");

        order.nftContract.transferFrom(address(this), msg.sender, tokenId);

        delete orders[tokenId];
        orderExists[tokenId] = false; // 标记订单为不存在

        emit Revoked(msg.sender, tokenId);
    }

    function update(uint256 tokenId, uint256 newPrice) public {
        Order storage order = orders[tokenId];
        require(order.seller == msg.sender, "Not the seller");
        require(!order.sold, "Order already sold");

        order.price = newPrice;

        emit Updated(msg.sender, tokenId, newPrice);
    }

    function purchase(uint256 tokenId) public payable {
        Order storage order = orders[tokenId];
        require(!order.sold, "Order already sold");
        require(msg.value >= order.price, "Not enough ether sent");

        order.seller.transfer(msg.value);

        order.nftContract.transferFrom(address(this), msg.sender, tokenId);

        order.sold = true;

        emit Purchased(msg.sender, tokenId, msg.value);
    }
}
