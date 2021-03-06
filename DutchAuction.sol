//SPDX-License-Identifier: MIT
pragma solidity 0.8.7;

interface IERC721 {
    function transferFrom(address _from, address _to, uint _nftId) external;
}

contract DutchAuction {
    uint private constant DURATION = 7 days;
    IERC721 public immutable nft; 
    uint public immutable nftId;
    address payable public immutable seller;
    uint public immutable startPrice;
    uint public immutable startAt;
    uint public immutable expiresAt;
    uint public immutable discountRate;

    constructor(uint _startPrice, uint _discountRate, address _nft, uint _nftId) {
        seller = payable(msg.sender);
        startPrice = _startPrice;
        discountRate = _discountRate;
        startAt = block.timestamp;
        expiresAt = block.timestamp + DURATION;

        require(_startPrice >= _discountRate * DURATION, "Starting Price < discount");

        nft = IERC721(_nft);
        nftId = _nftId;
    }

    function getPrice() public view returns(uint) {
        uint timeElapsed = block.timestamp - startAt;
        uint discount = discountRate * timeElapsed;
        return startPrice - discount;
    }

    function buyNft() external payable {
        require(block.timestamp < expiresAt, "auction ended");

        uint price = getPrice();
        require(msg.value >= price, "ETH < price");

        nft.transferFrom(seller, msg.sender, nftId);
        uint refund = price - msg.value;
        if (refund > 0) {
            payable(msg.sender).transfer(refund);
        } 
        selfdestruct(seller);
    }
}