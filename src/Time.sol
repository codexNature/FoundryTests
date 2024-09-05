//SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract Auction {
    uint256 public startAt = block.timestamp + 1 days;
    uint256 public endAt = block.timestamp + 2 days;

    error CannotBid();
    error CannotEnd();

    function bid() external view {
        if (!(block.timestamp >= startAt && block.timestamp <= endAt)) {
            revert CannotBid();
        }
        //require(block.timestamp >= startAt && block.timestamp <= endAt);
        //revert CannotBid();
    }

    function end() external view {
        if (!(block.timestamp <= endAt)) {
            revert CannotEnd();
        }
    }
}
