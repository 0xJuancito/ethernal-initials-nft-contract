require("@nomiclabs/hardhat-etherscan");
require('@nomiclabs/hardhat-waffle');
require('dotenv').config();

module.exports = {
  solidity: '0.8.0',
  networks: {
    mumbai: {
      url: process.env.STAGING_ALCHEMY_KEY,
      accounts: [process.env.PRIVATE_KEY],
    },
    polygon: {
      chainId: 1,
      url: process.env.PROD_ALCHEMY_KEY,
      accounts: [process.env.PRIVATE_KEY],
    },
  },
  etherscan: {
    apiKey: process.env.POLYGONSCAN_KEY,
  }
};