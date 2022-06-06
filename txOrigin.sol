// SPDX-License-Identifier: MIT
pragma solidity 0.8.7;

contract TxOrigin {
    uint public num;
    address public owner;

    function a() public {
        owner = msg.sender;
    }

    function c(uint _num) public {
        require(owner == tx.origin);
        num = _num;
    }
}