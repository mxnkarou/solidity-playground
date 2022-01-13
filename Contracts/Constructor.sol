// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.7;

contract Constructor {
    address public owner;
    uint256 public variable;

    // Constructors are only called once when the contract is initialized.
    // They can take variables which will have to be passed in when deploying.
    constructor (uint256 test) {
        // Assign the contract owner variable to the contract deployer.
        owner = msg.sender;
        // Assign the passed in variable.
        variable = test;
    }
}
