//SPDX-License-Identifier: MIT
pragma solidity 0.8.7;

contract MultiCallTest {
    function f1() public view returns (uint, uint) {
        return (1, block.timestamp);
    }

    function f2() public view returns (uint, uint) {
        return (2, block.timestamp);
    }

    function getData1() external pure returns(bytes memory) {
        // return abi.encodeWithSignature("f1()");
        return abi.encodeWithSelector(this.f1.selector);
    }

    function getData2() external pure returns(bytes memory) {
        return abi.encodeWithSelector(this.f2.selector);
    }
}

contract MultiCall {
    function multiCall(address[] memory target, bytes[] memory data) external view returns(bytes[] memory) {
        require(target.length == data.length, "Target and data do not have same no. of items.");
        bytes[] memory results = new bytes[](data.length);

        for (uint i; i < target.length; i++) {
            (bool success, bytes memory result) = target[i].staticcall(data[i]);
            require(success, "call Failed");

            results[i] = result;
        }        
        return results;
    }
}