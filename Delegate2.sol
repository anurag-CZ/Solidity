//SPDX-License-Identifier: MIT
pragma solidity 0.8.7;

contract DelegateCall {
    address public sender;
    uint public num;

    function delegateCallF(address _contract, uint _num) public {
       (bool success,) = _contract.delegatecall(abi.encodeWithSignature("d(uint256)", _num));

       require(success, "FAILED");
    }
}

contract DelegateTest1 {
    address public sender;
    uint public num;

    constructor() public {
        owner = msg.sender;
    }
    address public owner;

     function d(uint _num) public {
        num = _num;
    }
}

contract DelegateTest2 {
    address public sender;
    uint public num;

    constructor() public {
        owner = msg.sender;
    }
    address public owner;

    function d(uint _num) public {
        num = _num * _num;
    }
}