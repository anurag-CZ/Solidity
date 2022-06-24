//SPDX-License-Identifier: MIT
pragma solidity 0.8.7;

// call is a low level function to interact with other contracts.
// recommended method - when just sending Ether via calling the fallback function, not the recommend way to call existing functions.

contract CallTest {
    uint public num;

    event Received(address caller, uint amount, string message);

    fallback() external payable {
        emit Received(msg.sender, msg.value, "message");
    }

    function setUint(string memory _message, uint _num) public payable {
        emit Received(msg.sender, msg.value, _message);
        num = _num;
    }
}

contract Call {
    event Response(bool success, bytes data);

    function CallingFunction(address _addr) public payable {
        (bool success, bytes memory data) = _addr.call{value: msg.value}(abi.encodeWithSignature("setUint(string,uint256)", "HELLO", 47));

        emit Response(success, data);
    }
    
    //calling a function that  does not exist triggers fallback function
    function FunctionDoesNotExist(address _addr) public payable {
        (bool success, bytes memory data) = _addr.call{value: msg.value}(abi.encodeWithSignature("NotExist()"));

        emit Response(success, data);
    }
}