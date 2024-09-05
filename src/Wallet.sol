// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract Wallet {
    address payable public owner;

    constructor() payable {
        owner = payable(msg.sender);
    }

    receive() external payable {} //anyone can deposit into the contract.

    error NotOwner();

    function withdraw(uint256 _amount) external {
        if (owner != msg.sender) revert NotOwner();
        //require(msg.sender == owner, "caller is not owner");
        payable(msg.sender).transfer(_amount);
    }

    function setOwner(address _owner) external {
        if (owner != msg.sender) revert NotOwner();
        //require(msg.sender == owner, "caller is not owner");
        owner = payable(_owner);
    }
}
