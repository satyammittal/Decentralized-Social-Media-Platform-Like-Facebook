var TweetAccount = artifacts.require("./TweetAccount.sol");

module.exports = function(deployer) {
  deployer.deploy(TweetAccount);
};