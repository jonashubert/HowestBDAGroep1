var Doug = artifacts.require("DOUG");
var DocAuthDB = artifacts.require("DocAuthDB");
var DocManager = artifacts.require("DocManager");
var DocAuth = artifacts.require("DocAuth");



/*module.exports = function(deployer) {
  deployer.deploy(Doug).then(() => {
    return deployer.deploy([
    DocAuth,
    DocAuthDB,
    DocManager
  ]);
});
}*/

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
  return DOUGinst.addContract("DocAuth", DocAuthinst.address);
}).then(function(instance) {
  // Get the deployed instance of DocAuthDB
    return DocAuthDB.deployed;
}).then(function(instance) {
    DocAuthDBinst = instance;
    return DOUGinst.addContract("DocAuthDB", DocAuthDBinst.address);
}).then(function(){
    // Get the deployed instance of DocManager
    return DocManager.deployed;
}).then(function(instance){
  // Add DocManager to doug contract
    DocManagerinst = instance;
    return Douginst.addContract("DocManager", DocManagerinst.address);

})


//http://truffleframework.com/docs/getting_started/migrations
