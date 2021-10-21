const Shipping = artifacts.require("Shipping");

module.exports = function (deployer) {
  deployer.deploy(Shipping, [
    "0xc71fdbde4938d7605528fd998a7a5f5420eabb6a", 
    "0x6Edd58BEA2F9C2354Dddb16fB2712Ff8656bcAbb"
  ]);
};
