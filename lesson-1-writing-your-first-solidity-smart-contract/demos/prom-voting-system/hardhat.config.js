// Importing necessary modules and packages
const { HardhatUserConfig } = require("hardhat/config");
require("@nomicfoundation/hardhat-toolbox"); // Includes a set of common Hardhat plugins
require("dotenv/config"); // Loads environment variables from a .env file into process.env

// Configuration object for Hardhat
const config = {
  // Solidity compiler configuration
  solidity: {
    version: "0.8.0", // Specifies the Solidity version to use
    settings: {
      optimizer: {
        enabled: true, // Enables Solidity optimizer
        runs: 200, // Specifies the number of optimization runs (higher number = more optimized, but takes longer)
      },
    },
  },
  // Network configuration
  networks: {
    // Custom network configuration for Sepolia testnet
    "sepolia-testnet": {
      url: `https://sepolia.infura.io/v3/${process.env.INFURA_API_KEY}`, // RPC URL for Sepolia, using Infura as the provider
      // Accounts configuration, using private keys from environment variables
      // The filter(Boolean) method ensures that only non-empty strings are included
      // as valid private keys
      accounts: [process.env.ACCOUNT_PRIVATE_KEY].filter(Boolean),
    },
  },
};

// Exporting the Hardhat user configuration object
module.exports = config;
