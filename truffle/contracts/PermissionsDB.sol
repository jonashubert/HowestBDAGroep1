pragma solidity ^0.4.17;

// Permissions database

contract PermissionsDb is DougEnabled {
    
    mapping (address => uint8) public permss;

    // Set the permissions of an account.
    function setPermission(address addr, uint8 perm) returns (bool res) {
        if(DOUG != 0x0) {
            address permC = ContractProvider(DOUG).contracts("perms");
            if (msg.sender == permC) {
                perms[addr] = perm;
                return true;
            }
            return false;
        } else {
            return false;
        }
        }
    }
}