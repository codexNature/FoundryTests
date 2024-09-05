// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.19;

import {Test, console} from "forge-std/Test.sol";
import {Counter2} from "../src/Counter2.sol";

contract Counter2Test is Test {
    Counter2 public counter;

    function setUp() public {
        counter = new Counter2();
    }

    function testInc() public {
        counter.inc();
        assertEq(counter.count(), 1);
    }

    function testFailDec() public {
        counter.dec();
        //assertEq(counter.count(), 0);
    }

    function testUnderflow() public {
        vm.expectRevert();
        counter.dec();
    }

    function testDec() public {
        counter.inc();
        counter.inc();
        counter.dec();
        assertEq(counter.count(), 1);
    }
}
