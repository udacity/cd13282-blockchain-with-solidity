const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("PromVoting", function () {
  let promVoting;
  let owner;
  let addr1;

  beforeEach(async function () {
    const PromVoting = await ethers.getContractFactory("PromVoting");
    [owner, addr1] = await ethers.getSigners();
    promVoting = await PromVoting.deploy();
  });

  it("Should deploy and add multiple candidates", async function () {
    await promVoting.addCandidate("Alice");
    await promVoting.addCandidate("Bob");

    const alice = await promVoting.candidates(1);
    const bob = await promVoting.candidates(2);

    expect(alice.name).to.equal("Alice");
    expect(bob.name).to.equal("Bob");
  });

  it("Should allow voting for a specific candidate and emit an event", async function () {
    await promVoting.addCandidate("Alice");
    await promVoting.addCandidate("Bob");

    await expect(promVoting.vote(1))
      .to.emit(promVoting, "VoteCast")
      .withArgs(1);

    const alice = await promVoting.candidates(1);
    expect(alice.voteCount).to.equal(1);
  });

  it("Should return the correct vote count after voting for multiple candidates", async function () {
    await promVoting.addCandidate("Alice");
    await promVoting.addCandidate("Bob");

    await promVoting.vote(1); // Vote for Alice
    await promVoting.vote(2); // Vote for Bob
    await promVoting.vote(1); // Vote for Alice again

    const aliceVoteCount = await promVoting.getCandidateVoteCount(1);
    const bobVoteCount = await promVoting.getCandidateVoteCount(2);

    expect(aliceVoteCount).to.equal(2); // Alice should have 2 votes
    expect(bobVoteCount).to.equal(1); // Bob should have 1 vote
  });
});
