// SPDX-License-Identifier: MIT
pragma solidity ^0.8.3;

contract Ownable {
    address public owner;

    constructor() {
        owner = msg.sender;
    }

    modifier OnlyOwner() {
        require(msg.sender == owner, "Not Owner");
        _;
    }

    function SetOwner(address _newOwner) external OnlyOwner {
        require(_newOwner != address(0), "Invalid Address");
        owner = _newOwner;
    } 

    function OnlyOwnerCanCallThis() external OnlyOwner {
        
    }

    function AnyOneCanCall() external {

    }
}

