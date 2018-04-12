var ContractProvider = artifacts.require("ContractProvider");
var Doug = artifacts.require("Doug");
var DocAuthDB = artifacts.require("DocAuthDB");
var DocManager = artifacts.require("DocManager");
var DocManagerEnabled = artifacts.require("DocManagerEnabled");
var DougEnabled = artifacts.require("DougEnabled");
var DocAuth = artifacts.require("DocAuth");



module.exports = function(deployer) {
    return deployer.deploy([
    Doug,
    ContractProvider,
    DocManagerEnabled,
    Doug,
    DougEnabled,
    DocAuth,
    DocAuthDB,
    DocManager
  ]);
}

//http://truffleframework.com/docs/getting_started/migrations
