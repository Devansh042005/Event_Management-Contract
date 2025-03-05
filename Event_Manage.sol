pragma solidity >=0.5.0 < 0.9.0;

contract EventContract{
    struct Event{
        address organizer;
        string name;
        uint date;
        uint price;
        uint ticketCount;
        uint ticketRemain;
    }

    mapping(uint => Event) public events;
    mapping(address => mapping(uint => uint)) public tickets;
    uint public nextId;

    // Create an event

    function createEvent(string memory name , uint date , uint price, uint ticketCount) public{
        require(date > block.timestamp , "You can organize the events for the future dates");
        require(ticketCount> 0 , "You can organize event only if you create more than 0 tickets");

        events[nextId] = Event(msg.sender ,name, date , price , ticketCount , ticketCount);
        nextId++;
    }

    function buyTicket(uint id , uint quantity) public payable {
        require(events[id].date !=0, "The events does not exist");
        require(events[id].date > block.timestamp , "The event is occured");
        Event storage _event = events[id];
        require(msg.value == (_event.price*quantity), "Not enough ether" );
        require(_event.ticketRemain > quantity , "Not enough tickets");
        _event.ticketRemain -= quantity;
        tickets[msg.sender][id] += quantity;
    }

    function transferTicket(uint id , uint quantity , address to) public {
        require(events[id].date !=0, "The events does not exist");
        require(events[id].date > block.timestamp , "The event is occured");
        require(tickets[msg.sender][id]>= quantity, "you dont have enough tickets");
        tickets[msg.sender][id] -= quantity;
        tickets[to][id] += quantity;
    }
}
