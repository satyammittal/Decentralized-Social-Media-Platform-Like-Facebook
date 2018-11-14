var Chat = artifacts.require("./Chat.sol");

module.exports = function(deployer) {
  deployer.deploy(Chat);
};