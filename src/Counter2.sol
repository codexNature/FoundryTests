// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract Counter2 {
    uint256 public count;

    // Function to get the current count
    function get() public view returns (uint256) {
        return count;
    }

    // Function to increamanr count by 1
    function inc() public {
        count++;
    }

    //Function to decreament counr by 1
    function dec() public {
        //This function will fail if count = 0, it will only pass if we call inc before calling dec cuz count is initialised to 0.
        count--;
    }
}
