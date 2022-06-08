//SPDX-License-Identifier: MIT
pragma solidity 0.8.7;

contract SimpleAuction {
    address payable public beneficiary;
    uint public auctionEndTime;
    address public highestBidder;
    uint public highestBid;
    mapping(address => uint) public refundBid;

    bool ended;

    event BidIncreased(address _bidder, uint _bidAmount);
    event AuctionEnded(address _winner, uint _bidAmount);

    error AuctionAlreadyEnded();
    error BidValueNotEnough(uint amount);
    error AuctionEndAlreadyCalled();
    error AuctionNotYetEnded();

    constructor(address payable _beneficiary, uint _auctionEndTime) public {
        beneficiary = _beneficiary;
        auctionEndTime = block.timestamp + _auctionEndTime; 
    }

    function bid() public payable {
        // require(block.timestamp < auctionEndTime, "Auction Already Ended");
        if (block.timestamp > auctionEndTime) {
            revert AuctionAlreadyEnded();
        }

        // require(msg.value > highestBid, "Bid value is less than current Highest Bid");
        if (msg.value <= highestBid) {
            revert BidValueNotEnough(msg.value);
        }

        if (highestBid != 0) {
            refundBid[highestBidder] += highestBid;
        }
        highestBidder = msg.sender;
        highestBid = msg.value;
        emit BidIncreased(msg.sender, msg.value);
    }

    function withdraw() external returns(bool){
        uint amount = refundBid[msg.sender];
        
        if (amount > 0) {
            refundBid[msg.sender] = 0;

            if (!payable(msg.sender).send(amount)) {
                refundBid[msg.sender] = amount;
                return false;
            }
        }
        return true;
        
    }

    function auctionEnd() external {
        // require(block.timestamp > auctionEndTime, "Auction Not Yet Ended");
        if (block.timestamp < auctionEndTime) {
            revert AuctionNotYetEnded();
        }
        // require(!ended, "Auction End Already Called!");
        if (ended) {
            revert AuctionEndAlreadyCalled();
        }
        ended = true;

        emit AuctionEnded(highestBidder, highestBid);
        beneficiary.transfer(highestBid);
    }
}