// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract PromVoting {

    // Define a struct to hold candidate details
    struct Candidate {
        string name;
        uint voteCount;
    }

    // Candidate variable
    Candidate public candidate;

    // Event to be emitted when a vote is cast
    event VoteCast(string candidateName);

    // Initialize the contract with a candidate
    function addCandidate(string memory _name) public {
        candidate = Candidate(_name, 0);
    }

    // Function to vote for the candidate
    function vote() public {
        // Increment the candidate's vote count
        candidate.voteCount += 1;

        // Emit a vote event
        emit VoteCast(candidate.name);
    }
    
    // Function to check the current vote count
    function getVoteCount() public view returns (uint) {
        return candidate.voteCount;
    }
}
