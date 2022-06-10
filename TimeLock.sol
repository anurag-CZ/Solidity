//SPDX-License-Identifier: MIT
pragma solidity 0.8.7;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/math/SafeMath.sol";

contract TimeLock {
    using SafeMath for uint;

    uint public constant LOCK_TIME = 100;

    address public owner;
    mapping (address => uint) public balances;
    mapping (address => uint) public timeLock;

    error TransactionFailed();

    event withdrawEvent(address withdrawAddr, uint amount);

    constructor() {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Function caller is not Owner");
        _;
    }

    function deposit() external payable {
        balances[msg.sender] = balances[msg.sender].add(msg.value);
        timeLock[msg.sender] = block.timestamp + LOCK_TIME;
    }

    function withdraw(uint _amount) external {
        require(balances[msg.sender] > 0, "Withdrawal Failed. Balance is 0.");
        require(block.timestamp > timeLock[msg.sender], "Withdrawal Failed. Funds Locked");
        require(balances[msg.sender] >= _amount, "Withdrawal Failed. Not Enough Balance.");
       
        
        balances[msg.sender] = balances[msg.sender].sub(_amount);

        (bool status, ) = msg.sender.call{value: _amount}(""); 
        if(!status) {
            balances[msg.sender] = balances[msg.sender].add(_amount);
            revert TransactionFailed();    
        }
        emit withdrawEvent(msg.sender, _amount);
    }

    function increaseTimeLock(address _lockAddr, uint _increaseTime) external onlyOwner {
        timeLock[_lockAddr] = timeLock[_lockAddr].add(_increaseTime);
    }
}