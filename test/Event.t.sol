// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Test, console} from "forge-std/Test.sol";
import {Event} from "../src/Event.sol";

contract EventTest is Test {
    Event public evnt;

    event Transfer(address indexed from, address indexed to, uint256 amount);

    function setUp() public {
        evnt = new Event();
    }

    function testEmitTransferEvent() public {
        //1. Tell foundry which data to check
        vm.expectEmit(true, true, false, true); // true for indexed data, false for amount(not indexed and true for thr remainder of data.)

        //2 Emit the expected event
        /*@>*/
        emit Transfer(address(this), address(123), 666);

        //3 call the function that should emit the event
        /*@>*/
        evnt.transfer(address(this), address(123), 666);

        // Check for only index 1
        vm.expectEmit(true, false, false, false);
        /*@>*/
        emit Transfer(address(this), address(123), 666);
        /*@>*/
        evnt.transfer(address(this), address(124), 665); //this passed because we are checking just for the 1st index data. no assert because we are comparing the two lines with /*@>*/
    }

    function testEmitManyTransferEvent() public {
        address[] memory to = new address[](3);
        to[0] = address(123);
        to[1] = address(456);
        to[2] = address(789);

        uint256[] memory amounts = new uint256[](3);
        amounts[0] = 666;
        amounts[1] = 777;
        amounts[2] = 888;

        for (uint256 i; i < to.length; i++) {
            //1. Tell foundry which data to check
            //2 Emit the expected event
            vm.expectEmit(true, true, false, true);
            emit Transfer(address(this), to[i], amounts[i]);
        }
        //3 call the function that should emit the event
        evnt.transferMany(address(this), to, amounts);
    }
}
