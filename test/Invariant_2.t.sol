// SPDX-License-Identifier:MIT
pragma solidity ^0.8.19;

import {Test, console} from "forge-std/Test.sol";
import {WETH} from "../src/WETH.sol";

//Topics
// Handler based testing - test functions under specific conditions
// target contract
// target selector

//First we write a smart contract for handler
import {CommonBase} from "forge-std/Base.sol";
import {StdCheats} from "forge-std/StdCheats.sol";
import {StdUtils} from "forge-std/StdUtils.sol";

contract Handler is CommonBase, StdCheats, StdUtils {
    WETH private weth;
    uint256 public wethBalance;
    uint256 public numCalls;

    constructor(WETH _weth) {
        weth = _weth;
    }

    receive() external payable {}

    function sendToFallback(uint256 amount) public {
        amount = bound(amount, 0, address(this).balance);
        wethBalance += amount;
        numCalls += 1;

        (bool ok,) = address(weth).call{value: amount}("");
        require(ok, "sendToFallback failed");
    }

    function deposit(uint256 amount) public {
        amount = bound(amount, 0, address(this).balance);
        wethBalance += amount;
        numCalls += 1;

        weth.deposit{value: amount}();
    }

    function withdraw(uint256 amount) public {
        amount = bound(amount, 0, weth.balanceOf(address(this)));
        wethBalance -= amount;
        numCalls += 1;

        weth.withdraw(amount);
    }

    function fail() public pure {
        revert("failed");
    }
}

contract WETH_Handler_Based_Invariant_Test is Test {
    WETH public weth;
    Handler public handler;

    function setUp() public {
        weth = new WETH();
        handler = new Handler(weth);

        deal(address(weth), 100 * 1e18); //if failing change weth to handler
        targetContract(address(handler)); // foundry will only call function from the weth contract that is also in the handler contract.

        bytes4[] memory selectors = new bytes4[](3); //this is to target functions
        selectors[0] = Handler.deposit.selector;
        selectors[1] = Handler.withdraw.selector;
        selectors[2] = Handler.sendToFallback.selector;

        targetSelector(FuzzSelector({addr: address(handler), selectors: selectors}));
    }

    function invariant_eth_balance() public view {
        assertGe(address(weth).balance, handler.wethBalance()); //we are asserting that the amount of eth in the WETh contract is >= the amount deposited/in the habdler contract/
    }
}
