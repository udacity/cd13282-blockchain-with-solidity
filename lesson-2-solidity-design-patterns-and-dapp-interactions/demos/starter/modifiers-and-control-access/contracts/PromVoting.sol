// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

// Define the PromVoting contract
contract PromVoting {
    // A struct to represent a candidate in the voting
    struct Candidate {
        uint id; // Unique identifier for the candidate
        string name; // Name of the candidate
        uint voteCount; // Number of votes the candidate has received
    }

    // A struct to represent a vote cast by a voter
    struct Vote {
        uint candidateId; // ID of the candidate voted for
        uint timestamp; // Timestamp when the vote was cast
    }

    // Mapping from candidate ID to Candidate struct for storing candidate information
    mapping(uint => Candidate) public candidates;
    // Counter for the total number of candidates
    uint public candidatesCount;
    // State variable to keep track of the total number of votes
    uint public totalVotes;

    // Mapping from voter's address to Vote struct for storing votes cast by each voter
    mapping(address => Vote) public votes;
    // Start and end timestamps for when voting is open
    uint public startTime;
    uint public endTime;

    // Event emitted when a vote is cast, includes the candidateId and timestamp
    event VoteCast(uint candidateId, uint timestamp);

    // Constructor to set the voting duration starting from deployment
    constructor(uint _votingDuration) {
        startTime = block.timestamp; // Voting starts at contract deployment
        endTime = startTime + _votingDuration; // Voting ends based on duration provided
    }

    // Function to add a new candidate to the voting
    function addCandidate(string memory _name) public {
        candidatesCount++;
        candidates[candidatesCount] = Candidate(candidatesCount, _name, 0);
    }

    // Function to cast a vote for a candidate
    function vote(uint _candidateId) public {
        require(block.timestamp >= startTime && block.timestamp <= endTime, "Voting is not currently open.");
        candidates[_candidateId].voteCount += 1; // Increment the vote count for the chosen candidate
        votes[msg.sender] = Vote(_candidateId, block.timestamp); // Record the vote
        totalVotes += 1; // Increment totalVotes each time a vote is cast

        emit VoteCast(_candidateId, block.timestamp); // Emit a VoteCast event
    }

    // Function to get the total vote count for a specific candidate
    function getCandidateVoteCount(uint _candidateId) public view returns (uint) {
        return candidates[_candidateId].voteCount; // Return the vote count
    }

    // Function to get the total number of votes cast in the election
    function getTotalVotes() public view returns (uint) {
        return totalVotes; // Return the total number of votes
    }
}
