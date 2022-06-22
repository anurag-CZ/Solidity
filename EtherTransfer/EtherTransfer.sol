//SPDX-License-Identifier: MIT
pragma solidity 0.8.7;

contract EtherTransfer {
    event AmountReceived();

    receive() external payable {
        emit AmountReceived();
    }

    function sendEther(address payable to) external payable {
        bool status = to.send(msg.value);
        require(status, "Ether transaction Failed");
    }

    function transferEther(address payable to) external payable {
        to.transfer(msg.value);
    }

    function callEther(address to) external payable {
        (bool status, ) = to.call{value: msg.value}("");
        require(status, "Ether Transcation Failed");
    }
}