//SPDX-License-Identifier: MIT
pragma solidity 0.8.7;

contract EtherWallet {
    address payable public owner;

    constructor() {
        owner = payable(msg.sender);
    }

    receive() external payable {
        
    }


    function transferEther(uint _amount) external {
        require(msg.sender == owner, "Function call is not done by owner");
        payable(msg.sender).transfer(_amount);
    }

    function getbalance() external view returns(uint) {
        return address(this).balance;
    }
}