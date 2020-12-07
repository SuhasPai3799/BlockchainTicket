pragma solidity ^0.5.0;

contract TodoList {
  uint public taskCount = 0;
  
  struct Task {
    uint id;
    string content;
    bool completed;
    string owner_id;
  }
  /* struct Ticket{
    string owner_id;
    string movie_name;
    string date;
  }*/

  mapping(uint => Task) public tasks;
  constructor() public {
        
      }
  function createTask(string memory _content, string memory owner_id) public {
    taskCount ++;

    tasks[taskCount] = Task(taskCount, _content,false,owner_id);
  }
   function balanceOf() external view returns (uint){
     return address(this).balance;
 }

}

