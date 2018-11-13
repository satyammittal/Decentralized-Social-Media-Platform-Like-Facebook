pragma solidity ^0.4.24;
pragma experimental ABIEncoderV2;

contract TweetRegistry {
	
	
	// mappings to look up account names, account ids and addresses
	mapping (address => string) _addressToAccountName;
	mapping (uint => address) _accountIdToAccountAddress;
	mapping (string => address) _accountNameToAddress;
	mapping (address => mapping(uint => string)) user_tweets;
	mapping(address => uint) tweet_count;
	
	// might be interesting to see how many people use the system
	uint public _numberOfAccounts;
	
	// owner
	address _registryAdmin;
	
	// allowed to administrate accounts only, not everything
	address _accountAdmin;
	
	// if a newer version of this registry is available, force users to use it
	bool _registrationDisabled;

	function TweetRegistry() payable {
		_registryAdmin = msg.sender;
		_accountAdmin = msg.sender; // can be changed later
		_numberOfAccounts = 0;
		_registrationDisabled = false;
		
	}

	function register(string name, address accountAddress) returns (int result) {
		if (_accountNameToAddress[name] != address(0)) {
			// name already taken
			result = -1;
		} else if (bytes(_addressToAccountName[accountAddress]).length != 0) {
			// account address is already registered
			result = -2;
		} else if (bytes(name).length >= 64) {
			// name too long
			result = -3;
		} else if (_registrationDisabled){
			// registry is disabled because a newer version is available
			result = -4;
		} else {
			_addressToAccountName[accountAddress] = name;
			_accountNameToAddress[name] = accountAddress;
			_accountIdToAccountAddress[_numberOfAccounts] = accountAddress;
			_numberOfAccounts++;
			result = 0; // success
		}
	}
	
	function getNumberOfAccounts() constant returns (uint numberOfAccounts) {
		numberOfAccounts = _numberOfAccounts;
	}

	function getAddressOfName(string name) constant returns (address addr) {
		addr = _accountNameToAddress[name];
	}

	function getNameOfAddress(address addr) constant returns (string name) {
		name = _addressToAccountName[addr];
	}
	
	function getAddressOfId(uint id) constant returns (address addr) {
		addr = _accountIdToAccountAddress[id];
	}
	function getUserTweets(address addr) returns (string[])
	{
	    string[] tweets;
	    for(uint i=0;i<tweet_count[addr];i++)
	    {
	        tweets[i]=user_tweets[addr][i];
	    }
	    return tweets;
	}
    function getTweetCount(address addr) returns(uint)
    {
        return tweet_count[addr];
    }
	function setUserTweets(address addr,uint index,string tweet)
	{
	    user_tweets[addr][index]=tweet;
	    tweet_count[addr]++;
	}
	function getUsers(uint id) returns (address,string)
	{
	    address a= _accountIdToAccountAddress[id];
	    string name=_addressToAccountName[a];
	    return (a,name);
	}
	function adminDeleteRegistry() {
		if (msg.sender == _registryAdmin) {
			suicide(_registryAdmin); // this is a predefined function, it deletes the contract and returns all funds to the admin's address
		}
	}
}
/*************************************************************************/
contract TweetAccount {
	TweetRegistry users;
	uint user_count;
	// "array" of all tweets of this account: maps the tweet id to the actual tweet
	mapping (uint => string) tweets;
	
	// total number of tweets in the above tweets mapping
	uint numberOfTweets;
	
	// "owner" of this account: only admin is allowed to tweet
	address adminAddress;
	
	// constructor
	function TweetAccount() payable {
		numberOfTweets = 0;
		adminAddress = msg.sender;
		users=TweetRegistry(adminAddress);
		user_count=users.getNumberOfAccounts();
	}
	
	// returns true if caller of function ("sender") is admin
	function isAdmin() constant returns (bool isAdmin) {
		return msg.sender == adminAddress;
	}
	
	// create new tweet
	function tweet(string tweet) returns (int result) {
		if (!isAdmin()) {
			// only owner is allowed to create tweets for this account
			result = -1;
		} else if (bytes(tweet).length > 32) {
			// tweet contains more than 32 bytes
			result = -2;
		} else {
			tweets[numberOfTweets] = tweet;
			users.setUserTweets(msg.sender,numberOfTweets,tweet);
			numberOfTweets++;
			result = 0; // success
		}
	}
	
	function getMyTweet(uint tweetId) constant returns (string tweet) {
		// returns two values
		tweet = tweets[tweetId];
	}
	
	function getOwnerAddress() constant returns (address adminAddress) {
		return adminAddress;
	}
	
	function getMyTweetCount() constant returns (uint numberOfTweets) {
		return numberOfTweets;
	}

	// other users can send donations to your account: use this function for donation withdrawal
	function adminRetrieveDonations(address receiver) {
		if (isAdmin()) {
			receiver.send(this.balance);
		}
	}
	
	function adminDeleteAccount() 
	{
		if (isAdmin()) {
			suicide(adminAddress); // this is a predefined function, it deletes the contract and returns all funds to the owner's address
		}
	}	
	function getUserCount() returns (uint)
	{
	    return users.getNumberOfAccounts();
	}
	function fetchAllUsers() returns (address,string)
	{
	    user_count--;
	    return users.getUsers(user_count);
	    
	}
	function getUserTweet(string name) returns(string[])
	{
	    address a=users.getAddressOfName(name);
	    return users.getUserTweets(a);
	}
	
}
