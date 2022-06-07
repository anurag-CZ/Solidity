// SPDX-License-Identifier: MIT
pragma solidity 0.8.7;

contract SendEth {
    constructor() payable {}

    receive()  external payable {}

    function sendViaTransfer(address payable _to) external payable {
        _to.transfer(13);
    }

    function sendViaSend(address payable _to) external payable { 
        bool sent = _to.send(123);
        require(sent, "Sent Failed");
    }
    
    function sendViaCall(address payable _to) external payable {
        (bool success, ) =  _to.call{value: 123}("");
        require(success, "call Failed");
    }
}