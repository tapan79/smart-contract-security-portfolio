// SPDX-License-Identifier: MIT

pragma solidity ^0.8.17; // add compiler

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/ERC20.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/extensions/ERC20Capped.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/extensions/ERC20Burnable.sol";

// inherits ERC20 tokken feature
contract token is ERC20Capped, ERC20Burnable
{
    // owner address
    address payable public owner;
    uint256 public blockreward; // blockreward decide for miner

    constructor(uint256 cap, uint256 reward) ERC20("token", "TK") ERC20Capped(cap * (10 ** decimals()))// constructor used parent constructor ERC20
    {
        owner = payable(msg.sender); // owner means deployer address
        _mint(msg.sender, 700 * (10 ** decimals())); // deployer address - all initial supply to deplpoyer
        blockreward = reward * (10 ** decimals()); // set a reward amount
    }

    // only internal function call so visibility is internal and provide reward
    function _mintminerreward() internal // reward to miner
    {
        if (totalSupply() + blockreward <= cap()) // check for cap limit
        {
            _mint(block.coinbase, blockreward); // block.coinbase is miner global variable
        }    
    }

    // when token is transfer form A to B then get reward to miner and update balance with condition check
    function _update(address from, address to, uint256 value) internal override(ERC20, ERC20Capped)
    {
        if (from != address(0) && to != block.coinbase && block.coinbase != address(0)) // miner is not transfer and get token & not transfer from owner
        {
            _mintminerreward();
        }
        super._update(from, to, value);
    }

    // add in functionality
    modifier onlyowner
    {
        require (msg.sender == owner, "Only owner can call this function");
        _;
    }

    // may be change reward in future time
    function setblockreward(uint reward) public onlyowner
    {
        blockreward = reward * (10 ** decimals());
    }

    function destory() public onlyowner
    {
        selfdestruct(owner);
    }
}
