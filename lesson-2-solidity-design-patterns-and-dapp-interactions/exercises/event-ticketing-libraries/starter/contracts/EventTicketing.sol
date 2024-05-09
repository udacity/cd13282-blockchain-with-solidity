// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

// TODO: Import the Ownable library from OpenZeppelin

// TODO: Extend the EventTicketing contract with the Ownable contract from OpenZeppelin
contract EventTicketing {
    struct Ticket {
        string attendeeName;
        uint ticketId;
        bool isUsed;
        uint timestamp; // Timestamp when the ticket was purchased
    }

    string public eventName;
    uint public totalTicketsSold;
    uint public maxTickets;
    mapping(uint => Ticket) public ticketsSold;
    event TicketPurchased(uint ticketId, string attendeeName, uint timestamp);

    uint public startTime;
    uint public endTime;

    // Modifier to ensure actions are taken within the ticket sales period.
    modifier salesOpen() {
        require(block.timestamp >= startTime && block.timestamp <= endTime, "Ticket sales are not open.");
        _;
    }


    // TODO: Modify the constructor to pass an initialOwner address to the Ownable constructor
    constructor(uint _startTime, uint _endTime) {
        require(_endTime > _startTime, "End time must be after start time.");
        startTime = _startTime;
        endTime = _endTime;
    }

    // TODO: Add the onlyOwner modifier to restrict this function to the owner of the contract
    function setEventDetails(string memory _eventName, uint _maxTickets) public {
        require(bytes(_eventName).length > 0, "Event name cannot be empty.");
        require(_maxTickets > 0, "There should be at least one ticket.");
        eventName = _eventName;
        maxTickets = _maxTickets;
    }

    function purchaseTicket(string memory attendeeName) public salesOpen {
        require(totalTicketsSold < maxTickets, "All tickets have been sold.");
        uint ticketId = totalTicketsSold + 1;
        ticketsSold[ticketId] = Ticket(attendeeName, ticketId, false, block.timestamp);
        totalTicketsSold += 1;
        emit TicketPurchased(ticketId, attendeeName, block.timestamp);
    }

    function useTicket(uint ticketId) public {
        require(ticketId > 0 && ticketId <= totalTicketsSold, "Invalid ticket ID.");
        Ticket storage ticket = ticketsSold[ticketId];
        require(!ticket.isUsed, "Ticket already used.");
        ticket.isUsed = true;
    }
}
