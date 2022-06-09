//SPDX-License-Identifier: MIT
pragma solidity 0.8.7;

contract ReentrancyAssembly {
    mapping(address => uint) public balances;

    function donate(address _addr) public payable {
        balances[_addr] += msg.value;
    }

    function isContract(address _withdrawAddr) public view returns(bool) {
        uint size;
        assembly {
            size := extcodesize(_withdrawAddr)
        }
        return size > 0;
    }

    function withdraw(uint _amount) public payable {
        // require(!isContract(msg.sender), "Calling Address is contract");
      if(!isContract(msg.sender)) {
          if(balances[msg.sender] >= _amount) {
              (bool status, ) = msg.sender.call{value: _amount}("");
              require(status, "WIthdrawal failed");
              balances[msg.sender] -= _amount;
            }
            else {
                revert("Not Enough Balance");
            }
        }
        else {
            revert("Calling Address is Contract");
        }
    }
}