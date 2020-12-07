var TodoList = artifacts.require("./TodoList.sol");
var TicketSystem = artifacts.require("./TicketSystem.sol");

module.exports = function(deployer) {
  deployer.deploy(TodoList);
  deployer.deploy(TicketSystem)
};