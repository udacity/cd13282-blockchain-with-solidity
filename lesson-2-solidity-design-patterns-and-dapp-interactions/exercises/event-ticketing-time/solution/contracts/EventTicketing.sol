// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract EventTicketing {
    struct Ticket {
        string attendeeName;
        uint ticketId;
        bool isUsed;
        uint timestamp; // Added timestamp to track when the ticket was purchased
    }

    string public eventName;
    uint public totalTicketsSold;
    uint public maxTickets;
    mapping(uint => Ticket) public ticketsSold;
    event TicketPurchased(uint ticketId, string attendeeName, uint timestamp);

    uint public startTime; // Start time for ticket sales
    uint public endTime; // End time for ticket sales

    // Initialize the contract with start and end times for ticket sales
    constructor(uint _startTime, uint _endTime) {
        require(_endTime > _startTime, "End time must be after start time");
        startTime = _startTime;
        endTime = _endTime;
    }

    function setEventDetails(string memory _eventName, uint _maxTickets) public {
        require(bytes(_eventName).length > 0, "Event name cannot be empty");
        require(_maxTickets > 0, "There should be at least one ticket");
        eventName = _eventName;
        maxTickets = _maxTickets;
    }

    function purchaseTicket(string memory attendeeName) public {
        require(block.timestamp >= startTime && block.timestamp <= endTime, "Ticket sales not open");
        require(totalTicketsSold < maxTickets, "All tickets have been sold");
        uint ticketId = totalTicketsSold + 1;
        ticketsSold[ticketId] = Ticket(attendeeName, ticketId, false, block.timestamp); // Include purchase timestamp
        totalTicketsSold += 1;
        emit TicketPurchased(ticketId, attendeeName, block.timestamp); // Emit event with timestamp
    }

    function useTicket(uint ticketId) public {
        require(ticketId > 0 && ticketId <= totalTicketsSold, "Invalid ticket ID");
        Ticket storage ticket = ticketsSold[ticketId];
        require(!ticket.isUsed, "Ticket already used");
        ticket.isUsed = true;
    }
}
