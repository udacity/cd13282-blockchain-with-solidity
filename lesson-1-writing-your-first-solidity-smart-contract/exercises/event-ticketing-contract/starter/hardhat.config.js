// Importing necessary modules and packages
const { HardhatUserConfig } = require("hardhat/config");
require("@nomicfoundation/hardhat-toolbox"); // Includes a set of common Hardhat plugins
require("dotenv/config"); // Loads environment variables from a .env file into process.env

// Configuration object for Hardhat
const config = {
  // Solidity compiler configuration
  solidity: {
    version: "0.8.19", // Specifies the Solidity version to use
    settings: {
      optimizer: {
        enabled: true, // Enables Solidity optimizer
        runs: 200, // Specifies the number of optimization runs (higher number = more optimized, but takes longer)
      },
    },
  },
};

// Exporting the Hardhat user configuration object
module.exports = config;
