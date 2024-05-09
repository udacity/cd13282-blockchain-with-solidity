// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract PromVoting {
    // Define a struct to hold candidate details
    struct Candidate {
        uint id; // Unique identifier for the candidate
        string name;
        uint voteCount;
    }

    // Mapping from candidate ID to Candidate struct for storing candidates
    mapping(uint => Candidate) public candidates;
    // Counter for the total number of candidates
    uint public candidatesCount;

    // Event to be emitted when a vote is cast
    event VoteCast(uint candidateId);

    // Function to add a new candidate to the election
    function addCandidate(string memory _name) public {
        candidatesCount += 1;
        candidates[candidatesCount] = Candidate(candidatesCount, _name, 0);
    }

    // Function to vote for a candidate
    function vote(uint _candidateId) public {
        require(_candidateId > 0 && _candidateId <= candidatesCount, "Invalid candidate ID");
        // Increment the candidate's vote count
        candidates[_candidateId].voteCount += 1;

        // Emit a vote event
        emit VoteCast(_candidateId);
    }

    // Function to get the vote count for a specific candidate
    function getCandidateVoteCount(uint _candidateId) public view returns (uint) {
        require(_candidateId > 0 && _candidateId <= candidatesCount, "Invalid candidate ID");
        return candidates[_candidateId].voteCount;
    }
}
