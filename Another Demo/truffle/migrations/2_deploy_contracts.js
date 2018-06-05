const Data = artifacts.require('Data');
module.exports = async function (deployer) {
  deployer.deploy(Data);
};
