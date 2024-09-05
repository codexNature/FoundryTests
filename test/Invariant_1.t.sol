// SPDX-License-Identifier:MIT
pragma solidity ^0.8.19;

import {Test, console} from "forge-std/Test.sol";
import {WETH} from "../src/WETH.sol";

//Note: Open testing - randomly call all public functions
contract WETH_Open_Invariant_Tests is Test {
    WETH public weth;

    function setUp() public {
        weth = new WETH();
    }

    function invariant_totalSupply_is_always_zero() public view {
        assertEq(weth.totalSupply(), 0);
    }
}
