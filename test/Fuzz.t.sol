//SPDX-License-Identifier:MIT
pragma solidity ^0.8.19;

import {Test, console} from "forge-std/Test.sol";
import {Bit} from "../src/Bit.sol";

contract FuzzTest is Test {
    Bit public b;

    function setUp() public {
        b = new Bit();
    }

    function mostSignificantBit(uint256 x) private pure returns (uint256) {
        uint256 i = 0;
        while ((x >>= 1) > 0) {
            i++;
        }
        return i;
    }

    function testMostSignificanrBitManual() public view {
        assertEq(b.mostSignificantBit(0), 0);
        assertEq(b.mostSignificantBit(1), 0);
        assertEq(b.mostSignificantBit(2), 1);
        assertEq(b.mostSignificantBit(4), 2);
        assertEq(b.mostSignificantBit(8), 3);
        assertEq(b.mostSignificantBit(0), 0);
    }

    // function testMostSignificantBitFuzz(uint256 x) public view {
    //   uint i = b.mostSignificantBit(x);
    //   assertEq(i, mostSignificantBit(x));
    // }

    function testMostSignificantBitFuzz(uint256 x) public view {
        // assume = if false, the fuzzer will discard the current fuzz inputs
        //       and start a new fuzz run
        // skip if x = 0

        // vm.assume(x > 0 );
        // assertGt(x, 0);

        // bound(input, min, max) - bound input between min and max
        x = bound(x, 1, 10); //it will return x bounded btw 1 and 10.
        assertGe(x, 1);
        assertLe(x, 10);

        uint256 i = b.mostSignificantBit(x);
        assertEq(i, mostSignificantBit(x));
    }
}
