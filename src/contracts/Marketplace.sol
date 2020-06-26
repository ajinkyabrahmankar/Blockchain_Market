// SPDX-License-Identifier: MIT

pragma solidity >=0.5.0 <0.7.0;

contract Marketplace {
    string public name;
    uint public productCount = 0;
    mapping(uint => Product) public products;

    struct Product {
        uint id;
        string name;
        uint price;
        address payable owner;
        bool purchased;
    }

    event ProductCreated (
        uint id,
        string name,
        uint price,
        address payable owner,
        bool purchased
    );

    event ProductPurchased (
        uint id,
        string name,
        uint price,
        address payable owner,
        bool purchased
    );

    constructor() public{
        name = "Ajinkya Marketplace";
    }

    function createProduct(string memory _name, uint _price) public {
        //Require a valid name
        require(bytes(_name).length > 0, "name invalid");
        //Require a valid proce
        require(_price > 0, "invalid price");
        //Increment Product Count
        productCount ++;
        //Create the product
        products[productCount] = Product(productCount, _name, _price, msg.sender, false);
        //Trigger an event
        emit ProductCreated(productCount, _name, _price, msg.sender, false);
    }


    function purchaseProduct(uint _id) public payable {
        //Fetch the product
        Product memory _product = products[_id];
        //Fetch the owner
        address payable _seller = _product.owner;
        //Make sure the product has valid id
        require(_product.id > 0 && _product.id <= productCount, "The product id is invalid");
        //Require that there is enough Ether in the transaction
        require(msg.value >= _product.price, "Not enough ether");
        //Require that the product has not been purchased already
        require(!_product.purchased, "Product already sold");
        //Require that the buyer is not the seller
        require(_seller != msg.sender, "The seller cannot buy his things");
        //Transfer ownership to the buyer
        _product.owner = msg.sender;
        //Mark as purchased
        _product.purchased = true;
        //Update the product
        products[_id] = _product;
        //Pay the seller by sending them ether
        address(_seller).transfer(msg.value);
        //Trigger an event
        emit ProductPurchased(productCount, _product.name, _product.price, msg.sender, true);
    }
}

