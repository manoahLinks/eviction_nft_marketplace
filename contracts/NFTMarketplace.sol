// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

import "./erc721.sol";

contract NFTMarketplace {

    // state variables
    address owner;
    uint256 private _itemIds = 1;
    uint256 constant listingPrice = 0.0002 ether;

    // marketItem
     struct MarketItem {
        uint256 itemId;
        address nftContract;
        uint256 tokenId;
        address payable seller;
        address payable owner;
        uint256 price;
        bool isSold;
    }

    mapping(uint256 => MarketItem) marketItems;

    // events
    event MarketItemCreated(
        uint256 indexed itemId,
        address indexed nftContract,
        uint256 indexed tokenId,
        address seller,
        address owner,
        uint256 price,
        bool sold
    );

    constructor() {
        owner = payable(msg.sender);
    }

    // modifiesa
    modifier onlyOwner {
        require (msg.sender == owner, "Only owner can call this function");
        _;
    }

    // list Nft for sale
    function listItemForSale (address _nftcontract,uint256 _tokenId, uint256 _price) external payable {

        require(_price > 0, "amount must be greater than zero");
        require(msg.value == listingPrice, "not listing price");
        
        MarketItem memory new_market_item = marketItems[_itemIds];
        new_market_item.itemId = _itemIds;
        new_market_item.nftContract = _nftcontract;
        new_market_item.tokenId = _tokenId;
        new_market_item.seller = payable(msg.sender);
        new_market_item.owner = payable(address(0));
        new_market_item.price = _price;
        new_market_item.isSold = false;

        // emit event
        emit MarketItemCreated(
            _itemIds,
            _nftcontract,
            _tokenId,
            msg.sender,
            address(0),
            _price,
            false
        );


        _itemIds++;
    }
}