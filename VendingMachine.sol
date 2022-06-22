//SPDX-License-Identifier: MIT
pragma solidity 0.8.7;

contract VendingMachine {
    address public owner;
    mapping(address => uint) public ItemBalances;

    constructor(uint _amount) {
        owner = msg.sender;
        ItemBalances[address(this)] = _amount;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Not owner");
        _;
    }

    function buy(uint amount) public payable {
        require(msg.value >= 2 ether * amount, "Not enough Ether send.");
        ItemBalances[address(this)] -= amount;
        ItemBalances[msg.sender] += amount;
    }


    function withdraw() public payable onlyOwner {
        payable(msg.sender).transfer(address(this).balance);
    }

    function restock(uint amount) public payable onlyOwner {
        ItemBalances[address(this)] += amount;
    }
    
    function contarctbal() public view returns(uint){
        return address(this).balance;
    }   
}