// MWE for the assembly alternative to the getDocumentByAuthorName function.
// Code compiles, but does not generate a result due to an intractable bug that remains in the assembly code

contract DocAuth {

    mapping(bytes32 => Document) private documentLibrary;
    bytes32[] hashArray;
    address addr = this;

    function register(bytes32 _hash, bytes32 _author,bytes32 _title,bytes32 _email,uint256 _dateWritten) public returns (bool) {
        if (!isDocumentRegistered(_hash) ) {
            Document storage _document = documentLibrary[_hash];
            _document.author = _author;
            _document.title = _title;
            _document.email = _email;
            _document.dateWritten = _dateWritten;
            _document.dateRegistered = block.timestamp;
            _document.isInitialized = true;

			hashArray.push(_hash);
            return true;
        } else {
            return false;
        }
    }

    function isDocumentRegistered(bytes32 _hash) public view returns (bool) {
        bool _storedIsInitialized;
        (, , , , , _storedIsInitialized) = getDocument(_hash);
        return _storedIsInitialized;
    }

    function getAuthorOfDoc(bytes32 _hash) public view returns (bytes32) {
	    bytes32 _author;
	    (_author, , , , , ) = getDocument(_hash);
	    return _author;
   }

   function getDocument(bytes32 _hash) public view returns (bytes32,bytes32,bytes32,uint256,uint256, bool) {
        //todo: teruggeven van struct is blijkbaar niet goed. Hervormen naar tuple.
        //https://ethereum.stackexchange.com/questions/3609/returning-a-struct-and-reading-via-web3/3614#3614
        Document storage _document = documentLibrary[_hash];
        return (_document.author, _document.title, _document.email, _document.dateWritten, _document.dateRegistered, _document.isInitialized);
    }

   function getDocumentByAuthorNameAsm(bytes32 _author) public returns (bytes32[5] title,uint256[5] dateWritten, uint256[5] dateRegistered, bool[5] isInitialized, bytes32 author, bytes32 email) {
       bytes32[] memory hashArrayIntern = hashArray;
       bytes32[] memory resArray;
       uint arrayLength = hashArray.length;

       bytes4 sig = bytes4(keccak256("getAuthorOfDoc(bytes32)"));

	   assembly {
            let ptr := mload(0x40)
            mstore(ptr,sig)
            let resArray := msize() // Get the highest available block of memory
            mstore(add(resArray, 0x00), 5) //set size to 5

            let i:= 0
            loop:
            mstore(add(ptr, 0x04), add(hashArrayIntern, add(0x20, mul(i, 0x20))))
            let result := call(
              15000, // gas limit
              sload(addr_slot),  // to addr. append var to _slot to access storage variable
              0, // not transfer any ether
              ptr, // Inputs are stored at location ptr
              0x24, // Inputs are 36 bytes long
              ptr,  //Store output over input
              0x20) //Outputs are 32 bytes long

              if eq(mload(ptr), _author) {
              	mstore(add(resArray, add(0x20, mul(i, 0x20))), add(ptr, 0x20)) // if match, add the document hash to resArray
              }

            i := add(i, 1)
            jumpi (loop, lt(i, arrayLength))

            mstore(0x40, add(resArray, mul(add(i, 1), 0x20))) // update the offset
        } //end assembly


		// Retrieve the found docs from the mappings
		for (uint i = 0; i < 5; i++)    {
            (, title[i], , dateWritten[i], dateRegistered[i], isInitialized[i]) = getDocument(resArray[i]);
        }
        (author, , , , ,) = getDocument(resArray[0]);
        (, , email, , ,) = getDocument(resArray[0]);
        return (title, dateWritten, dateRegistered, isInitialized, author, email);
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
