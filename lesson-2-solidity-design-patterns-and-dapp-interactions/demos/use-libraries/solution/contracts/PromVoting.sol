// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

// Importing OpenZeppelin's Math library for safe mathematical operations.
import "@openzeppelin/contracts/utils/math/Math.sol";

// PromVoting contract declaration
contract PromVoting {
    // Using Math library for uint256 type for any necessary mathematical operations beyond basic arithmetic.
    using Math for uint256;

    // Struct to represent a candidate
    struct Candidate {
        uint id; // Unique identifier for a candidate
        string name; // Name of the candidate
        uint voteCount; // Number of votes received
        address candidateAddress; // Ethereum address of the candidate to prevent self-voting
    }

    // Struct to represent a vote
    struct Vote {
        uint candidateId; // Candidate ID that was voted for
        uint timestamp; // Time when the vote was cast
    }

    // Mapping to store candidates, accessed by their ID
    mapping(uint => Candidate) public candidates;
    // Counter for the total number of candidates
    uint public candidatesCount;
    // Total number of votes cast across all candidates
    uint public totalVotes;

    // Mapping to store votes by voter address to prevent duplicate voting
    mapping(address => Vote) public votes;
    // Mapping to keep track of registered voters
    mapping(address => bool) public registeredVoters;

    // Variables to manage the voting period, initialized in the constructor
    uint public startTime; // Voting start time
    uint public endTime; // Voting end time
    // Owner of the contract, typically the deployer
    address public owner;

    // Threshold of votes needed for a candidate to automatically win
    uint public winningThreshold;

    // Event emitted when a vote is successfully cast
    event VoteCast(uint candidateId, uint timestamp);
    // Event declared for when a winner is determined based on the threshold
    event WinnerDeclared(uint candidateId);

    // Modifiers for access control and to ensure actions are taken within specified conditions
    modifier onlyOwner() {
        require(msg.sender == owner, "Only the contract owner can perform this action.");
        _;
    }

    modifier onlyDuringVotingPeriod() {
        require(block.timestamp >= startTime && block.timestamp <= endTime, "Voting is not currently open.");
        _;
    }

    modifier onlyRegisteredVoters() {
        require(registeredVoters[msg.sender], "You must be a registered voter.");
        _;
    }

    modifier cannotVoteForSelf(uint _candidateId) {
        require(candidates[_candidateId].candidateAddress != msg.sender, "You cannot vote for yourself.");
        _;
    }

    // Constructor sets up voting duration and owner
    constructor(uint _votingDuration, uint _winningThreshold) {
        startTime = block.timestamp; 
        endTime = startTime + _votingDuration; 
        owner = msg.sender;
        winningThreshold = _winningThreshold; // Set the winning threshold
    }

    // Functions for contract interactions

    // Registers a voter, restricted to owner
    function registerVoter(address _voter) public onlyOwner {
        registeredVoters[_voter] = true;
    }

    // Adds a new candidate
    function addCandidate(string memory _name, address _candidateAddress) public onlyOwner {
        candidatesCount++;
        candidates[candidatesCount] = Candidate(candidatesCount, _name, 0, _candidateAddress);
    }

    // Casts a vote for a candidate
    function vote(uint _candidateId) public onlyDuringVotingPeriod onlyRegisteredVoters cannotVoteForSelf(_candidateId) {
        require(votes[msg.sender].timestamp == 0, "Voter has already voted.");
        candidates[_candidateId].voteCount += 1;
        totalVotes += 1; // Increment the total vote count
        votes[msg.sender] = Vote(_candidateId, block.timestamp);
        emit VoteCast(_candidateId, block.timestamp);
    }

    // Retrieves the vote count for a specific candidate
    function getCandidateVoteCount(uint _candidateId) public view returns (uint) {
        return candidates[_candidateId].voteCount;
    }

    // Calculates the average number of votes per candidate
    function calculateAverageVotes() public view returns (uint) {
        if (candidatesCount == 0) return 0; 
        return totalVotes / candidatesCount; 
    }

    // Checks for a winner based on the winning threshold
    function checkAndRegisterWinner() public {
        uint256 highestVotes = 0;
        uint256 winnerId = 0;
        for (uint i = 1; i <= candidatesCount; i++) {
            uint256 candidateVotes = candidates[i].voteCount;
            if (candidateVotes >= winningThreshold) {
                highestVotes = Math.max(highestVotes, candidateVotes);
                winnerId = i; 
            }
        }

        if (winnerId > 0) {
            emit WinnerDeclared(winnerId);
        }
    }
}
