//SPDX-License-Identifier: MIT
pragma solidity 0.8.7;

contract TestExample {
    uint public num;
    string public name;

    event Log(string name);

    constructor() payable  {
        emit Log("fallback Called");
    }

    function test(string memory _name, uint _num) external payable returns (bool, uint) {
        name = _name;
        num = _num;
        return (true, num);
    }
}

contract Test {
    bytes public data;

    function testCall(address _test2) external payable {
       (bool success, bytes memory _data) =  _test2.call{value: 111}(abi.encodeWithSignature("test(string,uint256)", "ABC", 123));

       require(success, "Call Failed");
       data = _data;
    }

    // function testCallDoesNotExist(address _test2) external payable {
    //        (bool success,) =  _test2.call(abi.encodeWithSignature("CallDoesNotExist()"));

    //    require(success, "Call Failed");
    // }
}