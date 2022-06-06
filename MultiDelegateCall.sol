//SPDX-License-Identifier: MIT
pragma solidity 0.8.7;

contract MultiDelegateCall {
    error MultiDelegateCallFailed();
    function multiDelegateCall(bytes[] calldata data) external payable returns(bytes[] memory results) {
        results = new bytes[](data.length);

        for (uint i; i < data.length; i++) {
            (bool status, bytes memory datas) = address(this).delegatecall(data[i]); 
            if(!status) {
                revert MultiDelegateCallFailed();
            }
            results[i] = datas;
        }
    }
}

contract TestMultiDelegateCall is MultiDelegateCall{
    event Log(address caller, string func, uint a);
    function f1(uint x, uint y) external {
        emit Log(msg.sender,"f1", x ** y);
    }

    function f2() external returns (uint) {
        emit Log(msg.sender, "f2",2);
        return 111;
    }
}

contract Caller {
    function getF1(uint x ,uint y) external pure returns(bytes memory) {
        return abi.encodeWithSelector(TestMultiDelegateCall.f1.selector, x,y);
    }
    function getF2() external pure returns(bytes memory) {
        return abi.encodeWithSelector(TestMultiDelegateCall.f2.selector);
    }
}