pragma solidity ^0.4.0;
contract Chat{
    
    // data structure of a single tweet
	struct Tweet {
		uint timestamp;
		string tweetString;
	}

    mapping (address => string) _addressToAccountName;
    mapping (uint => address) _accountIdToAccountAddress;
    mapping (string => address) _accountNameToAddress;
    mapping (uint => Tweet) _tweets;
    mapping (uint => string) _TweetToaccountId;

    uint256 _numberOfAccounts=0;
    uint _numberOfTweets=0;

    function Chat() {
        _numberOfAccounts = 0;
        _numberOfTweets = 0;
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

	function unregister() returns (string unregisteredAccountName) {
		unregisteredAccountName = _addressToAccountName[msg.sender];
		_addressToAccountName[msg.sender] = "";
		_accountNameToAddress[unregisteredAccountName] = address(0);
		// _accountIdToAccountAddress is never deleted on purpose
	}

    function tweet(string tweetString) returns (int result) {
		if (bytes(tweetString).length > 160) {
			// tweet contains more than 160 bytes
			result = -2;
		} else {
			_tweets[_numberOfTweets].timestamp = now;
			_tweets[_numberOfTweets].tweetString = tweetString;
			_TweetToaccountId[_numberOfTweets] = _addressToAccountName[msg.sender];
            _numberOfTweets++;
			result = 0; // success
		}
	}


    function tweetaddr(string tweetString, address addr) returns (int result) {
		if (bytes(tweetString).length > 160) {
			// tweet contains more than 160 bytes
			result = -2;
		} else {
			_tweets[_numberOfTweets].timestamp = now;
			_tweets[_numberOfTweets].tweetString = tweetString;
			_TweetToaccountId[_numberOfTweets] = _addressToAccountName[addr];
            _numberOfTweets++;
			result = 0; // success
		}
	}

    function getNumberOfTweets() constant returns (uint numberOfTweets) {
		return _numberOfTweets;
	}

    function getTweet(uint tweetId) constant returns (string tweetString, uint timestamp, string username) {
		// returns two values
		tweetString = _tweets[tweetId].tweetString;
		timestamp = _tweets[tweetId].timestamp;
        username = _TweetToaccountId[tweetId];
	}


}