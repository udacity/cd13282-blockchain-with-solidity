// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract EventTicketing {
    // Struct to hold ticket information, including the attendee's name, the ticket ID, and its usage status.
    struct Ticket {
        string attendeeName;
        uint ticketId;
        bool isUsed;
        uint timestamp; // Tracks when the ticket was purchased.
    }

    // Public state variables to hold the event's name, the total and maximum number of tickets sold.
    string public eventName;
    uint public totalTicketsSold;
    uint public maxTickets;
    mapping(uint => Ticket) public ticketsSold; // Mapping to track tickets by their IDs.
    event TicketPurchased(uint ticketId, string attendeeName, uint timestamp); // Event emitted upon ticket purchase.

    // Variables to manage the ticket sales period.
    uint public startTime; // Sales start time.
    uint public endTime; // Sales end time.

    // TODO: Implement the salesOpen modifier to ensure ticket purchases are made during the designated sales period.

    constructor(uint _startTime, uint _endTime) {
        require(_endTime > _startTime, "End time must be after start time.");
        startTime = _startTime;
        endTime = _endTime;
    }

    // Function to set the event's name and the maximum number of tickets.
    function setEventDetails(string memory _eventName, uint _maxTickets) public {
        require(bytes(_eventName).length > 0, "Event name cannot be empty.");
        require(_maxTickets > 0, "There should be at least one ticket.");
        eventName = _eventName;
        maxTickets = _maxTickets;
    }

    // Function to allow attendees to purchase tickets, ensuring sales are open and maxTickets limit hasn't been reached.
    function purchaseTicket(string memory attendeeName) public {
        // TODO: Ensure ticket sales are currently open before proceeding.
        require(totalTicketsSold < maxTickets, "All tickets have been sold.");
        uint ticketId = totalTicketsSold + 1;
        ticketsSold[ticketId] = Ticket(attendeeName, ticketId, false, block.timestamp);
        totalTicketsSold += 1;
        emit TicketPurchased(ticketId, attendeeName, block.timestamp); // Include timestamp in the emitted event.
    }

    // Function to mark a ticket as used, verifying the ticket's existence and unused status.
    function useTicket(uint ticketId) public {
        // Ensure the ticket ID is valid and the ticket hasn't been used yet.
        require(ticketId > 0 && ticketId <= totalTicketsSold, "Invalid ticket ID");
        Ticket storage ticket = ticketsSold[ticketId];
        require(!ticket.isUsed, "Ticket already used");
        ticket.isUsed = true;
    }
}