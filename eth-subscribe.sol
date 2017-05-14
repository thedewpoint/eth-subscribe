pragma solidity ^0.4.0;
contract EthSubscribe {
    address mgrAddr;
    mapping (string=>Owner) apps;
    mapping (address=>uint) pendingWithdrawals;
    struct Owner{
        address ownerAddr;
        string appName;
        uint subFee;
        mapping (address=>Customer) customers;
    }
    struct Customer {
        address customerAddr;
        uint256 subDate;
        uint subPaid;
    }
    function EthSubscribe() {
        mgrAddr = msg.sender;
    }
    function stageWithdrawal interal(address _addr, uint _amt) {
        pendingWithdrawals[_addr] += _amt;
    }
    function appExists interal(string _appName) returns (bool) {
        return apps[_appName] != "0x0";
    }
    function registerApp payable(string _appName, uint _subFee) returns (bool){
        if(appExists(_appName)) { return false}
        apps[_appName] = Owner(msg.sender, _appName, _subFee);
        stageWithdrawal(mgrAddr,msg.value);
        return true;
    }
    function subscribe payable(string _appName) returns (bool){
        if(!appExists(_appName)) {return false};
        Owner owner = apps[_appName];
        owner.customers[msg.sender] = Customer(msg.sender,msg.now,msg.value - owner.subFee);
        stageWithdrawal(owner.ownerAddr,msg.value - owner.subFee);
        return true;
    }
    function unsubscribe external(string _appName) returns (bool){
        if(!appExists(_appName)){return false;}
        stageWithdrawal(msg.sender,apps[_appName].customers[msg.sender].subPaid);
        apps[_appName].customers[msg.sender] = "0x0";
        return true;
    }
    function withdrawal external () returns (bool){
        uint amount = pendingWithdrawals[msg.sender];
        pendingWithdrawals[msg.sender] = 0;
        msg.sender.transfer(amount);
    }

}