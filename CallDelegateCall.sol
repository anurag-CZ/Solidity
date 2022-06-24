//SPDX-License-Identifier: MIT
pragma solidity 0.8.7;

contract Some {
    address public owner;

    constructor() {
        owner = msg.sender;
    }
    
    function setOwner(address _owner) public {
        owner = _owner;
    } 
}

contract Calls {
    address public owner;
    function callContract(address _contractAddr, address _owner) public {
        (bool success, ) = _contractAddr.call(abi.encodeWithSignature("setOwner(address)", _owner));
    }
     
    function delegateCallContract(address _contractAddr, address _owner) public {
         (bool success, ) = _contractAddr.delegatecall(abi.encodeWithSignature("setOwner(address)", _owner));
    }
}