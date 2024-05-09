// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract EventTicketing {
    // Define the Ticket struct with attendee information and purchase timestamp.
    struct Ticket {
        string attendeeName;
        uint ticketId;
        bool isUsed;
        uint timestamp;
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

    constructor(uint _startTime, uint _endTime) {
        require(_endTime > _startTime, "End time must be after start time.");
        startTime = _startTime;
        endTime = _endTime;
    }

    // Only the event organizer can set event details, like name and max tickets.
    function setEventDetails(string memory _eventName, uint _maxTickets) public {
        require(bytes(_eventName).length > 0, "Event name cannot be empty.");
        require(_maxTickets > 0, "There should be at least one ticket.");
        eventName = _eventName;
        maxTickets = _maxTickets;
    }

    // Attendees can purchase tickets if the sales period is open and tickets are available.
    function purchaseTicket(string memory attendeeName) public salesOpen {
        require(totalTicketsSold < maxTickets, "All tickets have been sold.");
        uint ticketId = totalTicketsSold + 1;
        ticketsSold[ticketId] = Ticket(attendeeName, ticketId, false, block.timestamp);
        totalTicketsSold += 1;
        emit TicketPurchased(ticketId, attendeeName, block.timestamp); // Include timestamp in the emitted event.
    }

    // Verify the ticket's existence and unused status before marking
    function useTicket(uint ticketId) public {
        require(ticketId > 0 && ticketId <= totalTicketsSold, "Invalid ticket ID.");
        Ticket storage ticket = ticketsSold[ticketId];
        require(!ticket.isUsed, "Ticket already used.");
        ticket.isUsed = true;
    }
}
