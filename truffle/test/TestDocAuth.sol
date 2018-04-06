pragma solidity ^0.4.17;

import "truffle/Assert.sol";
import "truffle/DeployedAddresses.sol";
import "../contracts/DocAuth.sol";

contract TestDocAuth {
  DocAuth docAuthChecker = DocAuth(DeployedAddresses.DocAuth());

  bytes32 author = "test";
  bytes32 title = "test title";
  bytes32 email = "test@test.com";
  bytes32 hash = "1234567890";
  uint256 dateWritten = 20180328210000;
  uint256 dateRegistered = 20180328210000;

  //testing the register function
  function testRegister() public {
    //(bytes32 _hash, bytes32 _author,bytes32 _title,bytes32 _email,uint256 _dateWritten,uint256 _dateRegistered, bool _isInitialized)
    bool added = docAuthChecker.register(hash, author, title, email, dateWritten);

    Assert.equal(added, true, "Document should be registered.");
  }

  // Testing the getDocument() function
  function testGetDocument() public {
    bool _storedIsInitialized;
    bytes32 _author;
    bytes32 _title;
    bytes32 _email;

    uint256 _dateWritten;
    uint256 _dateRegistered;
    (_author, _title, _email, _dateWritten, _dateRegistered, _storedIsInitialized) = docAuthChecker.getDocument(hash);

    Assert.equal(_storedIsInitialized, true, "Document should be initialized.");
    Assert.equal(_author, author, "Author not as expected.");
    Assert.equal(_title, title, "Title not as expected.");
    Assert.equal(_email, email, "Email not as expected.");
    Assert.equal(_dateWritten, dateWritten, "Date Written not as expected.");
    //Assert.equal(_dateRegistered, dateRegistered, "Date Registered not as expected.");
  }
}
