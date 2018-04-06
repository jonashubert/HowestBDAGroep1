App = {
  web3Provider: null,
  contracts: {},

  init: function() {
    return App.initWeb3();
  },

  initWeb3: function() {
    // Is there an injected web3 instance?
    if (typeof web3 !== 'undefined') {
      App.web3Provider = web3.currentProvider;
    } else {
      // If no injected web3 instance is detected, fall back to Ganache
      App.web3Provider = new Web3.providers.HttpProvider('http://localhost:8545');
    }
    web3 = new Web3(App.web3Provider);


    return App.initContract();
  },

  initContract: function() {
    $.getJSON('DocAuth.json', function(data) {
      // Get the necessary contract artifact file and instantiate it with truffle-contract
      var DocAuthArtifact = data;
      App.contracts.DocAuth = TruffleContract(DocAuthArtifact);

      // Set the provider for our contract
      App.contracts.DocAuth.setProvider(App.web3Provider);
    });

    return App.bindEvents();
  },

  bindEvents: function() {
    $(document).on('click', '#registerButton', App.register);
  },

  register: function(event) {
    event.preventDefault();

    var docAuthChecker;

    web3.eth.getAccounts(function(error, accounts) {
      if (error) {
        console.log(error);
      }

      var account = accounts[0];

      App.contracts.DocAuth.deployed().then(function(instance) {
        docAuthChecker = instance;


        var fileInput = document.getElementById('document');
        var file = fileInput.files[0];
        var reader = new FileReader();

        //note: gebruik van FileReader maakt het erg beperkt qua browser support
        //todo: uitzoeken welke, of het aanvaardbaar is. indien niet, anders oplossen.
        reader.onload = function(e) {
          //(bytes32 _hash, bytes32 _author,bytes32 _title,bytes32 _email,uint256 _dateWritten,uint256 _dateRegistered)
          var hash = web3.sha3(reader.result);


          docAuthChecker.getDocument.call(hash).then(
            function(tuple) {
              var isInitialized = tuple[5];
              if (isInitialized) {
                var author = web3.toAscii(tuple[0]);
                var title = web3.toAscii(tuple[1]);
                var email = web3.toAscii(tuple[2]);
                var dateWritten = tuple[3];
                var dateRegistered =  tuple[4];
$('#docinfo').css('font-size','120%');
$("#docinfo").append("<h3>This document was already registered! Here's some information about it:</h3>")
                $("#docinfo").append('<p>Author: ' + author + '</p>')
                $("#docinfo").append('<p>Title: ' + title + '</p>')
                $("#docinfo").append('<p>Author\'s emailaddress: ' + email + '</p>')
                $("#docinfo").append('<p>Written on: ' + dateWritten + '</p>')
                $("#docinfo").append('<p>Registered on: ' + dateRegistered + '</p>')

              } else {
                var date = $('#dateWrittenInput').datetimepicker('viewDate')
                var dateFormatted = parseInt(date.toISOString().slice(0,10).replace(/-/g,""));
                //register(bytes32 _hash, bytes32 _author,bytes32 _title,bytes32 _email,uint256 _dateWritten
                var author = web3.toHex($('#author').val());
                var title = web3.toHex($('#title').val());
                var email = web3.toHex($('#email').val());
                var result = docAuthChecker.register(hash, author, title, email , dateFormatted, {from: account});
              }
            }
          )
        }

        reader.readAsText(file);

        return null;
      }).catch(function(err) {
        console.log(err.message);
      });
    });
  }

};

$(function() {
  $(window).on('load', function() {
    App.init();
  });
});
