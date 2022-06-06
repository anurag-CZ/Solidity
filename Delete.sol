//SPDX-License-Identifier: MIT
pragma solidity 0.8.7;

contract Delete {
    constructor() payable {}
    
    function deleteContract() external  {
        selfdestruct(payable(msg.sender));
    }

    function test() external pure returns(uint) {
        return 123;
    }
}

contract DeletePayable {
    function deleteContract(Delete _deleteContract) external  {
        _deleteContract.deleteContract();
    }

    function getBalance() external view returns(uint) {
        return address(this).balance;
    }

    function test() external pure returns(uint) {
        return 1234;
    }
}