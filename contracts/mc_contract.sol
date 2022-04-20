// SPDX-License-Identifier: MIT

pragma solidity ^0.8.13;

/*
contract MyContract {

    address owner;

    bool public paused;

    constructor() {
        owner = msg.sender;
    }

    function sendMoney() public payable{

    }

    function setPaused(bool _paused) public{

        require(msg.sender == owner, " You are not the owner. ");
        paused = _paused; 
    }

    function withDrawMoney(address payable _to) public{

        require(msg.sender == owner, " You are not the owner. ");
        require(paused == false, " Contract is paused ");
        _to.transfer(address(this).balance);
    }

    function destroySmartContract(address payable _to) public {

        require(msg.sender == owner, " You are not the owner ");
        selfdestruct(_to);
    }

}
*/

/*
contract Mapping{

    function getBalance() public view returns(uint){
        return address(this).balance;
    }

    function sendMoney() public payable{

    }

    function withDrawAllMoney(address payable _addr) public {

        _addr.transfer(address(this).balance);
    }

}
*/

/*
contract MappingStructExample{

    struct Payment{
        uint amount;
        uint timestamp;
    }

    struct Balance{
        uint totalBalance;
        uint numPayments;
        mapping(uint => Payment) payments;
    }

    //mapping( address => uint ) public balanceReceived;

    mapping (address => Balance) public balanceReceived;

    function getBalance() public view returns(uint){
        return address(this).balance;
    }

    function sendMoney() public payable{
        //balanceReceived[msg.sender] += msg.value;
        balanceReceived[msg.sender].totalBalance += msg.value;
        
        Payment memory _payment = Payment(msg.value , block.timestamp);
        uint _numPayment = balanceReceived[msg.sender].numPayments;
        balanceReceived[msg.sender].payments[_numPayment] = _payment;

        balanceReceived[msg.sender].numPayments++;
    }

    function withDrawPartialMoney(address payable _addr, uint _amount) public {
        //addr.transfer(address(this).balance);

        require( _amount <= balanceReceived[msg.sender].totalBalance , " Not enough funds " );

        balanceReceived[msg.sender].totalBalance -= _amount;
        _addr.transfer(_amount);
    }    
}
*/

/*
// require example
contract ExceptionExample{

    mapping( address => uint ) public balanceReceived;

    function receiveMoney() public payable{
        balanceReceived[msg.sender] += msg.value;
    }

    function withDrawMoney(address payable _addr, uint _amount) public {

        require( _amount <= balanceReceived[msg.sender] ,"Not enough funds");
        balanceReceived[msg.sender] -= _amount;
        _addr.transfer(_amount);
    }

}
*/

/*
// assert example
// uint64 -> max=18 Ether
contract ExceptionExample{

    mapping( address => uint64 ) public balanceReceived;

    function receiveMoney() public payable{
        balanceReceived[msg.sender] += uint64(msg.value);
    }

    function withDrawMoney(address payable _addr, uint _amount) public {

        require( _amount <= balanceReceived[msg.sender] ,"Not enough funds");
        assert( balanceReceived[msg.sender] + _amount < balanceReceived[msg.sender] ); // check the roll over
        balanceReceived[msg.sender] -= uint64(_amount);
        _addr.transfer(_amount);
    }

}
*/

/*

import "./Owned.sol";

contract InhertanceModifierExample is Owned{

    mapping(address => uint) public tokenBalance;

    uint tokenPrice = 1 ether;

    constructor() {

        tokenBalance[owner]=100;
    }


    function createNewToken() public onlyOwner{
        
        tokenBalance[owner]++;
    }

    function burnToken() public onlyOwner{

        tokenBalance[owner]--;        
    }

    function purchaseToken() public payable{

        require( (( tokenPrice * tokenBalance[owner] ) / msg.value) > 0 ,"Not enough Tokens");
        tokenBalance[owner] -= msg.value / tokenPrice;
        tokenBalance[msg.sender] += msg.value / tokenPrice;
    }

    function sendToken( address _to , uint _amount) public{

        require( _amount <= tokenBalance[msg.sender] ," Not enough tokens");
        assert(_amount + tokenBalance[_to] >= tokenBalance[_to]);
        assert( tokenBalance[msg.sender] - _amount <= tokenBalance[msg.sender]);

        tokenBalance[msg.sender] -= _amount;
        tokenBalance[_to] += _amount;
    }
    
}
*/

contract EventExample{

    mapping(address => uint) public tokenBalance;

    event TokensSent(address _from, address _to, uint _amount);
 
    constructor() {
        tokenBalance[msg.sender]=100;
    }

    function sendToken(address _addr , uint _amount) public returns(bool){

        require( tokenBalance[msg.sender] >= _amount , " Not enough Tokens");
        assert( tokenBalance[_addr] + _amount >= tokenBalance[_addr] );
        assert( tokenBalance[msg.sender] - _amount <= tokenBalance[msg.sender] );

        tokenBalance[msg.sender] -= _amount;
        tokenBalance[_addr] += _amount;

        emit TokensSent(msg.sender, _addr, _amount);

        return true;
    }

}