// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

// Declaration of the contract
contract HelloWorld {
    // State variable to store a greeting
    string private greeting;

    // Function to set the greeting
    function setGreeting(string memory _greeting) public {
        greeting = _greeting;
    }

    // Function to get the current greeting
    function getGreeting() public view returns (string memory) {
        return greeting;
    }
}
