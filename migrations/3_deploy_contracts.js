var TweetRegistry = artifacts.require("./TweetRegistry.sol");

module.exports = function(deployer) {
  deployer.deploy(TweetRegistry);
};