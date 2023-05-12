//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract CurrencyExchangeOffice {
    address public owner;
    mapping (address => uint256) private rates;

    constructor() {
        owner = msg.sender;
        rates[address(this)] = 100;
    }

    function deposit(uint amount) public {
        require(msg.sender == owner, "Only the owner can refill tokens.");
        rates[address(this)] += amount;
    }

    function buy(uint256 tokenAmount) public payable {
        require(tokenAmount > 0, "Token amount must be greater than 0");
        require(msg.value > tokenAmount * 1 ether, "You need to sent more Ethereum");
        require(rates[address(this)] >= tokenAmount, "Not enough tokens in stock to complete this purchase");

        rates[address(this)] -= tokenAmount;
        rates[msg.sender] += tokenAmount;
    }

    function sell(uint256 tokenAmount) public {
        require(tokenAmount > 0, "Token amount must be greater than 0");
        require(rates[msg.sender] >= tokenAmount, "Not enough tokens");

        uint etherAmount = tokenAmount * 1 ether;
        rates[msg.sender] -= tokenAmount;

        payable(msg.sender).transfer(etherAmount);
    }
}
