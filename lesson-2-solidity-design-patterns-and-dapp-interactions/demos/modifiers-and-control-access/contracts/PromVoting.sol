// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

// Declaration of the PromVoting contract
contract PromVoting {
    // A struct representing a candidate in the voting system
    struct Candidate {
        uint id; // Unique identifier for a candidate
        string name; // Name of the candidate
        uint voteCount; // Total number of votes received by the candidate
        address candidateAddress; // Ethereum address associated with the candidate
    }

    // A struct representing a vote cast in the system
    struct Vote {
        uint candidateId; // ID of the candidate voted for
        uint timestamp; // Time when the vote was cast
    }

    // Mapping from candidate ID to the Candidate struct, for storing and retrieving candidate details
    mapping(uint => Candidate) public candidates;
    // Counter to keep track of the total number of candidates
    uint public candidatesCount;

    // Mapping from voter's address to the Vote struct, for storing and restricting duplicate votes
    mapping(address => Vote) public votes;
    // Mapping to track which addresses are registered to vote
    mapping(address => bool) public registeredVoters;

    // Variables to manage the voting period
    uint public startTime; // Voting start time
    uint public endTime; // Voting end time
    address public owner; // Owner of the contract, typically the deployer

    // Event emitted when a vote is successfully cast
    event VoteCast(uint candidateId, uint timestamp);

    // Modifier to restrict certain actions to the contract's owner
    modifier onlyOwner() {
        require(msg.sender == owner, "Only the contract owner can perform this action.");
        _;
    }

    // Modifier to ensure actions are taken only during the allowed voting period
    modifier onlyDuringVotingPeriod() {
        require(block.timestamp >= startTime && block.timestamp <= endTime, "Voting is not currently open.");
        _;
    }

    // Modifier to allow only registered voters to proceed with voting
    modifier onlyRegisteredVoters() {
        require(registeredVoters[msg.sender], "You must be a registered voter.");
        _;
    }

    // Modifier to prevent a candidate from voting for themselves
    modifier cannotVoteForSelf(uint _candidateId) {
        require(candidates[_candidateId].candidateAddress != msg.sender, "You cannot vote for yourself.");
        _;
    }

    // Constructor to initialize the voting contract with a voting duration
    constructor(uint _votingDuration) {
        startTime = block.timestamp; // Set start time to current block timestamp
        endTime = startTime + _votingDuration; // Calculate end time based on duration
        owner = msg.sender; // Assign contract deployer as the owner
    }

    // Function to register a voter, restricted to the contract's owner
    function registerVoter(address _voter) public onlyOwner {
        registeredVoters[_voter] = true;
    }

    // Function to add a new candidate, including their Ethereum address
    function addCandidate(string memory _name, address _candidateAddress) public onlyOwner {
        candidatesCount++; // Increment the total candidate count
        // Create a new candidate and add to the mapping
        candidates[candidatesCount] = Candidate(candidatesCount, _name, 0, _candidateAddress);
    }

    // Function to cast a vote for a candidate, including checks for voting period, registration, and self-voting
    function vote(uint _candidateId) public onlyDuringVotingPeriod onlyRegisteredVoters cannotVoteForSelf(_candidateId) {
        require(votes[msg.sender].timestamp == 0, "Voter has already voted."); // Ensure the voter hasn't already voted
        candidates[_candidateId].voteCount += 1; // Increment the selected candidate's vote count
        votes[msg.sender] = Vote(_candidateId, block.timestamp); // Record the vote
        emit VoteCast(_candidateId, block.timestamp); // Emit an event for the vote
    }

    // Function to retrieve the vote count for a specific candidate
    function getCandidateVoteCount(uint _candidateId) public view returns (uint) {
        return candidates[_candidateId].voteCount;
    }
}
