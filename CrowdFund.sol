//SPDX-License-Identifier: MIT
pragma solidity 0.8.7;

contract CrowdFund2 {
    address public manager;
    mapping (address => uint) public contributors;
    uint public minimumContribution;
    uint public deadline;
    uint public targetAmount;
    uint public raisedAmount;

    struct Request {
        string description;
        address payable recipient;
        uint value;
        bool status;
    }

    mapping (uint => Request) public requests;
    uint public requestNum;

    constructor(uint _minimumContribution, uint _targetAmount, uint _deadline) {
        minimumContribution = _minimumContribution;
        targetAmount = _targetAmount;
        deadline = block.timestamp + _deadline;
        manager = msg.sender;
    }

    modifier onlyManager() {
        require(msg.sender == manager, "Invalid Manager");
        _;
    }

    function contribute() public payable {
        require(msg.value > minimumContribution, "Contribution too low.");
        require(block.timestamp < deadline, "CrowdFunding is Over.");

        contributors[msg.sender] += msg.value;
        raisedAmount += msg.value;
    }

    function getBalance() public view returns(uint) {
        return address(this).balance;
    }

    function createRequests(string memory _description, address payable _recepient, uint _value) public {
        Request storage newRequest = requests[requestNum];
        requestNum++;
        newRequest.description = _description;
        newRequest.recipient = _recepient;
        newRequest.value = _value;
        newRequest.status = false;
    }

    function currentTimeStamp() public view returns(uint){
        return block.timestamp;
    }

    function makePayment(uint _requestNo) public {
        require(raisedAmount >= targetAmount);
        Request storage thisRequest = requests[_requestNo];
        require(thisRequest.status == false, "The request is completed.");
        thisRequest.recipient.transfer(thisRequest.value);
        thisRequest.status = true;
    }

    function refund() public  {
        require(block.timestamp > deadline && raisedAmount < targetAmount, "Refund not possible. Deadline reached!!!");
        require(contributors[msg.sender] > 0);

        address payable user = payable(msg.sender);
        user.transfer(contributors[msg.sender]);
        contributors[msg.sender] = 0;
    }

}