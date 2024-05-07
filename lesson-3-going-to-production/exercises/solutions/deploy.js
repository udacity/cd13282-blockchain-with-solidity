const { ethers } = require("hardhat");

async function main() {
  console.log("Starting deployment...");

  // Get the contract factory for the DecentralizedMarketplace contract
  const DecentralizedMarketplace = await ethers.getContractFactory(
    "DecentralizedMarketplace"
  );

  // Deploy the contract
  const contract = await DecentralizedMarketplace.deploy();

  // Wait for it to be deployed
  // await contract.deployed();

  // The contract is now deployed, and you can log its address
  console.log(`DecentralizedMarketplace deployed successfully`);
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error("An error occurred during deployment:", error);
    process.exit(1);
  });
