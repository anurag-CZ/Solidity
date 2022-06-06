// SPDX-License-Identifier: MIT
pragma solidity 0.8.7;

library Math {
    function maxNum(uint x, uint y) internal pure returns(uint) {
        return x > y ? x : y;
    }

    function add(uint x, uint y) internal pure returns(uint) {
        return x + y;
    }
}

contract Lib {
    function testMathMax(uint x, uint y) external pure returns(uint) {
        return Math.maxNum(x,y);
    }
    function testMathAdd(uint x, uint y) external pure returns(uint) {
        return Math.add(x,y);
    }
}