var Doug = artifacts.require("./Doug.sol");
var DocAuthDB = artifacts.require("./DocAuthDB.sol");
var DocManager = artifacts.require("./DocManager.sol");
var DocAuth = artifacts.require("./DocAuth.sol");

module.exports = function(deployer){
    deployer.deploy(Doug).then(function() {
    //Get the deployed instance of DOUG
    return Doug.deployed();
  }).then(function(instance) {
    DOUGinst = instance;
   return  deployer.deploy(DocAuth);
  }).then(function(instance) {
    // Get the deployed instance of DocAuth
    return DocAuth.deployed();    
  }).then(function(instance){
    DocAuthinst = instance;
    // Add DocAuth contract to DOUG
    return DOUGinst.addContract("docauth", DocAuthinst.address);
  }).then(function(instance) {
    // Deploy DocAuthDB
     return deployer.deploy(DocAuthDB);
  }).then(function (instance) {
    //get the deployed instance of DocAuthDB
    return DocAuthDB.deployed();
  }).then(function(instance) {
      DocAuthDBinst = instance;
      // Add DocAuthDB to DOUG
      return DOUGinst.addContract("docauthdb", DocAuthDBinst.address);
  }).then(function(){
      // Deploy DocManager
      return deployer.deploy(DocManager);
  }).then(function(instance) {
     return DocManager.deployed();
  }).then(function(instance){
      DocManagerinst = instance;
      // Get the deployed instance of DocManager
      return DOUGinst.addContract("docmanager", DocManagerinst.address);
  })
}
