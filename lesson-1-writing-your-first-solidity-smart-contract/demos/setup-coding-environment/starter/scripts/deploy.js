// Import Hardhat's runtime environment to use its functionalities
const hre = require("hardhat");

async function main() {
  // Fetch the ContractFactory for our HelloWorld contract.
  // ContractFactory is a Hardhat abstraction used to deploy new smart contracts.
  const HelloWorld = await hre.ethers.getContractFactory("HelloWorld");

  // Deploy the contract. This asynchronous operation will wait until the deployment is mined.
  const helloWorld = await HelloWorld.deploy();

  // Log the address of the newly deployed contract. This is useful for verifying deployment
  // and for interacting with the contract afterwards.
  console.log("HelloWorld deployed to:", helloWorld.address);
}

// Main function is called and any errors are caught.
// Hardhat recommends this pattern to handle async code in scripts.
main()
  .then(() => process.exit(0)) // On success, exit with a status code 0.
  .catch((error) => {
    console.error(error); // Log any errors that occur.
    process.exit(1); // Exit with a status code 1 indicating an error.
  });
