//SPDX-License-Identifier: MIT
pragma solidity 0.8.7;

contract MultiSigWallet {
    event Deposit(address indexed sender, uint amount);
    event Submit(uint indexed txID);
    event Approve(address indexed sender, uint indexed txID);
    event Revoke(address indexed sender, uint indexed txID);
    event Execute(uint indexed txID);

    struct Transaction {
        address to;
        uint value;
        bytes data;
        bool executed;
    }

    address[] public owners;
    mapping(address => bool) public isOwner;
    uint public required;

    Transaction[] public transactions;
    mapping(uint => mapping(address => bool)) public approved;

      modifier onlyOwner() {
        require(isOwner[msg.sender], "Not owner");
        _;
    }

    modifier txExists(uint _txID) {
        require(_txID < transactions.length, "Transaction does not exists.");
        _;
    }

    modifier notApproved(uint _txID) {
        require(!approved[_txID][msg.sender], "Transaction not approved.");
        _;
    }

    modifier notExecuted(uint _txID) {
        require(!transactions[_txID].executed, "Transaction executed already");
        _;
    }

    constructor(address[] memory _owners, uint _required) {
        require(_owners.length > 0, "Owner required");
        require(_required > 0 && _required <= _owners.length, "Invalid number of required");

        for (uint i; i < _owners.length; i++) {
            address owner = owners[i];
            require(owner != address(0), "invalid owner");
            require(!isOwner[owner], "Owner not unique");
            isOwner[owner] = true;
        }
        required = _required;
    }
    receive() external payable {
        emit Deposit(msg.sender, msg.value);
    }
    
    function submit(address _to, uint _value, bytes calldata _data) external onlyOwner {
        transactions.push(Transaction({
            to: _to,
            value: _value,
            data: _data,
            executed: false
        }));
        emit Submit(transactions.length - 1);
    }

    function approve(uint _txID) external txExists(_txID) notApproved(_txID) notExecuted(_txID) {
        approved[_txID][msg.sender] = true;
        emit Approve(msg.sender, _txID);
    }

    function _getApprovalCount(uint _txID) private view returns(uint count) {
        for (uint i; i< owners.length; i++) {
            if (approved[_txID][owners[i]]) {
                count += 1;
            }
        }
    }

    function execute(uint _txID) external onlyOwner txExists(_txID) notExecuted(_txID){
        require(_getApprovalCount(_txID) > required, "approval < required");

        Transaction storage transaction = transactions[_txID];
        transaction.executed = true;

        (bool success, ) = transaction.to.call{value: transaction.value}(transaction.data);
        require(success, "Transaction Failed");
        emit Execute(_txID);
    }

    function revoke(uint _txID) external onlyOwner txExists(_txID) notExecuted(_txID) {
        require(approved[_txID][msg.sender], "Transaction not approved");
        approved[_txID][msg.sender] = false;
        emit Revoke(msg.sender, _txID);
    }
 

}