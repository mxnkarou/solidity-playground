// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.7;

contract Auction {
    // Create an ommitable event.
    event Start();
    // Create an event that sends the highest bidder & highest bid.
    event End(address highestBidder, uint256 highestBid);
    // Create an indexable/searchable Event
    event Bid(address indexed sender, uint256 amount);
    event Withdraw(address indexed bidder, uint256 amount);

    // Defining initial variables.
    address payable public seller;
    bool public started;
    bool public ended;
    uint256 public endAt;
    uint256 public highestBid;
    address public highestBidder;
    // Create a map of all adresses & their bids - to later withdraw money if outbid.
    mapping(address => uint) public bids;

    constructor() {
        // Assign sender to the person creating the auction.
        seller = payable(msg.sender);
    }

    // Start auction (From outside the contract only).
    function start(uint256 startingBid) external {
        // Verify that the auction has not already been started.
        require(started == false, "Already started!");
        // Verify that the transaction sender is indeed the seller.
        require(msg.sender == seller, "You did not start the auction.");
        started = true;
        // Set the endAt date to 1 week after the block with this transaction has been mined.
        endAt = block.timestamp + 7 days;
        // Initialize the highestBid with the startingBid.
        highestBid = startingBid;
        // Emit the start event.
        emit Start();
    }

    function end() external {
        // Require that the Auction has been started.
        require(started, "Auction has not started.");
        // Require that the endAt time has passed.
        require(block.timestamp >= endAt, "Auction has not ended yet.");
        // Require that the Auction hasn't been ended already.
        require(!ended, "Auction already ended.");
        // Set ended to true.
        ended = true;
        // Emit the End Event.
        emit End(highestBidder, highestBid);
    }


     function bid() external payable {
        require(started, "Auction has not started.");
        require(block.timestamp < endAt, "Auction has ended.");
        require(msg.value > highestBid, "Bid too low.");

        // If the previous highest Bidder is not the default address. (0x0000000...)
        if (highestBidder != address(0)) {
            // Add the previous highest Bid to the Balance of the previous highest Bidder.
            bids[highestBidder] += highestBid;
        }

        // Assign the new highest Bid & Bidder.
        highestBidder = msg.sender;
        highestBid = msg.value;
        
        emit Bid(highestBidder, highestBid);
    }

    function withdraw() external payable {
        uint bal = bids[msg.sender];
        bids[msg.sender] = 0;
        (bool sent, bytes memory data) = payable(msg.sender).call(value: bal)("");
        require(sent, "Withdrawl failed.");

        emit Withdraw(msg.sender, bal);
    }
}
