//SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Test, console} from "forge-std/Test.sol";
import {IERC20} from "../src/interfaces/IERC20.sol";

contract WhaleTest is Test {
    IERC20 public dai;

    function setUp() public {
        dai = IERC20(0x6B175474E89094C44Da98b954EedeAC495271d0F);
    }

    function testDeposit() public {
        address alice = address(123);

        uint256 balBefore = dai.balanceOf(alice);
        console.log("Balance Before", balBefore / 1e18);

        uint256 totalBefore = dai.totalSupply();
        console.log("Total Before", totalBefore / 1e18);

        deal(address(dai), alice, 1e6 * 1e18, true); //minting 1M dai to alice. true updates the total supply of dai.

        uint256 balAfter = dai.balanceOf(alice);
        console.log("Balance After", balAfter / 1e18);

        uint256 totalAfter = dai.totalSupply();
        console.log("Total After", totalAfter / 1e18); //we divided by 1e18 cuz it is too long so just to sure actual amount in this case 1M DAI.
    }
}
