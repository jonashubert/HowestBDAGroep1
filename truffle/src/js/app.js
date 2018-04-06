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
          var hash = CryptoJS.SHA1(reader.result).toString();


          docAuthChecker.isDocumentRegistered.call(hash).then(
            function(exists) {
              if (exists) {
                /*docAuthChecker.getDocument.call(hash).then (
                  function(result) {
                    var res = "Document already registered: " + "<br> Document Owner: " + result[0];
                    $("#docinfo").html(res);*/
                    $("#docinfo").html("Exists");
                 // }
               // )
              } else {
                var date = $('#dateWrittenInput').datetimepicker('viewDate')
                var dateFormatted = parseInt(date.toISOString().slice(0,10).replace(/-/g,""));
                //register(bytes32 _hash, bytes32 _author,bytes32 _title,bytes32 _email,uint256 _dateWritten
                var result = docAuthChecker.register(hash, $('#author').val(), $('#title').val(), $('#email').val(), dateFormatted, {from: account});
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
