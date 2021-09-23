const Netflix = artifacts.require("Netflix");
const EthCrypto = require("eth-crypto");
const web3 = require("web3");
const buyerid = EthCrypto.createIdentity();
const sellerid = EthCrypto.createIdentity();
const bpublic = buyerid.publicKey;
const bprivate = buyerid.privateKey;
const spublic = sellerid.publicKey;
const sprivate = sellerid.privateKey;
const item1 = "screen1";
const item2 = "screen2";

contract("Netflix", (accounts) => {
    let [buyer, seller] = accounts;

    // start here

    it("should be able to create a new zombie", async () => {
        const contractInstance = await Netflix.new();
        console.log("Starting test");
        let avail = await contractInstance.viewAvailItems({from: buyer});
        console.log(avail);
        console.log("Listing new item.")
        await contractInstance.listItem("screen 1", "new Netflix Screen", 10, {from: seller});
        await contractInstance.listItem("screen 2", "new Netflix Screen", 5, {from: seller});
        avail = await contractInstance.viewAvailItems({from: buyer});
        console.log(avail);
        const encrypted = await EthCrypto.encryptWithPublicKey(
            bpublic, // encrypt with alice's publicKey
            item1
          );
        const decrypted = await EthCrypto.decryptWithPrivateKey(
            bprivate,
            encrypted
          );
        console.log("Encrypted string:")
        console.log(encrypted)
        console.log("Decrypted string:")
        console.log(decrypted)
        // await contractInstance.buyItem(1, bpublic, {from: buyer, value:web3.utils.toWei(10, "ether")});
    })

    //define the new it() function
})
