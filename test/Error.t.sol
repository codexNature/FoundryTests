// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Test, console} from "forge-std/Test.sol";
import {Error} from "../src/Error.sol";

contract ErrorTest is Test {
    Error public err;

    function setUp() public {
        err = new Error();
    }

    function testFail() public view {
        err.throwError();
    }

    function testRevert() public {
        vm.expectRevert();
        err.throwError();
    }

    function testRequireMsg() public {
        vm.expectRevert(bytes("Not Authorized"));
        err.throwError();
    }

    function testCustomError() public {
        vm.expectRevert(Error.NotAuthorized.selector);
        err.throwCustomError();
    }

    function testErrorLabels() public pure {
        assertEq(uint256(1), uint256(1), "test 1");
        assertEq(uint256(1), uint256(1), "test 2");
        assertEq(uint256(1), uint256(1), "test 3");
        assertEq(uint256(1), uint256(2), "test 4");
        assertEq(uint256(1), uint256(1), "test 5");
    }
}
