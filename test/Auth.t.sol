// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Test, console} from "forge-std/Test.sol";
import {Wallet} from "../src/Wallet.sol";

contract AuthTest is Test {
    Wallet public wallet;

    function setUp() public {
        wallet = new Wallet();
    }

    function testSetOwner() public {
        wallet.setOwner(address(1));
        assertEq(wallet.owner(), address(1));
    }

    function testFailNotOwner() public {
        vm.prank(address(1));
        wallet.setOwner(address(1));
        assertEq(wallet.owner(), address(1));
    }

    function testFailSetOwnerAgain() public {
        // msg.sender = address(this)
        wallet.setOwner(address(1));

        // msg.sender = address(1)
        vm.startPrank(address(1));
        wallet.setOwner(address(1));
        wallet.setOwner(address(1));
        wallet.setOwner(address(1));

        vm.stopPrank();

        // msg.sender = address(this)
        wallet.setOwner(address(1));
    }
}
