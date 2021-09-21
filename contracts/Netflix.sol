// SPDX-License-Identifier: MIT
pragma solidity 0.5.16;

contract Netflix {
    struct Item{
        uint listing_id;
        string name;
        string description;
        uint price;
        uint seller_id;
        uint bought;
        uint delivered;
        uint buyer_id;
        string buyer_public_key;
        string encrypted_msg;
        uint public_key_fetched;
    }

    uint sellers = 0;
    uint buyers = 0;
    uint listed_items = 0;
    mapping (uint => address) buyers_mapping;
    mapping (uint => address payable) sellers_mapping;

    mapping (address => uint) reverse_buyers_mapping;
    mapping (address => uint) reverse_sellers_mapping;

    Item[] listedItems;

    function uint2str(uint256 _i) internal pure returns (string memory str)
    {
        if (_i == 0)
        {
            return "0";
        }
        uint256 j = _i;
        uint256 length;
        while (j != 0)
        {
            length++;
            j /= 10;
        }
        bytes memory bstr = new bytes(length);
        uint256 k = length;
        j = _i;
        while (j != 0)
        {
            bstr[--k] = bytes1(uint8(48 + j % 10));
            j /= 10;
        }
        str = string(bstr);
    }

    function listItem(string memory _name, string memory _description, uint _price) public
    {
        if(reverse_sellers_mapping[msg.sender]==0)
        {
            sellers++;
            reverse_sellers_mapping[msg.sender] = sellers;
            sellers_mapping[sellers] = address(uint160(msg.sender));
            listedItems.push(Item(listed_items,_name,_description,_price,sellers,0,0,0,"NA","NA",0));
            listed_items++;
        }
        else
        {
            uint temp_seller_id = reverse_sellers_mapping[msg.sender];
            listedItems.push(Item(listed_items,_name,_description,_price,temp_seller_id,0,0,0,"NA","NA",0));
            listed_items++;
        }
    }

    function viewAvailItems() public view returns(string memory)
    {
        string memory ret = "";
        uint counter= 0;
        for (uint i=0; i < listedItems.length; i+=1) 
        {
            Item memory cur = listedItems[i];
            if (cur.bought == 0)
            {
                counter++;
                ret = string(abi.encodePacked(ret,"\n\n","**************************","\n","Listing Id: ",uint2str(cur.listing_id),"\n","Name: ",cur.name,"\n","Description: ",cur.description,"\n","Price: ",uint2str(cur.price)));
            }
        }
        if(counter!=0)
        {
            ret = string(abi.encodePacked(ret,"\n","***************************"));
        }
        else 
        {
            ret = "NO NETFLIX SCREENS ARE CURRENTLY UP FOR SALE";
        }
        return ret;
    }

    function buyItem(uint listing_id,string memory _public_key) public payable
    {
        require(msg.value==listedItems[listing_id].price,"Wrong amount paid. Please pay the correct amount to claim your item.");
        if(reverse_buyers_mapping[msg.sender]==0)
        {
            buyers++;
            reverse_buyers_mapping[msg.sender] = buyers;
            buyers_mapping[buyers] = msg.sender;
            listedItems[listing_id].bought = 1;
            listedItems[listing_id].buyer_public_key = _public_key;
            listedItems[listing_id].buyer_id = buyers;
        }
        else
        {
            listedItems[listing_id].bought = 1;
            listedItems[listing_id].buyer_public_key = _public_key;
            listedItems[listing_id].buyer_id = buyers;
        }
    }

    function get_public_key(uint listing_id) public view returns(string memory)
    {
        require(reverse_sellers_mapping[msg.sender]!=0,"You are not a seller");
        require(listedItems[listing_id].seller_id==reverse_sellers_mapping[msg.sender],"Item is not listed by you");
        require(listedItems[listing_id].bought==1,"Item not bought yet");
        listedItems[listing_id].public_key_fetched = 1;
        string memory ret = listedItems[listing_id].buyer_public_key;
        
        return ret;
    }

    function send_encrypted_string(string memory message,uint listing_id) public payable
    {
        require(reverse_sellers_mapping[msg.sender]!=0,"You are not a seller");
        require(listedItems[listing_id].seller_id==reverse_sellers_mapping[msg.sender],"Item is not listed by you");
        require(listedItems[listing_id].bought==1,"Item not bought yet");
        require(listedItems[listing_id].public_key_fetched==1,"Public Key Not Fetched Yet");
        listedItems[listing_id].encrypted_msg = message;
        listedItems[listing_id].delivered = 1;
        sellers_mapping[listedItems[listing_id].seller_id].transfer(listedItems[listing_id].price);
    } 

    function get_encrypted_string(uint listing_id) public view returns(string memory)
    {
        require(reverse_buyers_mapping[msg.sender]!=0,"You are not a Buyer");
        require(listedItems[listing_id].buyer_id==reverse_buyers_mapping[msg.sender],"Item is not bought by you");
        require(listedItems[listing_id].bought==1,"Item not bought yet");
        require(listedItems[listing_id].public_key_fetched==1,"Public Key Not Fetched Yet");
        require(listedItems[listing_id].delivered==1,"Item not delivered yet");
        string memory ret = listedItems[listing_id].encrypted_msg;
        return ret;
    }
}
