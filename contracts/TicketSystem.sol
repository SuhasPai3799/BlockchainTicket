pragma solidity ^0.5.0;
contract TicketSystem{
  address payable public recipient; 
  uint public tot_tickets = 40;
  uint tick_price = 1 ether;
  struct Ticket{
    address payable owner_id;
    string movie_id;
    string ticket_state;
    string sell_to;

  } 
  mapping(uint => Ticket) public tickets;
  constructor() public {
      
  
        for (uint i = 0; i < tot_tickets; i++)
        {
            tickets[i] = Ticket(address (0),"N/A","available","anyone");
        }
    }
 function redeem_to_pool(address payable owner_id) external 
 {
    //buyer_id.transfer(1 ether);
    for(uint i=0; i < tot_tickets ; i++)
    {
      if(tickets[i].owner_id == owner_id)
      {
        tickets[i].owner_id = address(0);
        tickets[i].ticket_state = "available";
        tickets[i].sell_to = "anyone";
        owner_id.transfer(1 ether);
        break;

      }
    }
 }
 function balanceOf() external view returns (uint){
     return address(this).balance;
 }
 function deposit() public payable {
    if(msg.value>=tick_price)
    {
      bool found = false;
      for(uint i = 0; i < tot_tickets; i++ )
      {
          if(keccak256(bytes(tickets[i].ticket_state)) == keccak256(bytes("available")))
          {
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

}