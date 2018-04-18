// var ConvertLib = artifacts.require("./ConvertLib.sol");
var SmartdevCoin = artifacts.require("./SmartdevCoin.sol");

module.exports = function(deployer) {
  //deployer.deploy(ConvertLib);
  //deployer.link(ConvertLib, SmartdevCoin);
  deployer.deploy(SmartdevCoin, 1000000000,'Smartdev Coin', 'SMC');
};
