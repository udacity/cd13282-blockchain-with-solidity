// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

// Importing OpenZeppelin's SafeMath library for demonstration
// import "@openzeppelin/contracts/utils/math/SafeMath.sol";

contract MyFirstContract {
    // Using SafeMath for uint256 for demonstration
    // using SafeMath for uint256;

    uint public myFavoriteNumber = 5;

    // A simple function to change the value of myNumber
    function setMyFavoriteNumber(uint _newFavoriteNumber) public {
        myFavoriteNumber = _newFavoriteNumber;
    }

    // A function to retrieve the value of myNumber
    function getMyFavoriteNumber() public view returns (uint) {
        return myFavoriteNumber;
    }
}
