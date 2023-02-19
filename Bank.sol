// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Bank{
    uint256 public total_balance;
    BankAccount[] public Accounts;
    uint256 public num_of_accounts;

    constructor() {
        total_balance = 0;
        num_of_accounts = 0;
    }

    function Create_Account(BankAccount account) public {
        Accounts.push(account);
        num_of_accounts++;
    }



    
}

contract BankAccount{
    constructor(Bank _bank) {
        owner = payable(tx.origin);
        bank = _bank;

        bank.Create_Account(this);
    }


    enum State {Active, Inactive}
    State state = State.Active;

    address payable public owner;
    Bank bank;

    modifier isOwner() {
        require(tx.origin == owner);
        _;
    }

    modifier isActive()
    {
        require(state == State.Active);
        _;
    }
    modifier EnoughBalance(uint256 amount)
    {
        require(amount <= address(this).balance);
        _;
    }
    


    function Deposit()
    public payable isActive isOwner{}

    function Withdraw(uint256 amount)
    public isActive isOwner EnoughBalance(amount) {
        require(address(this).balance >= amount);
        owner.transfer(amount);
    }

    function Transfer(address payable to, uint256 amount)
    public isActive isOwner{
        require(address(this).balance >= amount);
        bool success = to.send(amount);
        require(success);
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
        return address(this).balance;
    }

}

