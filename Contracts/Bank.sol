// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.7;

contract Bank {
    // Associate addresses with their balance - made "private" so this can only be called from within the contract.
    // -- uint256 default value is 0.
    mapping(address => uint256) private balances;

    // "Payable" - since we're sending/recieving ETH. "External" so the function can only be called outside the contract.
    function deposit() external payable {
        // Increase the current balance of the sender by the transaction value.
        // msg.sender is the address of the invoker.
        // msg.value is the transaction value.
        balances[msg.sender] += msg.value;
    }

    // Withdrawl function takes an payable address & a withdrawl amount.
    // Function has to be called from anywhere - hence "public" - and since we're sending/recieving ETH - "payable".
    function withdraw(address payable addr, uint256 amount) public payable {
        // Require that the given addr has enough ETH to send - else cancels & reverts the contract call & returns an error message.
        require(balances[addr] >= amount, "Insufficient funds!");
        // Send the ETH. (safe method)
        (bool sent, bytes memory data) = addr.call{value: amount}("");
        // Require that the transaction was sent succesfully.
        require(sent, "Withdrawl failed!");
        // Deduct the sent amount from the balance of sender.
        balances[msg.sender] -= amount;
    }

    // "Public" - we are calling this function from outside.
    // "View" - we are not modifying state data - only viewing it. (View functions are free)
    // Returns the balance - which is an uint256.
    function getBalance() public view returns (uint256) {
        // Returns the balance of this Contract.
        // this = Contract.
        return address(this).balance;
    }
}
