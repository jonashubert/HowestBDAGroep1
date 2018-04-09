pragma solidity ^0.4.17;

// Permissions
contract Permissions is DocManagerEnabled {
    
    //set the permissions of an account.
    function setPermission(address addr, uint8 perm) returns (bool res){
        if (!isDocManager()){
            return false;
        }
        address permdb = ContractProvider(DOUG).contracts("permsdb");
        if (permdb == 0x0) {
            return false;
        }
        return PermissionsDB(permdb).setPermission(addr, perm);
    }
}