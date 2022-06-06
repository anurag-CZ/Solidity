//SPDX-License-Identifier: MIT
pragma solidity 0.8.7;

contract AbiDecode {
    function encode(uint i, address addr, string memory name, uint[] memory nums) external pure returns(bytes memory data) {
        return abi.encode(i,addr, name, nums);
    }
    
    function decode(bytes memory data) external pure returns(uint i, address addr, string memory name, uint[] memory nums) {
        return abi.decode(data, (uint, address, string, uint[]));
    }
}