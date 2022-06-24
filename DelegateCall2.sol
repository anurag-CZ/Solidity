//SPDX-License-Identifier: MIT
pragma solidity 0.8.7;

// delegatecall similar to message call, 
// apart from the fact that the code at the target address is executed in the context(i.e. at the address) of the calling contract 
// and msg.sender and msg.value do not change their values.
// This means that a contract can dynamically load code from a different address at runtime.


contract DelegateCallTest {
    address public owner;
    string public name;
    uint public num;

    function setVars(string memory _name, uint _num) public {
        owner = msg.sender;
        name = _name;
        num = _num;
    }
}

// contract should have same order of state variable as of the called contract.
contract DelegateCall {
    address public owner;
    string public name;
    uint public num;

    event Log(bool status);

    function setVars(address _contractAddr, string memory _name, uint _num) public {
        (bool success,) = _contractAddr.delegatecall(abi.encodeWithSignature("setVars(string,uint256)", _name, _num));
        emit Log(success); 
    }

}