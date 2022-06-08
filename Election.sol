//SPDX-License-Identifier: MIT
pragma solidity 0.8.7;

contract Election {
    address public electionSupervisor;

    struct ElectionCandidate {
        uint candidateId;
        string candidateName;
        uint voteCount;
    }

    mapping (address => bool) public voters;
    mapping (uint => ElectionCandidate) public candidates;

    uint public candidateCount;

    bool electionStatus;

    event VoteRegistered();

    constructor() public {
        electionSupervisor = msg.sender;
    }

    modifier onlySupervisor() {
        require(msg.sender == electionSupervisor, "Only Supervisor can add candidates.");
        _;
    }

    function addCandidate(string memory _candidateName) public onlySupervisor {
         require(!electionStatus, "Election has ended");
        candidateCount++;
        candidates[candidateCount] = ElectionCandidate(candidateCount, _candidateName, 0);
    }

    function vote(uint _candidateId) public {
        require(!electionStatus, "Election has ended");
        require(!voters[msg.sender], "Already Voted.");
        require(_candidateId > 0 && _candidateId <= candidateCount, "Invalid candidate ID");

        voters[msg.sender] = true;
        candidates[_candidateId].voteCount ++;

        emit VoteRegistered();   
    }

    function endElection() public onlySupervisor {
        require(!electionStatus, "Election has already been ended");
        electionStatus = true;
    }

    function declareWinner() public view onlySupervisor returns(string memory name) {
        require(electionStatus, "Election is not yet over");

        for (uint i = 1; i <= candidateCount; i++) {
            uint totalVote;
            if (candidates[i].voteCount > totalVote) {
                name = candidates[i].candidateName;
            }

        }
        return name;
    }
}