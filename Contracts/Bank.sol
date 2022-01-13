// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.7;

contract Bank {
    // Associate addresses with their balance - made "private" so no getter function is automatically created.
    mapping(address => uint256) private balances;

    // "Payable" - since we're recieving ETH. "External" so the function can only be called outside the contract.
    function deposit() external payable {
        // Increase the current balance of the sender by the transaction value.
        balances[msg.sender] += msg.value;
    }

    // Withdrawl function takes an payable address & a withdrawl amount.
    // Function has to be called from outside - hence "public" - and since we're sending/recieving ETH - "payable".
    function withdraw(address payable addr, uint256 amount) public payable {
        // Require that the given addr has enough ETH to send.
        require(balances[addr] >= amount, "Insufficient funds!");
        // Send the ETH. (safe method)
        (bool sent, bytes memory data) = addr.call{value: amount}("");
        // Require that the transaction was sent succesfully.
        require(sent, "Withdrawl failed!");
        // Deduct the sent amount from the balance of sender.
        balances[msg.sender] -= amount;
    }

    // "Public" - we are calling this function from outside.
    // "View" - we are not modifying data - only viewing it.
    // Returns the balance - which is an uint256.
    function getBalance() public view returns (uint256) {
        // Returns the balance of this Contract.
        return address(this).balance;
    }
}