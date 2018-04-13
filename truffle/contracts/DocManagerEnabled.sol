pragma solidity ^0.4.17;

import './DougEnabled.sol';


// Base class for contracts that only allow the docmanager to call them.
// Note that it inherits from DougEnabled
contract DocManagerEnabled is DougEnabled {

    //makes it easier to check that fundmanager is the caller.
<<<<<<< HEAD
    function isDocManager() public constant returns (bool) {
=======
    function isDocManager() public returns (bool) {
>>>>>>> 116f95d46c13abd12d6717222fd97b469a786ff1
        if(DOUG != 0x0) {
            address dm = ContractProvider(DOUG).contracts("docmanager");
            return msg.sender == dm;
        }
        return false;
    }
<<<<<<< HEAD
}
=======
}
>>>>>>> 116f95d46c13abd12d6717222fd97b469a786ff1
