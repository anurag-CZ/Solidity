//SPDX-License-Identifier: MIT
pragma solidity 0.8.7;

contract ReentrancyMutex {
    mapping (address => uint) public balances;
    
    bool locked;

    function donate(address _to) public payable {
        balances[_to] += msg.value;
    }

    function balanceOf(address _addr) public view returns(uint) {
        return balances[_addr];
    }

    // Avoiding Reentrancy attack using mutex
    function withdraw(uint _amount) public payable {
        require(!locked, "Withdrawal is locked");
        locked = true;

        if (balances[msg.sender] >= _amount) {
            (bool status, ) = msg.sender.call{value : _amount}("");
            require(status, "Withdrawal Failed");
            balances[msg.sender] -= _amount;
        }
        else {
            revert("Not Enough Balance");
        }

        locked = false;  
    } 
}