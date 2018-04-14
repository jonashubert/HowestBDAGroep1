pragma solidity ^0.4.17;

import './DougEnabled.sol';
import './DocAuth.sol';

// The Doc Manager

contract DocManager is DougEnabled {

    // We still want a owner
    address owner;

    //Constructor
    function DocManager () public {
        owner  = msg.sender;
    }

    // Attempt to register the document
    function register(bytes32 _hash, bytes32 _author,bytes32 _title,bytes32 _email,uint256 _dateWritten) public returns (bool) {
        if (_hash == 0x0 || _author == 0x0 || _title == 0x0 || _email == 0x0 || _dateWritten == 0) {
            return false;
        }

        address docauth = ContractProvider(DOUG).contracts("docauth");
        //address permsdb = ContractProvider(DOUG).contracts("permsdb");

       // if (docauth == 0x0 || permsdb == 0x0 || PermissionsDB(permsdb).perms(msg.sender) < 1 ) {
           if (docauth == 0X0 ) {
            // if the user send money, we should return it if we can't register
            //msg.sender.send(msg.value);
            return false;
        }

        // Use the interface to call on the bank contract. We pass the parameters along as well.

        bool success = DocAuth(docauth).register(_hash, _author, _title, _email, _dateWritten);

        // if the transaction failed, return the Ether to the caller
        if (!success) {
           // msg.sender.send(msg.value);
        }
        return success;

    }

    function getDocument(bytes32 _hash) public view returns (bytes32,bytes32,bytes32,uint256,uint256, bool) {
            address docauth = ContractProvider(DOUG).contracts("docauth");
            bytes32 docAuthor;
            bytes32 docTitle;
            bytes32 docEmail;
            uint256 docdateWritten;
            uint256 docdateRegistered;
            bool docisInitialized;


            (docAuthor, docTitle, docEmail, docdateWritten, docdateRegistered, docisInitialized) = DocAuth(docauth).getDocument(_hash);


         return (docAuthor, docTitle, docEmail, docdateWritten, docdateRegistered, docisInitialized);
     }

	 function getDocumentByAuthorName(bytes32 _author) public view returns (bytes32[10]) {
		 address docauth = ContractProvider(DOUG).contracts("docauth");

		 return DocAuth(docauth).getDocumentByAuthorName(_author);
	}
}
