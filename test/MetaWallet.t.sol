//SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Test, console} from "forge-std/Test.sol";
import {Wallet} from "../src/MetaWallet.sol";

// Example of deal and hoax
// deal(address, uint) - Set balance of address
// hoax(address, uint) - deal + prank, Sets up prank and set balance

contract WalletTest is Test {
    Wallet public wallet;

    function setUp() public {
        wallet = new Wallet{value: 1e18}();
    }

    function _send(uint256 amount) private {
        (bool ok,) = address(wallet).call{value: amount}("");
        require(ok, "send Eth Failed");
    }

    function testEthBalance() public view {
        console.log("Eth Balance", address(this).balance / 1e18);
    }

    function testSendEth() public {
        uint256 bal = address(wallet).balance;
        // deal(address, uint) - Set balance of address
        deal(address(1), 100);
        assertEq(address(1).balance, 100);

        deal(address(1), 10);
        assertEq(address(1).balance, 10);

        // hoax(address, uint) - deal + prank, Sets up prank and set balance
        deal(address(1), 666);
        vm.prank(address(1));
        _send(666);

        hoax(address(1), 777);
        _send(777);

        assertEq(address(wallet).balance, bal + 666 + 777);
    }
}
