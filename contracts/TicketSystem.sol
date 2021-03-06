pragma solidity ^0.5.0;
contract TicketSystem{
  address payable public recipient; 
  uint public tot_tickets = 40;
  uint tick_price = 1 ether;
  address payable null_addr = address(0);
  struct Ticket{
    address payable owner_id;
    string movie_id;
    string ticket_state;
    address payable sell_to;

  } 
  mapping(uint => Ticket) public tickets;
  constructor() public {
      
  
        for (uint i = 0; i < tot_tickets; i++)
        {
            tickets[i] = Ticket(null_addr,"N/A","available",null_addr);
        }
    }
 function redeem_to_pool(address payable owner_id, uint ticket_id) external 
 {
    //buyer_id.transfer(1 ether);
    
      if(tickets[ticket_id].owner_id == owner_id && keccak256(bytes(tickets[ticket_id].ticket_state)) == keccak256(bytes("unavailable")) )
      {
        
        tickets[ticket_id].ticket_state = "available";
        tickets[ticket_id].sell_to = null_addr;
      }
 }
 function balanceOf() external view returns (uint){
     return address(this).balance;
 }
 function buyTicket() public payable {
    if(msg.value>=tick_price)
    {
      bool found = false;
      for(uint i = 0; i < tot_tickets; i++ )
      {
          if(keccak256(bytes(tickets[i].ticket_state)) == keccak256(bytes("available")) && tickets[i].owner_id == null_addr)
          {
            tickets[i].owner_id = msg.sender;
            tickets[i].ticket_state = "unavailable";
            msg.sender.transfer(msg.value - tick_price);
            found = true;
            break;
          }
          else if(keccak256(bytes(tickets[i].ticket_state)) == keccak256(bytes("available")))
          {
            address payable owner_id = tickets[i].owner_id;
            owner_id.transfer(tick_price);
            tickets[i].owner_id = msg.sender;
            tickets[i].ticket_state = "unavailable";
            msg.sender.transfer(msg.value - tick_price);
            found = true;
            break;
          }
      }
      if(found == false)
      {
        msg.sender.transfer(msg.value);
      }

    }
    else
    {
      msg.sender.transfer(msg.value);
    }
 }
  function uint2str(uint _i) internal pure returns (string memory _uintAsString) {
    if (_i == 0) {
        return "0";
    }
    uint j = _i;
    uint len;
    while (j != 0) {
        len++;
        j /= 10;
    }
    bytes memory bstr = new bytes(len);
    uint k = len - 1;
    while (_i != 0) {
        bstr[k--] = byte(uint8(48 + _i % 10));
        _i /= 10;
    }
    return string(bstr);
}
 function invest() external payable{

 }

// Sell_to -> A ticket owner can sell his ticket to a some guy with a particular address
// Claim ticket -> If someone wants to sell you his ticket, you can claim it. This function completes two transactions.
 function sell_to(address payable addr, uint ticket_id) public 
 {
      if(tickets[ticket_id].owner_id == msg.sender && keccak256(bytes(tickets[ticket_id].ticket_state)) == keccak256(bytes("unavailable")))
      {
        tickets[ticket_id].sell_to = addr;
        tickets[ticket_id].ticket_state = "up_for_transfer";
      }
 }

function acceptTicket(uint ticket_id) external payable
{
    if(msg.value>=tick_price)
    {
      if(tickets[ticket_id].sell_to == msg.sender && keccak256(bytes(tickets[ticket_id].ticket_state)) == keccak256(bytes("up_for_transfer")) )
      {
        msg.sender.transfer(msg.value-tick_price);
        address payable addr = tickets[ticket_id].owner_id;
        addr.transfer(tick_price);
        tickets[ticket_id].owner_id = msg.sender;
        tickets[ticket_id].ticket_state = "unavailable";
        tickets[ticket_id].sell_to = null_addr;
      }
      else
      {
        msg.sender.transfer(msg.value);
      }
    }
    else
    {
        msg.sender.transfer(msg.value);
    }
}
function withdrawTransfer(uint ticket_id) public
{
    tickets[ticket_id].ticket_state = "unavailable";
    tickets[ticket_id].sell_to = null_addr;
}
  
 

}