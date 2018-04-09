pragma solidity ^0.4.17;

import './DougEnabled.sol';
import './PermissionsDB.sol';
import './DocAuth.sol';

// The Doc Manager

contract DocManager is DougEnabled {

    // We still want a owner
    address owner;

    //Constructor
    function DocManager() {
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
            msg.sender.send(msg.value);
            return false;
        }

        // Use the interface to call on the bank contract. We pass the parameters along as well.

        bool success = DocAuth(docauth).register(_hash, _author, _title, _email, _dateWritten);

        // if the transaction failed, return the Ether to the caller
        if (!success) {
            msg.sender.send(msg.value);
        }
        return success;

    }
}