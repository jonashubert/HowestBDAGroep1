pragma solidity ^0.4.17;

import './DocManagerEnabled.sol';

// The Doc Auth database
contract DocAuthDB is DougEnabled {

   //This is where we keep all the contracts
    mapping(bytes32 => Document) private documentLibrary;

    /// Function gets an entry from the document library. Returns the metadata of the document.
    /// Will always return a Document object, even when the document doesn't exist.
    /// Check the property "isInitialized" to confirm it's not an empty value.
    function getDocument(bytes32 _hash) public view returns (bytes32,bytes32,bytes32,uint256,uint256, bool) {
        //todo: teruggeven van struct is blijkbaar niet goed. Hervormen naar "losse variabelen".
        //https://ethereum.stackexchange.com/questions/3609/returning-a-struct-and-reading-via-web3/3614#3614
        Document storage _document = documentLibrary[_hash];
        return (_document.author, _document.title, _document.email, _document.dateWritten, _document.dateRegistered, _document.isInitialized);
    }

    function register(bytes32 _hash, bytes32 _author,bytes32 _title,bytes32 _email,uint256 _dateWritten) public returns (bool) {
        if (DOUG != 0x0) {
            address docauth = ContractProvider(DOUG).contracts("docauth");
            if (msg.sender == docauth && !isDocumentRegistered(_hash) ) {
                Document storage _document = documentLibrary[_hash];
                _document.author = _author;
                _document.title = _title;
                _document.email = _email;
                _document.dateWritten = _dateWritten;
                _document.dateRegistered = block.timestamp;
                _document.isInitialized = true;

                return true;
            }
           else {
               // Return if registration cannot be made
               //msg.sender.send(msg.value);
               return false; 
            }
        }
            
    }

    function isDocumentRegistered(bytes32 _hash) public view returns (bool) {
        bool _storedIsInitialized;
        (, , , , , _storedIsInitialized) = getDocument(_hash);
        return _storedIsInitialized;
    }

    struct Document {
        bytes32  author;
        bytes32  title;
        bytes32  email;
        uint256  dateWritten;
        uint256  dateRegistered;
        bool  isInitialized;
    }


} 