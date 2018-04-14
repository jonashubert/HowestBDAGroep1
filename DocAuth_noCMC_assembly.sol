pragma solidity ^0.4.21;

contract DocAuth {
   //This is where we keep all the contracts
    mapping(bytes32 => Document) private documentLibrary;
    bytes32[] hashArray;

    /// Function gets an entry from the document library. Returns the metadata of the document.
    /// Will always return a Document object, even when the document doesn't exist.
    /// Check the property "isInitialized" to confirm it's not an empty value.
    function getDocument(bytes32 _hash) public view returns (bytes32,bytes32,bytes32,uint256,uint256, bool) {
        //todo: teruggeven van struct is blijkbaar niet goed. Hervormen naar "losse variabelen".
        //https://ethereum.stackexchange.com/questions/3609/returning-a-struct-and-reading-via-web3/3614#3614
        Document storage _document = documentLibrary[_hash];
        return (_document.author, _document.title, _document.email, _document.dateWritten, _document.dateRegistered, _document.isInitialized);
    }
    
    function getAuthorOfDoc(bytes32 _hash) public view returns (bytes32) {
        bytes32 _author;
        (_author, , , , , ) = getDocument(_hash);
        return _author;
    }

    function register(bytes32 _hash, bytes32 _author,bytes32 _title,bytes32 _email,uint256 _dateWritten) public returns (bool)
    {
       if(!isDocumentRegistered(_hash))
       {
           Document storage _document = documentLibrary[_hash];
           _document.author = _author;
           _document.title = _title;
           _document.email = _email;
           _document.dateWritten = _dateWritten;
           _document.dateRegistered = block.timestamp;
           _document.isInitialized = true;
           
           hashArray.push(_hash);

           return true;
       }
       else { return false; }
    }

    function isDocumentRegistered(bytes32 _hash) public view returns (bool) {
        bool _storedIsInitialized;
        (, , , , , _storedIsInitialized) = getDocument(_hash);
        return _storedIsInitialized;
    }
    
    function findDocument(bytes32 _input) public view returns (bool out) {
        uint arrayLength = hashArray.length;
        bytes4 sig = bytes4(keccak256("getAuthorOfDoc(uint256)"));
        DocAuth dc = this;
        assembly {
            let i:= 0
            loop:
            let ptr := mload(0x40)
            mstore(ptr,sig)
            mstore(add(ptr,0x04), mload(add(add(hashArray_slot, 0x20), mul(i, 0x20))))
            let result := call(
              15000, // gas limit
              sload(dc),  // to addr. append var to _slot to access storage variable
              0, // not transfer any ether
              ptr, // Inputs are stored at location ptr
              0x20, // Inputs are 32 bytes long
              ptr,  //Store output over input
              0x20) //Outputs are 32 bytes long
            if eq(_input, result) {
                out := "true"
            }
            i := add(i, 1)
            jumpi (loop, lt(i, arrayLength))
        }
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
