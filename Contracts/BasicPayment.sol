// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.7;

contract MyContract {
    address public lastSender;
    uint256 public lastAmount;
    uint256 public lastGas;


    function pay(address payable addr) public payable {
        (bool sent, bytes memory data) = addr.call{value: 1 ether}("");
        require(sent, "Error sending ETH.");
    }

   function recieve() external payable {
       lastSender = msg.sender;
       lastAmount = msg.value;
       lastGas = gasleft();
   }

   function getBalance() public view returns (uint256) {
       return address(this).balance;
   }
   
}