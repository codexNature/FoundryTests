// SPDX-License-Identifier:MIT
pragma solidity ^0.8.19;

import {Test, console} from "forge-std/Test.sol";
import {WETH} from "../src/WETH.sol";
import {Handler} from "./Invariant_2.t.sol";

import {CommonBase} from "forge-std/Base.sol";
import {StdCheats} from "forge-std/StdCheats.sol";
import {StdUtils} from "forge-std/StdUtils.sol";

contract ActorManager is CommonBase, StdCheats, StdUtils {
    Handler[] public handlers;

    constructor(Handler[] memory _handlers) {
        handlers = _handlers;
    }

    function sendToFallback(uint256 handlerIndex, uint256 amount) public {
        uint256 index = bound(handlerIndex, 0, handlers.length - 1);
        handlers[index].sendToFallback(amount);
    }

    function deposit(uint256 handlerIndex, uint256 amount) public {
        uint256 index = bound(handlerIndex, 0, handlers.length - 1);
        handlers[index].deposit(amount);
    }

    function withdraw(uint256 handlerIndex, uint256 amount) public {
        uint256 index = bound(handlerIndex, 0, handlers.length - 1);
        handlers[index].withdraw(amount);
    }
}

contract WETH_Multi_Handler_Invariant_Tests is Test {
    WETH public weth;
    ActorManager public manager;
    Handler[] public handlers;

    function setUp() public {
        weth = new WETH();

        for (uint256 i = 0; i < 3; i++) {
            handlers.push(new Handler(weth));
            deal(address(handlers[i]), 100 * 1e18);
        }

        manager = new ActorManager(handlers);

        targetContract(address(manager));
    }

    function invariant_eth_balance2() public view {
        uint256 total = 0;
        for (uint256 i = 0; i < handlers.length - 1; i++) {
            total += handlers[i].wethBalance();
        }
        console.log("ETH Total", total / 1e18);
        console.log("WETH Bal", address(weth).balance / 1e18);
        assertGe(address(weth).balance, total);
    }
}
