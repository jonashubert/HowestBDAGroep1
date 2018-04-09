const DOUG = artifacts.require('DOUG')
const DocAuth = artifacts.require('DocAuth')
const DocManager = artifacts.require('DocManager');
const DocAuthDB = artifacts.require('DocAuthDB')

contract('DOUG', () => {
  let DOUGinstance, DocAuthinstance, DocManagerinstance, DocAuthDBinstance, _author="test",_title = "test title", _email = "test@test.com", _hash = "1234567890", _dateWritten = 20180328210000, _dateRegistered = 20180328210000
  it("Should add a newly deployed contract (DocAuth) to the register", () => {
    return DOUG.deployed().then(instance => {
      DOUGinstance = instance
      return DocAuth.deployed()
    }).then(instance => {
      DocAuthinstance = instance
      expect(() => {
        return DOUGinstance.addContract("DocAuth", DocAuthinstance.address)
     }).to.not.throw()
    })
  })
  it("Should add DocManager to the register", () => {
    return DocManager.deployed().then(instance => {
      DocManagerinstance = instance
      expect(() => {
        return DOUGinstance.addContract("DocManager", DocManagerinstance.address)
      }).to.not.throw()
    })
  })
  it("Should add DocAuthDB to the register", () => {
    return docAuthDB.deployed().then(instance => {
      DocAuthDBinstance = instance
      expect(() => {
        return DOUGinstance.addContract("DocAuthDB", DocAuthDBinstance.address)
      }).to.not.throw()
    })
  })
  it("Should call register and register doc", () => {
    return DocAuthinstance.register(_hash, _author, _title, _email, _dateWritten).then(() => {
      return DocAuthDB.getDocument.call(_hash)
    }).then(x => {
      assert.equal(x[0], _hash, "numbers should be equal")
    })
  })
  it("Should remove DocAuthDB", () => {
    return DOUGinstance.removeContract("DocAuthDB").then(() => {
      return DOUGinstance.getContract.call("DocAuthDB")
    }).then(res => {
      assert.equal(res, "0x0000000000000000000000000000000000000000", "Address should be 0x0")
    })
  })
  it("Should remove DocManager", () => {
    return Douginstance.removeContract("DocManager").then(() => {
      return DOUGinstance.getContract.call("DocManager")
    }).then(res => {
      assert.equal(res, "0x0000000000000000000000000000000000000000", "Address should be 0x0")
    })
  })
  it("Should remove DocAuth", () => {
    return DOUGinstance.removeContract("DocAuth").then(() => {
      return DOUGinstance.getContract.call("DocAuth")
    }).then(res => {
      assert.equal(res, "0x0000000000000000000000000000000000000000", "Address should be 0x0")
    })
  })
})