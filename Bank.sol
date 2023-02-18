// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract BankAccount{
    constructor(){
        owner = payable(msg.sender);
    }


    enum State {Active, Inactive}
    State state = State.Active;

    address payable public owner;

    modifier isOwner() {
        require(msg.sender == owner);
        _;
    }

    modifier isActive()
    {
        require(state == State.Active);
        _;
    }

    // control balance
    uint256 balance;

    function Deposit()
    public payable isActive isOwner{
        balance += msg.value;
    }

    function Withdraw(uint256 amount)
    public payable isActive isOwner{
        require(balance >= amount);
        balance -= amount;
        owner.transfer(amount);
    }

    // control account status

    function Activate() public isOwner{
        state = State.Active;
    }

    function Deactivate() public isOwner{
        // deactivating the account will lead to locking the account
        // and the account will not be able to perform any transaction 
        // until it is activated again
        state = State.Inactive;
    }


    // account status variables
    function Is_Account_Active()
    public view returns(bool){
        return state == State.Active;
    }

    function get_balance() public view returns(uint256){
        return balance;
    }
}