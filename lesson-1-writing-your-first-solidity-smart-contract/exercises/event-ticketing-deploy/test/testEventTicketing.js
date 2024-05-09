// Import the necessary libraries for testing.
const { expect } = require("chai");
const { ethers } = require("hardhat");

// Describe the test suite for the EventTicketing contract.
describe("EventTicketing", function () {
  let eventTicketing; // Variable to hold the deployed EventTicketing contract.
  let owner; // Represents the contract owner in tests.
  let attendee; // Represents an attendee (user).

  // Hook that runs before each test to deploy a fresh instance of the contract.
  beforeEach(async function () {
    // Get the ContractFactory for EventTicketing, enabling new contract instance deployments.
    const EventTicketing = await ethers.getContractFactory("EventTicketing");
    // Get signers to represent different accounts interacting with the contract.
    [owner, attendee] = await ethers.getSigners();
    // Deploy a new instance of the EventTicketing contract.
    eventTicketing = await EventTicketing.deploy();
  });

  // Test case to set event details successfully.
  it("Should allow setting event details", async function () {
    // Set the event name and maximum tickets.
    await eventTicketing.setEventDetails("Blockchain Conference", 100);

    // Retrieve and verify the event details.
    expect(await eventTicketing.eventName()).to.equal("Blockchain Conference");
    expect(await eventTicketing.maxTickets()).to.equal(100);
  });

  // Test case to ensure tickets can be purchased successfully.
  it("Should allow ticket purchase and emit TicketPurchased event", async function () {
    // Set event details to enable ticket sales.
    await eventTicketing.setEventDetails("Blockchain Conference", 100);

    // Purchase a ticket and expect the TicketPurchased event to be emitted.
    await expect(eventTicketing.purchaseTicket("Attendee 1"))
      .to.emit(eventTicketing, "TicketPurchased")
      .withArgs(1, "Attendee 1");

    // Verify the ticket details and the totalTicketsSold count.
    const ticket = await eventTicketing.ticketsSold(1);
    expect(ticket.attendeeName).to.equal("Attendee 1");
    expect(ticket.isUsed).to.equal(false);
    expect(await eventTicketing.totalTicketsSold()).to.equal(1);
  });

  // Test case to ensure tickets can be marked as used.
  it("Should allow marking a ticket as used", async function () {
    // Set event details and purchase a ticket.
    await eventTicketing.setEventDetails("Blockchain Conference", 100);
    await eventTicketing.purchaseTicket("Attendee 1");

    // Mark the purchased ticket as used.
    await eventTicketing.useTicket(1);

    // Verify that the ticket is marked as used.
    const ticket = await eventTicketing.ticketsSold(1);
    expect(ticket.isUsed).to.equal(true);
  });
});
