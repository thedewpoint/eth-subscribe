pragma solidity ^0.4.2;

import "truffle/Assert.sol";
import "truffle/DeployedAddresses.sol";
import "../contracts/EthSubscribe.sol";

contract TestEthSubscribe {
  EthSubscribe ethSub;
 function beforeEach() {
    ethSub = EthSubscribe(DeployedAddresses.EthSubscribe());
  }
  function testManagedAddressIsSet() {
    address expected = tx.origin;
    address mgr = ethSub.mgrAddr();
    Assert.equal(mgr,expected, "Owner address should be stored");
  }
 function testSubscriptionFailsWhenAppNotExist() {
    bool success = ethSub.subscribe("testApp");
    Assert.equal(success,false, "App subscription should return false when the app doesn't exist");
  }
  function testAppRegistration() {
    bool success = ethSub.registerApp("testApp",5);
    Assert.equal(success,true, "App registration should return true");
    uint fee = ethSub.getAppFee("testApp");
    Assert.equal(fee,5, "App fee should be 5");
  }
   function testSubscriptionSucceedsWhenAppExists() {
    ethSub.registerApp("testApp",5);
    bool success = ethSub.subscribe("testApp");
    Assert.equal(success,true, "App registration should return true");
  }

}
