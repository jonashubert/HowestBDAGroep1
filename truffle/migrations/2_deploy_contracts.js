var ContractProvider = artifacts.require("ContractProvider");
var Doug = artifacts.require("Doug");
var DocAuthDB = artifacts.require("DocAuthDB");
var DocManager = artifacts.require("DocManager");
var DocManagerEnabled = artifacts.require("DocManagerEnabled");
var DougEnabled = artifacts.require("DougEnabled");
var DocAuth = artifacts.require("DocAuth");



/*module.exports = function(deployer) {
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
});
}*/

module.exports = function(deployer){
    deployer.then(function() {
    //Create a new version of DOUG
    return Doug.new();
  }).then(function(instance) {
    DOUGinst = instance;
    // Get the deployed instance of DocAuth
    return DocAuth.deployed();
  }).then(function(instance){
    DocAuthinst = instance;
    // Add DocAuth contract to DOUG
    return DOUGinst.addContract("docauth", DocAuthinst.address);
  }).then(function(instance) {
    // Get the deployed instance of DocAuthDB
      return DocAuthDB.deployed;
  }).then(function(instance) {
      DocAuthDBinst = instance;
      return DOUGinst.addContract("docauthdb", DocAuthDBinst.address);
  }).then(function(){
      // Get the deployed instance of DocManager
      return DocManager.deployed;
  }).then(function(instance){
    // Add DocManager to doug contract
      DocManagerinst = instance;
      return Douginst.addContract("docmanager", DocManagerinst.address);

  })
}

//http://truffleframework.com/docs/getting_started/migrations
