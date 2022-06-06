//SPDX-License-Identifier: MIT
pragma solidity 0.8.7;

contract test1 {
    uint public num;
    address public sender;
    uint public value;

    constructor() {
        owner = payable(msg.sender);
    }
    address payable owner;

    function setVars(uint _num) public payable {
        num = _num;
        sender = msg.sender;
        value = msg.value;
    }
    
    function destruct() public {
        selfdestruct(owner);
    }
}

contract test2 {
    uint public num;
    address public sender;
    uint public value;

    constructor() {
        owner = payable(msg.sender);
    }
    address payable owner;

    function setVars(uint _num) public payable {
        num = _num;
        sender = msg.sender;
        value = msg.value;
    }

    function destruct() public{
        selfdestruct(owner);
    }
}

contract main {
    uint public num;
    address public sender;
    uint public value;

    function setVars(address _contract, uint _num) public payable {
        (bool success, bytes memory data) = _contract.delegatecall(abi.encodeWithSignature("setVars(uint256)",_num));
    }
}
