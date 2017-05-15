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
    function stageWithdrawal (address _addr, uint _amt) internal {
        pendingWithdrawals[_addr] += _amt;
    }
    function appExists (string _appName) internal returns (bool) {
        return bytes(apps[_appName].appName).length != 0;
    }
    function registerApp (string _appName, uint _subFee) payable returns (bool){
        if(appExists(_appName)) { return false;}
        apps[_appName] = Owner(msg.sender, _appName, _subFee);
        stageWithdrawal(mgrAddr,msg.value);
        return true;
    }
    function subscribe (string _appName) payable returns (bool){
        if(!appExists(_appName)) {return false;}
        Owner owner = apps[_appName];
        owner.customers[msg.sender] = Customer(msg.sender,now,msg.value - owner.subFee);
        stageWithdrawal(owner.ownerAddr,msg.value - owner.subFee);
        return true;
    }
    function unsubscribe(string _appName) external returns (bool){
        if(!appExists(_appName)){return false;}
        stageWithdrawal(msg.sender,apps[_appName].customers[msg.sender].subPaid);
        delete apps[_appName].customers[msg.sender];
        return true;
    }
    function withdrawal() external returns (bool){
        uint amount = pendingWithdrawals[msg.sender];
        pendingWithdrawals[msg.sender] = 0;
        msg.sender.transfer(amount);
    }

}