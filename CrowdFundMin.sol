//SPDX-License-Identifier: MIT
pragma solidity 0.8.7;

contract CrowdFund {
    address public manager;
    uint public minContri;
    address[] public approvals;

    function campaign(uint _minContri) public {
        manager = msg.sender;
        minContri = _minContri;
    }

    function contribute() public payable {
        require(msg.value > minContri, "Minimum contribution not satisfied");
        approvals.push(msg.sender);
    }
}