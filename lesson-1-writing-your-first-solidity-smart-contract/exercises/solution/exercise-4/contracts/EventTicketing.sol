// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract EventTicketing {
    // Define a struct to store ticket information
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

    // Set event details like name and max tickets
    function setEventDetails(string memory _eventName, uint _maxTickets) public {
        require(bytes(_eventName).length > 0, "Event name cannot be empty");
        require(_maxTickets > 0, "There should be at least one ticket");
        eventName = _eventName;
        maxTickets = _maxTickets;
    }

    // Purchase a ticket
    function purchaseTicket(string memory attendeeName) public {
        require(totalTicketsSold < maxTickets, "All tickets have been sold");
        uint ticketId = totalTicketsSold + 1;
        ticketsSold[ticketId] = Ticket(attendeeName, ticketId, false);
        totalTicketsSold += 1;
        
        emit TicketPurchased(ticketId, attendeeName);
    }

    // Use a ticket
    function useTicket(uint ticketId) public {
        require(ticketId > 0 && ticketId <= totalTicketsSold, "Invalid ticket ID");
        Ticket storage ticket = ticketsSold[ticketId];
        require(!ticket.isUsed, "Ticket already used");
        ticket.isUsed = true;
    }
}
