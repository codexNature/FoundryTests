//SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Test, console} from "forge-std/Test.sol";

contract SignTest is Test {
    // private-key = 123
    // public key = vm.addr(private-key)
    // message = "secret message"
    // message hash = keccak256(message)
    // vm.sign(private.key, message hash)

    function testSignature() public pure {
        uint256 privateKey = 123;
        address pubkey = vm.addr(privateKey);

        bytes32 messageHash = keccak256("Secret message");

        (uint8 v, bytes32 r, bytes32 s) = vm.sign(privateKey, messageHash);

        address signer = ecrecover(messageHash, v, r, s);

        assertEq(signer, pubkey);

        bytes32 invalidMessageHash = keccak256("Invalid message");
        signer = ecrecover(invalidMessageHash, v, r, s); //not signed using vm.sign

        assertTrue(signer != pubkey);
    }
}
