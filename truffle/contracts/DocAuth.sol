pragma solidity ^0.4.18;

// Doc Auth

contract DocAuth is DocManagerEnabled {

    // Attempt to register the document
    function register(bytes32 _hash, bytes32 _author,bytes32 _title,bytes32 _email,uint256 _dateWritten) public returns (bool res) {
        if (!isDocManager()) {
            return false;
        }

        address docauthdb = ContractProvider(DOUG).contracts("docauthdb");
        if(docauthdb == 0x0) {
            // document can not be registered
            // Note - if registration costs money we should return it msg.sender.send(msg.value);
            return false;
        }

        // Use the interface to call on the docauthdb contract. We pass allong all the parameters as well
        bool success = DocAuthDB(docauthdb).register.value(_hash, _author, _title, _email, _dateWritten);

        // if the transation failed, return the ether to the caller.
        // note : we rekenen voor de moment geen kost aan -> dus dit stukje is misschien wat overbodig ?
        if (!success) {
            msg.sender.send(msg.value);
        }
        return success;
    }
}