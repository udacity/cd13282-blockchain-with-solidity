// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract EventTicketing {
    struct Ticket {
        string attendeeName;
        uint ticketId;
        bool isUsed;
    }

    string public eventName;
    uint public totalTicketsSold;
    uint public maxTickets;
    mapping(uint => Ticket) public ticketsSold;
    event TicketPurchased(uint ticketId, string attendeeName);

    function setEventDetails(string memory _eventName, uint _maxTickets) public {
        require(bytes(_eventName).length > 0, "Event name cannot be empty");
        require(_maxTickets > 0, "There should be at least one ticket");
        eventName = _eventName;
        maxTickets = _maxTickets;
    }

    function purchaseTicket(string memory attendeeName) public {
        require(totalTicketsSold < maxTickets, "All tickets have been sold");
        uint ticketId = totalTicketsSold + 1;
        ticketsSold[ticketId] = Ticket(attendeeName, ticketId, false);
        totalTicketsSold += 1;
        
        emit TicketPurchased(ticketId, attendeeName);
    }

    function useTicket(uint ticketId) public {
        require(ticketId > 0 && ticketId <= totalTicketsSold, "Invalid ticket ID");
        Ticket storage ticket = ticketsSold[ticketId];
        require(!ticket.isUsed, "Ticket already used");
        ticket.isUsed = true;
    }

    // TODO: Add start and end times for ticket sales
    // TODO: Modify functions to respect the ticket sales period
}
