var Doug = artifacts.require("DOUG");
var DocAuthDB = artifacts.require("DocAuthDB");
var DocManager = artifacts.require("DocManager");
var DocAuth = artifacts.require("DocAuth");



module.exports = function(deployer) {
  deployer.deploy(DOUG).then(() => {
    return deployer.deploy([
    DocAuth,
    DocAuthDB,
    DocManager
  ]);
});
}

//http://truffleframework.com/docs/getting_started/migrations