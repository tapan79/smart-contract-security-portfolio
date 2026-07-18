// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

contract Lottery
{
    // Entry fees from participants
    uint public entryFee = 1 ether;

    // owner or manager of contract
    address public manager;

    // address of winner
    address payable public winner;

    // address of players - create dynamic array whose name is players
    address payable[] public players;

    constructor()
    {
        manager = msg.sender; // msg.sender is deployer whose address is stored in manager
    }

    // change manager if manager role is change to new manager
    function transferManager(address newManager) public onlyManager {
    require(newManager != address(0), "Invalid address");
    manager = newManager;
    }
    
    // modifier as manager
    modifier onlyManager() {
    require(msg.sender == manager, "Only manager can call this function");
    _;
    }

    // change entry fee 
    function changeEntryFee(_entryFee) public onlyManager
    {
        entryFee = _entryFee;
    }

    event PlayerJoined(address indexed player); // create event for blockchain log - participants added
    function participate() public payable
    {
        require(msg.value == entryFee, "Incorrect entry fee"); // store the ether in contract address
        players.push(payable(msg.sender)); // store the address in players dynamic size array

        emit PlayerJoined(msg.sender);
    }

    // to get balance of this contract or deployer
    function getbalance() public view returns(uint) onlyManager
    {
        return address(this).balance; // check the total balance of contract, the function called by only the manager.
    }

    function random() internal view returns(uint) // here, internal visibilty used means contract call itself this function
    {
        return uint(keccak256(abi.encodePacked(block.prevrandao, block.timestamp, players.length, address(this).balance)));
    }

    event WinnerSelected(address indexed winner, uint256 prize); // create event for selecting the winner and amount transfer to the winner

    function pickwinner() public onlyManager
    {
        require(players.length >= 3, "Players are less than three");

        uint index = random() % players.length;
        winner = players[index];
        uint amount = address(this).balance;
        (bool success, ) = winner.call{value: amount}("");
        require(success, "Transfer failed");

        emit WinnerSelected(winner, amount);

        players = new address payable[](0); // reset the players address
    }
}
