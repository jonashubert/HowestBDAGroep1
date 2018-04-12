const Doug = artifacts.require("./DOUG.sol");
const DocAuthDB = artifacts.require("./DocAuthDB.sol");
const DocManager = artifacts.require("./DocManager.sol");
const DocAuth = artifacts.require("./DocAuth.sol");



/*module.exports = function(deployer) {
  deployer.deploy(Doug).then(() => {
    return deployer.deploy([
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
