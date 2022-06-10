//SPDX-License-Identifier: MIT
pragma solidity 0.8.7;

contract ReentrancyAssembly {
    mapping (address => uint) public balances;

    function donate(address addr) public payable {
        balances[addr] += msg.value;
    }

    function isContract(address addr) public view returns(bool) {
        bytes32 hash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;

        bytes32 hash2;
        assembly {
             hash2 := extcodehash(addr)
        }

        return(hash2 != hash && hash2 != 0x0);
    } 

    function withdraw(uint _amount) public {
        require(!isContract(msg.sender),"Calling address is contract address.");
         if(balances[msg.sender] >= _amount) {
              (bool status, ) = msg.sender.call{value: _amount}("");
              require(status, "WIthdrawal failed");
              balances[msg.sender] -= _amount;
            }
            else {
                revert("Not Enough Balance");
            }
    }
}