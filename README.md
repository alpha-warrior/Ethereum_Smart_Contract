# Ethereum Smart Contract to buy and sell Netflix Screens securely over a Blockchain
This work was done for the course Distributing Trust and Blockchains offered in A2k21 by Dr. Sujit Gujjar. 

### Team **KATana**: Kushagra, Akshit and Tathagata
---

The project has been coded in **Solidity** and is deployed using **Truffle**. **Doxygen** comments are enabled for the code and can be accessed using the index.html file in the html folder.

The working logic for the code is described below:

1. A Seller lists a new item (Netflix screen) using the listItem() function and provides a name, description and price for the newly listed item.
2. A Potential buyer of a Netflix screen can view all the available listings using the viewAwailItems() function.
3. The buyer has chosen the screen he wants to buy and then calls the buyItem() function providing the listing id of the screen and his public key. His public key is important as it will be used to encrypt the Netflix password so that no one else can access it. When he calls the buyItem() function he is expected to also send Wei equal to the price of the screen in the msg.value parameter. This is stored in the Contract's address for now.
4. The Seller of the product first fetches the Buyer's public key using the get_public_key() function.
5. On getting the public key, the Seller encrypts the Netflix password and creates the cipher text which it then sends to the Seller using the send_encrypted_string() function. As soon as the encrypted cipher text is sent to the Buyer, the price for the Screen, which was staged in the Contract's address, is transferred to the Seller's account.
6. The Buyer can then fetch the encrypted string using the get_encrypted_string() function and then decrypt it using his private key. He has now retrieved the Netflix Password and can now **Netflix and Chill**
---







