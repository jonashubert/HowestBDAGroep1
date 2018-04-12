pragma solidity ^0.4.17;

import './DougEnabled.sol';

// The Doug contract
contract Doug {
    address owner;

    //This is where we keep all the contracts.
    mapping (bytes32 => address) public contracts;

    modifier onlyOwner { // a modifier to reduce code replication
        if (msg.sender == owner) // this ensures that only the owner can access the function
        _;
    }
    //Constructor
    function Doug() public {
        owner = msg.sender;
    }

    // Add a new contract to Doug. This will overwrite an existing contract.
    function addContract(bytes32 name, address addr) public returns (bool result) {
            DougEnabled de = DougEnabled(addr);
            // Don't add the contract if this does not work.
            if (!de.setDOUGAddress(address(this)) ) {
                return false;
            }
            contracts[name] = addr;
            return true;
    }

    // Remove a contract from Doug. We could also selfdestruct if we want to.
    function removeContract(bytes32 name) onlyOwner public returns (bool result){
        if (contracts[name] == 0x0) {
            return false;
        }
        contracts[name] = 0x0;
        return true;
    }

    function remove() onlyOwner public {
        address dm = contracts["docmanager"];
        address docauth = contracts["docauth"];
        address docauthdb = contracts["docauthdb"];

        // Remove everything
        if (dm != 0x0) {DougEnabled(dm).remove();}
        if (docauth != 0x0) {DougEnabled(docauth).remove();}
        if (docauthdb != 0x0) {DougEnabled(docauthdb).remove();}
    }
}
