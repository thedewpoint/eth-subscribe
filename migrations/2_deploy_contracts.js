var EthSubscribe = artifacts.require("./EthSubscribe.sol");

module.exports = function(deployer) {
  deployer.deploy(EthSubscribe);
};
