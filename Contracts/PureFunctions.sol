// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.7;

contract PureFunction {
    // A pure function is a function that does not do anything with the contract state.
    // Only does computations & returns a value.

    function multiply(uint256 x, uint256 y) public pure returns (uint256) {
        return x * y;
    }
    
}
