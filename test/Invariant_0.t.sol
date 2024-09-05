// SPDX-License-Identifier:MIT
pragma solidity ^0.8.19;

// Topics
// -- Invariant
// -- Difference between fuzz and invariant
// -- Failing invariant tests
// -- Passing invariant tests
// -- Stats - runs, calls, reverts

contract IntroInvariant {
    bool public flag; //The test is that this flag is always equal to false.

    function func_1() external {}
    function func_2() external {}
    function func_3() external {}
    function func_4() external {}

    function func_5() external {
        flag = true;
    }
}

import {Test, console} from "forge-std/Test.sol";

contract IntroInvariantTest is Test {
    IntroInvariant private target;

    function setUp() public {
        target = new IntroInvariant();
    }

    function invariant_flag_is_always_false() public view {
        assertEq(target.flag(), false);
    }
}
