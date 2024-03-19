// Import necessary libraries for testing.
const { expect } = require("chai");
const { ethers } = require("hardhat");

// Describe the test suite for the PromVoting contract.
describe("PromVoting", function () {
  let promVoting; // Variable to hold the deployed PromVoting contract.
  let owner; // Represents the contract owner in tests.
  let addr1; // Represents another user.

  // Hook that runs before each test, used to deploy a fresh instance of the contract.
  beforeEach(async function () {
    // Get the ContractFactory for PromVoting, which allows deploying new contract instances.
    const PromVoting = await ethers.getContractFactory("PromVoting");
    // Get signers to represent different accounts interacting with the contract.
    [owner, addr1] = await ethers.getSigners();
    // Deploy a new instance of the PromVoting contract.
    promVoting = await PromVoting.deploy();
  });

  // Test case to ensure multiple candidates can be added successfully.
  it("Should deploy and add multiple candidates", async function () {
    // Add candidates using the addCandidate function.
    await promVoting.addCandidate("Alice");
    await promVoting.addCandidate("Bob");

    // Retrieve and verify each candidate's details.
    const alice = await promVoting.candidates(1);
    const bob = await promVoting.candidates(2);

    // Check if the candidate names match what was added.
    expect(alice.name).to.equal("Alice");
    expect(bob.name).to.equal("Bob");
  });

  // Test case to ensure that voting for a specific candidate emits an event and increments their vote count.
  it("Should allow voting for a specific candidate and emit an event", async function () {
    // Add candidates to enable voting.
    await promVoting.addCandidate("Alice");
    await promVoting.addCandidate("Bob");

    // Perform a vote for a specific candidate and expect the 'VoteCast' event to be emitted with the candidate ID.
    await expect(promVoting.vote(1)) // Vote for candidate with ID 1 (Alice).
      .to.emit(promVoting, "VoteCast")
      .withArgs(1);

    // Retrieve Alice's details and verify the vote count has incremented.
    const alice = await promVoting.candidates(1);
    expect(alice.voteCount).to.equal(1);
  });

  // Test case to verify the contract correctly reports the number of votes each candidate has received after multiple votes.
  it("Should return the correct vote count after voting for multiple candidates", async function () {
    // Add candidates to enable voting.
    await promVoting.addCandidate("Alice");
    await promVoting.addCandidate("Bob");

    // Cast votes for candidates.
    await promVoting.vote(1); // Vote for Alice.
    await promVoting.vote(2); // Vote for Bob.
    await promVoting.vote(1); // Vote for Alice again.

    // Retrieve and verify the vote count for each candidate.
    const aliceVoteCount = await promVoting.getCandidateVoteCount(1); // Alice's votes.
    const bobVoteCount = await promVoting.getCandidateVoteCount(2); // Bob's votes.

    // Check if the vote counts match the expected values.
    expect(aliceVoteCount).to.equal(2); // Alice should have 2 votes.
    expect(bobVoteCount).to.equal(1); // Bob should have 1 vote.
  });
});
