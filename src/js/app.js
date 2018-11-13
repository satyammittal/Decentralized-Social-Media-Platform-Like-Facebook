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
  var address = $('#address').val();
  App.contracts.Chat.deployed().then(function(instance) {
  //  return instance.vote(username, { from: App.account });
    console.log(instance.register(username, address, { from: address }));
    return instance.register(username, address, { from: address });
  }).then(function(result) {
    console.log(result);
    // Wait for votes to update
    $("#content").hide();
    $("#loader").show();
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
