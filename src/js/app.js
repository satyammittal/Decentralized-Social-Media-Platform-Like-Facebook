App = {
  web3Provider: null,
  contracts: {},


  init: function() {
    return App.initWeb3();
  },


  initWeb3: function() {
    // TODO: refactor conditional
    if (typeof web3 !== 'undefined') {
      // If a web3 instance is already provided by Meta Mask.
      App.web3Provider = web3.currentProvider;
      web3 = new Web3(web3.currentProvider);
    } else {
      // Specify default instance if no web3 instance provided
      App.web3Provider = new Web3.providers.HttpProvider('http://localhost:7545');
      web3 = new Web3(App.web3Provider);
      
    }
    return App.initContract();
  },

  initContract: function() {
    $.getJSON("Chat.json", function(chat) {
      // Instantiate a new truffle contract from the artifact
      App.contracts.Chat = TruffleContract(chat);
      // Connect provider to interact with contract
      App.contracts.Chat.setProvider(App.web3Provider);

      App.listenForEvents();

      return App.render();
    });
},
listenForEvents: function() {
  // TODO TRIGGER NEW TWEET ADDED
},
render: function() {
  var electionInstance;
  var loader = $("#loader");
  var content = $("#content");
  loader.hide();
  content.show();

  // Load account data
  web3.eth.getCoinbase(function(err, account) {
    if (err === null) {
      App.account = account;
      $("#accountAddress").html("Your Account: " + account);
    }
});
},
login: function() {
  var username = $('#username').val();
  //console.log(username);
  var address = $('#address').val();
  App.contracts.Chat.deployed().then(function(instance) {
  //  return instance.vote(username, { from: App.account });
    return instance.register(username, address, {from: web3.eth.accounts[1], gas:3000000});
  }).then(function(result) {
    console.log(result);
    // Wait for votes to update
    $("#content").hide();
    $("#loader").show();
    App.checkposts();
    $("#posts").show();
  }).catch(function(err) {
    console.error(err);
  });
},
checkposts: function(){
  var paras = document.getElementsByClassName('myposts');
  $('.myposts').remove();
  var ans = new Array();
  var gettweet = function(val) 
  {
    App.contracts.Chat.deployed().then(function(instance) {
      //  return instance.vote(username, { from: App.account });
        return instance.getTweet(val, {from: web3.eth.accounts[1], gas:3000000});
      }).then(function(result) {
        var res = result;
        var mess = res[0];
        var user = res[2];
        ans[0] = mess;
        ans[1] = user;
        var ul = $('#allposts');
        var child = ul.find('li:first').clone(true);
        child[0].style.display="block";
        console.log(child[0].querySelector("#postname"));
        child[0].querySelector("#postname").text = user;
        child[0].querySelector("#postmessage").innerHTML = mess;
        child[0].classList.add("myposts");
        child.appendTo(ul);
      }).catch(function(err) {
        console.error(err);
      });
      
  };
  

  App.contracts.Chat.deployed().then(function(instance) {
    //  return instance.vote(username, { from: App.account });
      return instance.getNumberOfTweets({from: web3.eth.accounts[1], gas:3000000});
    }).then(function(result) {
      for (i = 0; i < result['c'][0]; i++) { 
        gettweet(i)
      }
    }).catch(function(err) {
      console.error(err);
    });
},
post: function() {
  var tweet = $('#tweet').val();
  $('#tweet').val("");
  App.contracts.Chat.deployed().then(function(instance) {
  //  return instance.vote(username, { from: App.account });
    return instance.tweet(tweet, {from: web3.eth.accounts[1], gas:3000000});
  }).then(function(result) {
    console.log(result);
    // Wait for votes to update
    $("#posts").show();
    App.checkposts();
  }).catch(function(err) {
    console.error(err);
  });
},

  bindEvents: function() {
    $(document).on('click', '.btn-adopt', App.handleAdopt);
  },

  markAdopted: function(adopters, account) {
    /*
     * Replace me...
     */
  },

  handleAdopt: function(event) {
    event.preventDefault();

    var petId = parseInt($(event.target).data('id'));

    /*
     * Replace me...
     */
  }

};

$(function() {
  $(window).load(function() {
    App.init();
  });
});
