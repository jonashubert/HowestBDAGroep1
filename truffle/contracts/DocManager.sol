pragma solidity ^0.4.17;

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
        if (_hash == 0x0 || _author == 0x0 || _title == 0x0 || _email == 0x0 || _dateWritten ==0) {
            return false;
        }

        address docauth = ContractProvider(DOUG).contracts("docauth");
        address permsdb = ContractProvider(DOUG).contracts("permsdb");

        if (docauth == 0x0 || permsdb == 0x0 || PermissionsDB(permsdb).perms(msg.sender) < 1 ) {
            // if the user send money, we should return it if we can't register
            msg.sender.send(msg.value);
            return false;
        }

        // Use the interface to call on the bank contract. We pass the parameters along as well.

        bool success = DocAuth(docauth).register.value(_hash, _author, _title, _email, _dateWritten);

        // if the transaction failed, return the Ether to the caller
        if (!success) {
            msg.sender.send(msg.value);
        }
        return success;

    }

    // St the permissions for a given address.
    function setPermission (address addr, uint8 permLvl) returns (bool res) {
        if (msg.sender != owner) {
            return false;
        }
        address perms = ContractProvider(DOUG).contracts("perms");
        if (perms == 0x0 ){
            return false;
        }
        return Permissions(perms).setPermission(addr,PermLvl);
    }
}