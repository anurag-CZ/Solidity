//SPDX-License-Identifier: MIT
pragma solidity 0.8.7;

contract EtherReceive {
    receive() external payable {}

    function sendEther(address payable to) external payable {
        to.transfer(msg.value);
    }

    function getBalance() public view returns(uint) {
        return address(this).balance;
    }
}