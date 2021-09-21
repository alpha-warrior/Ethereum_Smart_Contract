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
            listedItems.push(Item(listed_items,_name,_description,_price,sellers,0,0,0));
            listed_items++;
        }
        else
        {
            uint temp_seller_id = reverse_sellers_mapping[msg.sender];
            listedItems.push(Item(listed_items,_name,_description,_price,temp_seller_id,0,0,0));
            listed_items++;
        }
    }

    function viewAvailItems() public view returns(string memory)
    {
        string memory ret = "";
        for (uint i=0; i < listedItems.length; i+=1) 
        {
            Item memory cur = listedItems[i];
            if (cur.bought == 0)
            {
                ret = string(abi.encodePacked(ret,"\n\n","**************************","\n","Listing Id: ",uint2str(cur.listing_id),"\n","Name: ",cur.name,"\n","Description: ",cur.description,"\n","Price: ",uint2str(cur.price)));
            }
        }
        ret = string(abi.encodePacked(ret,"\n","***************************"));
        return ret;
    }

    function buyItem(uint listing_id) public payable
    {
        require(msg.value==listedItems[listing_id].price,"Wrong amount paid. Please pay the correct amount to claim your item.");
        if(reverse_buyers_mapping[msg.sender]==0)
        {
            buyers++;
            reverse_buyers_mapping[msg.sender] = buyers;
            buyers_mapping[buyers] = msg.sender;
            listedItems[listing_id].bought = 1;
            sellers_mapping[listedItems[listing_id].seller_id].transfer(listedItems[listing_id].price);
        }
        else
        {
            listedItems[listing_id].bought = 1;
            sellers_mapping[listedItems[listing_id].seller_id].transfer(listedItems[listing_id].price);
        }
    }

}
