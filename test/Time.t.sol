//SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Test, console} from "forge-std/Test.sol";
import {Auction} from "../src/Time.sol";

contract TimeTest is Test {
    Auction public auction;
    uint256 private startAt;

    // vm.warp  set block.timestamp to future timestamp
    // vm.roll  set block.number
    // skip  increment current timestamp
    // rewind  decrement current timestamp

    function setUp() public {
        auction = new Auction();
        startAt = block.timestamp;
    }

    function testBidFailsBeforeStartTime() public {
        vm.expectRevert(Auction.CannotBid.selector);
        auction.bid();
    }

    function testBid() public {
        vm.warp(startAt + 1 days);
        auction.bid();
    }

    function testFailBidEnded() public {
        vm.expectRevert(Auction.CannotBid.selector);
        vm.warp(startAt + 2 days);
        auction.bid();
    }

    function testTimestamp() public {
        uint256 t = block.timestamp;
        // skip  increment current timestamp
        skip(100);
        assertEq(block.timestamp, t + 100);
        // rewind  decrement current timestamp
        rewind(50);
        assertEq(block.timestamp, t + 100 - 50);
    }

    function testBlockNumber() public {
        // vm.roll  set block.number
        //uint256 b = block.number;
        // set block number to 999
        vm.roll(999);
        assertEq(block.number, 999);
    }
}


contract LibLenderStatusTest is Test {
    using LibLenderStatus for LenderStatus;
    using LibRoleProvider for RoleProvider;

    LenderStatus status;
    RoleProvider provider;

    uint256 public timestamp;

    function setUp() public {
        //timestamp = block.timestamp;
    }

    function testFailTimestampEquality() public {
        // Define a timestamp within the range of uint32
        uint256 timestamp = 2 ** 32 - 1; // Maximum value for uint32
        uint32 expectedTimestamp = uint32(timestamp); // Cast to uint32 for expected value

        // Call the setCredential function using the instantiated provider
        status.setCredential(provider, timestamp); // Use the library function on the struct

        console.log("Status.lastApprovalTimestamp", status.lastApprovalTimestamp);
        console.log("Args Timestamp", timestamp);
        // Assert if the status.lastApprovalTimestamp is equal to uint32(timestamp)
        assertEq(status.lastApprovalTimestamp, timestamp, "Timestamp does not match uint32 conversion");
    }

    function testTimestampOverflow() public {
        // Define a timestamp outside the range of uint32
        uint256 timestamp = 2 ** 32; // Just above the maximum uint32 value

        // Expected behavior: uint32(timestamp) should wrap around (i.e., result in 0)
        uint32 expectedTimestamp = uint32(timestamp); // This will be 0 due to overflow

        // Explicitly cast MockRoleProvider to RoleProvider
        //RoleProvider provider = RoleProvider(address(new MockRoleProvider()));

        // Call the library function with mocked data
        status.setCredential(provider, timestamp);

        console.log("Status.lastApprovalTimestamp", status.lastApprovalTimestamp);
        console.log("Expected Timestamp", expectedTimestamp);
        // Assert that the downcast resulted in the expected value
        assertEq(
            status.lastApprovalTimestamp,
            expectedTimestamp,
            "Timestamp conversion does not match expected overflow behavior"
        );
    }
}
